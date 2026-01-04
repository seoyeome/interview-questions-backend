package com.example.interview.domain.category.presentation

import com.example.interview.domain.category.application.dto.CategoryResponse
import com.example.interview.domain.category.application.service.CategoryService
import com.example.interview.domain.category.domain.CategoryId
import com.example.interview.domain.category.presentation.dto.CreateCategoryRequest
import com.example.interview.domain.category.presentation.dto.UpdateCategoryRequest
import org.slf4j.LoggerFactory
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.*
import java.util.UUID
import kotlin.system.measureTimeMillis

@RestController
@RequestMapping("/api/v1/categories")
class CategoryController(
    private val categoryService: CategoryService
) {
    private val logger = LoggerFactory.getLogger(CategoryController::class.java)
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun createCategory(@RequestBody request: CreateCategoryRequest): CategoryResponse {
        return categoryService.createCategory(request.toCommand())
    }

    @PutMapping("/{id}")
    fun updateCategory(
        @PathVariable id: UUID,
        @RequestBody request: UpdateCategoryRequest
    ): CategoryResponse {
        return categoryService.updateCategory(request.toCommand(id))
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    fun deleteCategory(@PathVariable id: UUID) {
        categoryService.deleteCategory(CategoryId.from(id))
    }

    @GetMapping("/{id}")
    fun getCategory(@PathVariable id: UUID): CategoryResponse {
        return categoryService.getCategory(CategoryId.from(id))
    }

    @GetMapping
    fun getAllCategories(): List<CategoryResponse> {
        var result: List<CategoryResponse>
        val elapsed = measureTimeMillis {
            result = categoryService.getAllCategories()
        }
        logger.info("GET /api/v1/categories - ${result.size}개, ${elapsed}ms")
        return result
    }
} 