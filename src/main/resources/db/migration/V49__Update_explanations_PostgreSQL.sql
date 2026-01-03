-- PostgreSQL 질문에 대한 답변 추가

UPDATE questions SET explanation =
'**PostgreSQL이란?**
1986년부터 개발된 오픈소스 관계형 데이터베이스로, SQL 표준을 가장 엄격하게 준수하며 "세계에서 가장 진보된 오픈소스 RDBMS"로 알려져 있습니다.

**다른 SQL DB와의 차별점**

**1. 표준 준수 및 확장성**
- SQL 표준을 가장 충실히 구현
- Extension을 통한 기능 확장 (PostGIS, TimescaleDB 등)
- 사용자 정의 함수, 데이터 타입 생성 가능

**2. 고급 데이터 타입**
- JSON/JSONB: 완전한 JSON 문서 저장 및 쿼리
- Array, Range, Geometric 타입
- 사용자 정의 복합 타입

**3. 고급 쿼리 기능**
- Window Functions, CTE (재귀 쿼리 지원)
- Full-text Search 내장

**MySQL vs PostgreSQL**
| 구분 | PostgreSQL | MySQL |
|-----|-----------|--------|
| SQL 표준 | 엄격한 준수 | 일부 비표준 |
| 데이터 타입 | 풍부 (JSON, Array) | 제한적 |
| 복잡한 쿼리 | 우수 | 제한적 |
| 동시성 | MVCC | 행 수준 잠금 |

**사용 사례**
- 복잡한 분석 쿼리 (금융, 통계)
- 데이터 무결성이 중요한 시스템 (은행, 의료)
- JSON 중심 애플리케이션
- GIS 애플리케이션 (PostGIS)

**실무 경험**
복잡한 금융 거래 시스템에서 PostgreSQL의 MVCC와 트랜잭션 격리 수준을 활용하여 높은 동시성과 데이터 무결성을 동시에 확보했습니다.'
WHERE id = 'b0000000-0000-0000-0010-000000000000';

UPDATE questions SET explanation =
'**PostgreSQL의 주요 특징**

**1. 완전한 ACID 준수**
모든 트랜잭션에서 원자성, 일관성, 격리성, 지속성을 보장하여 데이터 무결성을 최우선으로 합니다.

**2. MVCC (Multi-Version Concurrency Control)**
읽기 작업이 쓰기 작업을 차단하지 않아 높은 동시성 처리 성능을 제공합니다.

**3. 풍부한 데이터 타입**
```sql
-- JSONB
CREATE TABLE products (data JSONB);

-- Array
CREATE TABLE posts (tags TEXT[]);

-- Range
CREATE TABLE reservations (during TSRANGE);
```

**4. 확장 가능한 아키텍처**
- PostGIS: 지리공간 데이터
- pg_trgm: 유사 문자열 검색
- TimescaleDB: 시계열 데이터

**5. 고급 인덱스 타입**
- B-Tree, Hash, GiST/GIN, BRIN
- Partial Index: 조건부 인덱싱
```sql
CREATE INDEX idx_active ON users(email)
WHERE status = ''active'';
```

**6. 트랜잭션 내 DDL 지원**
```sql
BEGIN;
    CREATE TABLE temp (...);
    DROP TABLE old_data;
COMMIT;  -- 전체 성공 또는 전체 롤백
```

**7. 강력한 쿼리 최적화**
- Parallel Query: 병렬 실행
- JIT Compilation: 속도 향상
- Genetic Query Optimizer: 복잡한 JOIN 최적화

**주요 장점**
- 복잡한 쿼리 처리 탁월
- 데이터 무결성 최우선
- 확장 가능한 아키텍처
- 30년 이상의 안정성

**실무 경험**
JSONB 타입으로 유연한 스키마가 필요한 로그 데이터를 저장하고, GIN 인덱스로 빠른 JSON 쿼리를 구현했습니다.'
WHERE id = 'b0000000-0000-0000-0010-000000000001';

