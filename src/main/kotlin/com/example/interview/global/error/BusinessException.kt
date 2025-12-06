package com.example.interview.global.error

import org.springframework.http.HttpStatus

/**
 * 비즈니스 로직 예외의 최상위 클래스
 * 모든 비즈니스 예외는 이 클래스를 상속받아야 함
 */
abstract class BusinessException(
    message: String,
    val status: HttpStatus = HttpStatus.BAD_REQUEST
) : RuntimeException(message)
