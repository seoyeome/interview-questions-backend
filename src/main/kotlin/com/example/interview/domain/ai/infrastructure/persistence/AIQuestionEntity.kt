package com.example.interview.domain.ai.infrastructure.persistence

import com.example.interview.domain.question.domain.QuestionDifficulty
import jakarta.persistence.*
import java.time.LocalDateTime
import java.util.UUID

@Entity
@Table(name = "ai_generated_questions")
class AIQuestionEntity(
    @Id
    val id: UUID = UUID.randomUUID(),

    @Column(name = "category_id", nullable = false)
    val categoryId: UUID,

    @Column(name = "sub_category_id", nullable = false)
    val subCategoryId: UUID,

    @Column(nullable = false, columnDefinition = "TEXT")
    val content: String,

    @Column(nullable = false, columnDefinition = "TEXT")
    val explanation: String,

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    val difficulty: QuestionDifficulty,

    @Column(name = "usage_count", nullable = false)
    val usageCount: Int = 0,

    @Column(name = "created_at", nullable = false)
    val createdAt: LocalDateTime = LocalDateTime.now()
) {
    fun incrementUsage(): AIQuestionEntity {
        return AIQuestionEntity(
            id = this.id,
            categoryId = this.categoryId,
            subCategoryId = this.subCategoryId,
            content = this.content,
            explanation = this.explanation,
            difficulty = this.difficulty,
            usageCount = this.usageCount + 1,
            createdAt = this.createdAt
        )
    }
}
