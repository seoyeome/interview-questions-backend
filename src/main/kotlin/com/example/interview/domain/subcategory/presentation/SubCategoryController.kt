package com.example.interview.domain.subcategory.presentation

import com.example.interview.domain.category.domain.CategoryId
import com.example.interview.domain.subcategory.application.dto.SubCategoryResponse
import com.example.interview.domain.subcategory.application.service.SubCategoryService
import com.example.interview.domain.subcategory.domain.SubCategoryId
import com.example.interview.domain.subcategory.presentation.dto.CreateSubCategoryRequest
import com.example.interview.domain.subcategory.presentation.dto.UpdateSubCategoryRequest
import org.slf4j.LoggerFactory
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.*
import java.util.UUID
import kotlin.system.measureTimeMillis

@RestController
@RequestMapping("/api/v1/sub-categories")
class SubCategoryController(
    private val subCategoryService: SubCategoryService
) {
    private val logger = LoggerFactory.getLogger(SubCategoryController::class.java)
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun createSubCategory(@RequestBody request: CreateSubCategoryRequest): SubCategoryResponse {
        return subCategoryService.createSubCategory(request.toCommand())
    }

    @PutMapping("/{id}")
    fun updateSubCategory(
        @PathVariable id: UUID,
        @RequestBody request: UpdateSubCategoryRequest
    ): SubCategoryResponse {
        return subCategoryService.updateSubCategory(request.toCommand(id))
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    fun deleteSubCategory(@PathVariable id: UUID) {
        subCategoryService.deleteSubCategory(SubCategoryId.from(id))
    }

    @GetMapping("/{id}")
    fun getSubCategory(@PathVariable id: UUID): SubCategoryResponse {
        return subCategoryService.getSubCategory(SubCategoryId.from(id))
    }

    @GetMapping
    fun getAllSubCategories(): List<SubCategoryResponse> {
        var result: List<SubCategoryResponse>
        val elapsed = measureTimeMillis {
            result = subCategoryService.getAllSubCategories()
        }
        logger.info("GET /api/v1/sub-categories - ${result.size}개, ${elapsed}ms")
        return result
    }

    @GetMapping("/category/{categoryId}")
    fun getSubCategoriesByCategory(@PathVariable categoryId: UUID): List<SubCategoryResponse> {
        return subCategoryService.getSubCategoriesByCategory(CategoryId.from(categoryId))
    }
} 