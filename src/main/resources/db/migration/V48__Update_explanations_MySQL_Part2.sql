-- MySQL 질문에 대한 답변 추가 (Part 2: 13-24번)

UPDATE questions SET explanation =
'**뷰(View)란?**
하나 이상의 테이블로부터 유도된 가상 테이블로, 실제 데이터를 저장하지 않고 SELECT 문만 저장합니다.

**생성 및 사용**
```sql
CREATE VIEW active_users AS
SELECT id, name, email
FROM users
WHERE status = ''ACTIVE'';

SELECT * FROM active_users;  -- 일반 테이블처럼 사용
```

**장점**
1. **보안**: 특정 컬럼만 노출하여 민감한 정보 숨김
2. **쿼리 단순화**: 복잡한 JOIN을 뷰로 저장하여 재사용
3. **독립성**: 테이블 구조 변경 시 뷰만 수정하면 애플리케이션 코드 수정 불필요
4. **일관성**: 동일한 데이터 뷰를 여러 곳에서 사용

**단점**
1. **성능 이슈**: 뷰 조회 시마다 내부 쿼리 실행, 인덱스 직접 생성 불가
2. **제한된 수정**: JOIN, GROUP BY, 집계 함수 포함 시 INSERT/UPDATE/DELETE 불가
3. **관리 부담**: 뷰가 많아지면 의존성 관리 어려움

**뷰 종류**
- **단순 뷰**: 하나의 테이블, 수정 가능
- **복합 뷰**: JOIN, GROUP BY 포함, 수정 불가능

**실무 경험**
민감한 사용자 정보를 숨기고 필요한 컬럼만 노출하는 뷰를 생성하여 보안을 강화했으며, 복잡한 주문 통계 쿼리를 뷰로 만들어 여러 리포트에서 재사용했습니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000013';

UPDATE questions SET explanation =
'**스토어드 프로시저(Stored Procedure)란?**
데이터베이스에 저장된 SQL 문의 집합으로, 반복적인 작업을 미리 정의해두고 호출하여 실행합니다.

**생성 및 사용**
```sql
DELIMITER $$
CREATE PROCEDURE GetUserOrders(IN user_id INT)
BEGIN
    SELECT * FROM orders WHERE customer_id = user_id;
END$$
DELIMITER ;

CALL GetUserOrders(123);  -- 호출
```

**사용 이유**
1. **성능 향상**: SQL 파싱과 최적화를 한 번만 수행 (컴파일 후 재사용)
2. **보안**: 직접 테이블 접근 대신 프로시저 권한만 부여
3. **재사용성**: 복잡한 로직을 한 번 작성하여 여러 곳에서 호출
4. **네트워크 트래픽 감소**: 여러 SQL 문을 한 번에 실행
5. **비즈니스 로직 중앙화**: DB에서 일관된 로직 유지

**장점**
- 코드 재사용, 유지보수 용이
- 트랜잭션 관리 가능
- 애플리케이션 부하 감소

**단점**
- 디버깅 어려움
- 버전 관리 어려움
- DB 종속성 증가

**실무 경험**
복잡한 재고 차감 로직을 스토어드 프로시저로 구현하여 여러 서비스에서 일관되게 사용했으며, 트랜잭션 처리로 데이터 정합성을 보장했습니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000014';

UPDATE questions SET explanation =
'**트리거(Trigger)란?**
특정 테이블에 INSERT, UPDATE, DELETE 이벤트가 발생할 때 자동으로 실행되는 저장 프로시저입니다.

**생성**
```sql
CREATE TRIGGER audit_user_update
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (user_id, action, changed_at)
    VALUES (NEW.id, ''UPDATE'', NOW());
END;
```

**트리거 종류**
- **BEFORE 트리거**: 이벤트 실행 전 (유효성 검사, 데이터 변경)
- **AFTER 트리거**: 이벤트 실행 후 (로그 기록, 알림)

