package com.example.interview.domain.category.application.service

import com.example.interview.domain.category.application.dto.CategoryResponse
import com.example.interview.domain.category.application.dto.CreateCategoryCommand
import com.example.interview.domain.category.application.dto.UpdateCategoryCommand
import com.example.interview.domain.category.domain.CategoryId

interface CategoryService {
    fun createCategory(command: CreateCategoryCommand): CategoryResponse
    fun updateCategory(command: UpdateCategoryCommand): CategoryResponse
    fun deleteCategory(id: CategoryId)
    fun getCategory(id: CategoryId): CategoryResponse
    fun getAllCategories(): List<CategoryResponse>
} 