-- Redis 질문에 대한 답변 추가 (Part 2: 15-27번)

UPDATE questions SET explanation =
'**Pub/Sub (발행/구독)**

Redis의 메시징 시스템으로 실시간 이벤트 전파에 사용됩니다.

**동작 원리**
- Publisher: 특정 채널에 메시지 발행
- Subscriber: 채널을 구독하여 메시지 수신
- 브로커: Redis가 중간에서 메시지 라우팅

**기본 사용**
```redis
# Subscriber (수신자)
SUBSCRIBE notifications

# Publisher (발신자)
PUBLISH notifications "New order received"

# 패턴 구독
PSUBSCRIBE user:*  # user:로 시작하는 모든 채널
```

**특징**
- **Fire-and-Forget**: 메시지 저장 안 됨 (구독자 없으면 사라짐)
- **실시간**: 즉시 전달
- **다대다**: 여러 Publisher → 여러 Subscriber

**활용 사례**
- **실시간 알림**: 주문 완료, 댓글 알림
- **채팅**: 채팅방 메시지 전파
- **캐시 무효화**: 여러 서버에 캐시 삭제 신호
- **이벤트 브로드캐스트**: 시스템 상태 변경 알림

**vs Kafka/RabbitMQ**
- Redis Pub/Sub: 간단, 메시지 보관 안 됨, 실시간
- Kafka: 복잡, 메시지 보관, 높은 처리량

**주의사항**
- 구독자가 없으면 메시지 손실
- 메시지 순서 보장 안 됨 (네트워크 지연)
- 영속성 없음 (재시작 시 구독 끊김)

**대안: Stream**
Redis 5.0+ Stream은 메시지 저장 + Consumer Group 지원

**실무**
마이크로서비스 간 실시간 이벤트 전파에 Pub/Sub을 사용하여 주문 완료 시 재고/배송 서비스에 즉시 알림을 보냈습니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000015';

UPDATE questions SET explanation =
'**Lua 스크립팅**

Redis에서 여러 명령을 원자적으로 실행하는 스크립트 기능입니다.

**필요성**
```python
# 문제: 조건부 업데이트 (비원자적)
current = redis.get("stock")
if int(current) > 0:
    redis.decr("stock")  # 동시 요청 시 재고 음수 가능!
```

**Lua 스크립트로 해결**
```lua
-- stock_decr.lua
local stock = redis.call('GET', KEYS[1])
if tonumber(stock) > 0 then
    redis.call('DECR', KEYS[1])
    return 1
else
    return 0
end
```

**실행**
```python
script = """
local stock = redis.call('GET', KEYS[1])
if tonumber(stock) > 0 then
    redis.call('DECR', KEYS[1])
    return 1
else
    return 0
end
"""

result = redis.eval(script, 1, "product:123:stock")
```

**특징**
- **원자적 실행**: 스크립트 전체가 하나의 명령처럼 실행
- **서버 사이드**: Redis 서버에서 실행 (네트워크 왕복 최소화)
- **블로킹**: 스크립트 실행 중 다른 명령 대기

**EVALSHA (최적화)**
```python
# 스크립트 해시로 저장
sha = redis.script_load(script)

# 해시로 실행 (네트워크 전송량 감소)
result = redis.evalsha(sha, 1, "product:123:stock")
```

**활용**
- **분산 락**: 락 획득/해제를 원자적으로
- **복잡한 비즈니스 로직**: 조건부 업데이트
- **Rate Limiting**: 요청 제한

**주의사항**
- 복잡한 스크립트는 Redis 블로킹 (간결하게)
- 디버깅 어려움
- 단순한 경우 MULTI/EXEC 사용

**실무**
재고 차감 로직을 Lua 스크립트로 구현하여 동시 주문 시에도 재고 음수 방지했습니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000016';

UPDATE questions SET explanation =
'**Redis vs Memcached**

둘 다 인메모리 캐시이지만 기능과 사용 사례가 다릅니다.

**Redis**
- **자료구조**: String, List, Set, Hash, Sorted Set 등 다양
- **영속성**: RDB, AOF 지원
- **복제**: Master-Slave, Sentinel
- **트랜잭션**: MULTI/EXEC
- **Lua 스크립팅**: 복잡한 로직 실행
- **Pub/Sub**: 메시징
- **메모리**: 단일 키 최대 512MB
- **스레드**: 싱글 스레드

