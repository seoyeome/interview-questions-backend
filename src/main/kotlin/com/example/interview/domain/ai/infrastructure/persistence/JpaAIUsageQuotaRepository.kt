package com.example.interview.domain.ai.infrastructure.persistence

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import java.time.LocalDate

interface JpaAIUsageQuotaRepository : JpaRepository<AIUsageQuotaEntity, Long> {

    fun findByUserIdAndUsageDate(userId: Long, usageDate: LocalDate): AIUsageQuotaEntity?

    @Modifying
    @Query("DELETE FROM AIUsageQuotaEntity a WHERE a.usageDate < :cutoffDate")
    fun deleteByUsageDateBefore(@Param("cutoffDate") cutoffDate: LocalDate): Int
}
