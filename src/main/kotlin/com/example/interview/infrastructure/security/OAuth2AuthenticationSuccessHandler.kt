package com.example.interview.infrastructure.security

import com.example.interview.domain.user.domain.AuthProvider
import com.example.interview.domain.user.domain.User
import com.example.interview.domain.user.domain.UserRepository
import com.example.interview.domain.user.domain.UserRole
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.beans.factory.annotation.Value
import org.springframework.security.core.Authentication
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken
import org.springframework.security.oauth2.core.user.OAuth2User
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler
import org.springframework.stereotype.Component
import org.springframework.web.util.UriComponentsBuilder

@Component
class OAuth2AuthenticationSuccessHandler(
    private val jwtTokenProvider: JwtTokenProvider,
    private val userRepository: UserRepository,
    @Value("\${app.oauth2.redirect-uri}") private val redirectUri: String
) : SimpleUrlAuthenticationSuccessHandler() {

    override fun onAuthenticationSuccess(
        request: HttpServletRequest,
        response: HttpServletResponse,
        authentication: Authentication
    ) {
        val oAuth2User = authentication.principal as OAuth2User
        val token = authentication as OAuth2AuthenticationToken
        val registrationId = token.authorizedClientRegistrationId

        val (email, name, profileImageUrl, providerId, provider) = when (registrationId) {
            "kakao" -> extractKakaoUserInfo(oAuth2User)
            else -> throw IllegalStateException("Unsupported OAuth provider: $registrationId")
        }

        // 사용자 조회 또는 생성
        val user = userRepository.findByEmail(email).orElseGet {
            userRepository.save(
                User(
                    email = email,
                    name = name,
                    profileImageUrl = profileImageUrl,
                    provider = provider,
                    providerId = providerId,
                    role = UserRole.USER
                )
            )
        }

        // JWT 토큰 생성
        val jwtToken = jwtTokenProvider.generateToken(user.id!!, user.email)

        // 프론트엔드로 리다이렉트 (토큰 포함)
        val targetUrl = UriComponentsBuilder.fromUriString(redirectUri)
            .queryParam("token", jwtToken)
            .build()
            .toUriString()

        redirectStrategy.sendRedirect(request, response, targetUrl)
    }

    private fun extractKakaoUserInfo(oAuth2User: OAuth2User): OAuth2UserInfo {
        // 카카오 ID만 사용 (추가 동의 항목 없이)
        val providerId = oAuth2User.getAttribute<Long>("id")!!.toString()

        // 이메일은 providerId@kakao.com 형식으로 생성 (내부용)
        val email = "${providerId}@kakao.com"

        // 닉네임은 사용자가 직접 설정하도록 기본값 제공
        val name = "사용자$providerId"

        return OAuth2UserInfo(email, name, null, providerId, AuthProvider.KAKAO)
    }

    data class OAuth2UserInfo(
        val email: String,
        val name: String,
        val profileImageUrl: String?,
        val providerId: String,
        val provider: AuthProvider
    )
}
