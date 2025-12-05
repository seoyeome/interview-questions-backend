package com.example.interview.domain.ai.presentation

import com.example.interview.domain.ai.presentation.dto.AIQuestionRequest
import com.example.interview.domain.ai.presentation.dto.AIQuestionResponse
import com.example.interview.infrastructure.ai.GeminiClient
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/v1/ai")
class AIQuestionController(
    private val geminiClient: GeminiClient
) {
    @PostMapping("/generate-question")
    fun generateQuestion(@RequestBody request: AIQuestionRequest): ResponseEntity<AIQuestionResponse> {
        val result = geminiClient.generateQuestion(
            category = request.category,
            subCategory = request.subCategory,
            difficulty = request.difficulty
        )

        return if (result != null) {
            ResponseEntity.ok(
                AIQuestionResponse(
                    content = result.content,
                    explanation = result.explanation,
                    difficulty = result.difficulty,
                    source = "AI"
                )
            )
        } else {
            ResponseEntity.status(503).build()
        }
    }
}
