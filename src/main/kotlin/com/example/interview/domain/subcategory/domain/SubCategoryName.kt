package com.example.interview.domain.subcategory.domain

@JvmInline
value class SubCategoryName private constructor(
    val value: String
) {
    companion object {
        fun from(value: String): SubCategoryName {
            require(value.isNotBlank()) { "서브 카테고리 이름은 비어있을 수 없습니다." }
            return SubCategoryName(value)
        }
    }
} 