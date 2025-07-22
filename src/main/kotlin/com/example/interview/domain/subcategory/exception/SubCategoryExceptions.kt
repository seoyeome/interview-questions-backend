package com.example.interview.domain.subcategory.exception

class SubCategoryNotFoundException : RuntimeException("서브 카테고리를 찾을 수 없습니다.")

class DuplicateSubCategoryNameException : RuntimeException("이미 존재하는 서브 카테고리 이름입니다.")

class InvalidSubCategoryNameException : RuntimeException("서브 카테고리 이름이 유효하지 않습니다.") 