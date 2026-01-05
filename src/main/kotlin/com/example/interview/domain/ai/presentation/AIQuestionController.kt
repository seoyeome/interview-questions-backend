package com.example.interview.domain.ai.presentation

import com.example.interview.domain.ai.application.AIQuestionService
import com.example.interview.domain.ai.application.AIQuotaService
import com.example.interview.domain.ai.presentation.dto.AIQuestionRequest
import com.example.interview.domain.ai.presentation.dto.AIQuestionResponse
import com.example.interview.infrastructure.common.dto.ApiResponse
import com.example.interview.infrastructure.security.JwtTokenProvider
import jakarta.servlet.http.HttpServletRequest
import org.slf4j.LoggerFactory
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
    private val logger = LoggerFactory.getLogger(AIQuestionController::class.java)
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
        logger.info("========================================")
        logger.info("AI 질문 요청 시작")
        logger.info("Request Body: category={}, subCategory={}, difficulty={}",
            request.category, request.subCategory, request.difficulty)
        logger.info("Request URL: {}", httpRequest.requestURL)
        logger.info("Request Method: {}", httpRequest.method)
        logger.info("Content-Type: {}", httpRequest.contentType)

        // 쿠키 로깅
        val cookies = httpRequest.cookies
        if (cookies != null) {
            logger.info("받은 쿠키 개수: {}", cookies.size)
            cookies.forEach { cookie ->
                logger.info("쿠키: name={}, value={}, secure={}, httpOnly={}, path={}",
                    cookie.name,
                    if (cookie.name == "token") cookie.value.take(20) + "..." else cookie.value,
                    cookie.secure,
                    cookie.isHttpOnly,
                    cookie.path
                )
            }
        } else {
            logger.warn("쿠키가 전혀 없음!")
        }

        val userId = getUserIdFromToken(httpRequest)
        if (userId == null) {
            logger.error("토큰에서 userId 추출 실패 - UNAUTHORIZED 반환")
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build()
        }

        logger.info("토큰에서 추출한 userId: {}", userId)

        return try {
            logger.info("AI 질문 서비스 호출 시작")
            val result = aiQuestionService.getOrGenerateQuestion(
                userId = userId,
                categoryName = request.category,
                subCategoryName = request.subCategory,
                difficulty = request.difficulty
            )
            logger.info("AI 질문 서비스 호출 성공: {}", result)
            logger.info("========================================")
            ResponseEntity.ok(result)
        } catch (e: IllegalStateException) {
            // Quota 초과 또는 AI 생성 실패
            logger.error("AI 질문 생성 실패 (Quota 초과): {}", e.message)
            logger.info("========================================")
            ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS).build()
        } catch (e: IllegalArgumentException) {
            // 카테고리/서브카테고리 없음
            logger.error("AI 질문 생성 실패 (잘못된 인자): {}", e.message)
            logger.info("========================================")
            ResponseEntity.badRequest().build()
        } catch (e: Exception) {
            logger.error("AI 질문 생성 중 예상치 못한 오류: {}", e.message, e)
            logger.info("========================================")
            ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build()
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
        val token = request.cookies
            ?.firstOrNull { it.name == "token" }
            ?.value
            ?.takeIf { it.isNotBlank() }
            ?: run {
                val bearerToken = request.getHeader("Authorization")
                if (!bearerToken.isNullOrBlank() && bearerToken.startsWith("Bearer ")) {
                    bearerToken.substring(7).trim().takeIf { it.isNotBlank() }
                } else {
                    null
                }
            }

        return token?.let { jwtTokenProvider.getUserIdFromToken(it) }
    }
}
