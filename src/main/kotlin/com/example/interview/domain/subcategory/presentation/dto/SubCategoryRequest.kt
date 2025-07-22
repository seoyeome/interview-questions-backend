package com.example.interview.domain.subcategory.presentation.dto

import com.example.interview.domain.category.domain.CategoryId
import com.example.interview.domain.subcategory.application.dto.CreateSubCategoryCommand
import com.example.interview.domain.subcategory.application.dto.UpdateSubCategoryCommand
import com.example.interview.domain.subcategory.domain.SubCategoryId
import java.util.UUID

data class CreateSubCategoryRequest(
    val categoryId: UUID,
    val name: String
) {
    fun toCommand(): CreateSubCategoryCommand {
        return CreateSubCategoryCommand(
            categoryId = CategoryId.from(categoryId),
            name = name
        )
    }
}

data class UpdateSubCategoryRequest(
    val name: String?
) {
    fun toCommand(id: UUID): UpdateSubCategoryCommand {
        return UpdateSubCategoryCommand(
            id = SubCategoryId.from(id),
            name = name
        )
    }
} 