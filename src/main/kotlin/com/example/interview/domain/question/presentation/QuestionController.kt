package com.example.interview.domain.question.presentation

import com.example.interview.domain.question.application.dto.QuestionResponse
import com.example.interview.domain.question.application.service.QuestionService
import com.example.interview.domain.question.domain.QuestionDifficulty
import com.example.interview.domain.question.domain.QuestionId
import com.example.interview.domain.question.presentation.dto.CreateQuestionRequest
import com.example.interview.domain.question.presentation.dto.UpdateQuestionRequest
import com.example.interview.domain.subcategory.domain.SubCategoryId
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping("/api/v1/questions")
class QuestionController(
    private val questionService: QuestionService
) {
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun createQuestion(@RequestBody request: CreateQuestionRequest): QuestionResponse {
        return questionService.create(request.toCommand())
    }

    @PutMapping("/{id}")
    fun updateQuestion(
        @PathVariable id: UUID,
        @RequestBody request: UpdateQuestionRequest
    ): QuestionResponse {
        return questionService.update(request.toCommand(id))
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    fun deleteQuestion(@PathVariable id: UUID) {
        questionService.delete(QuestionId.from(id))
    }

    @GetMapping("/{id}")
    fun getQuestion(@PathVariable id: UUID): QuestionResponse {
        return questionService.findById(QuestionId.from(id))
    }

    @GetMapping
    fun getAllQuestions(): List<QuestionResponse> {
        return questionService.getAllQuestions()
    }

    @GetMapping("/sub-category/{subCategoryId}")
    fun getQuestionsBySubCategory(@PathVariable subCategoryId: UUID): List<QuestionResponse> {
        return questionService.getQuestionsBySubCategory(SubCategoryId.from(subCategoryId))
    }

    @GetMapping("/difficulty/{difficulty}")
    fun getQuestionsByDifficulty(@PathVariable difficulty: String): List<QuestionResponse> {
        return questionService.getQuestionsByDifficulty(QuestionDifficulty.valueOf(difficulty))
    }
} 