UPDATE questions SET explanation =
'**PostgreSQL의 JSON 기능**

**JSON vs JSONB**
- **JSON**: 텍스트 그대로 저장, 입력 속도 빠름
- **JSONB**: 바이너리 형식 저장, 쿼리 속도 빠름, 인덱싱 가능 (권장)

**기본 사용**
```sql
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    data JSONB
);

INSERT INTO products (data) VALUES
(''{"name": "Laptop", "price": 1000, "specs": {"cpu": "i7"}}'');
```

**JSON 쿼리**
```sql
-- 특정 키 값 조회
SELECT data->''name'' FROM products;  -- 결과: "Laptop" (JSON)
SELECT data->>''name'' FROM products; -- 결과: Laptop (텍스트)

-- 중첩 키 접근
SELECT data->''specs''->>''cpu'' FROM products;  -- i7

-- WHERE 조건
SELECT * FROM products
WHERE data->>''name'' = ''Laptop'';

-- JSON 내부 검색
SELECT * FROM products
WHERE data @> ''{"price": 1000}'';  -- price가 1000인 문서
```

**JSON 함수**
```sql
-- 키 존재 확인
SELECT * FROM products WHERE data ? ''name'';

-- 배열 요소 접근
SELECT data->''tags''->>0 FROM products;  -- 첫 번째 태그

-- JSON 수정
UPDATE products
SET data = jsonb_set(data, ''{price}'', ''1200'')
WHERE id = 1;
```

**인덱싱**
```sql
-- GIN 인덱스 (JSON 쿼리 가속)
CREATE INDEX idx_data ON products USING GIN (data);

-- 특정 키에 인덱스
CREATE INDEX idx_name ON products ((data->>''name''));
```

**장점**
- NoSQL처럼 유연한 스키마
- RDBMS의 트랜잭션과 일관성 유지
- 복잡한 JSON 쿼리 가능

**실무 경험**
사용자 설정, 메타데이터 등 자주 변경되는 스키마를 JSONB로 저장하여 스키마 변경 없이 유연하게 대응하고, GIN 인덱스로 빠른 검색을 구현했습니다.'
WHERE id = 'b0000000-0000-0000-0010-000000000002';

UPDATE questions SET explanation =
'**MVCC (Multi-Version Concurrency Control)란?**
동시에 실행되는 여러 트랜잭션이 서로 간섭하지 않도록 데이터의 여러 버전을 유지하는 동시성 제어 기법입니다.

**PostgreSQL의 MVCC 동작 원리**

**1. 데이터 버전 관리**
- 각 행에 `xmin` (생성 트랜잭션 ID), `xmax` (삭제 트랜잭션 ID) 저장
- UPDATE 시 기존 행을 삭제 표시하고 새 버전 생성
- 각 트랜잭션은 자신의 스냅샷에 보이는 버전만 읽음

**2. 동작 예시**
```
트랜잭션 A (ID: 100): UPDATE users SET name = ''Kim'' WHERE id = 1;
트랜잭션 B (ID: 101): SELECT * FROM users WHERE id = 1;

행 버전:
| id | name | xmin | xmax |
|----|------|------|------|
| 1  | Lee  | 50   | 100  | ← 트랜잭션 B가 보는 버전
| 1  | Kim  | 100  | NULL | ← 트랜잭션 A가 보는 버전
```

**3. 장점**
- **읽기-쓰기 충돌 없음**: SELECT가 UPDATE를 차단하지 않음
- **높은 동시성**: 여러 트랜잭션이 동시에 작업 가능
- **일관된 읽기**: 트랜잭션 시작 시점의 스냅샷 유지

**4. 단점 및 관리**
- **Dead Tuple 발생**: 삭제 표시된 오래된 버전 누적
- **VACUUM 필요**: 주기적으로 오래된 버전 정리
- **Bloat**: 정리되지 않으면 테이블 크기 증가

