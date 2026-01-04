package com.example.interview.domain.question.infrastructure.persistence

import com.example.interview.domain.question.domain.QuestionDifficulty
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import java.util.UUID

interface JpaQuestionRepository : JpaRepository<QuestionEntity, UUID> {
    fun findAllBySubCategoryId(subCategoryId: UUID): List<QuestionEntity>
    fun findAllByDifficulty(difficulty: QuestionDifficulty): List<QuestionEntity>
    fun existsByContent(content: String): Boolean

    @Query(value = """
        SELECT q.* FROM questions q
        WHERE (:categoryId IS NULL OR q.sub_category_id IN (
            SELECT sc.id FROM sub_categories sc WHERE sc.category_id = CAST(:categoryId AS UUID)
        ))
        AND (:subCategoryId IS NULL OR q.sub_category_id = CAST(:subCategoryId AS UUID))
        AND (:difficulty IS NULL OR q.difficulty = CAST(:difficulty AS TEXT))
        ORDER BY RANDOM()
        LIMIT 1
    """, nativeQuery = true)
    fun findRandomQuestion(
        @Param("categoryId") categoryId: String?,
        @Param("subCategoryId") subCategoryId: String?,
        @Param("difficulty") difficulty: String?
    ): QuestionEntity?
} 