package com.example.interview.domain.subcategory.application.dto

import com.example.interview.domain.category.domain.CategoryId
import com.example.interview.domain.subcategory.domain.SubCategory
import com.example.interview.domain.subcategory.domain.SubCategoryId

data class CreateSubCategoryCommand(
    val categoryId: CategoryId,
    val name: String
) {
    fun toEntity(): SubCategory {
        return SubCategory.create(
            categoryId = categoryId,
            name = name
        )
    }
}

data class UpdateSubCategoryCommand(
    val id: SubCategoryId,
    val name: String?
) 