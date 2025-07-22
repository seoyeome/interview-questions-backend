package com.example.interview.domain.question.application.dto

import com.example.interview.domain.question.domain.Question
import com.example.interview.domain.question.domain.QuestionDifficulty
import java.time.LocalDateTime
import java.util.UUID

data class QuestionResponse(
    val id: UUID,
    val subCategoryId: UUID,
    val content: String,
    val difficulty: QuestionDifficulty,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime
) {
    companion object {
        fun from(question: Question): QuestionResponse {
            return QuestionResponse(
                id = question.id.value,
                subCategoryId = question.subCategoryId.value,
                content = question.content,
                difficulty = question.difficulty,
                createdAt = question.createdAt,
                updatedAt = question.updatedAt
            )
        }
    }
} 