package com.example.interview.domain.question.application.dto

import com.example.interview.domain.question.domain.Question
import com.example.interview.domain.question.domain.QuestionContent
import com.example.interview.domain.question.domain.QuestionDifficulty
import com.example.interview.domain.question.domain.QuestionId
import com.example.interview.domain.subcategory.domain.SubCategoryId

data class CreateQuestionCommand(
    val subCategoryId: SubCategoryId,
    val content: String,
    val difficulty: QuestionDifficulty
) {
    fun toEntity(): Question {
        return Question.create(
            subCategoryId = subCategoryId,
            content = content,
            difficulty = difficulty
        )
    }
}

data class UpdateQuestionCommand(
    val id: QuestionId,
    val content: String?,
    val difficulty: QuestionDifficulty?
) {
    fun toContent(): QuestionContent? {
        return content?.let { QuestionContent.from(it) }
    }

    fun toDifficulty(): QuestionDifficulty? {
        return difficulty
    }
} 