package com.example.interview.domain.user.presentation

import com.example.interview.domain.user.domain.AuthProvider
import com.example.interview.domain.user.domain.UserRepository
import com.example.interview.domain.user.presentation.dto.ChangePasswordRequest
import com.example.interview.domain.user.presentation.dto.UpdateNicknameRequest
import com.example.interview.domain.user.presentation.dto.UserProfileResponse
import com.example.interview.infrastructure.common.dto.ApiResponse
import com.example.interview.infrastructure.oauth.KakaoUnlinkService
import com.example.interview.infrastructure.security.JwtTokenProvider
import jakarta.servlet.http.Cookie
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import jakarta.validation.Valid
import org.slf4j.LoggerFactory
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.web.bind.annotation.*
import kotlin.system.measureTimeMillis

@RestController
@RequestMapping("/api/v1/user")
class UserController(
    private val userRepository: UserRepository,
    private val jwtTokenProvider: JwtTokenProvider,
    private val passwordEncoder: BCryptPasswordEncoder,
    private val kakaoUnlinkService: KakaoUnlinkService
) {
    private val logger = LoggerFactory.getLogger(UserController::class.java)

    @GetMapping("/profile")
    fun getProfile(request: HttpServletRequest): ResponseEntity<ApiResponse<UserProfileResponse>> {
        val userId = getUserIdFromToken(request)
            ?: return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build()

        val user = userRepository.findById(userId).orElseThrow {
            throw IllegalArgumentException("사용자를 찾을 수 없습니다")
        }

        val profileData = UserProfileResponse(
            id = user.id!!,
            email = user.email,
            nickname = user.nickname,
            provider = user.provider,
            role = user.role,
            createdAt = user.createdAt.toString(),
            lastLoginAt = user.lastLoginAt?.toString()
        )

        return ResponseEntity.ok(ApiResponse.success(profileData))
    }

    /**
     * 튜토리얼 완료 여부 조회
     */
    @GetMapping("/tutorial-status")
    fun getTutorialStatus(request: HttpServletRequest): ResponseEntity<ApiResponse<Boolean>> {
        var result: ResponseEntity<ApiResponse<Boolean>>
        val elapsed = measureTimeMillis {
            val userId = getUserIdFromToken(request)
            if (userId == null) {
                result = ResponseEntity.status(HttpStatus.UNAUTHORIZED).build()
                return@measureTimeMillis
            }

            val user = userRepository.findById(userId).orElseThrow {
                throw IllegalArgumentException("사용자를 찾을 수 없습니다")
            }
            result = ResponseEntity.ok(ApiResponse.success(user.tutorialCompleted))
        }
        logger.info("GET /api/v1/user/tutorial-status - ${elapsed}ms")
        return result
    }

    /**
     * 튜토리얼 완료 처리
     */
    @PostMapping("/tutorial-complete")
    fun completeTutorial(request: HttpServletRequest): ResponseEntity<ApiResponse<Unit>> {
        val userId = getUserIdFromToken(request)
            ?: return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build()

        val user = userRepository.findById(userId).orElseThrow {
            throw IllegalArgumentException("사용자를 찾을 수 없습니다")
        }

        user.tutorialCompleted = true
        userRepository.save(user)

        return ResponseEntity.ok(ApiResponse.success("튜토리얼이 완료되었습니다"))
    }

    /**
     * 튜토리얼 재시작 (다시 보기)
     */
    @PostMapping("/tutorial-reset")
    fun resetTutorial(request: HttpServletRequest): ResponseEntity<ApiResponse<Unit>> {
        val userId = getUserIdFromToken(request)
            ?: return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build()

        val user = userRepository.findById(userId).orElseThrow {
            throw IllegalArgumentException("사용자를 찾을 수 없습니다")
        }

        user.tutorialCompleted = false
        userRepository.save(user)

        return ResponseEntity.ok(ApiResponse.success("튜토리얼이 초기화되었습니다"))
    }

    @PatchMapping("/nickname")
    fun updateNickname(
        @Valid @RequestBody request: UpdateNicknameRequest,
        httpRequest: HttpServletRequest
    ): ResponseEntity<ApiResponse<Unit>> {
        val userId = getUserIdFromToken(httpRequest)
            ?: return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build()

        val user = userRepository.findById(userId).orElseThrow {
            throw IllegalArgumentException("사용자를 찾을 수 없습니다")
        }

        user.nickname = request.nickname
        userRepository.save(user)

        return ResponseEntity.ok(ApiResponse.success("닉네임이 변경되었습니다"))
    }

    @PatchMapping("/password")
    fun changePassword(
        @Valid @RequestBody request: ChangePasswordRequest,
        httpRequest: HttpServletRequest
    ): ResponseEntity<ApiResponse<Unit>> {
        val userId = getUserIdFromToken(httpRequest)
            ?: return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build()

        val user = userRepository.findById(userId).orElseThrow {
            throw IllegalArgumentException("사용자를 찾을 수 없습니다")
        }

        // LOCAL 제공자만 비밀번호 변경 가능
        if (user.provider != AuthProvider.LOCAL) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                .body(ApiResponse.error("소셜 로그인 사용자는 비밀번호를 변경할 수 없습니다"))
        }

        // 현재 비밀번호 확인
        if (!passwordEncoder.matches(request.currentPassword, user.password)) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.error("현재 비밀번호가 일치하지 않습니다"))
        }

        // 새 비밀번호로 변경
        user.password = passwordEncoder.encode(request.newPassword)
        userRepository.save(user)

        return ResponseEntity.ok(ApiResponse.success("비밀번호가 변경되었습니다"))
    }

    @DeleteMapping
    fun deleteAccount(
        httpRequest: HttpServletRequest,
        response: HttpServletResponse
    ): ResponseEntity<ApiResponse<Unit>> {
        val userId = getUserIdFromToken(httpRequest)
            ?: return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build()

        val user = userRepository.findById(userId).orElseThrow {
            throw IllegalArgumentException("사용자를 찾을 수 없습니다")
        }

        // 카카오 OAuth 사용자인 경우 연결 해제
        if (user.provider == AuthProvider.KAKAO && user.oauthAccessToken != null) {
            kakaoUnlinkService.unlinkKakaoAccount(user.oauthAccessToken!!)
        }

        // Soft Delete: 상태 변경 및 삭제 일시 기록
        user.status = com.example.interview.domain.user.domain.UserStatus.DELETED
        user.deletedAt = java.time.LocalDateTime.now()
        user.retentionUntil = java.time.LocalDateTime.now().plusDays(30) // 30일 후 완전 삭제
        userRepository.save(user)

        // 쿠키 삭제
        val cookie = Cookie("token", "").apply {
            isHttpOnly = true
            secure = true
            path = "/"
            maxAge = 0
            setAttribute("SameSite", "None")
        }
        response.addCookie(cookie)

        return ResponseEntity.ok(ApiResponse.success("회원 탈퇴가 완료되었습니다. 30일 후 모든 데이터가 완전히 삭제됩니다."))
    }

    private fun getUserIdFromToken(request: HttpServletRequest): Long? {
        val cookies = request.cookies ?: return null
        val tokenCookie = cookies.find { it.name == "token" } ?: return null
        return jwtTokenProvider.getUserIdFromToken(tokenCookie.value)
    }
}
