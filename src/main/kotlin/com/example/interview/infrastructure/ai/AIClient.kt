package com.example.interview.infrastructure.ai

import com.example.interview.infrastructure.ai.dto.AIGeneratedQuestion

/**
 * AI 클라이언트 인터페이스
 * 다양한 AI 서비스(Gemini, Groq, OpenAI 등)를 추상화
 */
interface AIClient {

    /**
     * AI를 통해 면접 질문 생성
     *
     * @param category 카테고리명
     * @param subCategory 서브카테고리명
     * @param difficulty 난이도 (EASY, MEDIUM, HARD)
     * @return 생성된 질문 또는 null (실패 시)
     */
    fun generateQuestion(
        category: String,
        subCategory: String,
        difficulty: String
    ): AIGeneratedQuestion?

    /**
     * AI 서비스 제공자명
     */
    fun getProviderName(): String
}
