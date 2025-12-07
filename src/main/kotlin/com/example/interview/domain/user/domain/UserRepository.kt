package com.example.interview.domain.user.domain

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.stereotype.Repository
import java.time.LocalDateTime
import java.util.*

@Repository
interface UserRepository : JpaRepository<User, Long> {
    fun findByEmail(email: String): Optional<User>
    fun existsByEmail(email: String): Boolean
    fun findByProviderId(providerId: String): User?

    // 30일 경과된 삭제 예정 사용자 조회 (자동 삭제용)
    @Query("SELECT u FROM User u WHERE u.status = 'DELETED' AND u.retentionUntil <= :currentTime")
    fun findDeletedUsersReadyForPermanentDeletion(currentTime: LocalDateTime): List<User>
}
