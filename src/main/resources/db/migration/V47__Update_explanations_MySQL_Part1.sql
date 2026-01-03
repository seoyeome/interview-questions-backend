-- MySQL 질문에 대한 답변 추가 (Part 1: 1-12번)

UPDATE questions SET explanation =
'**유니크 키(Unique Key)**
테이블에서 중복되지 않는 값을 보장하는 제약 조건입니다. NULL 값을 허용하며, 테이블당 여러 개 생성 가능합니다.

**기본 키(Primary Key)**
테이블에서 각 행을 고유하게 식별하는 컬럼으로, NULL 값이 불가능하며 테이블당 하나만 존재합니다.

**주요 차이점**
| 구분 | Primary Key | Unique Key |
|-----|-------------|------------|
| NULL 허용 | 불가 | 가능 |
| 개수 | 1개 | 여러 개 |
| 인덱스 | 클러스터드 | 논클러스터드 |

**예시**
```sql
CREATE TABLE users (
    id INT PRIMARY KEY,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) UNIQUE
);
```

**실무 적용**
Primary Key는 사용자 ID처럼 행을 식별할 때, Unique Key는 이메일이나 전화번호처럼 중복을 방지해야 하지만 NULL이 필요한 경우 사용합니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000000';

UPDATE questions SET explanation =
'**외래 키(Foreign Key)란?**
한 테이블의 컬럼이 다른 테이블의 기본 키를 참조하는 제약 조건으로, 테이블 간 관계를 정의하고 참조 무결성을 보장합니다.

**사용 이유**
1. **데이터 무결성 보장**: 존재하지 않는 값 참조 방지
2. **관계 정의**: 1:N, N:M 관계 명시
3. **참조 동작 제어**: CASCADE, SET NULL 등으로 자동 처리

**참조 동작**
- `ON DELETE CASCADE`: 부모 삭제 시 자식도 삭제
- `ON DELETE SET NULL`: 부모 삭제 시 자식 FK를 NULL로
- `ON UPDATE CASCADE`: 부모 업데이트 시 자식도 업데이트

**예시**
```sql
CREATE TABLE orders (
    id INT PRIMARY KEY,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
);
```

**실무 경험**
주문 시스템에서 외래 키를 사용하여 삭제된 사용자의 주문이 남아있지 않도록 CASCADE 옵션으로 자동 정리했습니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000001';

UPDATE questions SET explanation =
'**인덱스(Index)란?**
데이터를 빠르게 검색하기 위한 정렬된 자료구조로, 보통 B-Tree를 사용합니다.

**성능 영향**

**장점 (읽기 성능)**
- WHERE, JOIN, ORDER BY 절의 검색 속도 대폭 향상
- 테이블 전체 스캔 대신 O(log n) 시간에 검색

**단점 (쓰기 성능)**
- INSERT, UPDATE, DELETE 시 인덱스도 함께 갱신 필요
- 추가 저장 공간 필요

**주요 인덱스 종류**
1. **클러스터드 인덱스**: 테이블당 1개, 실제 데이터가 인덱스 순서대로 저장 (Primary Key)
2. **논클러스터드 인덱스**: 여러 개 가능, 데이터 위치 포인터만 저장
3. **복합 인덱스**: 여러 컬럼 조합, 컬럼 순서가 중요

**언제 인덱스를 만들까?**
- WHERE 절에 자주 사용되는 컬럼
- JOIN에 사용되는 컬럼
- 카디널리티(고유값 비율)가 높은 컬럼

**실무 경험**
사용자 이메일 검색 성능을 개선하기 위해 email 컬럼에 인덱스를 추가하여 조회 속도를 100ms에서 5ms로 단축했습니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000002';

UPDATE questions SET explanation =
'**트랜잭션(Transaction)이란?**
데이터베이스에서 하나의 논리적 작업 단위로, 여러 SQL 문을 묶어서 "모두 성공" 또는 "모두 실패"로 처리합니다.

**ACID 속성**

**1. Atomicity (원자성)**
트랜잭션의 모든 작업이 모두 실행되거나 모두 실행되지 않음을 보장합니다.

