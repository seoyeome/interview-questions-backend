package com.example.interview.domain.question.application.service

import com.example.interview.domain.question.application.dto.CreateQuestionCommand
import com.example.interview.domain.question.application.dto.QuestionResponse
import com.example.interview.domain.question.application.dto.UpdateQuestionCommand
import com.example.interview.domain.question.domain.Question
import com.example.interview.domain.question.domain.QuestionDifficulty
import com.example.interview.domain.question.domain.QuestionId
import com.example.interview.domain.question.domain.QuestionRepository
import com.example.interview.domain.subcategory.domain.SubCategoryId
import com.example.interview.domain.subcategory.domain.SubCategoryRepository
import com.example.interview.domain.subcategory.exception.SubCategoryNotFoundException
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

class DuplicateQuestionContentException(message: String) : RuntimeException(message)
class QuestionNotFoundException(message: String) : RuntimeException(message)

@Service
@Transactional(readOnly = true)
class QuestionServiceImpl(
    private val questionRepository: QuestionRepository,
    private val subCategoryRepository: SubCategoryRepository
) : QuestionService {

    @Transactional
    override fun create(command: CreateQuestionCommand): QuestionResponse {
        if (questionRepository.existsByContent(command.content)) {
            throw DuplicateQuestionContentException("Question with content '${command.content}' already exists")
        }

        val subCategory = subCategoryRepository.findById(command.subCategoryId)
            ?: throw IllegalArgumentException("SubCategory not found with id: ${command.subCategoryId}")

        val question = command.toEntity()
        val savedQuestion = questionRepository.save(question)
        return QuestionResponse.from(savedQuestion)
    }

    @Transactional
    override fun update(command: UpdateQuestionCommand): QuestionResponse {
        val question = questionRepository.findById(command.id)
            ?: throw QuestionNotFoundException("Question not found with id: ${command.id}")

        command.content?.let { content ->
            if (questionRepository.existsByContent(content)) {
                throw DuplicateQuestionContentException("Question with content '$content' already exists")
            }
            question.updateContent(content)
        }

        command.difficulty?.let { difficulty ->
            question.updateDifficulty(difficulty)
        }

        return QuestionResponse.from(question)
    }

    @Transactional(readOnly = true)
    override fun findById(id: QuestionId): QuestionResponse {
        val question = questionRepository.findById(id)
            ?: throw QuestionNotFoundException("Question not found with id: $id")
        return QuestionResponse.from(question)
    }

    @Transactional
    override fun delete(id: QuestionId) {
        val question = questionRepository.findById(id)
            ?: throw QuestionNotFoundException("Question not found with id: $id")
        questionRepository.delete(question)
    }

    override fun getAllQuestions(): List<QuestionResponse> {
        return questionRepository.findAll()
            .map { QuestionResponse.from(it) }
    }

    override fun getQuestionsBySubCategory(subCategoryId: SubCategoryId): List<QuestionResponse> {
        if (subCategoryRepository.findById(subCategoryId) == null) {
            throw SubCategoryNotFoundException()
        }

        return questionRepository.findAllBySubCategoryId(subCategoryId)
            .map { QuestionResponse.from(it) }
    }

    override fun getQuestionsByDifficulty(difficulty: QuestionDifficulty): List<QuestionResponse> {
        return questionRepository.findAllByDifficulty(difficulty)
            .map { QuestionResponse.from(it) }
    }

    override fun getRandomQuestion(
        categoryId: String?,
        subCategoryId: String?,
        difficulty: QuestionDifficulty?
    ): QuestionResponse? {
        val question = questionRepository.findRandomQuestion(categoryId, subCategoryId, difficulty)
        return question?.let { QuestionResponse.from(it) }
    }
} 