**Memcached**
- **자료구조**: String만
- **영속성**: 없음 (순수 메모리)
- **복제**: 없음
- **트랜잭션**: 없음
- **스크립팅**: 없음
- **메모리**: 단일 키 최대 1MB
- **스레드**: 멀티스레드

**비교표**

| 구분 | Redis | Memcached |
|------|-------|-----------|
| 자료구조 | 다양 | String만 |
| 영속성 | O | X |
| 복제 | O | X |
| 성능 | 약간 느림 | 약간 빠름 |
| 기능 | 풍부 | 단순 |
| 사용 사례 | 범용 | 순수 캐시 |

**선택 가이드**
- **Redis**: 자료구조 필요, 영속성/복제 필요, 다양한 기능
- **Memcached**: 단순 캐시만, 최대 성능

**실무**
대부분의 경우 Redis를 선택합니다. Memcached는 순수 캐시 용도로만 사용되며, Redis의 풍부한 기능이 더 유용합니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000017';

UPDATE questions SET explanation =
'**Redis를 세션 저장소로 사용**

웹 애플리케이션의 세션 데이터를 Redis에 저장하는 방식입니다.

**장점**

**1. 서버 간 세션 공유**
```
기존 (메모리 세션):
User → Server 1 (세션 있음) ✓
User → Server 2 (세션 없음) ✗ → 재로그인

Redis 세션:
User → Server 1 → Redis (공유 세션)
User → Server 2 → Redis (동일 세션) ✓
```

**2. 빠른 조회**
- 메모리 기반으로 < 1ms 응답
- DB 세션보다 50-100배 빠름

**3. 자동 만료 (TTL)**
```redis
# 30분 후 자동 삭제
SETEX session:abc123 1800 "user_id=1000"
```

**4. 수평 확장**
- 서버 추가/제거 시 세션 유지
- 로드 밸런서에서 sticky session 불필요

**5. 장애 대응**
- 서버 재시작 시에도 세션 유지
- Replication으로 고가용성

**구현 예시**

**Spring Session**
```java
@EnableRedisHttpSession(maxInactiveIntervalInSeconds = 1800)
public class SessionConfig {
    // 세션이 자동으로 Redis에 저장됨
}
```

**Express (Node.js)**
```javascript
const session = require('express-session');
const RedisStore = require('connect-redis').default;

app.use(session({
  store: new RedisStore({ client: redisClient }),
  secret: 'secret',
  resave: false,
  saveUninitialized: false,
  cookie: { maxAge: 1800000 } // 30분
}));
```

**세션 데이터 구조**
```redis
# Hash 사용
HSET session:abc123 user_id 1000
HSET session:abc123 username "alice"
HSET session:abc123 role "admin"
EXPIRE session:abc123 1800
```

**주의사항**
- 네트워크 지연 (로컬 메모리보다 느림)
- Redis 장애 시 모든 세션 손실 (Replication 필수)
- 직렬화/역직렬화 오버헤드

**vs JWT**
- Redis 세션: 서버에서 제어 가능 (즉시 무효화)
- JWT: 클라이언트 저장, 만료 전 무효화 어려움

**실무**
멀티 서버 환경에서 Redis 세션을 도입하여 사용자가 어느 서버에 접속해도 로그인 상태를 유지하도록 했습니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000018';

UPDATE questions SET explanation =
'**Redis 보안**

**1. 비밀번호 인증 (AUTH)**

```ini
# redis.conf
requirepass myStrongPassword123!
```

```redis
# 클라이언트 접속 시
AUTH myStrongPassword123!
```

**2. ACL (Access Control List) - Redis 6.0+**

사용자별 권한 설정:
```redis
# 사용자 생성
ACL SETUSER alice on >password ~cache:* +get +set

# 권한:
# on: 활성화
# >password: 비밀번호
# ~cache:*: cache:로 시작하는 키만 접근
# +get +set: GET, SET 명령만 허용
```

**3. 네트워크 보안**

