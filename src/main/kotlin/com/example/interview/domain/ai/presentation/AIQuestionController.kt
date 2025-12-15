package com.example.interview.domain.ai.presentation

import com.example.interview.domain.ai.application.AIQuestionService
import com.example.interview.domain.ai.application.AIQuotaService
import com.example.interview.domain.ai.presentation.dto.AIQuestionRequest
import com.example.interview.domain.ai.presentation.dto.AIQuestionResponse
import com.example.interview.infrastructure.common.dto.ApiResponse
import com.example.interview.infrastructure.security.JwtTokenProvider
import jakarta.servlet.http.HttpServletRequest
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/v1/ai")
class AIQuestionController(
    private val aiQuestionService: AIQuestionService,
    private val aiQuotaService: AIQuotaService,
    private val jwtTokenProvider: JwtTokenProvider
) {
    /**
     * AI 질문 생성 (항상 Gemini API 호출 → DB 저장)
     */
    @PostMapping("/generate-question")
    fun generateQuestion(@RequestBody request: AIQuestionRequest): ResponseEntity<AIQuestionResponse> {
        val result = aiQuestionService.generateAndSaveQuestion(
            categoryName = request.category,
            subCategoryName = request.subCategory,
            difficulty = request.difficulty
        )

        return if (result != null) {
            ResponseEntity.ok(result)
        } else {
            ResponseEntity.status(503).build()
        }
    }

    /**
     * DB에 저장된 AI 질문 랜덤 조회
     */
    @PostMapping("/get-saved-question")
    fun getSavedQuestion(@RequestBody request: AIQuestionRequest): ResponseEntity<AIQuestionResponse> {
        val result = aiQuestionService.getRandomAIQuestion(
            categoryName = request.category,
            subCategoryName = request.subCategory,
            difficulty = request.difficulty
        )

        return if (result != null) {
            ResponseEntity.ok(result)
        } else {
            ResponseEntity.noContent().build()
        }
    }

    /**
     * 하이브리드 AI 질문
     * DB에 있으면 반환 (quota 소모 X), 없으면 생성 (quota 소모 O)
     */
    @PostMapping("/question")
    fun getOrGenerateQuestion(
        @RequestBody request: AIQuestionRequest,
        httpRequest: HttpServletRequest
    ): ResponseEntity<AIQuestionResponse> {
        val userId = getUserIdFromToken(httpRequest)
            ?: return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build()

        return try {
            val result = aiQuestionService.getOrGenerateQuestion(
                userId = userId,
                categoryName = request.category,
                subCategoryName = request.subCategory,
                difficulty = request.difficulty
            )
            ResponseEntity.ok(result)
        } catch (e: IllegalStateException) {
            // Quota 초과 또는 AI 생성 실패
            ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS).build()
        } catch (e: IllegalArgumentException) {
            // 카테고리/서브카테고리 없음
            ResponseEntity.badRequest().build()
        }
    }

    /**
     * 남은 AI 생성 횟수 조회
     */
    @GetMapping("/remaining-quota")
    fun getRemainingQuota(request: HttpServletRequest): ResponseEntity<ApiResponse<Int>> {
        val userId = getUserIdFromToken(request)
            ?: return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build()

        val remaining = aiQuotaService.getRemainingQuota(userId)
        return ResponseEntity.ok(ApiResponse.success(remaining))
    }

    private fun getUserIdFromToken(request: HttpServletRequest): Long? {
        val cookies = request.cookies ?: return null
        val tokenCookie = cookies.find { it.name == "token" } ?: return null
        return jwtTokenProvider.getUserIdFromToken(tokenCookie.value)
    }
}
