package com.example.interview.domain.category.infrastructure.persistence

import com.example.interview.domain.category.domain.Category
import com.example.interview.domain.category.domain.CategoryId
import com.example.interview.domain.category.domain.CategoryRepository
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Repository

@Repository
class CategoryRepositoryImpl(
    private val jpaRepository: JpaCategoryRepository
) : CategoryRepository {
    override fun save(category: Category): Category {
        return jpaRepository.save(CategoryEntity.from(category)).toDomain()
    }

    override fun findById(id: CategoryId): Category? {
        return jpaRepository.findByIdOrNull(id.value)?.toDomain()
    }

    override fun findByName(name: String): Category? {
        return jpaRepository.findByName(name)?.toDomain()
    }

    override fun findAll(): List<Category> {
        return jpaRepository.findAll().map { it.toDomain() }
    }

    override fun deleteById(id: CategoryId) {
        jpaRepository.deleteById(id.value)
    }

    override fun existsByName(name: String): Boolean {
        return jpaRepository.existsByName(name)
    }
} 