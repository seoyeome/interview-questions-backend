package com.example.interview.domain.category.infrastructure.persistence

import com.example.interview.domain.category.domain.Category
import com.example.interview.domain.category.domain.CategoryId
import com.example.interview.domain.category.domain.CategoryName
import jakarta.persistence.*
import java.time.LocalDateTime
import java.util.UUID

@Entity
@Table(name = "categories")
class CategoryEntity(
    @Id
    val id: UUID,

    @Column(nullable = false)
    val name: String,

    val createdAt: LocalDateTime = LocalDateTime.now(),

    val updatedAt: LocalDateTime = LocalDateTime.now()
) {
    fun toDomain(): Category {
        return Category.from(
            id = CategoryId.from(id),
            name = CategoryName.from(name)
        )
    }

    companion object {
        fun from(category: Category): CategoryEntity {
            return CategoryEntity(
                id = category.id.value,
                name = category.name
            )
        }
    }
} 