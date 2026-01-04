package com.example.interview.domain.post.infrastructure.persistence

import com.example.interview.domain.post.domain.PostCategory
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import java.util.UUID

interface PostJpaRepository : JpaRepository<PostEntity, UUID> {

    @Query("SELECT p FROM PostEntity p WHERE p.deletedAt IS NULL AND (:category IS NULL OR p.category = :category) ORDER BY p.createdAt DESC")
    fun findAllActiveByCategory(
        @Param("category") category: PostCategory?,
        pageable: Pageable
    ): Page<PostEntity>

    @Query("SELECT p FROM PostEntity p WHERE p.userId = :userId AND p.deletedAt IS NULL ORDER BY p.createdAt DESC")
    fun findAllActiveByUserId(
        @Param("userId") userId: Long,
        pageable: Pageable
    ): Page<PostEntity>

    @Query("SELECT p FROM PostEntity p WHERE p.id = :id AND p.deletedAt IS NULL")
    fun findActiveById(@Param("id") id: UUID): PostEntity?
}
