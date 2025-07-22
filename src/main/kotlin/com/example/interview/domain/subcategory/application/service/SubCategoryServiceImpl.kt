package com.example.interview.domain.subcategory.application.service

import com.example.interview.domain.category.domain.CategoryId
import com.example.interview.domain.category.domain.CategoryRepository
import com.example.interview.domain.category.exception.CategoryNotFoundException
import com.example.interview.domain.subcategory.application.dto.CreateSubCategoryCommand
import com.example.interview.domain.subcategory.application.dto.SubCategoryResponse
import com.example.interview.domain.subcategory.application.dto.UpdateSubCategoryCommand
import com.example.interview.domain.subcategory.domain.SubCategoryId
import com.example.interview.domain.subcategory.domain.SubCategoryRepository
import com.example.interview.domain.subcategory.exception.DuplicateSubCategoryNameException
import com.example.interview.domain.subcategory.exception.SubCategoryNotFoundException
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional(readOnly = true)
class SubCategoryServiceImpl(
    private val subCategoryRepository: SubCategoryRepository,
    private val categoryRepository: CategoryRepository
) : SubCategoryService {

    @Transactional
    override fun createSubCategory(command: CreateSubCategoryCommand): SubCategoryResponse {
        val category = categoryRepository.findById(command.categoryId)
            ?: throw CategoryNotFoundException()

        if (subCategoryRepository.existsByNameAndCategoryId(command.name, command.categoryId)) {
            throw DuplicateSubCategoryNameException()
        }

        val subCategory = command.toEntity()
        return SubCategoryResponse.from(subCategoryRepository.save(subCategory))
    }

    @Transactional
    override fun updateSubCategory(command: UpdateSubCategoryCommand): SubCategoryResponse {
        val subCategory = subCategoryRepository.findById(command.id)
            ?: throw SubCategoryNotFoundException()

        command.name?.let { subCategory.updateName(it) }

        return SubCategoryResponse.from(subCategoryRepository.save(subCategory))
    }

    @Transactional
    override fun deleteSubCategory(id: SubCategoryId) {
        if (subCategoryRepository.findById(id) == null) {
            throw SubCategoryNotFoundException()
        }

        subCategoryRepository.deleteById(id)
    }

    override fun getSubCategory(id: SubCategoryId): SubCategoryResponse {
        return subCategoryRepository.findById(id)
            ?.let { SubCategoryResponse.from(it) }
            ?: throw SubCategoryNotFoundException()
    }

    override fun getAllSubCategories(): List<SubCategoryResponse> {
        return subCategoryRepository.findAll()
            .map { SubCategoryResponse.from(it) }
    }

    override fun getSubCategoriesByCategory(categoryId: CategoryId): List<SubCategoryResponse> {
        val category = categoryRepository.findById(categoryId)
            ?: throw CategoryNotFoundException()

        return subCategoryRepository.findAllByCategoryId(categoryId)
            .map { SubCategoryResponse.from(it) }
    }
} 