package com.example.interview.domain.question.domain

import com.example.interview.domain.subcategory.domain.SubCategoryId

interface QuestionRepository {
    fun save(question: Question): Question
    fun findById(id: QuestionId): Question?
    fun findAll(): List<Question>
    fun delete(question: Question)
    fun findAllBySubCategoryId(subCategoryId: SubCategoryId): List<Question>
    fun findAllByDifficulty(difficulty: QuestionDifficulty): List<Question>
    fun existsByContent(content: String): Boolean
    fun findRandomQuestion(categoryId: String?, subCategoryId: String?, difficulty: QuestionDifficulty?): Question?
} 