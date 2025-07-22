package com.example.interview.domain.category.domain

import java.time.LocalDateTime
import java.util.UUID

class Category private constructor(
    private val _id: CategoryId,
    private var _name: CategoryName,
    private val _createdAt: LocalDateTime,
    private var _updatedAt: LocalDateTime
) {
    val id: CategoryId
        get() = _id

    val name: String
        get() = _name.value

    val createdAt: LocalDateTime
        get() = _createdAt

    val updatedAt: LocalDateTime
        get() = _updatedAt

    fun updateName(name: String) {
        _name = CategoryName.from(name)
        _updatedAt = LocalDateTime.now()
    }

    companion object {
        fun from(
            id: CategoryId,
            name: CategoryName
        ): Category {
            return Category(
                _id = id,
                _name = name,
                _createdAt = LocalDateTime.now(),
                _updatedAt = LocalDateTime.now()
            )
        }

        fun create(name: String): Category {
            return Category(
                _id = CategoryId.from(UUID.randomUUID()),
                _name = CategoryName.from(name),
                _createdAt = LocalDateTime.now(),
                _updatedAt = LocalDateTime.now()
            )
        }
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as Category
        return id == other.id
    }

    override fun hashCode(): Int {
        return id.hashCode()
    }
} 