package com.example.interview.infrastructure.config

import com.github.benmanes.caffeine.cache.Caffeine
import org.springframework.cache.CacheManager
import org.springframework.cache.annotation.EnableCaching
import org.springframework.cache.caffeine.CaffeineCacheManager
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import java.util.concurrent.TimeUnit

@Configuration
@EnableCaching
class CacheConfig {

    @Bean
    fun cacheManager(): CacheManager {
        val cacheManager = CaffeineCacheManager("user-quota")
        cacheManager.setCaffeine(
            Caffeine.newBuilder()
                .maximumSize(10_000)  // 최대 10,000개 엔트리
                .expireAfterWrite(10, TimeUnit.MINUTES)  // 10분 TTL
                .recordStats()  // 통계 기록 (모니터링용)
        )
        return cacheManager
    }
}
