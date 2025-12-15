package com.example.interview.domain.ai.application

import com.example.interview.domain.ai.infrastructure.persistence.AIUsageQuotaEntity
import com.example.interview.domain.ai.infrastructure.persistence.JpaAIUsageQuotaRepository
import org.springframework.beans.factory.annotation.Value
import org.springframework.cache.annotation.CachePut
import org.springframework.cache.annotation.Cacheable
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDate

@Service
class AIQuotaService(
    private val quotaRepository: JpaAIUsageQuotaRepository,
    @Value("\${ai.quota.daily-limit:5}") private val dailyLimit: Int
) {

    /**
     * 남은 quota 조회 (캐싱 적용)
     * Key: userId::날짜
     * TTL: 10분
     */
    @Cacheable(
        cacheNames = ["user-quota"],
        key = "#userId + '::' + T(java.time.LocalDate).now().toString()",
        unless = "#result <= 0"  // 0 이하는 캐싱 안 함
    )
    fun getRemainingQuota(userId: Long): Int {
        val today = LocalDate.now()
        val used = quotaRepository
            .findByUserIdAndUsageDate(userId, today)
            ?.count ?: 0

        return maxOf(0, dailyLimit - used)
    }

    /**
     * Quota 사용 (캐시 업데이트)
     * @return 사용 후 남은 횟수
     */
    @CachePut(
        cacheNames = ["user-quota"],
        key = "#userId + '::' + T(java.time.LocalDate).now().toString()"
    )
    @Transactional
    fun useQuota(userId: Long): Int {
        val today = LocalDate.now()

        val quota = quotaRepository
            .findByUserIdAndUsageDate(userId, today)
            ?: AIUsageQuotaEntity(
                userId = userId,
                usageDate = today,
                count = 0
            )

        // DB 업데이트
        val updated = quotaRepository.save(quota.increment())

        // 새로운 남은 횟수 반환 (캐시에 자동 저장)
        return maxOf(0, dailyLimit - updated.count)
    }

    /**
     * AI 사용 가능 여부
     */
    fun canUseAI(userId: Long): Boolean {
        return getRemainingQuota(userId) > 0
    }

    /**
     * 30일 지난 데이터 삭제 (매월 1일 자정 실행)
     */
    @Scheduled(cron = "0 0 0 1 * *")
    @Transactional
    fun cleanupOldQuotaData() {
        val cutoffDate = LocalDate.now().minusDays(30)
        val deletedCount = quotaRepository.deleteByUsageDateBefore(cutoffDate)
        println("정리 완료: ${deletedCount}개의 오래된 quota 데이터 삭제")
    }
}
