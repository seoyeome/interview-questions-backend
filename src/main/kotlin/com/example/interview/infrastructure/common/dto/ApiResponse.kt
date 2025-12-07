package com.example.interview.infrastructure.common.dto

data class ApiResponse<T>(
    val data: T? = null,
    val message: String? = null,
    val success: Boolean = true
) {
    companion object {
        fun <T> success(data: T, message: String? = null): ApiResponse<T> {
            return ApiResponse(data = data, message = message, success = true)
        }

        fun <T> success(message: String): ApiResponse<T> {
            return ApiResponse(data = null, message = message, success = true)
        }

        fun <T> error(message: String): ApiResponse<T> {
            return ApiResponse(data = null, message = message, success = false)
        }
    }
}
