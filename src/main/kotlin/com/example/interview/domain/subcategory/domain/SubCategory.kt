package com.example.interview.domain.subcategory.domain

import com.example.interview.domain.category.domain.CategoryId
import java.time.LocalDateTime
import java.util.UUID

class SubCategory private constructor(
    private val _id: SubCategoryId,
    private val _categoryId: CategoryId,
    private var _name: SubCategoryName,
    private val _createdAt: LocalDateTime,
    private var _updatedAt: LocalDateTime
) {
    val id: SubCategoryId
        get() = _id

    val categoryId: CategoryId
        get() = _categoryId

    val name: String
        get() = _name.value

    val createdAt: LocalDateTime
        get() = _createdAt

    val updatedAt: LocalDateTime
        get() = _updatedAt

    fun updateName(name: String) {
        _name = SubCategoryName.from(name)
        _updatedAt = LocalDateTime.now()
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as SubCategory

        return id == other.id
    }

    override fun hashCode(): Int {
        return id.hashCode()
    }

    companion object {
        fun from(
            id: SubCategoryId,
            categoryId: CategoryId,
            name: SubCategoryName
        ): SubCategory {
            return SubCategory(
                _id = id,
                _categoryId = categoryId,
                _name = name,
                _createdAt = LocalDateTime.now(),
                _updatedAt = LocalDateTime.now()
            )
        }

        fun create(
            categoryId: CategoryId,
            name: String
        ): SubCategory {
            return SubCategory(
                _id = SubCategoryId.from(UUID.randomUUID()),
                _categoryId = categoryId,
                _name = SubCategoryName.from(name),
                _createdAt = LocalDateTime.now(),
                _updatedAt = LocalDateTime.now()
            )
        }
    }
} 