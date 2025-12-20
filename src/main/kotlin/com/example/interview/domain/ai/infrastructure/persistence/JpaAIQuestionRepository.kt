package com.example.interview.domain.ai.infrastructure.persistence

import com.example.interview.domain.question.domain.QuestionDifficulty
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import java.util.UUID

interface JpaAIQuestionRepository : JpaRepository<AIQuestionEntity, UUID> {

    @Query("""
        SELECT a FROM AIQuestionEntity a
        WHERE a.categoryId = :categoryId
        AND a.subCategoryId = :subCategoryId
        AND a.difficulty = :difficulty
        ORDER BY FUNCTION('RANDOM')
    """)
    fun findRandomByCategoryAndSubCategoryAndDifficulty(
        @Param("categoryId") categoryId: UUID,
        @Param("subCategoryId") subCategoryId: UUID,
        @Param("difficulty") difficulty: QuestionDifficulty
    ): List<AIQuestionEntity>

    fun existsByCategoryIdAndSubCategoryIdAndDifficulty(
        categoryId: UUID,
        subCategoryId: UUID,
        difficulty: QuestionDifficulty
    ): Boolean
}
