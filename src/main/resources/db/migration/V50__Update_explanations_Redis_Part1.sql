-- Redis 질문에 대한 답변 추가 (Part 1: 1-14번)

UPDATE questions SET explanation =
'**Redis란?**
- Redis는 인메모리 Key-Value 데이터 저장소로, 모든 데이터를 RAM에 저장하여 평균 1ms 이하의 응답 속도를 제공합니다.
- 단순 캐시가 아니라 String, List, Set, Hash 등 다양한 자료구조를 지원하는 데이터 구조 서버입니다.

**주요 특징**
1. **인메모리 기반**: 디스크 I/O 없이 메모리에서 직접 처리하여 극도로 빠름
2. **싱글 스레드**: 모든 명령을 순차 처리하여 락 없이 원자성 보장
3. **다양한 자료구조**: String, List, Set, Sorted Set, Hash 등
4. **영속성 옵션**: RDB 스냅샷, AOF 로그로 재시작 후 복구 가능
5. **고가용성**: Replication, Sentinel, Cluster 지원

**주요 활용**
- **캐싱**: DB 조회 결과 캐싱으로 응답 속도 50-100배 개선
- **세션 저장소**: 여러 서버 간 세션 공유
- **실시간 순위표**: Sorted Set으로 게임 리더보드
- **분산 락**: 동시성 제어
- **Pub/Sub**: 실시간 메시징

**장단점**
- 장점: 초고속 성능, 원자적 연산, 확장성
- 단점: 메모리 비용, 용량 제한, 복잡한 쿼리 불가

**실무 경험**
실무에서 상품 상세 페이지 조회를 캐싱하여 DB 부하를 90% 감소시키고 응답 시간을 100ms에서 2ms로 개선한 경험이 있습니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000000';

UPDATE questions SET explanation =
'**싱글 스레드인데 빠른 이유**

Redis는 단일 스레드로 동작하지만 초당 10만 개 이상의 요청을 처리할 수 있습니다.

**1. 메모리 연산이 핵심**
- 모든 데이터가 RAM에 있어 디스크 I/O가 없습니다
- 메모리 접근은 나노초 단위로 극도로 빠릅니다
- 병목은 CPU가 아니라 네트워크 I/O입니다

**2. 멀티스레드 오버헤드 제거**
- 락(Lock) 불필요: 동시성 제어 비용 제로
- 컨텍스트 스위칭 없음: CPU 효율 극대화
- 경쟁 상태(Race Condition) 없음: 순차 실행으로 원자성 보장

**3. I/O 멀티플렉싱**
- epoll/kqueue를 사용한 비동기 I/O
- 싱글 스레드지만 수천 개의 클라이언트 동시 처리
- I/O 대기 중에 다른 요청 처리 가능

**4. 단순한 연산**
- Key-Value 기반의 단순 연산 (복잡한 JOIN 없음)
- 대부분 O(1) 시간 복잡도
- CPU 연산 시간은 극히 짧음

**5. 원자적 실행**
```redis
INCR counter  # 읽기-증가-쓰기가 원자적으로 실행
# 멀티스레드에서 발생하는 경쟁 상태 원천 차단
```

**한계**
- CPU 집약적 작업(큰 데이터 스캔)은 전체 Redis 블로킹
- KEYS * 같은 느린 명령어는 피해야 함 (대신 SCAN 사용)
- 단일 코어만 사용 (멀티코어 활용 못 함)

**Redis 6.0 개선**
Redis 6.0부터는 I/O 처리에 멀티스레드를 사용하여 네트워크 병목을 해소했지만, 명령 실행은 여전히 싱글 스레드로 원자성을 보장합니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000001';

UPDATE questions SET explanation =
'**Redis가 지원하는 자료구조**

**1. String (문자열)**
- 가장 기본적인 타입, 최대 512MB
- 텍스트, 숫자, JSON 직렬화 데이터 저장
- 활용: 캐싱, 카운터(INCR), 세션

**2. List (리스트)**
- 순서가 있는 문자열 컬렉션
- 양쪽 끝에서 O(1) 삽입/삭제
- 활용: 큐(FIFO), 스택(LIFO), 최근 항목 조회

