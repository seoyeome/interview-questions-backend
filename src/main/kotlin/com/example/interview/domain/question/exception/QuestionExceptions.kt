package com.example.interview.domain.question.exception

class QuestionNotFoundException : RuntimeException("질문을 찾을 수 없습니다.")

class DuplicateQuestionContentException : RuntimeException("이미 존재하는 질문 내용입니다.")

class InvalidQuestionContentException : RuntimeException("질문 내용이 유효하지 않습니다.")

class InvalidQuestionDifficultyException : RuntimeException("질문 난이도가 유효하지 않습니다.") 