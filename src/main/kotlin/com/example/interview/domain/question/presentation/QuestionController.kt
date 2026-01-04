package com.example.interview.domain.question.presentation

import com.example.interview.domain.question.application.dto.QuestionResponse
import com.example.interview.domain.question.application.service.QuestionService
import com.example.interview.domain.question.domain.QuestionDifficulty
import com.example.interview.domain.question.domain.QuestionId
import com.example.interview.domain.question.presentation.dto.CreateQuestionRequest
import com.example.interview.domain.question.presentation.dto.UpdateQuestionRequest
import com.example.interview.domain.subcategory.domain.SubCategoryId
import org.slf4j.LoggerFactory
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.*
import java.util.UUID
import kotlin.system.measureTimeMillis

@RestController
@RequestMapping("/api/v1/questions")
class QuestionController(
    private val questionService: QuestionService
) {
    private val logger = LoggerFactory.getLogger(QuestionController::class.java)
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
        var result: List<QuestionResponse>
        val elapsed = measureTimeMillis {
            result = questionService.getAllQuestions()
        }
        logger.info("GET /api/v1/questions - 전체 조회: ${result.size}개, ${elapsed}ms")
        return result
    }

    @GetMapping("/sub-category/{subCategoryId}")
    fun getQuestionsBySubCategory(@PathVariable subCategoryId: UUID): List<QuestionResponse> {
        return questionService.getQuestionsBySubCategory(SubCategoryId.from(subCategoryId))
    }

    @GetMapping("/difficulty/{difficulty}")
    fun getQuestionsByDifficulty(@PathVariable difficulty: String): List<QuestionResponse> {
        return questionService.getQuestionsByDifficulty(QuestionDifficulty.valueOf(difficulty))
    }

    @GetMapping("/random")
    fun getRandomQuestion(
        @RequestParam(required = false) categoryId: String?,
        @RequestParam(required = false) subCategoryId: String?,
        @RequestParam(required = false) difficulty: String?
    ): QuestionResponse? {
        var result: QuestionResponse?
        val elapsed = measureTimeMillis {
            val difficultyEnum = difficulty?.let { QuestionDifficulty.valueOf(it) }
            result = questionService.getRandomQuestion(categoryId, subCategoryId, difficultyEnum)
        }
        logger.info("GET /api/v1/questions/random - categoryId=$categoryId, subCategoryId=$subCategoryId, difficulty=$difficulty, ${elapsed}ms")
        return result
    }
} 