**VACUUM의 역할**
```sql
VACUUM;  -- 수동 정리
-- 또는 autovacuum이 자동으로 정리
```

**실무 영향**
- 읽기 작업이 많은 시스템에서 쓰기 작업에 의해 차단되지 않음
- 트랜잭션 격리 수준 구현의 기반

**실무 경험**
높은 읽기 트래픽 환경에서 MVCC 덕분에 읽기 성능 저하 없이 동시 업데이트를 처리할 수 있었으며, autovacuum 설정 튜닝으로 테이블 bloat를 관리했습니다.'
WHERE id = 'b0000000-0000-0000-0010-000000000003';

UPDATE questions SET explanation =
'**트랜잭션 격리 수준 (Transaction Isolation Level)**
동시에 실행되는 트랜잭션들이 서로 어느 정도 영향을 주는지 정의하는 수준입니다.

**PostgreSQL 지원 격리 수준**

**1. Read Uncommitted (미지원)**
PostgreSQL에서는 Read Committed로 동작합니다.

**2. Read Committed (기본)**
커밋된 데이터만 읽을 수 있습니다.
```sql
-- 기본 설정
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
```
- **방지**: Dirty Read
- **허용**: Non-repeatable Read, Phantom Read

**3. Repeatable Read**
트랜잭션 내에서 같은 쿼리는 항상 같은 결과를 반환합니다.
```sql
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
```
- **방지**: Dirty Read, Non-repeatable Read, Phantom Read (PostgreSQL)
- PostgreSQL은 Serializable처럼 Phantom Read도 방지

**4. Serializable**
완전한 순차 실행처럼 동작합니다.
```sql
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```
- **방지**: 모든 동시성 이상 현상
- 충돌 발생 시 트랜잭션 롤백

**격리 수준별 비교**
| 격리 수준 | Dirty Read | Non-repeatable Read | Phantom Read |
|---------|-----------|-------------------|-------------|
| Read Committed | ✗ | ✓ | ✓ |
| Repeatable Read | ✗ | ✗ | ✗ (PG) |
| Serializable | ✗ | ✗ | ✗ |

**문제 현상 설명**
- **Dirty Read**: 커밋되지 않은 데이터 읽기
- **Non-repeatable Read**: 같은 쿼리의 결과가 달라짐 (UPDATE)
- **Phantom Read**: 같은 쿼리의 행 개수가 달라짐 (INSERT/DELETE)

**설정 방법**
```sql
-- 세션 레벨
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- 트랜잭션 레벨
BEGIN ISOLATION LEVEL SERIALIZABLE;
```

**실무 선택**
- **Read Committed**: 대부분의 애플리케이션 (기본)
- **Repeatable Read**: 통계, 리포트 생성
- **Serializable**: 금융 거래, 재고 관리 (중요한 일관성)

**실무 경험**
금융 거래 시스템에서 Serializable 격리 수준을 사용하여 동시 출금 시 잔액 부족을 완벽히 방지했으며, 충돌 시 재시도 로직을 구현했습니다.'
WHERE id = 'b0000000-0000-0000-0010-000000000004';

UPDATE questions SET explanation =
'**VACUUM 명령이란?**
PostgreSQL의 MVCC로 인해 발생하는 Dead Tuple(삭제 표시된 오래된 행)을 정리하여 디스크 공간을 회수하고 성능을 유지하는 명령입니다.

**왜 필요한가?**

**1. Dead Tuple 문제**
UPDATE/DELETE 시 실제 데이터를 삭제하지 않고 삭제 표시만 하여 오래된 버전이 누적됩니다.

**2. 테이블 Bloat**
Dead Tuple이 정리되지 않으면 테이블 크기가 증가하여 성능 저하가 발생합니다.

**VACUUM 종류**

