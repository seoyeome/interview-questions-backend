package com.example.interview.domain.ai.application

import com.example.interview.domain.ai.infrastructure.persistence.AIQuestionEntity
import com.example.interview.domain.ai.infrastructure.persistence.JpaAIQuestionRepository
import com.example.interview.domain.ai.presentation.dto.AIQuestionResponse
import com.example.interview.domain.category.domain.CategoryRepository
import com.example.interview.domain.question.domain.QuestionDifficulty
import com.example.interview.domain.subcategory.domain.SubCategoryRepository
import com.example.interview.infrastructure.ai.AIClient
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

@Service
class AIQuestionService(
    private val aiQuestionRepository: JpaAIQuestionRepository,
    private val aiClient: AIClient,
    private val categoryRepository: CategoryRepository,
    private val subCategoryRepository: SubCategoryRepository,
    private val aiQuotaService: AIQuotaService
) {

    /**
     * AI 질문 생성 (항상 AI API 호출 후 DB 저장)
     */
    @Transactional
    fun generateAndSaveQuestion(
        categoryName: String,
        subCategoryName: String,
        difficulty: String
    ): AIQuestionResponse? {
        // 1. AI API로 질문 생성
        val aiResult = aiClient.generateQuestion(
            category = categoryName,
            subCategory = subCategoryName,
            difficulty = difficulty
        ) ?: return null

        // 2. 카테고리/서브카테고리 ID 조회
        val category = categoryRepository.findByName(categoryName) ?: return null
        val subCategory = subCategoryRepository.findByNameAndCategoryId(
            name = subCategoryName,
            categoryId = category.id
        ) ?: return null

        // 3. DB에 저장
        val entity = AIQuestionEntity(
            categoryId = category.id.value,
            subCategoryId = subCategory.id.value,
            content = aiResult.content,
            explanation = aiResult.explanation,
            difficulty = QuestionDifficulty.valueOf(aiResult.difficulty)
        )
        val saved = aiQuestionRepository.save(entity)

        return AIQuestionResponse(
            content = saved.content,
            explanation = saved.explanation,
            difficulty = saved.difficulty.name,
            source = "AI"
        )
    }

    /**
     * DB에 저장된 AI 질문 조회 (있으면 반환, 없으면 null)
     */
    @Transactional
    fun getRandomAIQuestion(
        categoryName: String,
        subCategoryName: String,
        difficulty: String
    ): AIQuestionResponse? {
        // 1. 카테고리/서브카테고리 ID 조회
        val category = categoryRepository.findByName(categoryName) ?: return null
        val subCategory = subCategoryRepository.findByNameAndCategoryId(
            name = subCategoryName,
            categoryId = category.id
        ) ?: return null

        val difficultyEnum = QuestionDifficulty.valueOf(difficulty)

        // 2. DB에서 랜덤 조회
        val questions = aiQuestionRepository.findRandomByCategoryAndSubCategoryAndDifficulty(
            categoryId = category.id.value,
            subCategoryId = subCategory.id.value,
            difficulty = difficultyEnum
        )

        val question = questions.firstOrNull() ?: return null

        // 3. 사용 횟수 증가
        aiQuestionRepository.save(question.incrementUsage())

        return AIQuestionResponse(
            content = question.content,
            explanation = question.explanation,
            difficulty = question.difficulty.name,
            source = "AI_DB"
        )
    }

    /**
     * 하이브리드 AI 질문 로직
     * 1. DB에 저장된 AI 질문이 있으면 반환 (fromCache=true, quota 소모 X)
     * 2. 없으면 quota 확인 후 AI API 호출 (fromCache=false, quota 소모 O)
     */
    @Transactional
    fun getOrGenerateQuestion(
        userId: Long,
        categoryName: String,
        subCategoryName: String,
        difficulty: String
    ): AIQuestionResponse {
        // 1. "ALL"인 경우 랜덤 카테고리/서브카테고리 선택
        val category = if (categoryName == "ALL") {
            val allCategories = categoryRepository.findAll()
            if (allCategories.isEmpty()) throw IllegalArgumentException("카테고리가 존재하지 않습니다")
            allCategories.random()
        } else {
            categoryRepository.findByName(categoryName)
                ?: throw IllegalArgumentException("카테고리를 찾을 수 없습니다: $categoryName")
        }

        val subCategory = if (subCategoryName == "ALL") {
            val allSubCategories = subCategoryRepository.findAllByCategoryId(category.id)
            if (allSubCategories.isEmpty()) throw IllegalArgumentException("서브카테고리가 존재하지 않습니다")
            allSubCategories.random()
        } else {
            subCategoryRepository.findByNameAndCategoryId(
                name = subCategoryName,
                categoryId = category.id
            ) ?: throw IllegalArgumentException("서브카테고리를 찾을 수 없습니다: $subCategoryName")
        }

        val difficultyEnum = QuestionDifficulty.valueOf(difficulty)

        // 2. DB에 저장된 AI 질문이 있는지 확인
        val cachedQuestions = aiQuestionRepository.findRandomByCategoryAndSubCategoryAndDifficulty(
            categoryId = category.id.value,
            subCategoryId = subCategory.id.value,
            difficulty = difficultyEnum
        )

        // 3. DB에 질문이 있으면 반환 (quota 소모 X)
        if (cachedQuestions.isNotEmpty()) {
            val question = cachedQuestions.first()
            aiQuestionRepository.save(question.incrementUsage())

            return AIQuestionResponse(
                content = question.content,
                explanation = question.explanation,
                difficulty = question.difficulty.name,
                source = "AI_DB",
                fromCache = true,
                remainingQuota = aiQuotaService.getRemainingQuota(userId)  // 캐시 조회
            )
        }

        // 4. DB에 없으면 quota 확인
        if (!aiQuotaService.canUseAI(userId)) {
            throw IllegalStateException("오늘의 AI 질문 생성 횟수를 모두 사용했습니다. 내일 다시 시도해주세요.")
        }

        // 5. AI API로 새 질문 생성 (선택된 실제 카테고리/서브카테고리 사용)
        val aiResult = aiClient.generateQuestion(
            category = category.name,
            subCategory = subCategory.name,
            difficulty = difficulty
        ) ?: throw IllegalStateException("AI 질문 생성에 실패했습니다. 잠시 후 다시 시도해주세요.")

        // 6. DB에 저장
        val entity = AIQuestionEntity(
            categoryId = category.id.value,
            subCategoryId = subCategory.id.value,
            content = aiResult.content,
            explanation = aiResult.explanation,
            difficulty = difficultyEnum
        )
        aiQuestionRepository.save(entity)

        // 7. Quota 차감 (캐시 업데이트)
        val newRemainingQuota = aiQuotaService.useQuota(userId)

        return AIQuestionResponse(
            content = aiResult.content,
            explanation = aiResult.explanation,
            difficulty = aiResult.difficulty,
            source = "AI",
            fromCache = false,
            remainingQuota = newRemainingQuota
        )
    }
}
