package com.example.interview.domain.question.presentation.dto

import com.example.interview.domain.question.application.dto.CreateQuestionCommand
import com.example.interview.domain.question.application.dto.UpdateQuestionCommand
import com.example.interview.domain.question.domain.QuestionDifficulty
import com.example.interview.domain.question.domain.QuestionId
import com.example.interview.domain.subcategory.domain.SubCategoryId
import java.util.UUID

data class CreateQuestionRequest(
    val subCategoryId: UUID,
    val content: String,
    val difficulty: String
) {
    fun toCommand(): CreateQuestionCommand {
        return CreateQuestionCommand(
            subCategoryId = SubCategoryId.from(subCategoryId),
            content = content,
            difficulty = QuestionDifficulty.valueOf(difficulty)
        )
    }
}

data class UpdateQuestionRequest(
    val content: String?,
    val difficulty: String?
) {
    fun toCommand(id: UUID): UpdateQuestionCommand {
        return UpdateQuestionCommand(
            id = QuestionId.from(id),
            content = content,
            difficulty = difficulty?.let { QuestionDifficulty.valueOf(it) }
        )
    }
} 