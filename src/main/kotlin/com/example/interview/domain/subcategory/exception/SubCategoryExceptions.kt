package com.example.interview.domain.subcategory.exception

import com.example.interview.global.error.BusinessException
import org.springframework.http.HttpStatus

class SubCategoryNotFoundException : BusinessException("서브 카테고리를 찾을 수 없습니다.", HttpStatus.NOT_FOUND)

class DuplicateSubCategoryNameException : BusinessException("이미 존재하는 서브 카테고리 이름입니다.", HttpStatus.CONFLICT)

class InvalidSubCategoryNameException : BusinessException("서브 카테고리 이름이 유효하지 않습니다.", HttpStatus.BAD_REQUEST) 