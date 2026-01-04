package com.example.interview.domain.post.application.dto

import org.springframework.data.domain.Page

data class PostListResponse(
    val content: List<PostResponse>,
    val totalElements: Long,
    val totalPages: Int,
    val size: Int,
    val number: Int
) {
    companion object {
        fun from(page: Page<PostResponse>): PostListResponse {
            return PostListResponse(
                content = page.content,
                totalElements = page.totalElements,
                totalPages = page.totalPages,
                size = page.size,
                number = page.number
            )
        }
    }
}