**1. VACUUM (일반)**
```sql
VACUUM;  -- 전체 데이터베이스
VACUUM users;  -- 특정 테이블
```
- Dead Tuple 정리
- 디스크 공간 회수 (OS에 반환하지 않음, 재사용 가능하게만)
- 인덱스 정리

**2. VACUUM FULL (전체 정리)**
```sql
VACUUM FULL users;
```
- 테이블을 완전히 재작성
- 디스크 공간을 OS에 반환
- **주의**: 테이블 전체 잠금 (운영 중 사용 주의)

**3. VACUUM ANALYZE**
```sql
VACUUM ANALYZE users;
```
- VACUUM + 통계 업데이트
- 쿼리 플래너가 최적 실행 계획 수립

**AutoVacuum**
PostgreSQL은 기본적으로 자동으로 VACUUM을 실행합니다.
```sql
-- 설정 확인
SHOW autovacuum;

-- postgresql.conf
autovacuum = on
autovacuum_max_workers = 3
autovacuum_naptime = 1min
```

**VACUUM 시점**
- Dead Tuple 비율이 일정 수준 이상
- 트랜잭션 ID Wraparound 방지
- 대량 UPDATE/DELETE 후

**실무 관리**
```sql
-- Dead Tuple 확인
SELECT schemaname, relname, n_dead_tup
FROM pg_stat_user_tables
ORDER BY n_dead_tup DESC;

-- 마지막 VACUUM 시간 확인
SELECT schemaname, relname, last_vacuum, last_autovacuum
FROM pg_stat_user_tables;
```

**실무 경험**
대량 데이터 삭제 후 VACUUM을 실행하여 테이블 크기를 50% 감소시켰으며, autovacuum 설정을 조정하여 peak time에 자동 실행되지 않도록 관리했습니다.'
WHERE id = 'b0000000-0000-0000-0010-000000000005';

UPDATE questions SET explanation =
'**ANALYZE 명령이란?**
테이블의 통계 정보를 수집하여 쿼리 플래너가 최적의 실행 계획을 수립할 수 있도록 돕는 명령입니다.

**목적**
쿼리 옵티마이저가 인덱스 사용 여부, JOIN 순서, 예상 행 수 등을 정확히 판단하여 최적의 쿼리 실행 계획을 만들도록 합니다.

**수집하는 통계**
- 테이블의 총 행 수
- 각 컬럼의 데이터 분포
- NULL 값 비율
- 가장 많이 등장하는 값 (Most Common Values)
- 히스토그램

**사용법**
```sql
-- 전체 데이터베이스
ANALYZE;

-- 특정 테이블
ANALYZE users;

-- 특정 컬럼
ANALYZE users(email);
```

**언제 실행해야 하나?**
1. 대량 데이터 INSERT/UPDATE/DELETE 후
2. 인덱스 생성 후
3. 쿼리 성능이 갑자기 저하된 경우
4. 테이블 구조 변경 후

**VACUUM ANALYZE**
```sql
VACUUM ANALYZE users;  -- VACUUM + ANALYZE 동시 실행
```

**통계 확인**
```sql
-- 통계 정보 확인
SELECT * FROM pg_stats WHERE tablename = ''users'';

-- 마지막 ANALYZE 시간
SELECT schemaname, relname, last_analyze, last_autoanalyze
FROM pg_stat_user_tables;
```

**Auto Analyze**
PostgreSQL은 자동으로 ANALYZE를 실행합니다 (autovacuum 데몬).

**실무 예시**
```sql
-- 1. 대량 데이터 삽입
INSERT INTO orders SELECT ...;  -- 100만 건

-- 2. ANALYZE 실행
ANALYZE orders;

-- 3. 쿼리 성능 확인
EXPLAIN SELECT * FROM orders WHERE status = ''pending'';
-- 통계가 업데이트되어 더 정확한 실행 계획 수립
```