**바인드 주소 제한**
```ini
# redis.conf
bind 127.0.0.1 192.168.1.10  # 특정 IP만 접속
```

**방화벽**
```bash
# 특정 IP만 6379 포트 접근 허용
sudo ufw allow from 192.168.1.0/24 to any port 6379
```

**4. TLS/SSL 암호화 (Redis 6.0+)**

```ini
# redis.conf
tls-port 6380
tls-cert-file /path/to/redis.crt
tls-key-file /path/to/redis.key
tls-ca-cert-file /path/to/ca.crt
```

**5. 위험한 명령어 비활성화**

```ini
# redis.conf
rename-command FLUSHDB ""
rename-command FLUSHALL ""
rename-command CONFIG "CONFIG_abc123"  # 이름 변경
rename-command KEYS ""
```

**6. Protected Mode**

기본 활성화, 외부 접속 차단:
```ini
protected-mode yes  # 로컬만 접속 가능
```

**보안 체크리스트**
- ✅ requirepass 설정 (강력한 비밀번호)
- ✅ bind를 내부 IP로 제한
- ✅ 방화벽 설정 (VPC 내부만)
- ✅ ACL로 사용자별 권한 분리
- ✅ 위험 명령어 비활성화
- ✅ TLS 암호화 (민감 데이터)
- ✅ 정기적 보안 패치

**실무**
프로덕션 환경에서는 Redis를 VPC 내부 네트워크에만 노출하고, ACL로 애플리케이션별 사용자를 분리하여 보안을 강화했습니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000019';

UPDATE questions SET explanation =
'**메모리 사용량 최적화**

**1. maxmemory 설정**

```ini
# redis.conf
maxmemory 2gb
maxmemory-policy allkeys-lru  # 메모리 부족 시 LRU 제거
```

**2. 적절한 자료구조 선택**

**String vs Hash**
```redis
# 비효율: 개별 String (각 키마다 오버헤드)
SET user:1000:name "Alice"
SET user:1000:age "30"
SET user:1000:email "alice@example.com"

# 효율: Hash (하나의 키)
HSET user:1000 name "Alice" age 30 email "alice@example.com"
```

**3. 데이터 압축**

```python
import gzip

data = json.dumps(large_object)
compressed = gzip.compress(data.encode())
redis.set("key", compressed)  # 50-80% 메모리 절약
```

**4. TTL 설정**

```redis
# 불필요한 데이터 자동 삭제
SETEX cache:temp 60 "data"  # 60초 후 삭제
```

**5. 메모리 분석**

```redis
# 메모리 사용량 확인
INFO memory

# 큰 키 찾기
redis-cli --bigkeys

# 샘플링으로 메모리 분석
MEMORY USAGE key
```

**6. Eviction 정책 활용**

```ini
maxmemory-policy allkeys-lru  # 자동으로 오래된 키 제거
```

**7. 불필요한 데이터 제거**

```bash
# 만료된 키 즉시 삭제
redis-cli --scan --pattern "temp:*" | xargs redis-cli DEL
```

**메모리 절약 팁**
- Hash는 작은 객체에 효율적
- Bitmap은 불린 값에 효율적 (1bit per value)
- Sorted Set보다 List가 메모리 적음 (순서만 필요한 경우)
- 긴 키 이름 피하기: `user:1000:profile` → `u:1000:p`

**실무**
메모리 사용량이 80% 초과 시 알림을 설정하고, 주기적으로 bigkeys 분석으로 비효율적인 키를 찾아 최적화했습니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000020';

UPDATE questions SET explanation =
'**데이터 일관성 주의사항**

**1. 복제 지연 (Replication Lag)**

```
Master에 쓰기 → Slave 복제 (비동기)
└─ 수 밀리초~수 초 지연 가능
```

**문제**
```python
# Master에 쓰기
redis_master.set("user:1000", "Alice")

# 즉시 Slave에서 읽기
data = redis_slave.get("user:1000")  # None 또는 이전 값!
```

**해결**
- 중요한 읽기는 Master에서
- Eventual Consistency 허용 가능한 경우만 Slave

**2. 캐시-DB 불일치**

