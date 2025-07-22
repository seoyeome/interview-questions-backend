package com.example.interview.domain.subcategory.application.dto

import com.example.interview.domain.subcategory.domain.SubCategory
import java.time.LocalDateTime
import java.util.UUID

data class SubCategoryResponse(
    val id: UUID,
    val categoryId: UUID,
    val name: String,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime
) {
    companion object {
        fun from(subCategory: SubCategory): SubCategoryResponse {
            return SubCategoryResponse(
                id = subCategory.id.value,
                categoryId = subCategory.categoryId.value,
                name = subCategory.name,
                createdAt = subCategory.createdAt,
                updatedAt = subCategory.updatedAt
            )
        }
    }
} 