**활용 사례**
1. **감사 로그**: 데이터 변경 이력 자동 기록
2. **데이터 검증**: INSERT/UPDATE 전 유효성 검사
3. **파생 데이터 유지**: 집계 테이블 자동 업데이트
4. **연관 데이터 동기화**: 한 테이블 변경 시 다른 테이블 자동 업데이트

**장점**
- 자동화된 데이터 무결성 유지
- 일관된 비즈니스 규칙 적용

**단점**
- 디버깅 어려움 (보이지 않는 로직)
- 성능 저하 가능
- 복잡한 의존성

**주의사항**
트리거가 트리거를 호출하는 연쇄 반응 주의, 과도한 사용은 성능 문제 야기

**실무 경험**
사용자 정보 변경 시 AFTER UPDATE 트리거로 변경 이력을 자동 저장하여 감사 로그를 구축했습니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000015';

UPDATE questions SET explanation =
'**풀텍스트 검색(Full-text Search)이란?**
텍스트 컬럼에서 키워드를 빠르게 검색하기 위한 기능으로, LIKE보다 성능이 우수하고 자연어 검색을 지원합니다.

**구현 방법**

**1. FULLTEXT 인덱스 생성**
```sql
CREATE TABLE articles (
    id INT PRIMARY KEY,
    title VARCHAR(200),
    content TEXT,
    FULLTEXT INDEX ft_idx (title, content)
);
```

**2. 검색 쿼리**
```sql
-- 자연어 검색
SELECT * FROM articles
WHERE MATCH(title, content) AGAINST(''MySQL 성능'' IN NATURAL LANGUAGE MODE);

-- 불린 모드 (AND, OR, NOT 지원)
SELECT * FROM articles
WHERE MATCH(title, content) AGAINST(''+MySQL -Oracle'' IN BOOLEAN MODE);
```

**검색 모드**
- **NATURAL LANGUAGE MODE**: 자연어 검색 (기본)
- **BOOLEAN MODE**: +, -, *, "" 등 연산자 사용
- **QUERY EXPANSION**: 관련 단어까지 확장 검색

**장점**
- LIKE ''%keyword%''보다 훨씬 빠름
- 관련도 점수 제공
- 불용어(stopword) 자동 제외

**단점**
- 최소 단어 길이 제한 (기본 4자)
- 한글 검색 제한적 (n-gram 파서 필요)
- 인덱스 크기가 큼

**실무 경험**
게시판 검색 기능에서 LIKE 검색 대신 FULLTEXT 인덱스를 적용하여 검색 속도를 10배 향상시켰습니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000016';

UPDATE questions SET explanation =
'**실행 계획(EXPLAIN)이란?**
MySQL이 쿼리를 어떻게 실행할지 보여주는 정보로, 쿼리 최적화에 필수적입니다.

**사용법**
```sql
EXPLAIN SELECT * FROM users WHERE email = ''test@example.com'';
```

**주요 컬럼**

**1. type (조인 타입)**
성능 순서: system > const > eq_ref > ref > range > index > ALL
- **const**: 기본 키나 유니크 인덱스로 단일 행 조회 (가장 빠름)
- **ref**: 비유니크 인덱스로 여러 행 조회
- **range**: 인덱스 범위 스캔 (BETWEEN, <, >)
- **ALL**: 전체 테이블 스캔 (가장 느림, 개선 필요)

**2. key**
실제 사용된 인덱스 (NULL이면 인덱스 미사용)

**3. rows**
검색할 것으로 예상되는 행 수 (적을수록 좋음)

**4. Extra**
- **Using index**: 커버링 인덱스 (인덱스만으로 조회 완료, 매우 빠름)
- **Using where**: WHERE 조건 사용
- **Using filesort**: 정렬 작업 필요 (느림, 인덱스 추가 고려)
- **Using temporary**: 임시 테이블 사용 (느림, 쿼리 개선 필요)

