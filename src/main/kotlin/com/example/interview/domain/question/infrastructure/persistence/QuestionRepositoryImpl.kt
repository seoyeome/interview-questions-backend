package com.example.interview.domain.question.infrastructure.persistence

import com.example.interview.domain.question.domain.*
import com.example.interview.domain.subcategory.domain.SubCategoryId
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Repository

@Repository
class QuestionRepositoryImpl(
    private val jpaRepository: JpaQuestionRepository
) : QuestionRepository {

    override fun save(question: Question): Question {
        return jpaRepository.save(QuestionEntity.from(question)).toDomain()
    }

    override fun findAll(): List<Question> {
        return jpaRepository.findAll().map { it.toDomain() }
    }

    override fun findById(id: QuestionId): Question? {
        return jpaRepository.findByIdOrNull(id.value)?.toDomain()
    }

    override fun findAllBySubCategoryId(subCategoryId: SubCategoryId): List<Question> {
        return jpaRepository.findAllBySubCategoryId(subCategoryId.value).map { it.toDomain() }
    }

    override fun findAllByDifficulty(difficulty: QuestionDifficulty): List<Question> {
        return jpaRepository.findAllByDifficulty(difficulty).map { it.toDomain() }
    }

    override fun delete(question: Question) {
        jpaRepository.deleteById(question.id.value)
    }

    override fun existsByContent(content: String): Boolean {
        return jpaRepository.existsByContent(content)
    }

    override fun findRandomQuestion(
        categoryId: String?,
        subCategoryId: String?,
        difficulty: QuestionDifficulty?
    ): Question? {
        return jpaRepository.findRandomQuestion(
            categoryId,
            subCategoryId,
            difficulty?.name
        )?.toDomain()
    }
} 