**3. Set (집합)**
- 중복 없는 비순차 컬렉션
- 멤버십 체크 O(1)
- 교집합, 합집합, 차집합 연산 지원
- 활용: 태그, 고유 방문자, 친구 관계

**4. Sorted Set (정렬된 집합)**
- 각 멤버에 점수(score)를 부여하여 자동 정렬
- 점수 범위 조회, 순위 조회 가능
- 활용: 실시간 순위표, 우선순위 큐, 시간순 데이터

**5. Hash (해시)**
- 필드-값 쌍의 컬렉션 (객체 표현)
- 개별 필드만 업데이트 가능 (메모리 효율적)
- 활용: 사용자 프로필, 상품 정보

**6. Bitmap**
- 비트 단위 연산
- 활용: 일일 활성 사용자(DAU), 출석 체크

**7. HyperLogLog**
- 대략적인 고유 개수 추정 (12KB로 수십억 개 추정)
- 활용: 고유 방문자 수(UV)

**8. Stream**
- 로그형 데이터 구조 (Kafka와 유사)
- 활용: 이벤트 로그, 메시지 큐

**9. Geospatial**
- 위도/경도 기반 위치 저장
- 활용: 반경 내 검색

**실무 활용 예시**
- 게임 순위표: Sorted Set으로 실시간 랭킹 구현
- 장바구니: Hash로 상품ID-수량 저장
- 최근 방문 페이지: List로 최근 10개 유지
- 공통 관심사: Set의 교집합으로 추천 시스템'
WHERE id = 'b0000000-0000-0000-0011-000000000002';

UPDATE questions SET explanation =
'**캐시로 사용 시 장단점**

**장점**

**1. 극도로 빠른 응답**
- DB 쿼리: 50-100ms
- Redis 캐시: 1ms 이하
- 50-100배 성능 향상

**2. DB 부하 대폭 감소**
- 캐시 히트율 80% 달성 시 DB 부하 80% 감소
- DB 확장 비용 절감

**3. TTL 기반 자동 관리**
```redis
SETEX cache:user:123 3600 "data"  # 1시간 후 자동 삭제
```

**4. 확장성**
- 메모리 추가로 쉽게 확장
- Redis Cluster로 수평 확장

**단점**

**1. 메모리 비용**
- RAM은 디스크 대비 10-20배 비쌈
- 모든 데이터를 캐싱할 수 없음
- Eviction 정책 필요 (maxmemory-policy)

**2. 데이터 일관성 이슈**
- DB 업데이트 시 캐시 무효화 필요
- 해결: Cache Invalidation 전략

**3. 장애 시 데이터 손실**
- 전원 장애 시 메모리 데이터 손실
- 해결: AOF/RDB Persistence, Replication

**4. 캐시 스탬피드 (Stampede)**
- 인기 데이터 만료 시 동시 다수 요청이 DB로 몰림
- 해결: Lock 사용 또는 확률적 조기 만료

**5. 메모리 부족**
- maxmemory 도달 시 Eviction 발생
- LRU 정책으로 오래된 키 자동 삭제

**실무 Best Practices**
- 캐시 히트율 모니터링 (목표: 80% 이상)
- 적절한 TTL 설정 (자주 변경: 짧게, 정적 데이터: 길게)
- Cache-Aside 패턴 사용
- 중요 데이터는 DB 우선 저장 (Write-Through)

**경험**
실무에서 상품 목록 API를 캐싱하여 Black Friday 트래픽 10배 증가 상황에서도 안정적으로 서비스했습니다. 캐시 히트율 92%를 달성하여 DB 부하를 크게 줄였습니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000003';

UPDATE questions SET explanation =
'**Redis 영속성(Persistence) 방법**

Redis는 인메모리 DB이지만 디스크에 데이터를 저장하여 재시작 후 복구할 수 있습니다.

**1. RDB (Redis Database Snapshot)**

**동작**
- 특정 시점의 전체 데이터를 바이너리 파일(dump.rdb)로 저장
- fork()로 자식 프로세스가 백그라운드에서 저장 (BGSAVE)