**활용 방법**
1. type이 ALL이면 인덱스 추가 고려
2. rows가 크면 WHERE 조건이나 인덱스 개선
3. Using filesort, Using temporary는 성능 저하 신호

**실무 경험**
EXPLAIN으로 느린 쿼리의 실행 계획을 분석하여 ALL 타입을 ref로 개선하고, 적절한 인덱스를 추가하여 쿼리 속도를 100배 향상시켰습니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000017';

UPDATE questions SET explanation =
'**복제(Replication)란?**
하나의 MySQL 서버(마스터)의 데이터를 다른 서버(슬레이브)로 자동으로 복사하는 기능입니다.

**설정 방법**

**1. 마스터 설정**
```sql
-- my.cnf
[mysqld]
server-id = 1
log-bin = mysql-bin
binlog-do-db = mydb

-- 복제 사용자 생성
CREATE USER ''repl''@''%'' IDENTIFIED BY ''password'';
GRANT REPLICATION SLAVE ON *.* TO ''repl''@''%'';
```

**2. 슬레이브 설정**
```sql
-- my.cnf
[mysqld]
server-id = 2

-- 마스터 지정
CHANGE MASTER TO
  MASTER_HOST=''master_ip'',
  MASTER_USER=''repl'',
  MASTER_PASSWORD=''password'',
  MASTER_LOG_FILE=''mysql-bin.000001'',
  MASTER_LOG_POS=0;

START SLAVE;
```

**복제 목적**
1. **읽기 성능 향상**: 읽기 부하를 슬레이브로 분산
2. **고가용성**: 마스터 장애 시 슬레이브로 전환
3. **백업**: 슬레이브에서 백업 수행 (마스터 부하 감소)
4. **분석**: 슬레이브에서 무거운 분석 쿼리 실행

**복제 방식**
- **비동기 복제**: 마스터는 슬레이브 응답을 기다리지 않음 (빠르지만 데이터 손실 가능)
- **반동기 복제**: 최소 1개 슬레이브의 확인을 기다림 (안전하지만 느림)

**실무 경험**
마스터-슬레이브 복제로 읽기 전용 API를 슬레이브로 분산하여 마스터의 부하를 70% 감소시키고, 장애 시 슬레이브를 마스터로 승격하여 다운타임을 최소화했습니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000018';

UPDATE questions SET explanation =
'**마스터-슬레이브 복제 원리**

**1. 바이너리 로그 (Binary Log)**
마스터는 모든 데이터 변경(INSERT, UPDATE, DELETE)을 바이너리 로그에 기록합니다.

**2. 복제 과정**

**Step 1: 마스터**
- 모든 변경 사항을 Binary Log에 기록
- 각 이벤트에 위치(position) 부여

**Step 2: 슬레이브의 I/O Thread**
- 마스터에 연결하여 Binary Log 이벤트를 읽음
- Relay Log에 저장

**Step 3: 슬레이브의 SQL Thread**
- Relay Log의 이벤트를 읽어서 실행
- 마스터와 동일한 데이터 상태 유지

**복제 흐름**
```
Master                      Slave
[Data Change]
   ↓
[Binary Log]  ─────────→  [I/O Thread]
                              ↓
                          [Relay Log]
                              ↓
                          [SQL Thread]
                              ↓
                          [Data Change]
```

**복제 지연**
슬레이브가 마스터를 따라잡지 못하는 현상으로, 대량 쓰기 작업 시 발생할 수 있습니다.

**확인 방법**
```sql
SHOW SLAVE STATUS\G
-- Seconds_Behind_Master: 복제 지연 시간 (초)
```

**실무 고려사항**
- 읽기/쓰기 분리 시 복제 지연 고려 필요
- 중요한 쓰기 직후 읽기는 마스터에서 수행
- 슬레이브 여러 대로 읽기 부하 분산

