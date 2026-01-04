package com.example.interview.domain.post.infrastructure.persistence

import com.example.interview.domain.post.domain.*
import jakarta.persistence.*
import java.time.LocalDateTime
import java.util.UUID

@Entity
@Table(name = "posts")
class PostEntity(
    @Id
    @Column(columnDefinition = "UUID")
    val id: UUID,

    @Column(name = "user_id", nullable = false)
    val userId: Long,

    @Column(nullable = false, length = 200)
    var title: String,

    @Column(nullable = false, columnDefinition = "TEXT")
    var content: String,

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 50)
    var category: PostCategory,

    @Column(name = "view_count", nullable = false)
    var viewCount: Int = 0,

    @Column(name = "created_at", nullable = false, updatable = false)
    val createdAt: LocalDateTime = LocalDateTime.now(),

    @Column(name = "updated_at", nullable = false)
    var updatedAt: LocalDateTime = LocalDateTime.now(),

    @Column(name = "deleted_at")
    var deletedAt: LocalDateTime? = null
) {
    fun toDomain(): Post {
        return Post.from(
            id = PostId.from(id),
            userId = userId,
            title = PostTitle.from(title),
            content = PostContent.from(content),
            category = category,
            viewCount = viewCount,
            createdAt = createdAt,
            updatedAt = updatedAt,
            deletedAt = deletedAt
        )
    }

    companion object {
        fun from(post: Post): PostEntity {
            return PostEntity(
                id = post.id.value,
                userId = post.userId,
                title = post.title,
                content = post.content,
                category = post.category,
                viewCount = post.viewCount,
                createdAt = post.createdAt,
                updatedAt = post.updatedAt,
                deletedAt = post.deletedAt
            )
        }
    }
}
