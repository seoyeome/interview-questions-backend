package com.example.interview.domain.question.domain

import com.example.interview.domain.subcategory.domain.SubCategoryId
import java.time.LocalDateTime
import java.util.UUID

class Question private constructor(
    private val _id: QuestionId,
    private val _subCategoryId: SubCategoryId,
    private var _content: QuestionContent,
    private var _difficulty: QuestionDifficulty,
    private var _explanation: String?,
    private val _createdAt: LocalDateTime,
    private var _updatedAt: LocalDateTime
) {
    val id: QuestionId
        get() = _id

    val subCategoryId: SubCategoryId
        get() = _subCategoryId

    val content: String
        get() = _content.value

    val difficulty: QuestionDifficulty
        get() = _difficulty

    val explanation: String?
        get() = _explanation

    val createdAt: LocalDateTime
        get() = _createdAt

    val updatedAt: LocalDateTime
        get() = _updatedAt

    fun updateContent(content: String) {
        _content = QuestionContent.from(content)
        _updatedAt = LocalDateTime.now()
    }

    fun updateDifficulty(difficulty: QuestionDifficulty) {
        _difficulty = difficulty
        _updatedAt = LocalDateTime.now()
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as Question

        return id == other.id
    }

    override fun hashCode(): Int {
        return id.hashCode()
    }

    companion object {
        fun from(
            id: QuestionId,
            subCategoryId: SubCategoryId,
            content: QuestionContent,
            difficulty: QuestionDifficulty,
            explanation: String? = null
        ): Question {
            return Question(
                _id = id,
                _subCategoryId = subCategoryId,
                _content = content,
                _difficulty = difficulty,
                _explanation = explanation,
                _createdAt = LocalDateTime.now(),
                _updatedAt = LocalDateTime.now()
            )
        }

        fun create(
            subCategoryId: SubCategoryId,
            content: String,
            difficulty: QuestionDifficulty,
            explanation: String? = null
        ): Question {
            return Question(
                _id = QuestionId.from(UUID.randomUUID()),
                _subCategoryId = subCategoryId,
                _content = QuestionContent.from(content),
                _difficulty = difficulty,
                _explanation = explanation,
                _createdAt = LocalDateTime.now(),
                _updatedAt = LocalDateTime.now()
            )
        }
    }
} 