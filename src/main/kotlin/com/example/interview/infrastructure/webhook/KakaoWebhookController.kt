package com.example.interview.infrastructure.webhook

import com.example.interview.domain.user.domain.UserRepository
import com.example.interview.domain.user.domain.UserStatus
import org.slf4j.LoggerFactory
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.time.LocalDateTime

@RestController
@RequestMapping("/api/v1/webhook")
class KakaoWebhookController(
    private val userRepository: UserRepository
) {
    private val log = LoggerFactory.getLogger(javaClass)

    /**
     * 카카오 연결 해제 웹훅
     * 사용자가 카카오톡에서 서비스 연결을 끊었을 때 호출됨
     */
    @PostMapping("/kakao/unlink")
    fun handleKakaoUnlink(@RequestBody request: KakaoUnlinkRequest): ResponseEntity<Void> {
        log.info("Received Kakao unlink webhook for user: ${request.user_id}")

        val providerId = request.user_id.toString()
        val user = userRepository.findByProviderId(providerId)

        if (user != null) {
            // 즉시 삭제하지 않고 휴면 상태로 변경
            user.status = UserStatus.DEACTIVATED
            user.deletedAt = LocalDateTime.now()
            // 법적 보관 의무: 3개월 후 완전 삭제 가능
            user.retentionUntil = LocalDateTime.now().plusMonths(3)

            userRepository.save(user)
            log.info("User ${user.id} deactivated. Will be deleted after ${user.retentionUntil}")
        } else {
            log.warn("User not found for providerId: $providerId")
        }

        return ResponseEntity.ok().build()
    }

    /**
     * 카카오 공용 웹훅 (연결, 연결 해제, 정보 수정 등)
     * referenceId는 카카오 개발자 콘솔에서 설정한 값
     */
    @PostMapping("/kakao")
    fun handleKakaoWebhook(@RequestBody request: KakaoWebhookRequest): ResponseEntity<Void> {
        log.info("Received Kakao webhook: ${request.type}")

        when (request.type) {
            "user.unlink" -> {
                request.user_id?.let { userId ->
                    handleKakaoUnlink(KakaoUnlinkRequest(userId, request.reference_id))
                }
            }
            else -> {
                log.info("Unhandled webhook type: ${request.type}")
            }
        }

        return ResponseEntity.ok().build()
    }
}

/**
 * 카카오 연결 해제 요청 DTO
 */
data class KakaoUnlinkRequest(
    val user_id: Long,
    val reference_id: String? = null
)

/**
 * 카카오 공용 웹훅 요청 DTO
 */
data class KakaoWebhookRequest(
    val type: String,  // user.unlink, user.update 등
    val user_id: Long? = null,
    val reference_id: String
)