**2. Consistency (일관성)**
트랜잭션 전후로 데이터베이스가 일관된 상태를 유지하며, 제약 조건이 위반되지 않습니다.

**3. Isolation (격리성)**
동시에 실행되는 트랜잭션들이 서로 영향을 주지 않고 독립적으로 실행됩니다.

**4. Durability (지속성)**
커밋된 트랜잭션은 시스템 장애가 발생해도 영구적으로 저장됩니다.

**기본 사용**
```sql
START TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;  -- 모두 성공
```

**실무 적용**
계좌 이체, 주문 처리, 재고 관리 등 여러 작업이 모두 성공해야 하는 비즈니스 로직에서 필수적으로 사용합니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000003';

UPDATE questions SET explanation =
'**Commit**
트랜잭션의 모든 변경 사항을 영구적으로 데이터베이스에 반영하는 명령으로, 변경 내용이 디스크에 기록되며 다른 트랜잭션에서도 확인 가능합니다.

**Rollback**
트랜잭션의 모든 변경 사항을 취소하고 시작 전 상태로 되돌리는 명령으로, 오류 발생 시 자동으로 실행될 수 있습니다.

**비교**
| 구분 | COMMIT | ROLLBACK |
|-----|--------|----------|
| 의미 | 영구 반영 | 취소 |
| 결과 | 변경 사항 저장 | 변경 사항 제거 |
| 가시성 | 다른 트랜잭션에서 보임 | 보이지 않음 |

**실무 예시**
```sql
START TRANSACTION;
INSERT INTO orders (user_id, total) VALUES (1, 10000);
UPDATE products SET stock = stock - 1 WHERE id = 5;
-- 재고 부족 확인
IF (stock < 0) THEN
    ROLLBACK;  -- 주문 취소
ELSE
    COMMIT;    -- 주문 완료
END IF;
```

**실무 경험**
결제 처리 중 외부 API 호출 실패 시 ROLLBACK으로 주문 데이터를 자동으로 원복하여 데이터 정합성을 유지했습니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000004';

UPDATE questions SET explanation =
'**MySQL의 주요 잠금 종류**

**1. 공유 잠금 (Shared Lock, S Lock)**
읽기 잠금으로, 다른 트랜잭션의 읽기는 허용하지만 쓰기는 차단합니다.
```sql
SELECT * FROM users WHERE id = 1 FOR SHARE;
```

**2. 배타 잠금 (Exclusive Lock, X Lock)**
쓰기 잠금으로, 다른 트랜잭션의 읽기/쓰기 모두 차단합니다.
```sql
SELECT * FROM users WHERE id = 1 FOR UPDATE;
```

**3. 레코드 잠금 (Record Lock)**
특정 인덱스 레코드에 거는 InnoDB의 기본 행 레벨 잠금입니다.

**4. 갭 잠금 (Gap Lock)**
인덱스 레코드 사이의 간격에 거는 잠금으로, Phantom Read를 방지합니다.

**5. 넥스트 키 잠금 (Next-Key Lock)**
레코드 잠금 + 갭 잠금의 조합으로, InnoDB의 기본 잠금 방식입니다.

**언제 잠금이 걸리나?**
- `SELECT ... FOR UPDATE`: 배타 잠금
- `SELECT ... FOR SHARE`: 공유 잠금
- `UPDATE, DELETE`: 자동으로 배타 잠금
- `INSERT`: 삽입하는 행에 배타 잠금

**데드락 (Deadlock)**
두 개 이상의 트랜잭션이 서로의 잠금을 기다리는 상황으로, InnoDB가 자동 감지하여 하나를 롤백합니다.

**실무 경험**
재고 차감 시 `SELECT ... FOR UPDATE`로 배타 잠금을 걸어 동시 주문으로 인한 음수 재고 문제를 방지했습니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000005';

UPDATE questions SET explanation =
'**MyISAM**
오래된 스토리지 엔진으로 테이블 레벨 잠금을 사용하며, 트랜잭션과 외래 키를 지원하지 않습니다. 읽기 속도가 빠르지만 동시성이 낮습니다.

