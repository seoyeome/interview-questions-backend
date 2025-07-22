package com.example.interview.domain.question.domain

enum class QuestionDifficulty {
    EASY, MEDIUM, HARD;

    companion object {
        fun from(value: String): QuestionDifficulty {
            return try {
                valueOf(value.uppercase())
            } catch (e: IllegalArgumentException) {
                throw IllegalArgumentException("유효하지 않은 난이도입니다: $value")
            }
        }
    }
} 