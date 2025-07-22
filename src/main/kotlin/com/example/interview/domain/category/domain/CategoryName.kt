package com.example.interview.domain.category.domain

@JvmInline
value class CategoryName private constructor(
    val value: String
) {
    companion object {
        fun from(value: String): CategoryName {
            require(value.isNotBlank()) { "카테고리 이름은 비어있을 수 없습니다." }
            return CategoryName(value)
        }
    }
} 