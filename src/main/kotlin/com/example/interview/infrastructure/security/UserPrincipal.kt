package com.example.interview.infrastructure.security

import com.example.interview.domain.user.domain.UserRole

data class UserPrincipal(
    val id: Long,
    val email: String,
    val role: UserRole
)
