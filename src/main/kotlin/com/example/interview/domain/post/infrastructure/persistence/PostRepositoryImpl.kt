package com.example.interview.domain.post.infrastructure.persistence

import com.example.interview.domain.post.domain.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Repository

@Repository
class PostRepositoryImpl(
    private val jpaRepository: PostJpaRepository
) : PostRepository {

    override fun save(post: Post): Post {
        val entity = PostEntity.from(post)
        val saved = jpaRepository.save(entity)
        return saved.toDomain()
    }

    override fun findById(id: PostId): Post? {
        return jpaRepository.findActiveById(id.value)?.toDomain()
    }

    override fun findAll(category: PostCategory?, pageable: Pageable): Page<Post> {
        return jpaRepository.findAllActiveByCategory(category, pageable)
            .map { it.toDomain() }
    }

    override fun findByUserId(userId: Long, pageable: Pageable): Page<Post> {
        return jpaRepository.findAllActiveByUserId(userId, pageable)
            .map { it.toDomain() }
    }

    override fun delete(post: Post) {
        val entity = PostEntity.from(post)
        jpaRepository.save(entity)
    }

    override fun existsById(id: PostId): Boolean {
        return jpaRepository.findActiveById(id.value) != null
    }
}
