package com.example.interview.domain.auth.presentation.dto

import jakarta.validation.constraints.Email
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.Size

data class SignupRequest(
    @field:NotBlank(message = "이메일은 필수입니다")
    @field:Email(message = "올바른 이메일 형식이 아닙니다")
    val email: String,

    @field:NotBlank(message = "닉네임은 필수입니다")
    @field:Size(min = 2, max = 50, message = "닉네임은 2-50자 사이여야 합니다")
    val nickname: String,

    @field:NotBlank(message = "비밀번호는 필수입니다")
    @field:Size(min = 8, max = 100, message = "비밀번호는 8-100자 사이여야 합니다")
    val password: String
)

data class LoginRequest(
    @field:NotBlank(message = "이메일은 필수입니다")
    @field:Email(message = "올바른 이메일 형식이 아닙니다")
    val email: String,

    @field:NotBlank(message = "비밀번호는 필수입니다")
    val password: String
)

data class AuthResponse(
    val token: String?,
    val message: String
)