**ANALYZE vs VACUUM**
| 구분 | ANALYZE | VACUUM |
|-----|---------|--------|
| 목적 | 통계 수집 | Dead Tuple 정리 |
| 성능 영향 | 쿼리 최적화 | 공간 회수 |
| 실행 빈도 | 데이터 변경 후 | 주기적 |

**실무 경험**
대량 데이터 마이그레이션 후 ANALYZE를 실행하여 느린 쿼리의 실행 계획을 개선하고, 인덱스 스캔으로 변경하여 성능을 10배 향상시켰습니다.'
WHERE id = 'b0000000-0000-0000-0010-000000000006';

UPDATE questions SET explanation =
'**시퀀스(Sequence)란?**
자동으로 증가하는 고유한 정수 값을 생성하는 데이터베이스 객체로, 주로 기본 키(Primary Key)에 사용됩니다.

**시퀀스 생성**
```sql
-- 1. 직접 생성
CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9999999999
    CACHE 1;

-- 2. 사용
INSERT INTO users (id, name)
VALUES (nextval(''user_id_seq''), ''Kim'');
```

**SERIAL 타입 (권장)**
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,  -- 자동으로 시퀀스 생성
    name VARCHAR(100)
);

-- 동일한 의미:
CREATE SEQUENCE users_id_seq;
CREATE TABLE users (
    id INTEGER PRIMARY KEY DEFAULT nextval(''users_id_seq''),
    name VARCHAR(100)
);
```

**시퀀스 타입**
- **SMALLSERIAL**: 2바이트 (1~32767)
- **SERIAL**: 4바이트 (1~2147483647)
- **BIGSERIAL**: 8바이트 (1~9223372036854775807)

**시퀀스 함수**
```sql
-- 다음 값 가져오기
SELECT nextval(''user_id_seq'');

-- 현재 값 확인
SELECT currval(''user_id_seq'');

-- 값 설정
SELECT setval(''user_id_seq'', 1000);

-- 마지막 값 확인
SELECT last_value FROM user_id_seq;
```

**시퀀스 관리**
```sql
-- 시퀀스 재시작
ALTER SEQUENCE user_id_seq RESTART WITH 1;

-- 시퀀스 삭제
DROP SEQUENCE user_id_seq;

-- 시퀀스 소유자 설정
ALTER SEQUENCE user_id_seq OWNED BY users.id;
```

**주의사항**
1. **Gap 발생**: 롤백해도 시퀀스 값은 롤백되지 않음
2. **동시성**: 여러 트랜잭션이 동시에 사용해도 중복 없음
3. **캐싱**: 성능 향상을 위해 메모리에 미리 할당

**실무 팁**
```sql
-- 현재 최대 ID보다 크게 설정 (데이터 마이그레이션 후)
SELECT setval(''users_id_seq'', (SELECT MAX(id) FROM users));

-- 시퀀스 현황 확인
SELECT * FROM pg_sequences;
```

**실무 경험**
레거시 시스템 마이그레이션 시 기존 ID 최댓값을 시퀀스 시작값으로 설정하여 ID 충돌을 방지했습니다.'
WHERE id = 'b0000000-0000-0000-0010-000000000007';

UPDATE questions SET explanation =
'**서브쿼리 vs JOIN 성능**

**일반적인 가이드**
대부분의 경우 JOIN이 서브쿼리보다 성능이 좋지만, PostgreSQL의 쿼리 옵티마이저가 상황에 따라 최적화하므로 항상 그런 것은 아닙니다.

**JOIN이 유리한 경우**
```sql
-- JOIN (빠름)
SELECT u.name, o.total
FROM users u
INNER JOIN orders o ON u.id = o.user_id;

-- 서브쿼리 (느림 - 각 행마다 실행)
SELECT u.name,
       (SELECT SUM(total) FROM orders WHERE user_id = u.id)