**실무 경험**
복제 지연을 모니터링하여 10초 이상 지연 시 알림을 받도록 설정하고, 슬레이브 성능을 개선하여 평균 지연을 1초 이하로 유지했습니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000019';

UPDATE questions SET explanation =
'**MySQL 8.x 주요 변경점 및 신기능**

**1. 성능 개선**
- **InnoDB 성능 향상**: 읽기/쓰기 처리량 2배 증가
- **임시 테이블 개선**: 메모리 임시 테이블을 TempTable 엔진으로 처리 (더 빠름)

**2. Window Functions 지원**
```sql
SELECT
    name,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS rank,
    AVG(salary) OVER () AS avg_salary
FROM employees;
```

**3. CTE (Common Table Expression) 지원**
```sql
WITH RECURSIVE cte AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM cte WHERE n < 10
)
SELECT * FROM cte;
```

**4. JSON 기능 강화**
- JSON 테이블 함수, 집계 함수 추가
- `JSON_TABLE()`: JSON을 테이블로 변환

**5. 역할(Role) 기반 권한 관리**
```sql
CREATE ROLE ''app_read'';
GRANT SELECT ON mydb.* TO ''app_read'';
GRANT ''app_read'' TO ''user1''@''localhost'';
```

**6. 기본 인증 방식 변경**
- `caching_sha2_password`로 변경 (보안 강화)

**7. 데이터 딕셔너리**
- 메타데이터를 트랜잭션 테이블에 저장 (이전: 파일 기반)
- DDL 문의 원자성 보장, 크래시 복구 개선

**8. 시스템 변수 영구 설정**
```sql
SET PERSIST max_connections = 500;  -- 재시작 후에도 유지
```

**실무 영향**
Window Functions로 복잡한 순위 쿼리를 간결하게 작성할 수 있고, CTE로 가독성이 향상되었으며, Role 기반 권한으로 사용자 관리가 편리해졌습니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000020';

UPDATE questions SET explanation =
'**NoSQL vs MySQL 선택 기준**

**MySQL(관계형 DB) 선택**

**1. 데이터 무결성이 중요한 경우**
- 금융, 결제, 주문 시스템
- ACID 트랜잭션 필수
- 외래 키, 제약 조건 필요

**2. 복잡한 쿼리가 필요한 경우**
- JOIN, 집계, 서브쿼리 활용
- 다양한 조건의 검색

**3. 스키마가 명확한 경우**
- 정형화된 데이터
- 스키마 변경이 적음

**NoSQL 선택**

**1. 확장성이 중요한 경우**
- 대용량 데이터 (TB, PB 단위)
- 수평 확장(샤딩) 필요
- 트래픽 급증 대응

**2. 유연한 스키마가 필요한 경우**
- 비정형 데이터
- 스키마 변경이 빈번함
- 다양한 형태의 데이터

**3. 단순한 키-값 조회가 주**
- 캐싱 (Redis)
- 세션 저장
- 로그 저장 (MongoDB)

**4. 빠른 쓰기 성능이 중요**
- 실시간 로그 수집
- IoT 센서 데이터
- 이벤트 스트리밍

**비교**
| 구분 | MySQL | NoSQL |
|-----|-------|-------|
| 트랜잭션 | 강력한 ACID | 제한적 (BASE) |
| 스키마 | 고정적 | 유연함 |
| 확장 | 수직 확장 | 수평 확장 |
| JOIN | 강력함 | 약함/없음 |
| 사용 사례 | 금융, 주문 | 로그, 캐시, 빅데이터 |

**실무 경험**
주문 시스템은 MySQL(트랜잭션 보장), 실시간 로그는 MongoDB(빠른 쓰기), 세션 캐시는 Redis(빠른 읽기)로 각 특성에 맞게 선택했습니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000021';

UPDATE questions SET explanation =
'**대용량 테이블 성능 튜닝**

