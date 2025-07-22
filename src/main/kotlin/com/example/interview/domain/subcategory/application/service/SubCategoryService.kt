package com.example.interview.domain.subcategory.application.service

import com.example.interview.domain.category.domain.CategoryId
import com.example.interview.domain.subcategory.application.dto.CreateSubCategoryCommand
import com.example.interview.domain.subcategory.application.dto.SubCategoryResponse
import com.example.interview.domain.subcategory.application.dto.UpdateSubCategoryCommand
import com.example.interview.domain.subcategory.domain.SubCategoryId

interface SubCategoryService {
    fun createSubCategory(command: CreateSubCategoryCommand): SubCategoryResponse
    fun updateSubCategory(command: UpdateSubCategoryCommand): SubCategoryResponse
    fun deleteSubCategory(id: SubCategoryId)
    fun getSubCategory(id: SubCategoryId): SubCategoryResponse
    fun getAllSubCategories(): List<SubCategoryResponse>
    fun getSubCategoriesByCategory(categoryId: CategoryId): List<SubCategoryResponse>
} 