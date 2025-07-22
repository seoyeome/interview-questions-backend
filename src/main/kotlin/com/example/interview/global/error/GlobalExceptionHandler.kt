package com.example.interview.global.error

import com.example.interview.domain.question.exception.*
import com.example.interview.domain.subcategory.exception.DuplicateSubCategoryNameException
import com.example.interview.domain.subcategory.exception.InvalidSubCategoryNameException
import com.example.interview.domain.subcategory.exception.SubCategoryNotFoundException
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.RestControllerAdvice

@RestControllerAdvice
class GlobalExceptionHandler {

    @ExceptionHandler(IllegalArgumentException::class)
    fun handleIllegalArgumentException(e: IllegalArgumentException): ResponseEntity<ErrorResponse> {
        val response = ErrorResponse(
            status = HttpStatus.BAD_REQUEST.value(),
            message = e.message ?: "잘못된 요청입니다."
        )
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response)
    }

    @ExceptionHandler(SubCategoryNotFoundException::class)
    fun handleSubCategoryNotFoundException(e: SubCategoryNotFoundException): ResponseEntity<ErrorResponse> {
        val response = ErrorResponse(
            status = HttpStatus.NOT_FOUND.value(),
            message = e.message ?: "서브 카테고리를 찾을 수 없습니다."
        )
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response)
    }

    @ExceptionHandler(DuplicateSubCategoryNameException::class)
    fun handleDuplicateSubCategoryNameException(e: DuplicateSubCategoryNameException): ResponseEntity<ErrorResponse> {
        val response = ErrorResponse(
            status = HttpStatus.CONFLICT.value(),
            message = e.message ?: "이미 존재하는 서브 카테고리 이름입니다."
        )
        return ResponseEntity.status(HttpStatus.CONFLICT).body(response)
    }

    @ExceptionHandler(InvalidSubCategoryNameException::class)
    fun handleInvalidSubCategoryNameException(e: InvalidSubCategoryNameException): ResponseEntity<ErrorResponse> {
        val response = ErrorResponse(
            status = HttpStatus.BAD_REQUEST.value(),
            message = e.message ?: "유효하지 않은 서브 카테고리 이름입니다."
        )
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response)
    }

    @ExceptionHandler(QuestionNotFoundException::class)
    fun handleQuestionNotFoundException(e: QuestionNotFoundException): ResponseEntity<ErrorResponse> {
        val response = ErrorResponse(
            status = HttpStatus.NOT_FOUND.value(),
            message = e.message ?: "질문을 찾을 수 없습니다."
        )
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response)
    }

    @ExceptionHandler(DuplicateQuestionContentException::class)
    fun handleDuplicateQuestionContentException(e: DuplicateQuestionContentException): ResponseEntity<ErrorResponse> {
        val response = ErrorResponse(
            status = HttpStatus.CONFLICT.value(),
            message = e.message ?: "이미 존재하는 질문 내용입니다."
        )
        return ResponseEntity.status(HttpStatus.CONFLICT).body(response)
    }

    @ExceptionHandler(InvalidQuestionContentException::class)
    fun handleInvalidQuestionContentException(e: InvalidQuestionContentException): ResponseEntity<ErrorResponse> {
        val response = ErrorResponse(
            status = HttpStatus.BAD_REQUEST.value(),
            message = e.message ?: "유효하지 않은 질문 내용입니다."
        )
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response)
    }

    @ExceptionHandler(InvalidQuestionDifficultyException::class)
    fun handleInvalidQuestionDifficultyException(e: InvalidQuestionDifficultyException): ResponseEntity<ErrorResponse> {
        val response = ErrorResponse(
            status = HttpStatus.BAD_REQUEST.value(),
            message = e.message ?: "유효하지 않은 질문 난이도입니다."
        )
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response)
    }

    @ExceptionHandler(Exception::class)
    fun handleException(e: Exception): ResponseEntity<ErrorResponse> {
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