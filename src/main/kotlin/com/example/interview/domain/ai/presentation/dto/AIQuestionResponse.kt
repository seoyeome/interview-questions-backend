package com.example.interview.domain.ai.presentation.dto

data class AIQuestionResponse(
    val content: String,
    val explanation: String,
    val difficulty: String,
    val source: String = "AI",
    val fromCache: Boolean = false,      // DB에서 가져온 질문인지 여부
    val remainingQuota: Int = 0          // 남은 AI 생성 횟수
)
