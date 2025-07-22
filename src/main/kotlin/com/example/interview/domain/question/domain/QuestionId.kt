package com.example.interview.domain.question.domain

import java.util.UUID

@JvmInline
value class QuestionId private constructor(
    val value: UUID
) {
    companion object {
        fun from(value: UUID): QuestionId {
            return QuestionId(value)
        }
        
        fun generate(): QuestionId = QuestionId(UUID.randomUUID())
    }
} 