**설정**
```ini
save 900 1      # 15분 동안 1개 이상 변경 시
save 300 10     # 5분 동안 10개 이상 변경 시
save 60 10000   # 1분 동안 10000개 이상 변경 시
```

**장점**
- 빠른 복구 (바이너리 파일 로드)
- 작은 파일 크기 (압축)
- 백업 용이 (단일 파일)

**단점**
- 데이터 손실 위험 (마지막 스냅샷 이후 데이터)
- Fork 오버헤드 (메모리 일시적 2배 사용)

**2. AOF (Append-Only File)**

**동작**
- 모든 쓰기 명령을 텍스트 로그 파일에 순차 기록
- 재시작 시 명령어를 재실행하여 복구

**설정**
```ini
appendonly yes
appendfsync everysec  # 1초마다 디스크 동기화 (권장)
```

**Fsync 정책**
- always: 매 명령마다 동기화 (가장 안전, 느림)
- everysec: 1초마다 (권장, 최대 1초치 손실)
- no: OS에 맡김 (빠름, 최대 30초치 손실)

**장점**
- 데이터 안전성 높음 (최대 1초치 손실)
- 읽기 쉬운 텍스트 파일
- 손상 복구 가능 (redis-check-aof)

**단점**
- 파일 크기 큼 (Rewrite로 압축 가능)
- 복구 느림 (명령어 재실행)
- 디스크 I/O 부하

**3. RDB + AOF 혼합 (권장)**

```ini
save 900 1
appendonly yes
appendfsync everysec
aof-use-rdb-preamble yes  # AOF에 RDB 포맷 포함
```

**장점**
- RDB: 빠른 전체 복구
- AOF: 최신 데이터 보장
- 최고의 안정성 + 성능

**선택 가이드**
- 순수 캐시 (데이터 손실 허용): Persistence 비활성화
- 일반 애플리케이션: RDB + AOF (everysec)
- 미션 크리티컬: AOF (always)

**실무 경험**
RDB + AOF 혼합 모드를 사용하여 서버 재시작 시에도 데이터 손실 없이 빠르게 복구했습니다. 매일 새벽 RDB 파일을 S3에 백업하여 재해 복구 대비를 했습니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000004';

UPDATE questions SET explanation =
'**RDB vs AOF 차이**

**RDB (스냅샷)**
- 특정 시점의 전체 데이터를 바이너리 파일로 저장
- 주기적 저장 (예: 5분마다)
- 복구 빠름 (파일 로드만)
- 데이터 손실 위험 (마지막 스냅샷 이후)
- 파일 작음 (압축)

**AOF (로그)**
- 모든 쓰기 명령을 텍스트로 순차 기록
- 실시간 저장 (1초마다 또는 매 명령마다)
- 복구 느림 (명령어 재실행)
- 데이터 안전 (최대 1초치 손실)
- 파일 큼 (Rewrite로 압축 가능)

**비교표**

| 구분 | RDB | AOF |
|------|-----|-----|
| 저장 방식 | 스냅샷 | 명령어 로그 |
| 파일 크기 | 작음 | 큼 |
| 복구 속도 | 빠름 | 느림 |
| 데이터 손실 | 분 단위 | 초 단위 |
| 성능 영향 | 낮음 | 중간 |
| 백업 | 용이 | Rewrite 필요 |

**실무 권장**
- 대부분: RDB + AOF 혼합
- 순수 캐시: 비활성화
- 중요 데이터: AOF만

**경험**
초기에 RDB만 사용하다가 5분치 데이터 손실 사고 이후 AOF를 추가하여 안정성을 확보했습니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000005';

UPDATE questions SET explanation =
'**Redis 복제(Replication)**

Redis는 Master-Slave 구조로 데이터를 자동 복제합니다.

**동작 원리**
1. Slave가 Master에 연결 요청
2. Master가 RDB 스냅샷 생성하여 Slave에 전송
3. Slave가 스냅샷 로드
4. 이후 Master의 모든 쓰기 명령을 Slave에 실시간 복제 (비동기)

