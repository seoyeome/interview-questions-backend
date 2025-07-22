-- Insert Backend subcategories
INSERT INTO sub_categories (category_id, name)
SELECT id, unnest(ARRAY['Spring', 'JPA', 'Kotlin', 'Java'])
FROM categories WHERE name = 'Backend';

-- Insert Frontend subcategories
INSERT INTO sub_categories (category_id, name)
SELECT id, unnest(ARRAY['React', 'JavaScript', 'TypeScript', 'Next.js'])
FROM categories WHERE name = 'Frontend';

-- Insert Database subcategories
INSERT INTO sub_categories (category_id, name)
SELECT id, unnest(ARRAY['MySQL', 'PostgreSQL', 'Redis', 'MongoDB'])
FROM categories WHERE name = 'Database';

-- Insert DevOps subcategories
INSERT INTO sub_categories (category_id, name)
SELECT id, unnest(ARRAY['Docker', 'Kubernetes', 'AWS', 'CI/CD'])
FROM categories WHERE name = 'DevOps';

-- Insert Computer Science subcategories
INSERT INTO sub_categories (category_id, name)
SELECT id, unnest(ARRAY['운영체제', '네트워크', '자료구조', '알고리즘'])
FROM categories WHERE name = 'Computer Science'; 