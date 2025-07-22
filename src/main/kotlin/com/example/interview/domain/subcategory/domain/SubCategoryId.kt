package com.example.interview.domain.subcategory.domain

import java.util.UUID

@JvmInline
value class SubCategoryId private constructor(
    val value: UUID
) {
    companion object {
        fun from(value: UUID): SubCategoryId {
            return SubCategoryId(value)
        }
        
        fun generate(): SubCategoryId = SubCategoryId(UUID.randomUUID())
    }
} 