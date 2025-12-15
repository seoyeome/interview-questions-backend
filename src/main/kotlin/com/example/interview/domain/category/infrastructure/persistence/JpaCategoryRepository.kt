package com.example.interview.domain.category.infrastructure.persistence

import org.springframework.data.jpa.repository.JpaRepository
import java.util.UUID

interface JpaCategoryRepository : JpaRepository<CategoryEntity, UUID> {
    fun findByName(name: String): CategoryEntity?
    fun existsByName(name: String): Boolean
} 