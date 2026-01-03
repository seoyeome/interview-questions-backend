package com.example.interview.infrastructure.config

import org.flywaydb.core.Flyway
import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.autoconfigure.flyway.FlywayMigrationStrategy
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

@Configuration
class FlywayConfig {

    @Bean
    fun flywayMigrationStrategy(
        @Value("\${FLYWAY_REPAIR_ON_STARTUP:false}") repairOnStartup: Boolean
    ): FlywayMigrationStrategy {
        return FlywayMigrationStrategy { flyway: Flyway ->
            if (repairOnStartup) {
                println("⚠️  FLYWAY_REPAIR_ON_STARTUP=true - Executing flyway.repair()...")
                flyway.repair()
                println("✅ Flyway repair completed")
            }
            flyway.migrate()
        }
    }
}
