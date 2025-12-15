package com.example.interview.domain.subcategory.infrastructure.persistence

import com.example.interview.domain.category.domain.CategoryId
import com.example.interview.domain.subcategory.domain.SubCategory
import com.example.interview.domain.subcategory.domain.SubCategoryId
import com.example.interview.domain.subcategory.domain.SubCategoryRepository
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Repository

@Repository
class SubCategoryRepositoryImpl(
    private val jpaRepository: JpaSubCategoryRepository
) : SubCategoryRepository {
    override fun save(subCategory: SubCategory): SubCategory {
        return jpaRepository.save(SubCategoryEntity.from(subCategory)).toDomain()
    }

    override fun findById(id: SubCategoryId): SubCategory? {
        return jpaRepository.findByIdOrNull(id.value)?.toDomain()
    }

    override fun findByNameAndCategoryId(name: String, categoryId: CategoryId): SubCategory? {
        return jpaRepository.findByNameAndCategoryId(name, categoryId.value)?.toDomain()
    }

    override fun findAll(): List<SubCategory> {
        return jpaRepository.findAll().map { it.toDomain() }
    }

    override fun deleteById(id: SubCategoryId) {
        jpaRepository.deleteById(id.value)
    }

    override fun findAllByCategoryId(categoryId: CategoryId): List<SubCategory> {
        return jpaRepository.findAllByCategoryId(categoryId.value).map { it.toDomain() }
    }

    override fun existsByNameAndCategoryId(name: String, categoryId: CategoryId): Boolean {
        return jpaRepository.existsByNameAndCategoryId(name, categoryId.value)
    }
} 