package com.example.interview.infrastructure.ai.groq

import com.example.interview.infrastructure.ai.AIClient
import com.example.interview.infrastructure.ai.dto.AIGeneratedQuestion
import com.fasterxml.jackson.annotation.JsonProperty
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import org.springframework.http.MediaType
import org.springframework.web.client.RestClient
import org.springframework.web.client.body

class GroqClient(
    private val apiKey: String,
    private val model: String,
    private val restClient: RestClient.Builder
) : AIClient {

    private val client by lazy {
        restClient
            .baseUrl("https://api.groq.com/openai/v1/chat/completions")
            .defaultHeader("Authorization", "Bearer $apiKey")
            .defaultHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
            .build()
    }

    override fun generateQuestion(
        category: String,
        subCategory: String,
        difficulty: String
    ): AIGeneratedQuestion? {
        val prompt = buildPrompt(category, subCategory, difficulty)

        return try {
            val request = GroqRequest(
                model = model,
                messages = listOf(
                    GroqMessage(role = "user", content = prompt)
                ),
                temperature = 0.9,
                maxTokens = 512
            )

            val response = client.post()
                .body(request)
                .retrieve()
                .body<GroqResponse>()

            val generatedText = response?.choices?.firstOrNull()
                ?.message?.content
                ?: return null

            parseAIResponse(generatedText)
        } catch (e: Exception) {
            println("Groq API 호출 실패: ${e.message}")
            null
        }
    }

    override fun getProviderName(): String = "Groq"

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
            var jsonText = text.trim()
            if (jsonText.startsWith("```json")) {
                jsonText = jsonText.removePrefix("```json").removeSuffix("```").trim()
            } else if (jsonText.startsWith("```")) {
                jsonText = jsonText.removePrefix("```").removeSuffix("```").trim()
            }

            val objectMapper = jacksonObjectMapper()
            objectMapper.readValue(jsonText, AIGeneratedQuestion::class.java)
        } catch (e: Exception) {
            println("AI 응답 파싱 실패: ${e.message}")
            null
        }
    }
}

// Groq API Request/Response DTOs (OpenAI 호환)
data class GroqRequest(
    val model: String,
    val messages: List<GroqMessage>,
    val temperature: Double,
    @JsonProperty("max_tokens")
    val maxTokens: Int
)

data class GroqMessage(
    val role: String,
    val content: String
)

data class GroqResponse(
    val choices: List<GroqChoice>?
)

data class GroqChoice(
    val message: GroqMessage
)
