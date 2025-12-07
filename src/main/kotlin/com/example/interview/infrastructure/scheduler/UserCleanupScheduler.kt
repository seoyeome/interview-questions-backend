package com.example.interview.infrastructure.scheduler

import com.example.interview.domain.user.domain.UserRepository
import org.slf4j.LoggerFactory
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDateTime

/**
 * 탈퇴 후 30일이 경과된 사용자 데이터를 자동으로 완전 삭제하는 스케줄러
 * 개인정보보호법 준수를 위한 데이터 보관 기간 관리
 */
@Component
class UserCleanupScheduler(
    private val userRepository: UserRepository
) {
    private val logger = LoggerFactory.getLogger(javaClass)

    /**
     * 매일 새벽 3시에 실행
     * 30일 보관 기간이 경과된 삭제 예정 사용자를 완전히 삭제
     */
    @Scheduled(cron = "0 0 3 * * *")
    @Transactional
    fun cleanupExpiredUsers() {
        logger.info("사용자 데이터 정리 스케줄러 시작")

        val currentTime = LocalDateTime.now()
        val usersToDelete = userRepository.findDeletedUsersReadyForPermanentDeletion(currentTime)

        if (usersToDelete.isEmpty()) {
            logger.info("삭제할 사용자가 없습니다")
            return
        }

        logger.info("${usersToDelete.size}명의 사용자 데이터를 완전히 삭제합니다")

        usersToDelete.forEach { user ->
            logger.info("사용자 완전 삭제 - ID: ${user.id}, Email: ${user.email}, 탈퇴일: ${user.deletedAt}")
        }

        // 완전 삭제 (Hard Delete)
        userRepository.deleteAll(usersToDelete)

        logger.info("사용자 데이터 정리 완료: ${usersToDelete.size}명 삭제됨")
    }
}