**문제 시나리오**
```python
# 1. 캐시에 저장
redis.set("user:1000", json.dumps(user))

# 2. DB 직접 업데이트 (캐시 모르게)
db.execute("UPDATE users SET name='Bob' WHERE id=1000")

# 3. 캐시에서 읽기
cached = redis.get("user:1000")  # 여전히 "Alice"
```

**해결: Cache Invalidation**
```python
def update_user(user_id, data):
    # 1. DB 업데이트
    db.execute("UPDATE users SET ... WHERE id=?", user_id)

    # 2. 캐시 삭제
    redis.delete(f"user:{user_id}")
```

**3. TTL 만료와 일관성**

**문제**
```python
# 긴 TTL: 오래된 데이터
redis.setex("price", 3600, "1000")  # 1시간
# 실제 가격 변경되어도 1시간 동안 이전 가격 제공

# 짧은 TTL: 캐시 히트율 낮음
redis.setex("price", 10, "1000")  # 10초
```

**해결**
- 변경 빈도에 따른 적절한 TTL
- 업데이트 시 캐시 무효화

**4. 원자성 보장 안 됨**

**문제**
```python
# 비원자적 업데이트
balance = int(redis.get("balance"))
balance += 100
redis.set("balance", balance)  # 동시 요청 시 손실!
```

**해결: Lua 스크립트 또는 WATCH**
```python
# Lua 스크립트
redis.eval("return redis.call('INCRBY', KEYS[1], ARGV[1])",
           1, "balance", 100)
```

**5. Cluster 환경의 멀티 키 연산**

```python
# Cluster에서 실패 (키가 다른 노드에 있을 수 있음)
redis.mget("user:1000", "user:2000")  # ERROR!

# 해결: Hash Tag로 같은 슬롯에 배치
redis.mget("user:{1000}", "product:{1000}")
```

**Best Practices**
- 중요 데이터: Master에서 읽기
- DB 업데이트 시 캐시 무효화
- 원자성 필요: Lua 스크립트
- 모니터링: Replication Lag 확인

**실무**
주문 완료 후 재고 캐시를 즉시 무효화하여 최신 재고 정보를 보장했습니다. Slave 복제 지연으로 인한 문제를 방지하기 위해 재고 조회는 Master에서만 수행했습니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000021';

UPDATE questions SET explanation =
'**싱글 스레드의 성능 영향**

**긍정적 영향**

**1. 경쟁 상태 없음**
- 멀티스레드의 락(Lock) 불필요
- 모든 연산이 원자적

**2. 예측 가능한 성능**
- 컨텍스트 스위칭 없음
- 일관된 응답 시간

**3. 단순한 구조**
- 버그 발생 확률 낮음
- 디버깅 용이

**부정적 영향**

**1. 느린 명령어가 전체 차단**

```redis
# 나쁜 예
KEYS *  # 100만 개 키 스캔 → 수 초 블로킹
        # 이 동안 모든 다른 요청 대기!

# 좋은 예
SCAN 0 COUNT 100  # 점진적 스캔
```

**2. CPU 집약적 작업에 취약**

```redis
# 큰 Set 비교
SDIFF set1 set2  # 각 100만 개 → 느림

# 큰 Sorted Set 범위 조회
ZRANGE leaderboard 0 1000000  # 블로킹
```

**3. 단일 코어만 사용**
- 멀티코어 CPU 활용 못 함
- 해결: 여러 Redis 인스턴스 실행 (포트 분리)

**최적화 방법**

**1. 빠른 명령어 사용**
```redis
# 피할 것: O(N)
KEYS pattern
SMEMBERS large_set
LRANGE list 0 -1

# 권장: O(1) 또는 점진적
SCAN 0
SISMEMBER set member
LRANGE list 0 99
```

**2. 파이프라이닝**
```python
# 100번 왕복 → 1번 왕복
pipe = redis.pipeline()
for i in range(100):
    pipe.get(f"key:{i}")
pipe.execute()
```

**3. Lua 스크립트**
- 여러 명령을 하나로 결합

**4. 큰 값 분할**
```python
# 10MB 값 → 10개 1MB 값
for i in range(10):
    redis.set(f"data:part{i}", chunk[i])
```

**모니터링**