**설정**
```ini
# Slave 서버에서
replicaof 192.168.1.10 6379  # Master IP, Port
```

**특징**
- **비동기 복제**: Master는 Slave 응답을 기다리지 않음 (성능 우수)
- **읽기 분산**: Slave에서 읽기 부하 분산
- **자동 재연결**: Slave 장애 시 자동 복구

**장점**
- 읽기 성능 향상 (Slave로 부하 분산)
- 고가용성 (Master 장애 시 Slave 승격)
- 백업 (Slave에서 BGSAVE)

**단점**
- 복제 지연 (Replication Lag)
- Master 단일 장애점 (Sentinel로 해결)

**실무 활용**
- Master: 쓰기 전용
- Slave 3대: 읽기 분산
- Slave에서 RDB 백업 (Master 부하 없음)

**경험**
읽기가 많은 서비스에서 Slave 3대를 추가하여 읽기 처리량을 4배 늘렸습니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000006';

UPDATE questions SET explanation =
'**Slave의 역할**

**1. 데이터 복제**
- Master의 모든 데이터를 실시간으로 복제
- 읽기 전용 (기본 설정)

**2. 읽기 부하 분산**
- SELECT 쿼리를 Slave에서 처리
- Master는 쓰기만 담당

```python
# 애플리케이션 레벨 분기
if operation == "write":
    redis_master.set(key, value)
else:
    redis_slave.get(key)
```

**3. 장애 대비**
- Master 장애 시 Slave를 Master로 승격 (Failover)
- Sentinel이 자동으로 승격 수행

**4. 백업**
- Slave에서 BGSAVE 실행 (Master 부하 없음)

**주의사항**
- 복제 지연: Slave가 최신 데이터가 아닐 수 있음
- 일관성 필요 시: Master에서만 읽기

**실무 구성**
- Master 1대: 쓰기
- Slave 2-3대: 읽기 분산
- Sentinel 3대: 자동 Failover'
WHERE id = 'b0000000-0000-0000-0011-000000000007';

UPDATE questions SET explanation =
'**Redis Sentinel**

Sentinel은 Redis의 고가용성(HA) 솔루션으로 자동 장애 조치를 담당합니다.

**주요 역할**

**1. 모니터링**
- Master와 Slave의 상태를 지속적으로 감시
- 주기적으로 PING 전송

**2. 장애 감지**
- Master 응답 없으면 장애로 판단
- 여러 Sentinel이 과반수 합의 (Quorum)

**3. 자동 Failover**
- Master 장애 시 Slave를 자동으로 Master로 승격
- 다른 Slave들을 새 Master에 재연결
- 클라이언트에 새 Master 정보 알림

**4. 설정 제공**
- 클라이언트가 Sentinel에 접속하여 현재 Master 주소 조회

**동작 과정**
1. Sentinel들이 Master 장애 감지
2. 과반수가 동의하면 Failover 시작
3. 가장 우선순위 높은 Slave를 Master로 승격
4. 나머지 Slave들 재설정
5. 클라이언트에 새 Master 알림

**설정**
```ini
# sentinel.conf
sentinel monitor mymaster 192.168.1.10 6379 2  # Quorum 2
sentinel down-after-milliseconds mymaster 5000
sentinel failover-timeout mymaster 60000
```

**권장 구성**
- Sentinel 3대 이상 (홀수)
- Quorum: 과반수

**장점**
- 자동 복구 (수동 개입 불필요)
- 다운타임 최소화 (수초 내 Failover)

**실무 경험**
Sentinel을 통해 Master 장애 시 30초 내 자동 복구되어 서비스 중단을 최소화했습니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000008';

UPDATE questions SET explanation =
'**Redis Cluster**

Redis Cluster는 데이터 샤딩과 복제를 결합한 분산 솔루션입니다.

**핵심 개념**

**1. 데이터 샤딩**
- 16,384개의 슬롯으로 키 공간을 분할
- 각 노드가 슬롯 일부를 담당
- 키는 CRC16 해시로 슬롯 결정

