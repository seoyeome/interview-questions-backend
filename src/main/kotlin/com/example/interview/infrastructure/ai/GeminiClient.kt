package com.example.interview.infrastructure.ai

import com.fasterxml.jackson.annotation.JsonProperty
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Component
import org.springframework.web.client.RestClient
import org.springframework.web.client.body

@Component
class GeminiClient(
    @Value("\${gemini.api.key}") private val apiKey: String,
    private val restClient: RestClient.Builder
) {
    private val client = restClient
        .baseUrl("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent")
        .build()

    fun generateQuestion(
        category: String,
        subCategory: String,
        difficulty: String
    ): AIGeneratedQuestion? {
        val prompt = buildPrompt(category, subCategory, difficulty)

        return try {
            val request = GeminiRequest(
                contents = listOf(
                    Content(
                        parts = listOf(Part(text = prompt))
                    )
                ),
                generationConfig = GenerationConfig(
                    temperature = 0.9,
                    topK = 40,
                    topP = 0.95,
                    maxOutputTokens = 1024
                )
            )

            val response = client.post()
                .uri { it.queryParam("key", apiKey).build() }
                .body(request)
                .retrieve()
                .body<GeminiResponse>()

            val generatedText = response?.candidates?.firstOrNull()
                ?.content?.parts?.firstOrNull()?.text
                ?: return null

            parseAIResponse(generatedText)
        } catch (e: Exception) {
            println("Gemini API 호출 실패: ${e.message}")
            null
        }
    }

    private fun buildPrompt(category: String, subCategory: String, difficulty: String): String {
        return """
            당신은 면접 질문 생성 전문가입니다.
            주어진 카테고리와 서브카테고리, 난이도에 맞는 기술 면접 질문과 구체적인 모범 답변을 생성해주세요.

            응답 형식 (반드시 이 JSON 형식으로만 응답하세요):
            {
              "content": "질문 내용",
              "explanation": "모범 답변 내용 (구체적이고 실무적으로 작성)",
              "difficulty": "EASY|MEDIUM|HARD"
            }

            카테고리: $category
            서브카테고리: $subCategory
            난이도: $difficulty

            규칙:
            - 질문은 실제 면접에서 나올 법한 현실적인 질문이어야 합니다
            - 모범 답변은 200-500자 사이로 구체적이고 실무적으로 작성하세요
            - 답변에는 핵심 개념, 장단점, 실제 사용 예시를 포함하세요
            - 난이도에 맞는 질문 수준을 유지하세요 (EASY: 기본 개념, MEDIUM: 실무 적용, HARD: 깊은 이해와 최적화)
            - JSON 형식 외 다른 텍스트는 절대 포함하지 마세요
        """.trimIndent()
    }

    private fun parseAIResponse(text: String): AIGeneratedQuestion? {
        return try {
            // 마크다운 코드 블록 제거
            var jsonText = text.trim()
            if (jsonText.startsWith("```json")) {
                jsonText = jsonText.removePrefix("```json").removeSuffix("```").trim()
            } else if (jsonText.startsWith("```")) {
                jsonText = jsonText.removePrefix("```").removeSuffix("```").trim()
            }

            // JSON 파싱
            val objectMapper = com.fasterxml.jackson.module.kotlin.jacksonObjectMapper()
            objectMapper.readValue(jsonText, AIGeneratedQuestion::class.java)
        } catch (e: Exception) {
            println("AI 응답 파싱 실패: ${e.message}")
            null
        }
    }
}

// Request/Response DTOs
data class GeminiRequest(
    val contents: List<Content>,
    val generationConfig: GenerationConfig
)

data class Content(
    val parts: List<Part>
)

data class Part(
    val text: String
)

data class GenerationConfig(
    val temperature: Double,
    val topK: Int,
    val topP: Double,
    val maxOutputTokens: Int
)

data class GeminiResponse(
    val candidates: List<Candidate>?
)

data class Candidate(
    val content: Content
)

data class AIGeneratedQuestion(
    val content: String,
    val explanation: String,
    val difficulty: String
)
