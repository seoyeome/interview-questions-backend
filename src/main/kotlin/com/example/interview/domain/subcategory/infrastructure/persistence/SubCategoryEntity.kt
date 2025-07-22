package com.example.interview.domain.subcategory.infrastructure.persistence

import com.example.interview.domain.category.domain.CategoryId
import com.example.interview.domain.subcategory.domain.SubCategory
import com.example.interview.domain.subcategory.domain.SubCategoryId
import com.example.interview.domain.subcategory.domain.SubCategoryName
import jakarta.persistence.*
import java.time.LocalDateTime
import java.util.UUID

@Entity
@Table(name = "sub_categories")
class SubCategoryEntity(
    @Id
    val id: UUID,

    @Column(name = "category_id", nullable = false)
    val categoryId: UUID,

    @Column(nullable = false)
    val name: String,

    val createdAt: LocalDateTime = LocalDateTime.now(),

    val updatedAt: LocalDateTime = LocalDateTime.now()
) {
    fun toDomain(): SubCategory {
        return SubCategory.from(
            id = SubCategoryId.from(id),
            categoryId = CategoryId.from(categoryId),
            name = SubCategoryName.from(name)
        )
    }

    companion object {
        fun from(subCategory: SubCategory): SubCategoryEntity {
            return SubCategoryEntity(
                id = subCategory.id.value,
                categoryId = subCategory.categoryId.value,
                name = subCategory.name
            )
        }
    }
} 