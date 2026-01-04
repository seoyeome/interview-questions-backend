package com.example.interview.domain.post.application.dto

import com.example.interview.domain.post.domain.PostCategory

data class PostCreateRequest(
    val title: String,
    val content: String,
    val category: String
) {
    fun toCategory(): PostCategory = PostCategory.from(category)
}