**InnoDB**
MySQL의 기본 스토리지 엔진(5.5+)으로 행 레벨 잠금을 사용하며, 트랜잭션과 외래 키를 지원합니다. 높은 동시성과 크래시 복구 기능을 제공합니다.

**주요 차이점**
| 구분 | MyISAM | InnoDB |
|-----|--------|--------|
| 트랜잭션 | ✗ | ✓ (ACID) |
| 외래 키 | ✗ | ✓ |
| 잠금 레벨 | 테이블 | 행 |
| 동시성 | 낮음 | 높음 |
| 크래시 복구 | 어려움 | 자동 |

**잠금 차이 예시**
MyISAM은 UPDATE 시 전체 테이블을 잠그지만, InnoDB는 해당 행만 잠가 다른 행은 동시 접근이 가능합니다.

**사용 사례**
- InnoDB: 대부분의 애플리케이션, 금융/주문 등 트랜잭션이 필요한 경우 (권장)
- MyISAM: 읽기 전용 데이터, 로그 테이블 (레거시)

**실무 경험**
레거시 시스템의 MyISAM 테이블을 InnoDB로 마이그레이션하여 동시 사용자 처리량을 3배 향상시켰습니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000006';

UPDATE questions SET explanation =
'**InnoDB가 외래 키와 트랜잭션을 지원하는 이유**

**1. 설계 목적의 차이**
InnoDB는 엔터프라이즈급 트랜잭션 처리와 데이터 무결성을 목표로 설계되었고, MyISAM은 빠른 읽기 성능에 최적화되었습니다.

**2. 트랜잭션 지원 기술**
- **리두 로그 (Redo Log)**: 트랜잭션 변경 사항을 기록하여 크래시 복구 가능
- **언두 로그 (Undo Log)**: ROLLBACK 시 이전 상태로 복구
- **버퍼 풀 (Buffer Pool)**: 트랜잭션 관리를 위한 메모리 구조

**3. 외래 키 지원**
참조 무결성을 보장하여 부모-자식 관계의 일관성을 유지하고, CASCADE 동작으로 자동 처리합니다.

**4. MVCC (Multi-Version Concurrency Control)**
데이터의 여러 버전을 유지하여 읽기와 쓰기가 서로 블로킹하지 않고 높은 동시성을 달성합니다.

**5. 행 레벨 잠금**
변경되는 행만 잠그고 다른 행은 다른 트랜잭션이 접근 가능하여 MyISAM의 테이블 레벨 잠금보다 동시성이 높습니다.

**실무 예시**
금융 거래에서 계좌 이체 시 출금과 입금이 모두 성공해야 하므로 InnoDB의 트랜잭션 보장이 필수적이며, 주문 시스템에서 외래 키로 존재하지 않는 사용자의 주문을 방지합니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000007';

UPDATE questions SET explanation =
'**정규화(Normalization)란?**
데이터베이스 설계 시 중복을 최소화하고 데이터 무결성을 향상시키기 위해 데이터를 논리적으로 작은 테이블로 분할하는 과정입니다.

**1NF (First Normal Form)**
모든 컬럼이 원자값(Atomic Value)을 가져야 하며, 반복되는 그룹이 없어야 합니다.

**위반 예시**
```
| 학생ID | 이름 | 수강과목 |
|--------|------|---------|
| 1      | 김철수 | 수학, 영어, 과학 |  ← 원자값 아님
```

**1NF 적용**
```
| 학생ID | 이름 | 수강과목 |
|--------|------|---------|
| 1      | 김철수 | 수학 |
| 1      | 김철수 | 영어 |
| 1      | 김철수 | 과학 |
```

**2NF (Second Normal Form)**
1NF를 만족하고, 부분 함수 종속을 제거합니다. 복합 키일 때 모든 비키 속성이 전체 기본 키에 종속되어야 합니다.

**위반 예시**: 학생이름이 학생ID에만 종속 (부분 종속)
**해결**: 학생 테이블, 과목 테이블, 수강 테이블로 분리

**3NF (Third Normal Form)**
2NF를 만족하고, 이행 함수 종속을 제거합니다. 비키 속성이 다른 비키 속성에 종속되지 않아야 합니다.

