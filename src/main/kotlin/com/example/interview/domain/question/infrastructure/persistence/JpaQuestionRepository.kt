package com.example.interview.domain.question.infrastructure.persistence

import com.example.interview.domain.question.domain.QuestionDifficulty
import org.springframework.data.jpa.repository.JpaRepository
import java.util.UUID

interface JpaQuestionRepository : JpaRepository<QuestionEntity, UUID> {
    fun findAllBySubCategoryId(subCategoryId: UUID): List<QuestionEntity>
    fun findAllByDifficulty(difficulty: QuestionDifficulty): List<QuestionEntity>
    fun existsByContent(content: String): Boolean
} 