package com.example.interview.domain.post.domain

enum class PostCategory(val displayName: String) {
    QUESTION("질문"),
    FREE("자유게시판");

    companion object {
        fun from(value: String): PostCategory {
            return entries.find { it.name == value.uppercase() }
                ?: throw IllegalArgumentException("Invalid post category: $value")
        }
    }
}
