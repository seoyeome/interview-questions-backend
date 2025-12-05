package com.example.interview.domain.ai.presentation.dto

data class AIQuestionRequest(
    val category: String,
    val subCategory: String,
    val difficulty: String
)
