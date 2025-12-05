package com.example.interview.domain.ai.presentation.dto

data class AIQuestionResponse(
    val content: String,
    val explanation: String,
    val difficulty: String,
    val source: String = "AI"
)
