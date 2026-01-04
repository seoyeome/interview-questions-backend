package com.example.interview.domain.post.domain

import java.util.UUID

@JvmInline
value class PostId(val value: UUID) {
    companion object {
        fun from(value: UUID): PostId = PostId(value)
        fun generate(): PostId = PostId(UUID.randomUUID())
    }
}
