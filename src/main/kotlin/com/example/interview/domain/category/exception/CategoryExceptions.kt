package com.example.interview.domain.category.exception

class CategoryNotFoundException : RuntimeException("카테고리를 찾을 수 없습니다.")

class DuplicateCategoryNameException : RuntimeException("이미 존재하는 카테고리 이름입니다.") 