**위반 예시**: 학생ID → 학과코드 → 학과이름 (이행 종속)
**해결**: 학생 테이블과 학과 테이블로 분리

**장단점**
- 장점: 데이터 중복 최소화, 일관성 유지, 이상 현상 방지
- 단점: 테이블 수 증가, JOIN 연산 증가로 성능 저하 가능

**실무 적용**
기본적으로 3NF까지 정규화하되, 성능 문제 발생 시 선택적으로 비정규화합니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000008';

UPDATE questions SET explanation =
'**JOIN의 주요 종류**

**1. INNER JOIN (내부 조인)**
두 테이블에서 조건이 일치하는 행만 반환하는 가장 많이 사용되는 JOIN입니다.
```sql
SELECT u.name, o.total
FROM users u
INNER JOIN orders o ON u.id = o.user_id;
```

**2. LEFT (OUTER) JOIN**
왼쪽 테이블의 모든 행을 반환하고, 오른쪽 테이블에 일치하는 데이터가 없으면 NULL을 표시합니다.
```sql
SELECT u.name, o.total
FROM users u
LEFT JOIN orders o ON u.id = o.user_id;
-- 주문하지 않은 사용자도 포함
```

**3. RIGHT (OUTER) JOIN**
오른쪽 테이블의 모든 행을 반환하며, LEFT JOIN의 반대입니다. 실무에서는 LEFT JOIN으로 대체 가능합니다.

**4. FULL (OUTER) JOIN**
양쪽 테이블의 모든 행을 반환합니다. MySQL은 직접 지원하지 않아 LEFT JOIN + RIGHT JOIN의 UNION으로 구현합니다.

**5. CROSS JOIN**
두 테이블의 모든 가능한 조합을 반환합니다 (카티션 곱). 실무에서는 거의 사용하지 않습니다.

**6. SELF JOIN**
같은 테이블을 두 번 참조하여 계층 구조 데이터를 처리합니다 (예: 직원과 상사 관계).

**비교**
| JOIN | 결과 |
|------|------|
| INNER | 교집합 |
| LEFT | 왼쪽 기준 + 일치 |
| RIGHT | 오른쪽 기준 + 일치 |
| FULL | 합집합 |

**실무 팁**
INNER JOIN을 기본으로 사용하고, "없는 데이터도 포함"해야 하면 LEFT JOIN을 사용합니다. JOIN 전 WHERE로 데이터를 먼저 필터링하여 성능을 개선할 수 있습니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000009';

UPDATE questions SET explanation =
'**INNER JOIN**
두 테이블에서 조건이 일치하는 행만 반환하는 교집합 연산으로, 양쪽 테이블에 모두 존재하는 데이터만 결과에 포함됩니다.

**OUTER JOIN**
한쪽 또는 양쪽 테이블의 모든 행을 반환하며, 일치하지 않는 부분은 NULL로 채웁니다.

**종류별 설명**

**LEFT OUTER JOIN**
왼쪽 테이블의 모든 행을 반환하고, 오른쪽 테이블에 일치하는 데이터가 없으면 NULL을 표시합니다.

**RIGHT OUTER JOIN**
오른쪽 테이블의 모든 행을 반환하며, LEFT JOIN의 반대입니다.

**FULL OUTER JOIN**
양쪽 테이블의 모든 행을 반환합니다 (합집합).

**예시**
```
users:              orders:
| id | name |      | id | user_id | total |
|----|------|      |----|---------|-------|
| 1  | Alice |     | 1  | 1       | 100   |
| 2  | Bob   |
| 3  | Carol |

INNER JOIN: Alice만 (일치하는 것만)
LEFT JOIN: Alice, Bob, Carol (users 전부 + orders는 NULL 가능)
```

**비교표**
| 구분 | INNER JOIN | LEFT JOIN | RIGHT JOIN | FULL JOIN |
|-----|-----------|-----------|------------|-----------|
| 왼쪽 테이블 | 일치만 | 전부 | 일치만 | 전부 |
| 오른쪽 테이블 | 일치만 | 일치만 | 전부 | 전부 |
| NULL 포함 | ✗ | ✓ | ✓ | ✓ |

