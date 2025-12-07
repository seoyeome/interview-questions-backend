package com.example.interview.domain.user.domain

import jakarta.persistence.*
import org.springframework.data.annotation.CreatedDate
import org.springframework.data.annotation.LastModifiedDate
import org.springframework.data.jpa.domain.support.AuditingEntityListener
import java.time.LocalDateTime

@Entity
@Table(name = "users")
@EntityListeners(AuditingEntityListener::class)
class User(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @Column(nullable = false, unique = true)
    val email: String,

    @Column(nullable = false)
    var nickname: String,

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    val provider: AuthProvider,

    @Column(name = "provider_id")
    val providerId: String? = null,

    @Column(name = "oauth_access_token", length = 500)
    var oauthAccessToken: String? = null,

    @Column(name = "password")
    var password: String? = null,

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    val role: UserRole = UserRole.USER,

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    var status: UserStatus = UserStatus.ACTIVE,

    @Column(name = "last_login_at")
    var lastLoginAt: LocalDateTime? = null,

    @Column(name = "deleted_at")
    var deletedAt: LocalDateTime? = null,

    @Column(name = "retention_until")
    var retentionUntil: LocalDateTime? = null,

    @CreatedDate
    @Column(nullable = false, updatable = false)
    var createdAt: LocalDateTime = LocalDateTime.now(),

    @LastModifiedDate
    @Column(nullable = false)
    var updatedAt: LocalDateTime = LocalDateTime.now()
)

enum class AuthProvider {
    KAKAO,
    LOCAL
}

enum class UserRole {
    USER,
    ADMIN
}

enum class UserStatus {
    ACTIVE,      // 활성 사용자
    DEACTIVATED, // 연결 끊김 (휴면)
    SUSPENDED,   // 정지
    DELETED      // 삭제 예정
}
