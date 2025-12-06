package com.example.interview.domain.question.exception

import com.example.interview.global.error.BusinessException
import org.springframework.http.HttpStatus

class QuestionNotFoundException : BusinessException("질문을 찾을 수 없습니다.", HttpStatus.NOT_FOUND)

class DuplicateQuestionContentException : BusinessException("이미 존재하는 질문 내용입니다.", HttpStatus.CONFLICT)

class InvalidQuestionContentException : BusinessException("질문 내용이 유효하지 않습니다.", HttpStatus.BAD_REQUEST)

class InvalidQuestionDifficultyException : BusinessException("질문 난이도가 유효하지 않습니다.", HttpStatus.BAD_REQUEST) 