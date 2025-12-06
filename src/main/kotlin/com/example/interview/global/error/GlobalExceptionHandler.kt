package com.example.interview.global.error

import org.slf4j.LoggerFactory
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.MethodArgumentNotValidException
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.RestControllerAdvice

@RestControllerAdvice
class GlobalExceptionHandler {

    private val logger = LoggerFactory.getLogger(GlobalExceptionHandler::class.java)

    /**
     * 비즈니스 예외 통합 처리
     * 모든 BusinessException을 상속받은 예외는 여기서 처리됨
     */
    @ExceptionHandler(BusinessException::class)
    fun handleBusinessException(e: BusinessException): ResponseEntity<ErrorResponse> {
        logger.warn("{} occurred: {}", e.javaClass.simpleName, e.message)
        val response = ErrorResponse(
            status = e.status.value(),
            message = e.message ?: "비즈니스 로직 오류가 발생했습니다."
        )
        return ResponseEntity.status(e.status).body(response)
    }

    /**
     * @Valid 검증 실패 처리
     * 사용자 입력값 검증 실패 시 발생하는 예외 처리
     */
    @ExceptionHandler(MethodArgumentNotValidException::class)
    fun handleMethodArgumentNotValidException(e: MethodArgumentNotValidException): ResponseEntity<ErrorResponse> {
        val errorMessage = e.bindingResult.fieldErrors
            .firstOrNull()?.defaultMessage ?: "입력값이 올바르지 않습니다."

        logger.warn("Validation failed: {}", errorMessage)
        val response = ErrorResponse(
            status = HttpStatus.BAD_REQUEST.value(),
            message = errorMessage
        )
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response)
    }

    /**
     * IllegalArgumentException 처리
     */
    @ExceptionHandler(IllegalArgumentException::class)
    fun handleIllegalArgumentException(e: IllegalArgumentException): ResponseEntity<ErrorResponse> {
        logger.warn("IllegalArgumentException occurred: {}", e.message, e)
        val response = ErrorResponse(
            status = HttpStatus.BAD_REQUEST.value(),
            message = e.message ?: "잘못된 요청입니다."
        )
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response)
    }

    /**
     * 예상치 못한 예외 처리
     */
    @ExceptionHandler(Exception::class)
    fun handleException(e: Exception): ResponseEntity<ErrorResponse> {
        logger.error("Unexpected exception occurred: {}", e.message, e)
        val response = ErrorResponse(
            status = HttpStatus.INTERNAL_SERVER_ERROR.value(),
            message = "서버 내부 오류가 발생했습니다."
        )
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response)
    }
}

data class ErrorResponse(
    val status: Int,
    val message: String
) 