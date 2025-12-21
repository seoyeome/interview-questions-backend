-- Create ai_generated_questions table
CREATE TABLE ai_generated_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID NOT NULL,
    sub_category_id UUID NOT NULL,
    content TEXT NOT NULL,
    explanation TEXT NOT NULL,
    difficulty VARCHAR(50) NOT NULL,
    usage_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ai_question_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    CONSTRAINT fk_ai_question_sub_category FOREIGN KEY (sub_category_id) REFERENCES sub_categories(id) ON DELETE CASCADE
);

-- Create index for faster queries
CREATE INDEX idx_ai_questions_category_subcategory_difficulty
ON ai_generated_questions(category_id, sub_category_id, difficulty);

CREATE INDEX idx_ai_questions_created_at
ON ai_generated_questions(created_at);