**2. 자동 Failover**
- 각 Master에 Slave 연결
- Master 장애 시 Slave 자동 승격

**구조**
```
Master 1 (슬롯 0-5460)     + Slave 1
Master 2 (슬롯 5461-10922) + Slave 2
Master 3 (슬롯 10923-16383)+ Slave 3
```

**동작**
```redis
SET user:1000 "data"
→ CRC16("user:1000") % 16384 = 슬롯 123
→ Master 1에 저장
```

**장점**
- 수평 확장 (노드 추가로 용량/성능 증가)
- 자동 Failover (Sentinel 불필요)
- 일부 노드 장애에도 서비스 지속

**단점**
- 멀티 키 연산 제한 (같은 슬롯만 가능)
- 운영 복잡도 증가
- 재샤딩 시 부하

**vs Replication**
- Replication: 모든 노드가 전체 데이터 (읽기 확장)
- Cluster: 데이터 분산 (쓰기 확장 + 읽기 확장)

**실무 선택**
- 데이터 < 메모리: Replication
- 데이터 > 메모리: Cluster

**경험**
100GB 데이터를 Cluster 6노드(Master 3 + Slave 3)로 분산하여 처리량을 3배 증가시켰습니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000009';

UPDATE questions SET explanation =
'**클러스터링 vs 복제**

**복제 (Replication)**
- 모든 노드가 전체 데이터 복사본 보유
- Master 1대 + Slave N대
- 읽기 부하 분산
- 쓰기는 Master만 (확장 불가)
- 데이터 크기 = 단일 노드 메모리 제한

**클러스터링 (Cluster)**
- 데이터를 여러 노드에 분산 (샤딩)
- Master N대 + 각 Slave
- 읽기 + 쓰기 모두 확장
- 데이터 크기 = 노드 수 × 메모리

**비교표**

| 구분 | 복제 | 클러스터 |
|------|------|----------|
| 데이터 | 전체 복사 | 분산 |
| 읽기 확장 | O | O |
| 쓰기 확장 | X | O |
| 용량 확장 | X | O |
| 운영 복잡도 | 낮음 | 높음 |
| Failover | Sentinel 필요 | 자동 |

**선택 가이드**
- 데이터 < 64GB, 읽기 많음: 복제
- 데이터 > 64GB, 쓰기 많음: 클러스터
- 단순한 구조 선호: 복제

**실무**
대부분의 경우 Replication으로 충분하며, 데이터가 단일 서버 메모리를 초과할 때만 Cluster를 고려합니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000010';

UPDATE questions SET explanation =
'**Redis 샤딩**

샤딩은 데이터를 여러 Redis 인스턴스에 분산하는 기법입니다.

**1. Redis Cluster (자동 샤딩)**
- Redis가 16,384 슬롯으로 자동 분산
- 노드 추가/제거 시 자동 재분배
- 권장 방법

**2. 애플리케이션 레벨 샤딩 (수동)**

**Hash 기반**
```python
def get_shard(key):
    shard_count = 4
    return hash(key) % shard_count

# 쓰기
shard_id = get_shard("user:1000")
redis_clients[shard_id].set("user:1000", data)

# 읽기
shard_id = get_shard("user:1000")
data = redis_clients[shard_id].get("user:1000")
```

**Range 기반**
```python
# user_id 범위로 분산
if user_id < 1000000:
    redis1.set(...)
elif user_id < 2000000:
    redis2.set(...)
```

**3. Proxy 기반 (Twemproxy, Codis)**
- 중간에 Proxy를 두고 자동 라우팅

**수동 샤딩 장단점**

**장점**
- Redis Cluster 지원 이전에도 사용 가능
- 세밀한 제어

**단점**
- 재샤딩 어려움 (노드 추가 시 데이터 재분배)
- 애플리케이션 복잡도 증가
- 멀티 키 연산 불가

**권장**
- 가능하면 Redis Cluster 사용
- Cluster 불가 시 수동 샤딩 고려

**실무**
초기에 수동 샤딩을 사용했으나 노드 추가 시 재샤딩이 어려워 Redis Cluster로 마이그레이션했습니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000011';

