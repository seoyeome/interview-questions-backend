package com.example.interview.domain.subcategory.domain

import com.example.interview.domain.category.domain.CategoryId

interface SubCategoryRepository {
    fun save(subCategory: SubCategory): SubCategory
    fun findById(id: SubCategoryId): SubCategory?
    fun findAll(): List<SubCategory>
    fun deleteById(id: SubCategoryId)
    fun findAllByCategoryId(categoryId: CategoryId): List<SubCategory>
    fun existsByNameAndCategoryId(name: String, categoryId: CategoryId): Boolean
} 