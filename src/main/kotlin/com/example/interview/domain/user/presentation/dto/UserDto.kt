package com.example.interview.domain.user.presentation.dto

import com.example.interview.domain.user.domain.AuthProvider
import com.example.interview.domain.user.domain.UserRole
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.Size

data class UserProfileResponse(
    val id: Long,
    val email: String,
    val nickname: String,
    val provider: AuthProvider,
    val role: UserRole,
    val createdAt: String,
    val lastLoginAt: String?
)

data class UpdateNicknameRequest(
    @field:NotBlank(message = "닉네임은 필수입니다")
    @field:Size(min = 2, max = 50, message = "닉네임은 2-50자 사이여야 합니다")
    val nickname: String
)

data class ChangePasswordRequest(
    @field:NotBlank(message = "현재 비밀번호는 필수입니다")
    val currentPassword: String,

    @field:NotBlank(message = "새 비밀번호는 필수입니다")
    @field:Size(min = 8, max = 100, message = "비밀번호는 8-100자 사이여야 합니다")
    val newPassword: String
)

data class MessageResponse(
    val message: String
)
