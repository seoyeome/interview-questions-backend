package com.example.interview.domain.question.domain

@JvmInline
value class QuestionContent private constructor(
    val value: String
) {
    companion object {
        fun from(value: String): QuestionContent {
            require(value.isNotBlank()) { "질문 내용은 비어있을 수 없습니다." }
            return QuestionContent(value)
        }
    }
} 