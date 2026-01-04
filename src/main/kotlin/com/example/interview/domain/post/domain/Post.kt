package com.example.interview.domain.post.domain

import java.time.LocalDateTime

class Post private constructor(
    private val _id: PostId,
    private val _userId: Long,
    private var _title: PostTitle,
    private var _content: PostContent,
    private var _category: PostCategory,
    private var _viewCount: Int,
    private val _createdAt: LocalDateTime,
    private var _updatedAt: LocalDateTime,
    private var _deletedAt: LocalDateTime?
) {
    val id: PostId
        get() = _id

    val userId: Long
        get() = _userId

    val title: String
        get() = _title.value

    val content: String
        get() = _content.value

    val category: PostCategory
        get() = _category

    val viewCount: Int
        get() = _viewCount

    val createdAt: LocalDateTime
        get() = _createdAt

    val updatedAt: LocalDateTime
        get() = _updatedAt

    val deletedAt: LocalDateTime?
        get() = _deletedAt

    val isDeleted: Boolean
        get() = _deletedAt != null

    fun update(title: String, content: String, category: PostCategory) {
        require(!isDeleted) { "삭제된 게시글은 수정할 수 없습니다" }
        _title = PostTitle.from(title)
        _content = PostContent.from(content)
        _category = category
        _updatedAt = LocalDateTime.now()
    }

    fun increaseViewCount() {
        require(!isDeleted) { "삭제된 게시글은 조회할 수 없습니다" }
        _viewCount++
    }

    fun delete() {
        require(!isDeleted) { "이미 삭제된 게시글입니다" }
        _deletedAt = LocalDateTime.now()
    }

    fun isOwnedBy(userId: Long): Boolean {
        return _userId == userId
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (other !is Post) return false
        return id == other.id
    }

    override fun hashCode(): Int {
        return id.hashCode()
    }

    companion object {
        fun create(
            userId: Long,
            title: String,
            content: String,
            category: PostCategory
        ): Post {
            return Post(
                _id = PostId.generate(),
                _userId = userId,
                _title = PostTitle.from(title),
                _content = PostContent.from(content),
                _category = category,
                _viewCount = 0,
                _createdAt = LocalDateTime.now(),
                _updatedAt = LocalDateTime.now(),
                _deletedAt = null
            )
        }

        fun from(
            id: PostId,
            userId: Long,
            title: PostTitle,
            content: PostContent,
            category: PostCategory,
            viewCount: Int,
            createdAt: LocalDateTime,
            updatedAt: LocalDateTime,
            deletedAt: LocalDateTime?
        ): Post {
            return Post(
                _id = id,
                _userId = userId,
                _title = title,
                _content = content,
                _category = category,
                _viewCount = viewCount,
                _createdAt = createdAt,
                _updatedAt = updatedAt,
                _deletedAt = deletedAt
            )
        }
    }
}
