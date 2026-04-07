package com.example.interview.infrastructure.ai.dto

/**
 * AI가 생성한 질문 DTO
 */
data class AIGeneratedQuestion(
    val content: String,
    val explanation: String,
    val difficulty: String
)
