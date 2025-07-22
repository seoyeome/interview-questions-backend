package com.example.interview.domain.category.application.service

import com.example.interview.domain.category.application.dto.CategoryResponse
import com.example.interview.domain.category.application.dto.CreateCategoryCommand
import com.example.interview.domain.category.application.dto.UpdateCategoryCommand
import com.example.interview.domain.category.domain.Category
import com.example.interview.domain.category.domain.CategoryId
import com.example.interview.domain.category.domain.CategoryRepository
import com.example.interview.domain.category.exception.CategoryNotFoundException
import com.example.interview.domain.category.exception.DuplicateCategoryNameException
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional(readOnly = true)
class CategoryServiceImpl(
    private val categoryRepository: CategoryRepository
) : CategoryService {

    @Transactional
    override fun createCategory(command: CreateCategoryCommand): CategoryResponse {
        if (categoryRepository.existsByName(command.name)) {
            throw DuplicateCategoryNameException()
        }

        val category = command.toEntity()
        return CategoryResponse.from(categoryRepository.save(category))
    }

    @Transactional
    override fun updateCategory(command: UpdateCategoryCommand): CategoryResponse {
        val category = categoryRepository.findById(command.id)
            ?: throw CategoryNotFoundException()

        command.name?.let { category.updateName(it) }

        return CategoryResponse.from(categoryRepository.save(category))
    }

    @Transactional
    override fun deleteCategory(id: CategoryId) {
        if (categoryRepository.findById(id) == null) {
            throw CategoryNotFoundException()
        }

        categoryRepository.deleteById(id)
    }

    override fun getCategory(id: CategoryId): CategoryResponse {
        return categoryRepository.findById(id)
            ?.let { CategoryResponse.from(it) }
            ?: throw CategoryNotFoundException()
    }

    override fun getAllCategories(): List<CategoryResponse> {
        return categoryRepository.findAll()
            .map { CategoryResponse.from(it) }
    }
} 