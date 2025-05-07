package com.example.interviewquestions.service;

import com.example.interviewquestions.model.Question;
import com.example.interviewquestions.repository.QuestionRepository;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class QuestionService {

    private final QuestionRepository questionRepository;
    private final ObjectMapper objectMapper;

    @Autowired
    public QuestionService(QuestionRepository questionRepository, ObjectMapper objectMapper) {
        this.questionRepository = questionRepository;
        this.objectMapper = objectMapper;
    }

    @PostConstruct
    public void init() {
        if (questionRepository.count() == 0) {
            try {
                ClassPathResource resource = new ClassPathResource("questions.json");
                Map<String, List<Question>> questionsMap = objectMapper.readValue(
                    resource.getInputStream(),
                    new TypeReference<Map<String, List<Question>>>() {}
                );
                
                questionsMap.get("questions").forEach(questionRepository::save);
            } catch (IOException e) {
                throw new RuntimeException("Failed to load questions from JSON", e);
            }
        }
    }

    public Question getRandomQuestion(String category) {
        List<Question> questions;
        if (category != null && !category.isEmpty()) {
            questions = questionRepository.findByCategory(category);
        } else {
            questions = questionRepository.findAll();
        }
        
        if (questions.isEmpty()) {
            return null;
        }
        
        Random random = new Random();
        return questions.get(random.nextInt(questions.size()));
    }

    public Question addQuestion(Question question) {
        return questionRepository.save(question);
    }

    public List<String> getCategories() {
        return questionRepository.findAll()
            .stream()
            .map(Question::getCategory)
            .distinct()
            .collect(Collectors.toList());
    }
} 