```redis
# 느린 명령 로깅
CONFIG SET slowlog-log-slower-than 10000  # 10ms 이상

# 느린 명령 조회
SLOWLOG GET 10
```

**실무**
KEYS 명령을 SCAN으로 변경하고, 큰 데이터는 분할 저장하여 싱글 스레드로 인한 블로킹을 최소화했습니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000022';

UPDATE questions SET explanation =
'**Redis 트랜잭션 (MULTI/EXEC)**

여러 명령을 원자적으로 실행하는 기능입니다.

**기본 사용**
```redis
MULTI               # 트랜잭션 시작
SET key1 "value1"   # 큐에 추가
SET key2 "value2"   # 큐에 추가
INCR counter        # 큐에 추가
EXEC                # 원자적 실행
```

**특징**

**1. 원자성 (Atomicity)**
- 모든 명령이 순차적으로 실행
- 중간에 다른 클라이언트의 명령 끼어들지 않음

**2. 격리성 (Isolation)**
- EXEC 전까지 명령 실행 안 됨 (큐에만 추가)
- 다른 클라이언트는 트랜잭션 내용 모름

**3. 롤백 없음**
```redis
MULTI
SET key "value"
INCR string_key  # 문자열에 INCR → 에러
EXEC

# 결과: 일부는 실행됨 (부분 실패 가능!)
```

**WATCH (낙관적 락)**

```redis
WATCH balance  # 감시 시작

# balance 읽기
GET balance  # 1000

# 다른 클라이언트가 balance 변경하면 EXEC 실패
MULTI
SET balance 900
EXEC  # balance가 변경되었으면 (nil) 반환
```

**DISCARD**
```redis
MULTI
SET key1 "value1"
SET key2 "value2"
DISCARD  # 트랜잭션 취소 (큐 비움)
```

**vs 전통적 DB 트랜잭션**

| 구분 | Redis | RDBMS |
|------|-------|-------|
| 원자성 | 순차 실행 | 완전 원자성 |
| 롤백 | 없음 | 있음 |
| 격리 수준 | Read Uncommitted | 다양 |
| 복잡도 | 단순 | 복잡 |

**실무 활용**

**계좌 이체**
```python
while True:
    redis.watch("account:A", "account:B")

    balance_a = int(redis.get("account:A"))
    balance_b = int(redis.get("account:B"))

    if balance_a < 100:
        redis.unwatch()
        return "Insufficient funds"

    pipe = redis.pipeline()
    pipe.decrby("account:A", 100)
    pipe.incrby("account:B", 100)

    try:
        pipe.execute()
        break  # 성공
    except WatchError:
        continue  # 재시도
```

**주의사항**
- 롤백 없음 (Lua 스크립트 고려)
- WATCH는 충돌 많으면 비효율적
- 간단한 경우만 사용 (복잡하면 Lua)

**실무**
장바구니 동시 수정을 WATCH/MULTI/EXEC로 처리하여 재고 일관성을 보장했습니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000023';

UPDATE questions SET explanation =
'**DISCARD**

MULTI 이후 큐에 쌓인 명령을 취소하는 명령입니다.

**사용**
```redis
MULTI
SET key1 "value1"
SET key2 "value2"
DISCARD  # 트랜잭션 취소
# key1, key2 설정 안 됨
```

**동작**
- MULTI부터 DISCARD까지 쌓인 명령 큐를 비움
- 실행되지 않음
- 트랜잭션 모드 종료

**vs EXEC**
```redis
# EXEC: 명령 실행
MULTI
SET key "value"
EXEC  # 실행됨

# DISCARD: 명령 취소
MULTI
SET key "value"
DISCARD  # 실행 안 됨
```

**활용**

**조건부 취소**
```python
redis.multi()
redis.set("key1", "value1")
redis.set("key2", "value2")

# 조건 확인
if not validate_condition():
    redis.discard()  # 취소
else:
    redis.execute()  # 실행
```

**WATCH 충돌 처리**
```python
redis.watch("balance")
balance = int(redis.get("balance"))

if balance < 100:
    redis.unwatch()  # WATCH 해제
    # 또는
    redis.multi()
    redis.discard()  # 트랜잭션 취소
```

