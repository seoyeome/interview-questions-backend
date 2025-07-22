package com.example.interview.domain.category.domain

import java.util.UUID

@JvmInline
value class CategoryId private constructor(
    val value: UUID
) {
    companion object {
        fun from(value: UUID): CategoryId = CategoryId(value)
        
        fun generate(): CategoryId = CategoryId(UUID.randomUUID())
    }
} 