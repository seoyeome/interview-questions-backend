package com.example.interview.domain.question.infrastructure.persistence

import com.example.interview.domain.question.domain.*
import com.example.interview.domain.subcategory.domain.SubCategoryId
import jakarta.persistence.*
import java.time.LocalDateTime
import java.util.UUID

@Entity
@Table(name = "questions")
class QuestionEntity(
    @Id
    val id: UUID,

    @Column(name = "sub_category_id", nullable = false)
    val subCategoryId: UUID,

    @Column(nullable = false)
    val content: String,

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    val difficulty: QuestionDifficulty,

    val createdAt: LocalDateTime = LocalDateTime.now(),

    val updatedAt: LocalDateTime = LocalDateTime.now()
) {
    fun toDomain(): Question {
        return Question.from(
            id = QuestionId.from(id),
            subCategoryId = SubCategoryId.from(subCategoryId),
            content = QuestionContent.from(content),
            difficulty = difficulty
        )
    }

    companion object {
        fun from(question: Question): QuestionEntity {
            return QuestionEntity(
                id = question.id.value,
                subCategoryId = question.subCategoryId.value,
                content = question.content,
                difficulty = question.difficulty
            )
        }
    }
} 