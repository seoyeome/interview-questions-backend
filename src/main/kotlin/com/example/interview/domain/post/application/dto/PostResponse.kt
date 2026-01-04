package com.example.interview.domain.post.application.dto

import com.example.interview.domain.post.domain.Post
import com.example.interview.domain.post.domain.PostCategory
import java.time.LocalDateTime
import java.util.UUID

data class PostResponse(
    val id: UUID,
    val userId: Long,
    val title: String,
    val content: String,
    val category: PostCategory,
    val viewCount: Int,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime
) {
    companion object {
        fun from(post: Post): PostResponse {
            return PostResponse(
                id = post.id.value,
                userId = post.userId,
                title = post.title,
                content = post.content,
                category = post.category,
                viewCount = post.viewCount,
                createdAt = post.createdAt,
                updatedAt = post.updatedAt
            )
        }
    }
}