UPDATE questions SET explanation =
'**Eviction 정책**

maxmemory 도달 시 Redis가 키를 제거하는 정책입니다.

**주요 정책**

**1. noeviction (기본값)**
- 메모리 가득 차면 쓰기 명령 거부
- 읽기는 계속 가능
- 사용: 데이터 손실 절대 불가

**2. allkeys-lru**
- 모든 키 중 가장 오래 사용 안 된 키 제거
- 사용: 일반적인 캐시

**3. volatile-lru**
- TTL 설정된 키 중 가장 오래 사용 안 된 키 제거
- 사용: 일부만 캐시, 나머지는 영구 데이터

**4. allkeys-random**
- 모든 키 중 랜덤 제거
- 사용: 특별한 경우

**5. volatile-ttl**
- TTL이 가장 짧은 키 먼저 제거
- 사용: 만료 시간 기반 우선순위

**6. allkeys-lfu (Redis 4.0+)**
- 가장 적게 사용된 키 제거 (LRU보다 정확)

**설정**
```ini
maxmemory 2gb
maxmemory-policy allkeys-lru
```

**선택 가이드**
- 순수 캐시: allkeys-lru
- 캐시 + 영구 데이터: volatile-lru
- 데이터 보존 필수: noeviction

**모니터링**
```redis
INFO stats
# evicted_keys: 제거된 키 수
```

**실무**
allkeys-lru를 사용하여 자주 사용되는 상품 데이터는 자동으로 유지하고 오래된 데이터는 자동 제거되도록 했습니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000012';

UPDATE questions SET explanation =
'**LRU (Least Recently Used)**

가장 오래 사용하지 않은 데이터를 제거하는 정책입니다.

**동작 원리**
- 각 키에 마지막 접근 시간 기록
- 메모리 부족 시 가장 오래전 접근한 키 제거

**Redis LRU 구현**
- 정확한 LRU가 아닌 근사 LRU (성능 최적화)
- 샘플링 방식: 일부 키만 검사하여 제거 대상 선택

**설정**
```ini
maxmemory-policy allkeys-lru
maxmemory-samples 5  # 샘플링 개수 (클수록 정확, 느림)
```

**LRU vs LFU**
- LRU: 최근에 사용했는지 (시간)
- LFU: 얼마나 자주 사용했는지 (빈도)

**적합한 경우**
- 시간 지역성이 강한 데이터 (최근 것이 다시 사용될 확률 높음)
- 일반적인 웹 캐시

**실무**
상품 상세 페이지 캐시에 LRU를 적용하여 인기 상품은 자동으로 유지되고 비인기 상품은 자연스럽게 제거되었습니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000013';

UPDATE questions SET explanation =
'**파이프라이닝 (Pipelining)**

여러 명령을 한 번에 전송하여 네트워크 왕복 시간을 줄이는 기법입니다.

**문제 상황**
```python
# 100개 명령을 개별 전송
for i in range(100):
    redis.set(f"key:{i}", i)
# 네트워크 RTT × 100번 = 매우 느림
```

**파이프라이닝 사용**
```python
pipe = redis.pipeline()
for i in range(100):
    pipe.set(f"key:{i}", i)
pipe.execute()  # 한 번에 전송
# 네트워크 RTT × 1번 = 빠름!
```

**효과**
- RTT (Round-Trip Time) 감소
- 처리량 수십~수백 배 증가

**주의사항**
- 트랜잭션 아님 (원자성 보장 안 됨)
- 다른 클라이언트의 명령이 중간에 실행될 수 있음
- 원자성 필요 시: MULTI/EXEC 사용

**vs 트랜잭션**
```python
# 트랜잭션 (원자적)
pipe = redis.pipeline(transaction=True)  # MULTI/EXEC 자동
pipe.set("key1", "value1")
pipe.set("key2", "value2")
pipe.execute()  # 원자적 실행
```

**실무**
배치 작업에서 10,000개 키를 업데이트할 때 파이프라이닝으로 10분 → 10초로 단축했습니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000014';