**1. 인덱스 최적화**
- WHERE, JOIN 조건에 사용되는 컬럼에 인덱스 추가
- 복합 인덱스 활용 (컬럼 순서 중요)
- 사용하지 않는 인덱스 제거 (쓰기 성능 향상)
- 커버링 인덱스로 테이블 접근 최소화

**2. 파티셔닝**
대용량 테이블을 작은 물리적 단위로 분할하여 성능 향상
```sql
-- 날짜 기반 파티셔닝
CREATE TABLE orders (
    id INT,
    order_date DATE,
    ...
) PARTITION BY RANGE (YEAR(order_date)) (
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025)
);
```

**3. 쿼리 최적화**
- `SELECT *` 대신 필요한 컬럼만 조회
- LIMIT 사용으로 결과 제한
- 서브쿼리 대신 JOIN 사용 (상황에 따라)
- EXPLAIN으로 실행 계획 분석

**4. 테이블 구조 개선**
- 적절한 데이터 타입 선택 (INT vs BIGINT)
- VARCHAR 길이 최적화
- NULL 최소화
- 정규화/비정규화 균형

**5. 하드웨어 및 설정**
- SSD 사용 (I/O 성능 향상)
- `innodb_buffer_pool_size` 증가 (메모리 캐시)
- `innodb_flush_log_at_trx_commit` 조정 (성능 vs 안정성)

**6. 아카이빙**
- 오래된 데이터는 별도 테이블로 이동
- 주기적인 파티션 삭제

**실무 경험**
1억 건의 로그 테이블에서 날짜 기반 파티셔닝과 적절한 인덱스 추가로 조회 속도를 50배 향상시켰으며, 1년 이상 된 데이터는 아카이브 테이블로 이동하여 운영 테이블 크기를 80% 감소시켰습니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000022';

UPDATE questions SET explanation =
'**슬로우 쿼리 대응 방법**

**1. 슬로우 쿼리 로그 활성화**
```sql
SET GLOBAL slow_query_log = ''ON'';
SET GLOBAL long_query_time = 1;  -- 1초 이상 쿼리 기록
```

**2. 슬로우 쿼리 분석**
```bash
# mysqldumpslow로 분석
mysqldumpslow -s t -t 10 slow-query.log  -- 상위 10개 느린 쿼리
```

**3. EXPLAIN으로 실행 계획 확인**
```sql
EXPLAIN SELECT * FROM orders WHERE customer_id = 123;
```
- type이 ALL (전체 스캔)이면 인덱스 추가 고려
- rows가 크면 WHERE 조건 개선
- Using filesort, Using temporary는 성능 저하 신호

**4. 쿼리 최적화**

**인덱스 추가**
```sql
CREATE INDEX idx_customer ON orders(customer_id);
```

**쿼리 재작성**
```sql
-- 나쁨: 함수 사용으로 인덱스 미사용
SELECT * FROM users WHERE YEAR(created_at) = 2024;

-- 좋음: 범위 조건으로 인덱스 사용
SELECT * FROM users
WHERE created_at >= ''2024-01-01''
  AND created_at < ''2025-01-01'';
```

**5. 캐싱**
- 자주 조회되는 데이터는 Redis 등에 캐싱
- 쿼리 결과 캐싱 (애플리케이션 레벨)

**6. 읽기/쓰기 분리**
- 무거운 쿼리는 슬레이브에서 실행
- 마스터 부하 감소

**7. 테이블 파티셔닝**
- 대용량 테이블을 날짜/범위별로 분할

**8. 모니터링 및 알림**
- 슬로우 쿼리 자동 알림 설정
- 주기적인 성능 검토

**실무 경험**
슬로우 쿼리 로그를 분석하여 인덱스가 없는 컬럼을 발견하고 인덱스 추가로 30초 쿼리를 0.1초로 개선했으며, 복잡한 통계 쿼리는 Redis에 결과를 캐싱하여 실시간 조회 성능을 확보했습니다.'
WHERE id = 'b0000000-0000-0000-0009-000000000023';
