package com.example.interview.domain.post.domain

@JvmInline
value class PostTitle(val value: String) {
    init {
        require(value.isNotBlank()) { "제목은 비어있을 수 없습니다" }
        require(value.length <= 200) { "제목은 200자를 초과할 수 없습니다" }
    }

    companion object {
        fun from(value: String): PostTitle = PostTitle(value.trim())
    }
}
