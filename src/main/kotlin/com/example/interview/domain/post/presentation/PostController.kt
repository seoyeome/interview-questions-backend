package com.example.interview.domain.post.presentation

import com.example.interview.domain.post.application.PostService
import com.example.interview.domain.post.application.dto.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort
import org.springframework.data.web.PageableDefault
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping("/api/v1/posts")
class PostController(
    private val postService: PostService
) {

    @PostMapping
    fun createPost(
        @AuthenticationPrincipal userId: Long,
        @RequestBody request: PostCreateRequest
    ): ResponseEntity<PostResponse> {
        val response = postService.createPost(userId, request)
        return ResponseEntity.status(HttpStatus.CREATED).body(response)
    }

    @GetMapping
    fun getPosts(
        @RequestParam(required = false) category: String?,
        @PageableDefault(size = 20, sort = ["createdAt"], direction = Sort.Direction.DESC) pageable: Pageable
    ): ResponseEntity<Page<PostResponse>> {
        val response = postService.getPosts(category, pageable)
        return ResponseEntity.ok(response)
    }

    @GetMapping("/my")
    fun getMyPosts(
        @AuthenticationPrincipal userId: Long,
        @PageableDefault(size = 20, sort = ["createdAt"], direction = Sort.Direction.DESC) pageable: Pageable
    ): ResponseEntity<Page<PostResponse>> {
        val response = postService.getMyPosts(userId, pageable)
        return ResponseEntity.ok(response)
    }

    @GetMapping("/{id}")
    fun getPost(@PathVariable id: UUID): ResponseEntity<PostResponse> {
        val response = postService.getPostWithViewCount(id)
        return ResponseEntity.ok(response)
    }

    @PutMapping("/{id}")
    fun updatePost(
        @AuthenticationPrincipal userId: Long,
        @PathVariable id: UUID,
        @RequestBody request: PostUpdateRequest
    ): ResponseEntity<PostResponse> {
        val response = postService.updatePost(userId, id, request)
        return ResponseEntity.ok(response)
    }

    @DeleteMapping("/{id}")
    fun deletePost(
        @AuthenticationPrincipal userId: Long,
        @PathVariable id: UUID
    ): ResponseEntity<Void> {
        postService.deletePost(userId, id)
        return ResponseEntity.noContent().build()
    }
}
