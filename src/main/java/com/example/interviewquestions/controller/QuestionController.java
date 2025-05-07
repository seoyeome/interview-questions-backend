package com.example.interviewquestions.controller;

import com.example.interviewquestions.model.Question;
import com.example.interviewquestions.service.QuestionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/questions")
@CrossOrigin(origins = "http://localhost:3000")
public class QuestionController {
    
    private final QuestionService questionService;
    
    @Autowired
    public QuestionController(QuestionService questionService) {
        this.questionService = questionService;
    }
    
    @GetMapping("/random")
    public Question getRandomQuestion(@RequestParam(required = false) String category) {
        return questionService.getRandomQuestion(category);
    }
    
    @PostMapping
    public Question addQuestion(@RequestBody Question question) {
        return questionService.addQuestion(question);
    }
    
    @GetMapping("/categories")
    public List<String> getCategories() {
        return questionService.getCategories();
    }
} 