package com.example.interview.domain.question.application.service

import com.example.interview.domain.question.application.dto.QuestionResponse
import com.example.interview.domain.question.application.dto.CreateQuestionCommand
import com.example.interview.domain.question.application.dto.UpdateQuestionCommand
import com.example.interview.domain.question.domain.QuestionDifficulty
import com.example.interview.domain.question.domain.QuestionId
import com.example.interview.domain.subcategory.domain.SubCategoryId

interface QuestionService {
    fun create(command: CreateQuestionCommand): QuestionResponse
    fun update(command: UpdateQuestionCommand): QuestionResponse
    fun delete(id: QuestionId)
    fun findById(id: QuestionId): QuestionResponse
    fun getAllQuestions(): List<QuestionResponse>
    fun getQuestionsBySubCategory(subCategoryId: SubCategoryId): List<QuestionResponse>
    fun getQuestionsByDifficulty(difficulty: QuestionDifficulty): List<QuestionResponse>
} 