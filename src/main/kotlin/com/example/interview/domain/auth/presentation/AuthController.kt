package com.example.interview.domain.auth.presentation

import com.example.interview.domain.auth.presentation.dto.LoginRequest
import com.example.interview.domain.auth.presentation.dto.SignupRequest
import com.example.interview.domain.auth.presentation.dto.AuthResponse
import com.example.interview.domain.user.domain.AuthProvider
import com.example.interview.domain.user.domain.User
import com.example.interview.domain.user.domain.UserRepository
import com.example.interview.domain.user.domain.UserRole
import com.example.interview.infrastructure.security.JwtTokenProvider
import jakarta.servlet.http.Cookie
import jakarta.servlet.http.HttpServletResponse
import jakarta.validation.Valid
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/v1/auth")
class AuthController(
    private val userRepository: UserRepository,
    private val jwtTokenProvider: JwtTokenProvider,
    private val passwordEncoder: BCryptPasswordEncoder
) {

    @PostMapping("/signup")
    fun signup(
        @Valid @RequestBody request: SignupRequest
    ): ResponseEntity<AuthResponse> {
        // 이메일 중복 체크
        if (userRepository.existsByEmail(request.email)) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                .body(AuthResponse(null, "이미 존재하는 이메일입니다"))
        }

        // 사용자 생성
        userRepository.save(
            User(
                email = request.email,
                name = request.name,
                password = passwordEncoder.encode(request.password),
                provider = AuthProvider.LOCAL,
                role = UserRole.USER
            )
        )

        return ResponseEntity.status(HttpStatus.CREATED)
            .body(AuthResponse(null, "회원가입 성공"))
    }

    @PostMapping("/login")
    fun login(
        @Valid @RequestBody request: LoginRequest,
        response: HttpServletResponse
    ): ResponseEntity<AuthResponse> {
        // 사용자 조회
        val user = userRepository.findByEmail(request.email).orElse(null)
            ?: return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(AuthResponse(null, "이메일 또는 비밀번호가 올바르지 않습니다"))

        // OAuth 사용자는 일반 로그인 불가
        if (user.provider != AuthProvider.LOCAL) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(AuthResponse(null, "${user.provider.name} 로그인을 이용해주세요"))
        }

        // 비밀번호 검증
        if (!passwordEncoder.matches(request.password, user.password)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(AuthResponse(null, "이메일 또는 비밀번호가 올바르지 않습니다"))
        }

        // JWT 토큰 생성
        val token = jwtTokenProvider.generateToken(user.id!!, user.email)

        // HttpOnly 쿠키로 토큰 설정
        val cookie = Cookie("token", token).apply {
            isHttpOnly = true
            secure = true // HTTPS only
            path = "/"
            maxAge = 86400 // 24시간
            setAttribute("SameSite", "Strict")
        }
        response.addCookie(cookie)

        return ResponseEntity.ok(AuthResponse(null, "로그인 성공"))
    }

    @PostMapping("/logout")
    fun logout(response: HttpServletResponse): ResponseEntity<AuthResponse> {
        // 쿠키 삭제
        val cookie = Cookie("token", "").apply {
            isHttpOnly = true
            secure = true
            path = "/"
            maxAge = 0
            setAttribute("SameSite", "Strict")
        }
        response.addCookie(cookie)

        return ResponseEntity.ok(AuthResponse(null, "로그아웃 성공"))
    }
}
