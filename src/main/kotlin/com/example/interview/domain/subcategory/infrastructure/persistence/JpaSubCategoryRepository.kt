package com.example.interview.domain.subcategory.infrastructure.persistence

import org.springframework.data.jpa.repository.JpaRepository
import java.util.UUID

interface JpaSubCategoryRepository : JpaRepository<SubCategoryEntity, UUID> {
    fun findByNameAndCategoryId(name: String, categoryId: UUID): SubCategoryEntity?
    fun findAllByCategoryId(categoryId: UUID): List<SubCategoryEntity>
    fun existsByNameAndCategoryId(name: String, categoryId: UUID): Boolean
} 