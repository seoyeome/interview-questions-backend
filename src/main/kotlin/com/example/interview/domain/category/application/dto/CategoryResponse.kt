package com.example.interview.domain.category.application.dto

import com.example.interview.domain.category.domain.Category
import java.time.LocalDateTime
import java.util.UUID

data class CategoryResponse(
    val id: UUID,
    val name: String,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime
) {
    companion object {
        fun from(category: Category): CategoryResponse {
            return CategoryResponse(
                id = category.id.value,
                name = category.name,
                createdAt = category.createdAt,
                updatedAt = category.updatedAt
            )
        }
    }
} 