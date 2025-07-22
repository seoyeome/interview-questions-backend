package com.example.interview.domain.category.presentation.dto

import com.example.interview.domain.category.application.dto.CreateCategoryCommand
import com.example.interview.domain.category.application.dto.UpdateCategoryCommand
import com.example.interview.domain.category.domain.CategoryId
import java.util.UUID

data class CreateCategoryRequest(
    val name: String
) {
    fun toCommand(): CreateCategoryCommand {
        return CreateCategoryCommand(name)
    }
}

data class UpdateCategoryRequest(
    val name: String?
) {
    fun toCommand(id: UUID): UpdateCategoryCommand {
        return UpdateCategoryCommand(
            id = CategoryId.from(id),
            name = name
        )
    }
} 