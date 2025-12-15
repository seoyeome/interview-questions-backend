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
                    maxOutputTokens = 512
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
            면접 질문 생성 전문가로서 기술 면접 질문과 모범 답변을 생성하세요.

            JSON 형식으로만 응답:
            {"content":"질문","explanation":"답변","difficulty":"$difficulty"}

            카테고리: $category
            서브카테고리: $subCategory
            난이도: $difficulty

            요구사항:
            - 실제 면접 수준의 현실적 질문
            - 답변: 200-500자, 구체적이고 실무적 작성
            - 핵심 개념, 장단점, 사용 예시 포함
            - 난이도별 수준 (EASY:기본개념, MEDIUM:실무적용, HARD:심화+최적화)
            - JSON 외 텍스트 절대 금지
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