FROM users u;
```
- 여러 컬럼을 가져올 때
- 대량 데이터 조인
- 인덱스 활용 가능

**서브쿼리가 유리한 경우**
```sql
-- EXISTS (빠름 - 첫 번째 일치만 찾음)
SELECT name FROM users u
WHERE EXISTS (SELECT 1 FROM orders WHERE user_id = u.id);

-- JOIN (느림 - 모든 일치 찾고 DISTINCT)
SELECT DISTINCT u.name
FROM users u
INNER JOIN orders o ON u.id = o.user_id;
```
- 존재 여부만 확인 (EXISTS)
- 단일 값만 필요
- 조건 필터링

**성능 비교 예시**

**1. 존재 여부 확인**
```sql
-- EXISTS (빠름)
WHERE EXISTS (SELECT 1 FROM orders WHERE user_id = u.id)

-- IN (상황에 따라 다름)
WHERE id IN (SELECT user_id FROM orders)

-- JOIN (DISTINCT 필요)
INNER JOIN orders ON users.id = orders.user_id
```

**2. 집계 값**
```sql
-- 서브쿼리 (간결)
SELECT name, (SELECT COUNT(*) FROM orders WHERE user_id = u.id) AS cnt
FROM users u;

-- JOIN (빠를 수 있음)
SELECT u.name, COUNT(o.id) AS cnt
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;
```

**실행 계획 확인**
```sql
EXPLAIN ANALYZE
SELECT ...;  -- 실제 실행 시간과 계획 확인
```

**성능 비교 팁**
| 상황 | 권장 |
|-----|------|
| 존재 여부 | EXISTS |
| 여러 컬럼 가져오기 | JOIN |
| 단일 집계 값 | 서브쿼리 |
| 대량 데이터 | JOIN + 인덱스 |

**실무 경험**
사용자별 주문 개수를 조회할 때 서브쿼리 방식이 간결했지만, 대용량 데이터에서는 JOIN + GROUP BY로 변경하여 성능을 3배 향상시켰습니다. 항상 EXPLAIN ANALYZE로 확인하는 것이 중요합니다.'
WHERE id = 'b0000000-0000-0000-0010-000000000008';

UPDATE questions SET explanation =
'**윈도 함수(Window Function)란?**
그룹화하지 않고 각 행에 대해 관련된 행들의 집합(윈도)에서 계산을 수행하는 함수입니다.

**GROUP BY와의 차이**
- GROUP BY: 여러 행을 하나로 그룹화
- Window Function: 각 행을 유지하면서 집계 계산

**주요 윈도 함수**

**1. 순위 함수**
```sql
SELECT
    name,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num,
    RANK() OVER (ORDER BY salary DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank
FROM employees;

결과:
| name | salary | row_num | rank | dense_rank |
|------|--------|---------|------|------------|
| Kim  | 5000   | 1       | 1    | 1          |
| Lee  | 5000   | 2       | 1    | 1          |
| Park | 4000   | 3       | 3    | 2          |
```

**2. 집계 함수**
```sql
SELECT
    name,
    salary,
    AVG(salary) OVER () AS avg_salary,
    SUM(salary) OVER (ORDER BY hire_date) AS running_total
FROM employees;
```

**3. 값 접근 함수**
```sql
SELECT
    order_date,
    amount,
    LAG(amount) OVER (ORDER BY order_date) AS prev_amount,
    LEAD(amount) OVER (ORDER BY order_date) AS next_amount
FROM orders;
```

**PARTITION BY 사용**
```sql
-- 부서별로 윈도 분할
SELECT
    department,
    name,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank
FROM employees;

결과:
| department | name | salary | dept_rank |
|-----------|------|--------|-----------|
| 개발팀     | Kim  | 5000   | 1         |
| 개발팀     | Lee  | 4000   | 2         |
| 영업팀     | Park | 4500   | 1         |
```

**활용 예시**

**1. 상위 N개 조회**
```sql
SELECT * FROM (
    SELECT
        product_id,
        sales,
        RANK() OVER (ORDER BY sales DESC) AS rank
    FROM product_sales
) ranked
WHERE rank <= 10;  -- 상위 10개 제품
```

**2. 누적 합계**
```sql
SELECT
    order_date,
    amount,
    SUM(amount) OVER (ORDER BY order_date) AS cumulative_sum
FROM orders;
```

**3. 이동 평균**
```sql
SELECT
    date,
    value,
    AVG(value) OVER (
        ORDER BY date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS moving_avg_7days
FROM metrics;
```

**4. 이전 값과 비교**
```sql
SELECT
    date,
    sales,
    sales - LAG(sales) OVER (ORDER BY date) AS sales_diff
FROM daily_sales;
```

**실무 경험**
매출 리포트에서 부서별 순위, 누적 매출, 이전 달 대비 증감률을 윈도 함수로 한 번에 계산하여 쿼리 복잡도를 대폭 줄였습니다.'
WHERE id = 'b0000000-0000-0000-0010-000000000009';

UPDATE questions SET explanation =
'**CTE (Common Table Expression)란?**
WITH 절을 사용하여 임시 결과 집합을 정의하는 기능으로, 복잡한 쿼리를 간결하고 읽기 쉽게 만듭니다.

**기본 문법**
```sql
WITH cte_name AS (
    SELECT ...
)
SELECT * FROM cte_name;
```

**사용 예시**

**1. 쿼리 가독성 향상**
```sql
-- CTE 사용 전 (복잡)
SELECT *
FROM (
    SELECT department, AVG(salary) AS avg_sal
    FROM employees
    GROUP BY department
) dept_avg
WHERE avg_sal > 50000;

-- CTE 사용 후 (명확)
WITH dept_avg AS (
    SELECT department, AVG(salary) AS avg_sal
    FROM employees
    GROUP BY department
)
SELECT * FROM dept_avg WHERE avg_sal > 50000;
```

**2. 재사용**
```sql
WITH active_users AS (
    SELECT * FROM users WHERE status = ''active''
)
SELECT
    (SELECT COUNT(*) FROM active_users) AS total,
    (SELECT COUNT(*) FROM active_users WHERE age > 30) AS over_30;
```

**3. 재귀 CTE**
```sql
-- 계층 구조 조회 (조직도, 댓글 트리)
WITH RECURSIVE org_chart AS (
    -- Base case: 최상위
    SELECT id, name, manager_id, 1 AS level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive case: 하위 직원
    SELECT e.id, e.name, e.manager_id, oc.level + 1
    FROM employees e
    INNER JOIN org_chart oc ON e.manager_id = oc.id
)
SELECT * FROM org_chart ORDER BY level, id;
```

**재귀 CTE 활용**

**1. 연속된 숫자 생성**
```sql
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 100
)
SELECT * FROM numbers;
```

**2. 댓글 트리**
```sql
WITH RECURSIVE comment_tree AS (
    SELECT id, content, parent_id, 0 AS depth
    FROM comments
    WHERE parent_id IS NULL

    UNION ALL

    SELECT c.id, c.content, c.parent_id, ct.depth + 1
    FROM comments c
    JOIN comment_tree ct ON c.parent_id = ct.id
)
SELECT * FROM comment_tree ORDER BY depth, id;
```

**여러 CTE 사용**
```sql
WITH
    active_users AS (
        SELECT * FROM users WHERE status = ''active''
    ),
    recent_orders AS (
        SELECT * FROM orders WHERE created_at > NOW() - INTERVAL ''30 days''
    )
SELECT u.name, COUNT(o.id) AS order_count
FROM active_users u
LEFT JOIN recent_orders o ON u.id = o.user_id
GROUP BY u.name;
```

**언제 사용하나?**
- 복잡한 쿼리를 단계별로 분해
- 같은 서브쿼리를 여러 번 사용
- 재귀적 데이터 구조 (트리, 그래프)
- 임시 테이블 대신 가독성 향상

**실무 경험**
조직도 계층 구조를 재귀 CTE로 조회하여 모든 하위 부서와 직원을 한 번의 쿼리로 가져왔으며, 복잡한 리포트 쿼리를 여러 CTE로 분리하여 유지보수성을 크게 개선했습니다.'
WHERE id = 'b0000000-0000-0000-0010-00000000000A';

UPDATE questions SET explanation =
'**PostgreSQL 확장 방법**

**1. 읽기 복제 (Replication)**

**스트리밍 복제**
```sql
-- Primary 설정 (postgresql.conf)
wal_level = replica
max_wal_senders = 3

-- Standby 설정
primary_conninfo = ''host=primary_host port=5432 user=repl''
```
- 읽기 부하를 여러 Standby로 분산
- 고가용성 (Primary 장애 시 Standby 승격)

**2. 연결 풀링 (Connection Pooling)**

**PgBouncer**
```
[databases]
mydb = host=localhost port=5432

[pgbouncer]
pool_mode = transaction
max_client_conn = 1000
```
- 연결 오버헤드 감소
- 더 많은 동시 연결 처리

**3. 샤딩 (Sharding)**

**수평 파티셔닝**
```sql
-- 범위 기반 파티셔닝
CREATE TABLE orders (
    id BIGINT,
    created_at TIMESTAMP,
    ...
) PARTITION BY RANGE (created_at);

CREATE TABLE orders_2024 PARTITION OF orders
FOR VALUES FROM (''2024-01-01'') TO (''2025-01-01'');
```

**Citus 확장**
```sql
-- 분산 테이블 생성
SELECT create_distributed_table(''orders'', ''user_id'');
-- user_id 기준으로 여러 노드에 샤딩
```

**4. 외부 확장 (Extensions)**

**PostGIS (지리공간 데이터)**
```sql
CREATE EXTENSION postgis;

SELECT * FROM places
WHERE ST_DWithin(location, ST_MakePoint(127.0, 37.5), 1000);
-- 1km 내 장소 검색
```

**TimescaleDB (시계열 데이터)**
```sql
CREATE EXTENSION timescaledb;

SELECT create_hypertable(''metrics'', ''time'');
-- 시계열 최적화
```

**5. 읽기/쓰기 분리**
```
Application
    ↓
  ┌─────────────┐
  │   Primary   │ ← 쓰기
  │  (Master)   │
  └──────┬──────┘
         │ Replication
    ┌────┴────┐
    ↓         ↓
┌────────┐ ┌────────┐
│Standby1│ │Standby2│ ← 읽기
└────────┘ └────────┘
```

**6. 캐싱 레이어**
- Redis/Memcached로 자주 읽는 데이터 캐싱
- 애플리케이션 레벨 캐싱

**7. 수직 확장**
- 더 강력한 서버 (CPU, 메모리, SSD)
- postgresql.conf 튜닝
  - `shared_buffers`, `work_mem`, `effective_cache_size`

**확장 전략 선택**
| 방법 | 장점 | 단점 | 사용 사례 |
|-----|------|------|----------|
| 복제 | 읽기 성능 향상 | 쓰기는 개선 안 됨 | 읽기 중심 |
| 샤딩 | 쓰기/읽기 모두 확장 | 복잡도 증가 | 대용량 데이터 |
| 연결 풀링 | 동시 연결 증가 | 쿼리 성능 개선 없음 | 많은 동시 연결 |
| 캐싱 | 빠른 읽기 | 일관성 이슈 | 자주 읽는 데이터 |

**실무 경험**
읽기 트래픽 증가로 Streaming Replication을 구축하여 3개의 Standby로 읽기 부하를 분산했으며, PgBouncer로 연결 풀링을 적용하여 동시 연결 수를 5배 증가시켰습니다.'
WHERE id = 'b0000000-0000-0000-0010-00000000000B';