**실무 선택**
- INNER JOIN: 양쪽에 데이터가 모두 있어야 하는 경우 (예: 주문한 사용자의 주문 내역)
- LEFT JOIN: 왼쪽 데이터는 모두 필요한 경우 (예: 모든 사용자 + 주문 정보)'
WHERE id = 'b0000000-0000-0000-0009-000000000010';

UPDATE questions SET explanation =
'**GROUP BY**
데이터를 그룹으로 묶어서 집계하는 절로, 같은 값을 가진 행들을 하나의 그룹으로 만들어 그룹별 통계를 계산합니다.

**HAVING**
GROUP BY 결과에 조건을 적용하는 절로, 집계 함수 결과에 대한 필터링을 수행합니다.

**WHERE vs HAVING**
| 구분 | WHERE | HAVING |
|-----|-------|--------|
| 시점 | 그룹화 전 | 그룹화 후 |
| 대상 | 개별 행 | 그룹 |
| 집계 함수 | 사용 불가 | 사용 가능 |

**사용 예시**

**GROUP BY**
```sql
-- 부서별 직원 수
SELECT department, COUNT(*) AS employee_count
FROM employees
GROUP BY department;
```

**HAVING**
```sql
-- 직원 수가 10명 이상인 부서만
SELECT department, COUNT(*) AS employee_count
FROM employees
GROUP BY department
HAVING COUNT(*) >= 10;
```

**WHERE + HAVING 함께 사용**
```sql
-- 2024년 주문 중, 총 주문 금액이 10000 이상인 고객
SELECT customer_id, SUM(total) AS total_amount
FROM orders
WHERE YEAR(order_date) = 2024
GROUP BY customer_id
HAVING SUM(total) >= 10000;
```

**실행 순서**
1. FROM → 2. WHERE (그룹화 전 필터) → 3. GROUP BY → 4. HAVING (그룹화 후 필터) → 5. SELECT → 6. ORDER BY

**주의사항**
- SELECT 절에는 GROUP BY 컬럼 또는 집계 함수만 사용 가능
- WHERE 절에서는 집계 함수 사용 불가 (HAVING 사용)

**실무 경험**
월별 매출 분석 시 GROUP BY로 날짜별 집계 후 HAVING으로 목표 매출 이상인 월만 필터링했습니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000011';

UPDATE questions SET explanation =
'**서브쿼리(Subquery)란?**
SQL 문 안에 중첩된 SELECT 문으로, 메인 쿼리의 일부로 실행되는 독립적인 쿼리입니다.

**주요 종류**

**1. 단일 행 서브쿼리**
하나의 값만 반환하며, 비교 연산자(=, >, <)를 사용합니다.
```sql
-- 평균 급여보다 많이 받는 직원
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
```

**2. 다중 행 서브쿼리**
여러 개의 값을 반환하며, IN, ANY, ALL, EXISTS를 사용합니다.
```sql
-- 주문한 고객 목록
SELECT name
FROM customers
WHERE id IN (SELECT DISTINCT customer_id FROM orders);
```

**3. FROM 절 서브쿼리 (인라인 뷰)**
```sql
SELECT dept.name, avg_sal.평균급여
FROM departments dept
JOIN (
    SELECT department_id, AVG(salary) AS 평균급여
    FROM employees
    GROUP BY department_id
) avg_sal ON dept.id = avg_sal.department_id;
```

**유용한 경우**

**복잡한 조건 필터링**
```sql
SELECT name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);
```

**데이터 존재 여부 확인**
```sql
-- 주문하지 않은 고객
SELECT name FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.id
);
```

**서브쿼리 vs JOIN**
같은 결과를 낼 수 있지만, 상황에 따라 성능이 다릅니다. EXPLAIN으로 실행 계획을 확인하여 선택하는 것이 좋습니다.

**성능 주의**
상관 서브쿼리(각 행마다 실행)는 느릴 수 있으므로, 가능하면 JOIN으로 대체하고 EXISTS를 IN보다 우선 고려합니다.

**실무 경험**
부서별 최고 급여자를 찾을 때 서브쿼리를 사용하여 간결하게 구현했으며, 대용량 데이터에서는 JOIN으로 변경하여 성능을 개선했습니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000012';