**실무**
검증 실패 시 DISCARD로 트랜잭션을 안전하게 취소하여 부분 실행을 방지했습니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000024';

UPDATE questions SET explanation =
'**Atomic 연산**

Redis의 모든 명령은 원자적으로 실행되어 중간 상태가 노출되지 않습니다.

**주요 Atomic 명령**

**1. INCR/DECR (증감)**
```redis
SET counter 0
INCR counter  # 1 (읽기-증가-쓰기가 원자적)
INCRBY counter 10  # 11
DECR counter  # 10
```

**멀티스레드 환경에서의 안전성**
```python
# 잘못된 방법 (비원자적)
counter = int(redis.get("counter"))
counter += 1
redis.set("counter", counter)
# 동시 요청 시 값 손실!

# 올바른 방법 (원자적)
redis.incr("counter")  # 항상 안전
```

**2. SETNX (Set if Not eXists)**
```redis
SETNX lock:resource "1"  # 키가 없을 때만 설정
# 분산 락 구현에 사용
```

**3. GETSET**
```redis
GETSET key "new_value"  # 이전 값 반환 + 새 값 설정 (원자적)
```

**4. List 양끝 연산**
```redis
LPUSH queue "task1"  # 왼쪽 추가
RPOP queue           # 오른쪽 제거
# 큐 구현에 안전
```

**5. HINCRBY (Hash 필드 증가)**
```redis
HINCRBY user:1000 views 1  # views 필드 +1
```

**실무 활용**

**1. 조회수 카운터**
```python
# 동시 접속자 수백 명이 조회해도 정확
redis.incr(f"post:{post_id}:views")
```

**2. 재고 관리**
```python
# 주문 시 재고 차감
remaining = redis.decr("product:123:stock")
if remaining < 0:
    redis.incr("product:123:stock")  # 롤백
    return "Out of stock"
```

**3. 분산 락**
```python
# 락 획득 (원자적)
if redis.set("lock:resource", "1", nx=True, ex=10):
    # 크리티컬 섹션
    process()
    redis.delete("lock:resource")
```

**4. Rate Limiting**
```redis
# 1분에 100회 제한
current = INCR rate:user:1000
IF current = 1:
    EXPIRE rate:user:1000 60
IF current > 100:
    REJECT
```

**싱글 스레드의 이점**
- 모든 명령이 순차 실행
- 락 없이 원자성 보장
- 경쟁 상태(Race Condition) 없음

**실무**
좋아요 버튼 중복 클릭 방지를 INCR로 구현하여 동시 요청에도 정확한 카운트를 유지했습니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000025';

UPDATE questions SET explanation =
'**Persistence 비교 (RDB vs AOF)**

**RDB (Redis Database)**
- **방식**: 특정 시점 스냅샷
- **파일**: 바이너리 (dump.rdb)
- **복구**: 빠름 (파일 로드)
- **성능**: 주기적 fork (낮은 부하)
- **데이터 손실**: 마지막 스냅샷 이후 (분 단위)
- **파일 크기**: 작음 (압축)

**AOF (Append-Only File)**
- **방식**: 모든 쓰기 명령 로그
- **파일**: 텍스트 (appendonly.aof)
- **복구**: 느림 (명령 재실행)
- **성능**: 디스크 I/O (중간 부하)
- **데이터 손실**: 최대 1초 (everysec)
- **파일 크기**: 큼 (Rewrite로 축소)

**선택 가이드**

**RDB 적합**
- 빠른 복구 필요
- 데이터 손실 일부 허용 (수 분)
- 백업 중요

**AOF 적합**
- 데이터 안전성 최우선
- 느린 복구 허용
- 감사 로그 필요

**혼합 모드 (권장)**
```ini
save 900 1          # RDB
appendonly yes      # AOF
appendfsync everysec
aof-use-rdb-preamble yes  # 빠른 복구 + 안전성
```

**실무**
대부분 RDB + AOF 혼합을 사용하여 빠른 복구와 데이터 안전성을 모두 확보합니다. 순수 캐시는 Persistence 비활성화합니다.'
WHERE id = 'b0000000-0000-0000-0011-000000000026';
