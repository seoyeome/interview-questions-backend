package com.example.interview.domain.category.application.dto

import com.example.interview.domain.category.domain.Category
import com.example.interview.domain.category.domain.CategoryId
import java.util.UUID

data class CreateCategoryCommand(
    val name: String
) {
    fun toEntity(): Category {
        return Category.create(name)
    }
}

data class UpdateCategoryCommand(
    val id: CategoryId,
    val name: String?
) 