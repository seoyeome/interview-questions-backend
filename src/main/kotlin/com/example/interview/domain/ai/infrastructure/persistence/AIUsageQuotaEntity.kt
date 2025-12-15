package com.example.interview.domain.ai.infrastructure.persistence

import jakarta.persistence.*
import java.time.LocalDate

@Entity
@Table(
    name = "ai_usage_quota",
    indexes = [
        Index(name = "idx_user_date", columnList = "user_id,usage_date")
    ]
)
class AIUsageQuotaEntity(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @Column(name = "user_id", nullable = false)
    val userId: Long,

    @Column(name = "usage_date", nullable = false)
    val usageDate: LocalDate,

    @Column(nullable = false)
    val count: Int = 0
) {
    fun increment(): AIUsageQuotaEntity {
        return AIUsageQuotaEntity(
            id = this.id,
            userId = this.userId,
            usageDate = this.usageDate,
            count = this.count + 1
        )
    }
}
