package com.example.interview.domain.post.domain

import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable

interface PostRepository {
    fun save(post: Post): Post
    fun findById(id: PostId): Post?
    fun findAll(category: PostCategory?, pageable: Pageable): Page<Post>
    fun findByUserId(userId: Long, pageable: Pageable): Page<Post>
    fun delete(post: Post)
    fun existsById(id: PostId): Boolean
}
