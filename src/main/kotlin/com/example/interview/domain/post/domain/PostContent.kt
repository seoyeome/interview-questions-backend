package com.example.interview.domain.post.domain

@JvmInline
value class PostContent(val value: String) {
    init {
        require(value.isNotBlank()) { "내용은 비어있을 수 없습니다" }
        require(value.length <= 10000) { "내용은 10000자를 초과할 수 없습니다" }
    }

    companion object {
        fun from(value: String): PostContent = PostContent(value.trim())
    }
}
