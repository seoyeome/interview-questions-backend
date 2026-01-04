package com.example.interview.domain.post.application

import com.example.interview.domain.post.application.dto.*
import com.example.interview.domain.post.domain.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

@Service
@Transactional(readOnly = true)
class PostService(
    private val postRepository: PostRepository
) {

    @Transactional
    fun createPost(userId: Long, request: PostCreateRequest): PostResponse {
        val post = Post.create(
            userId = userId,
            title = request.title,
            content = request.content,
            category = request.toCategory()
        )

        val saved = postRepository.save(post)
        return PostResponse.from(saved)
    }

    fun getPost(postId: UUID): PostResponse {
        val post = postRepository.findById(PostId.from(postId))
            ?: throw IllegalArgumentException("게시글을 찾을 수 없습니다")

        return PostResponse.from(post)
    }

    @Transactional
    fun getPostWithViewCount(postId: UUID): PostResponse {
        val post = postRepository.findById(PostId.from(postId))
            ?: throw IllegalArgumentException("게시글을 찾을 수 없습니다")

        post.increaseViewCount()
        val updated = postRepository.save(post)

        return PostResponse.from(updated)
    }

    fun getPosts(category: String?, pageable: Pageable): Page<PostResponse> {
        val postCategory = category?.let { PostCategory.from(it) }
        return postRepository.findAll(postCategory, pageable)
            .map { PostResponse.from(it) }
    }

    fun getMyPosts(userId: Long, pageable: Pageable): Page<PostResponse> {
        return postRepository.findByUserId(userId, pageable)
            .map { PostResponse.from(it) }
    }

    @Transactional
    fun updatePost(userId: Long, postId: UUID, request: PostUpdateRequest): PostResponse {
        val post = postRepository.findById(PostId.from(postId))
            ?: throw IllegalArgumentException("게시글을 찾을 수 없습니다")

        if (!post.isOwnedBy(userId)) {
            throw IllegalArgumentException("본인의 게시글만 수정할 수 있습니다")
        }

        post.update(
            title = request.title,
            content = request.content,
            category = request.toCategory()
        )

        val updated = postRepository.save(post)
        return PostResponse.from(updated)
    }

    @Transactional
    fun deletePost(userId: Long, postId: UUID) {
        val post = postRepository.findById(PostId.from(postId))
            ?: throw IllegalArgumentException("게시글을 찾을 수 없습니다")

        if (!post.isOwnedBy(userId)) {
            throw IllegalArgumentException("본인의 게시글만 삭제할 수 있습니다")
        }

        post.delete()
        postRepository.delete(post)
    }
}
