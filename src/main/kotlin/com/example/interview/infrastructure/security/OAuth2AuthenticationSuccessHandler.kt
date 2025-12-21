package com.example.interview.infrastructure.security

import com.example.interview.domain.user.domain.AuthProvider
import com.example.interview.domain.user.domain.User
import com.example.interview.domain.user.domain.UserRepository
import com.example.interview.domain.user.domain.UserRole
import jakarta.servlet.http.Cookie
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.beans.factory.annotation.Value
import org.springframework.security.core.Authentication
import org.springframework.security.oauth2.client.OAuth2AuthorizedClient
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken
import org.springframework.security.oauth2.core.user.OAuth2User
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler
import org.springframework.stereotype.Component

@Component
class OAuth2AuthenticationSuccessHandler(
    private val jwtTokenProvider: JwtTokenProvider,
    private val userRepository: UserRepository,
    private val authorizedClientService: OAuth2AuthorizedClientService,
    @Value("\${app.oauth2.redirect-uri}") private val redirectUri: String,
    @Value("\${app.cookie.secure:true}") private val cookieSecure: Boolean,
    @Value("\${app.cookie.same-site:None}") private val cookieSameSite: String
) : SimpleUrlAuthenticationSuccessHandler() {

    override fun onAuthenticationSuccess(
        request: HttpServletRequest,
        response: HttpServletResponse,
        authentication: Authentication
    ) {
        val oAuth2User = authentication.principal as OAuth2User
        val token = authentication as OAuth2AuthenticationToken
        val registrationId = token.authorizedClientRegistrationId

        val (email, nickname, providerId, provider) = when (registrationId) {
            "kakao" -> extractKakaoUserInfo(oAuth2User)
            else -> throw IllegalStateException("Unsupported OAuth provider: $registrationId")
        }

        // OAuth2 액세스 토큰 가져오기
        val authorizedClient: OAuth2AuthorizedClient? = authorizedClientService.loadAuthorizedClient(
            registrationId,
            oAuth2User.getAttribute<Long>("id")!!.toString()
        )
        val accessToken = authorizedClient?.accessToken?.tokenValue

        // 사용자 조회 또는 생성
        val user = userRepository.findByEmail(email).orElseGet {
            userRepository.save(
                User(
                    email = email,
                    nickname = nickname,
                    provider = provider,
                    providerId = providerId,
                    role = UserRole.USER,
                    oauthAccessToken = accessToken
                )
            )
        }

        // 탈퇴한 사용자 로그인 불가
        if (user.status == com.example.interview.domain.user.domain.UserStatus.DELETED) {
            // 에러 페이지로 리다이렉트 (프론트엔드에서 처리)
            redirectStrategy.sendRedirect(request, response, "$redirectUri?error=account_deleted")
            return
        }

        // 마지막 로그인 시간 및 액세스 토큰 업데이트
        user.lastLoginAt = java.time.LocalDateTime.now()
        user.oauthAccessToken = accessToken
        userRepository.save(user)

        // JWT 토큰 생성
        val jwtToken = jwtTokenProvider.generateToken(user.id!!, user.email)

        // HttpOnly 쿠키로 토큰 설정
        val cookie = Cookie("token", jwtToken).apply {
            isHttpOnly = true
            secure = cookieSecure
            path = "/"
            maxAge = 86400 // 24시간
            if (cookieSameSite.isNotBlank()) {
                setAttribute("SameSite", cookieSameSite)
            }
        }
        response.addCookie(cookie)

        // 프론트엔드로 리다이렉트 (토큰은 쿠키에 있으므로 URL에서 제거)
        redirectStrategy.sendRedirect(request, response, redirectUri)
    }

    private fun extractKakaoUserInfo(oAuth2User: OAuth2User): OAuth2UserInfo {
        // 카카오 ID만 사용 (추가 동의 항목 없이)
        val providerId = oAuth2User.getAttribute<Long>("id")!!.toString()

        // 이메일은 providerId@kakao.com 형식으로 생성 (내부용)
        val email = "${providerId}@kakao.com"

        // 닉네임은 사용자가 직접 설정하도록 기본값 제공
        val nickname = "사용자$providerId"

        return OAuth2UserInfo(email, nickname, providerId, AuthProvider.KAKAO)
    }

    data class OAuth2UserInfo(
        val email: String,
        val nickname: String,
        val providerId: String,
        val provider: AuthProvider
    )
}
