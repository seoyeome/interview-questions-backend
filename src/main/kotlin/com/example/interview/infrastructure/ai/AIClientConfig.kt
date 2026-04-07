package com.example.interview.infrastructure.ai

import com.example.interview.infrastructure.ai.gemini.GeminiClient
import com.example.interview.infrastructure.ai.groq.GroqClient
import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.web.client.RestClient

/**
 * AI 클라이언트 설정
 * ai.provider 값에 따라 적절한 AIClient 구현체를 Bean으로 등록
 */
@Configuration
class AIClientConfig {

    @Bean
    @ConditionalOnProperty(name = ["ai.provider"], havingValue = "groq", matchIfMissing = true)
    fun groqClient(
        @Value("\${ai.groq.api-key:}") apiKey: String,
        @Value("\${ai.groq.model:llama-3.3-70b-versatile}") model: String,
        restClientBuilder: RestClient.Builder
    ): AIClient {
        return GroqClient(apiKey, model, restClientBuilder)
    }

    @Bean
    @ConditionalOnProperty(name = ["ai.provider"], havingValue = "gemini")
    fun geminiClient(
        @Value("\${ai.gemini.api-key:}") apiKey: String,
        @Value("\${ai.gemini.model:gemini-2.0-flash}") model: String,
        restClientBuilder: RestClient.Builder
    ): AIClient {
        return GeminiClient(apiKey, model, restClientBuilder)
    }
}
