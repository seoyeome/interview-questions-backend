package com.example.interview.infrastructure.oauth

import org.slf4j.LoggerFactory
import org.springframework.http.HttpEntity
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpMethod
import org.springframework.stereotype.Service
import org.springframework.web.client.RestTemplate
import org.springframework.web.client.HttpClientErrorException

@Service
class KakaoUnlinkService {
    private val logger = LoggerFactory.getLogger(javaClass)
    private val restTemplate = RestTemplate()
    private val KAKAO_UNLINK_URL = "https://kapi.kakao.com/v1/user/unlink"

    /**
     * 카카오 연결 해제
     * @param accessToken 사용자의 OAuth 액세스 토큰
     * @return 성공 여부
     */
    fun unlinkKakaoAccount(accessToken: String): Boolean {
        return try {
            val headers = HttpHeaders().apply {
                set("Authorization", "Bearer $accessToken")
            }

            val entity = HttpEntity<String>(headers)
            val response = restTemplate.exchange(
                KAKAO_UNLINK_URL,
                HttpMethod.POST,
                entity,
                Map::class.java
            )

            logger.info("카카오 연결 해제 성공: ${response.body}")
            true
        } catch (e: HttpClientErrorException) {
            logger.error("카카오 연결 해제 실패: ${e.statusCode} - ${e.responseBodyAsString}", e)
            false
        } catch (e: Exception) {
            logger.error("카카오 연결 해제 중 예외 발생", e)
            false
        }
    }
}
