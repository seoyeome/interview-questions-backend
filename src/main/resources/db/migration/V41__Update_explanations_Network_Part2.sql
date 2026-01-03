-- Network 면접 질문 답변 추가 (Part 2: 15-26)

UPDATE questions SET explanation =
'**로드 밸런서 (Load Balancer)란?**
- 여러 서버에 **트래픽을 분산**시켜 부하를 균등하게 배분하는 장치/소프트웨어입니다
- 고가용성(High Availability)과 확장성(Scalability)을 제공합니다

**목적**
1. **부하 분산**: 한 서버에 트래픽 집중 방지
2. **가용성 향상**: 서버 장애 시 자동으로 다른 서버로 전환
3. **확장성**: 서버 추가로 처리 능력 증가
4. **성능 최적화**: 응답 시간 단축

**동작 방식**
```
클라이언트
    ↓
[로드 밸런서]
    ├─→ 서버 1 (80%)
    ├─→ 서버 2 (10%)
    └─→ 서버 3 (10%)
```

**분산 알고리즘 (Scheduling Algorithm)**

**1. Round Robin (라운드 로빈)**
- 순차적으로 돌아가며 요청 분배
- 서버 1 → 서버 2 → 서버 3 → 서버 1 ...
- **장점**: 간단, 공평
- **단점**: 서버 성능 차이 무시

**2. Least Connections (최소 연결)**
- 현재 연결 수가 가장 적은 서버에 할당
- **장점**: 실제 부하 반영
- **단점**: 연결 추적 오버헤드

**3. Weighted Round Robin (가중 라운드 로빈)**
- 서버 성능에 따라 가중치 부여
- 고성능 서버에 더 많은 요청 할당
- 예: 서버1(50%), 서버2(30%), 서버3(20%)

**4. IP Hash**
- 클라이언트 IP를 해시하여 항상 같은 서버로 연결
- **장점**: 세션 유지 (Sticky Session)
- **단점**: 특정 IP 대역에서 트래픽 몰리면 불균형

**5. Least Response Time (최소 응답 시간)**
- 응답 속도가 가장 빠른 서버에 할당
- **장점**: 성능 최적화
- **단점**: 측정 오버헤드

**로드 밸런서 계층별 분류**

**L4 로드 밸런서 (Transport Layer)**
- **기준**: IP 주소, 포트 번호
- **프로토콜**: TCP, UDP
- **특징**:
  - 빠름 (패킷 헤더만 확인)
  - 내용(Payload) 확인 불가
  - 간단한 분산
- **예시**: AWS NLB (Network Load Balancer), HAProxy

**L7 로드 밸런서 (Application Layer)**
- **기준**: HTTP 헤더, URL, 쿠키, 세션 등
- **프로토콜**: HTTP, HTTPS, FTP
- **특징**:
  - 느림 (패킷 내용까지 확인)
  - 세밀한 분산 가능
  - URL 기반 라우팅, SSL 오프로딩
- **예시**: AWS ALB (Application Load Balancer), Nginx, Apache

**L4 vs L7 비교**

| 항목          | L4                    | L7                          |
|---------------|-----------------------|-----------------------------|
| 계층          | 전송 계층             | 응용 계층                   |
| 기준          | IP, 포트              | URL, 헤더, 쿠키             |
| 속도          | 빠름                  | 느림                        |
| 유연성        | 낮음                  | 높음                        |
| 비용          | 저렴                  | 비싸                        |
| 사용 예시     | TCP/UDP 부하 분산     | HTTP 기반 라우팅            |

**Health Check (헬스 체크)**
- 서버 상태를 주기적으로 확인
```
로드 밸런서가 매 5초마다:
GET /health → 서버 1 (200 OK, 정상)
GET /health → 서버 2 (500 Error, 장애)
GET /health → 서버 3 (Timeout, 다운)

결과:
→ 서버 1에만 트래픽 전달
→ 서버 2, 3은 자동으로 제외
```

**세션 관리**

**문제**: 로드 밸런서로 인해 요청마다 다른 서버 접속
```
로그인 → 서버 1 (세션 생성)
장바구니 → 서버 2 (세션 없음, 로그인 풀림!)
```

**해결책**
1. **Sticky Session (Session Affinity)**
   - 같은 클라이언트는 항상 같은 서버로
   - 방법: 쿠키, IP 해시
   - 단점: 부하 불균형 가능

2. **Session Clustering**
   - 서버 간 세션 공유
   - 모든 서버가 동일한 세션 데이터 보유

3. **외부 세션 저장소**
   - Redis, Memcached에 세션 저장
   - 모든 서버가 공통 저장소 사용 (권장)

**실무 예시**

**AWS 환경**
```
클라이언트
    ↓
ALB (L7) - URL 기반 라우팅
    ├─→ /api/* → API 서버 그룹
    └─→ /static/* → 정적 파일 서버

NLB (L4) - TCP 부하 분산
    ├─→ DB 서버 1
    └─→ DB 서버 2
```

**Nginx 설정 예시**
```nginx
upstream backend {
    least_conn;  # 최소 연결 알고리즘
    server 192.168.1.10:8080 weight=3;
    server 192.168.1.11:8080 weight=1;
    server 192.168.1.12:8080 backup;  # 백업 서버
}

server {
    listen 80;
    location / {
        proxy_pass http://backend;
    }
}
```

**고급 기능**
1. **SSL Termination**: 로드 밸런서에서 SSL 복호화, 서버는 HTTP
2. **Geo-Routing**: 지역별 서버 분산
3. **Rate Limiting**: 요청 수 제한
4. **WAF (Web Application Firewall)**: 보안 필터링

**장점**
- ✅ 고가용성 (단일 장애점 제거)
- ✅ 확장성 (서버 추가로 성능 향상)
- ✅ 유지보수 용이 (무중단 배포)

**단점**
- ⚠️ 단일 장애점이 될 수 있음 (로드 밸런서 자체)
  - 해결: 로드 밸런서 이중화
- ⚠️ 비용 증가
- ⚠️ 복잡도 증가'
WHERE id = 'b0000000-0000-0000-0018-000000000015';

UPDATE questions SET explanation =
'**대칭 키 암호화 (Symmetric Key Encryption)**
- **같은 키**로 암호화와 복호화를 모두 수행

**특징**
- 하나의 키(비밀 키)만 사용
- 송신자와 수신자가 **동일한 키를 공유**해야 함

**장점**
- ✅ **빠름**: 알고리즘이 단순, 대용량 데이터 처리에 유리
- ✅ **효율적**: CPU 부하 낮음

**단점**
- ⚠️ **키 분배 문제**: 안전하게 키를 전달하기 어려움
- ⚠️ **키 관리**: N명이 통신하려면 N(N-1)/2개의 키 필요

**대표 알고리즘**
- **AES (Advanced Encryption Standard)**: 현재 표준, 매우 안전
  - AES-128, AES-192, AES-256
- **DES (Data Encryption Standard)**: 구식, 취약
- **3DES (Triple DES)**: DES 3회 적용, 느림
- **ChaCha20**: 빠르고 안전, 모바일에 유리

**비대칭 키 암호화 (Asymmetric Key Encryption)**
- **공개 키**와 **개인 키** 2개의 키 쌍 사용
- 공개 키로 암호화 → 개인 키로만 복호화 가능

**특징**
- 공개 키: 누구에게나 공개 가능
- 개인 키: 절대 비밀, 소유자만 보유

**장점**
- ✅ **키 분배 문제 해결**: 공개 키는 안전하게 전달 가능
- ✅ **확장성**: N명이 통신해도 각자 키 쌍 1개만 필요
- ✅ **디지털 서명 가능**: 신원 확인

**단점**
- ⚠️ **느림**: 수백~수천 배 느림
- ⚠️ **CPU 부하**: 복잡한 수학 연산

**대표 알고리즘**
- **RSA**: 가장 널리 사용, 키 길이 2048~4096비트
- **ECC (Elliptic Curve Cryptography)**: 짧은 키로 높은 보안
- **Diffie-Hellman**: 키 교환 프로토콜

**비교 표**

| 항목              | 대칭 키                | 비대칭 키                  |
|-------------------|------------------------|----------------------------|
| 키 개수           | 1개 (비밀 키)          | 2개 (공개 키 + 개인 키)    |
| 속도              | 매우 빠름              | 느림 (100~1000배 차이)     |
| 키 길이           | 짧음 (128~256비트)     | 길음 (2048~4096비트)       |
| 키 분배           | 어려움 (안전한 채널 필요) | 쉬움 (공개 키는 공개 가능) |
| 대용량 데이터     | 적합                   | 부적합                     |
| 디지털 서명       | 불가능                 | 가능                       |
| 사용 예시         | 파일 암호화, 디스크 암호화 | SSL/TLS, 이메일 암호화    |
| 알고리즘          | AES, ChaCha20          | RSA, ECC                   |

**실무 사용: 하이브리드 암호화**
- **비대칭 키**로 **대칭 키**를 안전하게 전달
- 실제 데이터는 **대칭 키**로 암호화 (빠름)

**HTTPS (SSL/TLS) 예시**
```
1. 핸드셰이크 (비대칭 키):
   클라이언트 ← 서버의 공개 키 (인증서)
   클라이언트 → 세션 키(대칭 키)를 서버 공개 키로 암호화하여 전송
   서버 → 개인 키로 복호화하여 세션 키 획득

2. 데이터 전송 (대칭 키):
   클라이언트 ↔ 서버
   모두 세션 키(AES)로 빠르게 암호화/복호화
```

**암호화 과정**

**대칭 키**
```
평문: "Hello"
키: "secret123"

암호화: encrypt("Hello", "secret123") → "8x9a@#$"
복호화: decrypt("8x9a@#$", "secret123") → "Hello"
```

**비대칭 키**
```
평문: "Hello"
공개 키: public_key
개인 키: private_key

암호화: encrypt("Hello", public_key) → "x7f&@#"
복호화: decrypt("x7f&@#", private_key) → "Hello"

반대도 가능 (디지털 서명):
서명: sign("Hello", private_key) → "signature"
검증: verify("Hello", "signature", public_key) → true
```

**실무 선택 기준**

**대칭 키 사용**
- 대용량 파일 암호화
- 디스크/데이터베이스 암호화
- 같은 시스템 내 데이터 보호
- 빠른 속도가 중요

**비대칭 키 사용**
- 키 교환
- 디지털 서명 (신원 확인)
- 이메일 암호화 (PGP)
- SSL/TLS 핸드셰이크

**하이브리드 사용 (HTTPS, SSH 등)**
- 처음에 비대칭 키로 세션 키 교환
- 이후 대칭 키로 고속 통신

**보안 강도**
- AES-256: 매우 안전 (양자 컴퓨터 이전까지)
- RSA-2048: 안전
- RSA-4096: 매우 안전 (하지만 느림)
- ECC-256: RSA-3072와 동등, 더 빠름'
WHERE id = 'b0000000-0000-0000-0018-000000000016';

UPDATE questions SET explanation =
'**SSL/TLS란?**
- **SSL (Secure Sockets Layer)**: 넷스케이프가 개발한 암호화 프로토콜 (구식)
- **TLS (Transport Layer Security)**: SSL의 후속 버전, 현재 표준
  - TLS 1.0 (1999) → TLS 1.1 → TLS 1.2 (2008) → **TLS 1.3 (2018, 현재 권장)**
- 실무에서는 SSL과 TLS를 혼용해서 부르지만, 실제로는 **TLS**를 사용

**목적**
1. **기밀성 (Confidentiality)**: 데이터 암호화
2. **무결성 (Integrity)**: 데이터 변조 방지
3. **인증 (Authentication)**: 서버 신원 확인

**TLS 핸드셰이크 과정 (TLS 1.2 기준)**

**1. Client Hello**
```
클라이언트 → 서버
- 지원하는 TLS 버전 (TLS 1.2, TLS 1.3)
- 지원하는 암호화 알고리즘 목록 (Cipher Suite)
  예: TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
- 랜덤 데이터 (Client Random)
```

**2. Server Hello**
```
서버 → 클라이언트
- 선택한 TLS 버전
- 선택한 암호화 알고리즘
- 랜덤 데이터 (Server Random)
```

**3. Certificate (인증서)**
```
서버 → 클라이언트
- 서버의 SSL/TLS 인증서 전송
  - 서버 공개 키 포함
  - CA(인증 기관)의 서명
  - 도메인 정보
```

**4. Server Key Exchange (선택적)**
```
서버 → 클라이언트
- Diffie-Hellman 같은 키 교환 알고리즘 사용 시
- 키 교환에 필요한 파라미터 전송
```

**5. Server Hello Done**
```
서버 → 클라이언트
"핸드셰이크 서버 측 완료"
```

**6. Client Key Exchange**
```
클라이언트:
1. 서버 인증서 검증 (CA 서명 확인, 도메인 일치 확인)
2. Pre-Master Secret 생성 (랜덤 값)
3. 서버 공개 키로 Pre-Master Secret 암호화

클라이언트 → 서버
- 암호화된 Pre-Master Secret 전송
```

**7. 세션 키 생성 (양쪽 모두)**
```
클라이언트와 서버 각자:
- Client Random + Server Random + Pre-Master Secret
→ Master Secret 생성
→ 세션 키(대칭 키) 생성
```

**8. Change Cipher Spec**
```
클라이언트 → 서버
"이제부터 암호화 통신 시작합니다"

서버 → 클라이언트
"OK, 준비됐습니다"
```

**9. Finished**
```
클라이언트 ↔ 서버
- 핸드셰이크 메시지의 해시값을 세션 키로 암호화하여 전송
- 상대방이 복호화하여 무결성 검증
```

**10. 암호화 통신 시작**
```
이후 모든 데이터는 세션 키(AES)로 암호화되어 전송
```

**시각화**
```
Client                          Server
  │                               │
  │─────① Client Hello────────→  │
  │                               │
  │←────② Server Hello────────── │
  │←────③ Certificate────────────│
  │←────④ Server Key Exchange────│ (선택)
  │←────⑤ Server Hello Done─────│
  │                               │
  │─────⑥ Client Key Exchange───→│
  │─────⑦ Change Cipher Spec────→│
  │─────⑧ Finished──────────────→│
  │                               │
  │←────⑨ Change Cipher Spec─────│
  │←────⑩ Finished───────────────│
  │                               │
  │══════ 암호화 통신 ═══════════│
```

**TLS 1.3 개선 사항**
- **더 빠름**: 핸드셰이크가 1-RTT(왕복)로 단축 (1.2는 2-RTT)
- **더 안전함**: 취약한 암호화 알고리즘 제거
- **0-RTT 재개**: 이전 세션을 빠르게 재개 가능

**인증서 (Certificate)**
- **CA (Certificate Authority)**: 인증서 발급 기관
  - Let''s Encrypt (무료), DigiCert, GlobalSign 등
- **인증서 체인**: Root CA → Intermediate CA → 서버 인증서
- **검증 항목**:
  1. CA 서명 유효성
  2. 도메인 이름 일치
  3. 유효 기간
  4. 인증서 폐기 여부 (CRL, OCSP)

**Cipher Suite 구성**
```
TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
│    │     │        │          │
│    │     │        │          └─ HMAC 알고리즘 (메시지 인증)
│    │     │        └─ 암호화 알고리즘 + 모드
│    │     └─ 서버 인증 알고리즘
│    └─ 키 교환 알고리즘
└─ 프로토콜

ECDHE: Elliptic Curve Diffie-Hellman Ephemeral (완전 순방향 비밀성)
RSA: 서버 인증
AES_128_GCM: 대칭 키 암호화 (AES 128비트, GCM 모드)
SHA256: 해시 함수
```

**완전 순방향 비밀성 (Perfect Forward Secrecy, PFS)**
- 세션마다 새로운 키 생성
- 과거 세션 키가 노출되어도 다른 세션은 안전
- ECDHE, DHE 사용 시 지원

**SSL/TLS vs HTTPS**
- **SSL/TLS**: 프로토콜 (암호화 방법)
- **HTTPS**: HTTP + SSL/TLS (응용)

**실무 확인**
```bash
# 서버 인증서 확인
openssl s_client -connect google.com:443

# TLS 버전 확인
curl -I https://google.com --tlsv1.3
```

**보안 설정 권장 사항**
- ✅ TLS 1.3 사용 (TLS 1.2 최소)
- ✅ 강력한 Cipher Suite 선택
- ✅ HSTS (HTTP Strict Transport Security) 활성화
- ✅ 인증서 유효 기간 관리
- ❌ TLS 1.0, TLS 1.1 비활성화 (취약)
- ❌ SSL 2.0, SSL 3.0 절대 사용 금지

**성능 최적화**
- Session Resumption (세션 재사용)
- OCSP Stapling (인증서 폐기 확인 최적화)
- HTTP/2, HTTP/3 사용 (TLS 1.3 필수)'
WHERE id = 'b0000000-0000-0000-0018-000000000017';

UPDATE questions SET explanation =
'**Wi-Fi (Wireless Fidelity)**
- **기술**: 무선 LAN (WLAN), IEEE 802.11 표준
- **매체**: 전파 (2.4GHz, 5GHz, 6GHz)
- **범위**: 수십 m (실내), 수백 m (실외)

**장점**
- ✅ **이동성**: 케이블 없이 자유롭게 이동
- ✅ **설치 간편**: 공사 불필요, 빠른 구축
- ✅ **확장 용이**: 기기 추가가 쉬움
- ✅ **비용 절감**: 배선 공사 비용 없음

**단점**
- ⚠️ **속도 불안정**: 거리, 장애물, 간섭에 영향
- ⚠️ **보안 취약**: 무선 신호 도청 가능 (WPA3 필요)
- ⚠️ **간섭**: 다른 기기, 전자레인지, Bluetooth
- ⚠️ **대역폭 공유**: 같은 AP 사용 시 속도 분산
- ⚠️ **거리 제한**: 멀어질수록 속도 감소

**Wi-Fi 표준 (802.11)**
| 표준       | 출시  | 최대 속도  | 주파수          | 비고                |
|-----------|-------|-----------|----------------|---------------------|
| 802.11b   | 1999  | 11 Mbps   | 2.4 GHz        | 구식                |
| 802.11g   | 2003  | 54 Mbps   | 2.4 GHz        | 널리 사용됨         |
| 802.11n   | 2009  | 600 Mbps  | 2.4/5 GHz      | Wi-Fi 4             |
| 802.11ac  | 2014  | 6.9 Gbps  | 5 GHz          | Wi-Fi 5 (현재 주류) |
| 802.11ax  | 2019  | 9.6 Gbps  | 2.4/5/6 GHz    | **Wi-Fi 6/6E** (최신) |

**Ethernet (이더넷)**
- **기술**: 유선 LAN, IEEE 802.3 표준
- **매체**: 케이블 (UTP, 광섬유)
- **범위**: 케이블 길이 제한 (100m for Cat6)

**장점**
- ✅ **안정적**: 간섭 없음, 일정한 속도
- ✅ **빠름**: 1Gbps ~ 100Gbps
- ✅ **보안**: 물리적 접근 필요
- ✅ **지연 낮음**: 게임, 실시간 스트리밍에 유리
- ✅ **신뢰성**: 패킷 손실 거의 없음

**단점**
- ⚠️ **이동성 제한**: 케이블에 묶임
- ⚠️ **설치 복잡**: 배선 공사 필요
- ⚠️ **확장 어려움**: 케이블 추가 작업
- ⚠️ **비용**: 케이블, 포트 비용

**Ethernet 표준**
| 표준           | 속도      | 케이블 종류   | 최대 거리 |
|---------------|-----------|--------------|----------|
| Fast Ethernet | 100 Mbps  | Cat 5        | 100m     |
| Gigabit       | 1 Gbps    | Cat 5e, Cat 6 | 100m     |
| 10 Gigabit    | 10 Gbps   | Cat 6a, Cat 7 | 100m     |
| 40/100 Gigabit| 40-100 Gbps | 광섬유      | 수 km    |

**비교 표**

| 항목          | Wi-Fi                  | Ethernet               |
|---------------|------------------------|------------------------|
| 매체          | 무선 (전파)            | 유선 (케이블)          |
| 속도          | 최대 9.6 Gbps (Wi-Fi 6) | 최대 100 Gbps          |
| 실제 속도     | 불안정 (환경 영향)     | 안정적                 |
| 지연 (Latency)| 높음 (5~50ms)          | 낮음 (< 1ms)           |
| 이동성        | 우수                   | 제한적                 |
| 보안          | 취약 (암호화 필요)     | 우수 (물리적 접근)     |
| 설치          | 간편                   | 복잡 (배선)            |
| 비용          | 저렴                   | 중간~고가              |
| 간섭          | 있음                   | 없음                   |
| 범위          | 제한적 (수십 m)        | 케이블 길이만큼        |
| 사용 예시     | 스마트폰, 노트북       | 데스크톱, 서버         |

**실무 선택 기준**

**Wi-Fi 사용**
- 스마트폰, 태블릿, 노트북
- 이동이 필요한 기기
- 임시 네트워크
- 배선이 어려운 환경
- 게스트 네트워크

**Ethernet 사용**
- 데스크톱 PC
- 서버, NAS
- 게임 (FPS, 실시간 대전)
- 4K/8K 스트리밍
- 중요한 업무용 기기
- 대용량 파일 전송

**하이브리드 전략**
```
[공유기]
  ├─ Ethernet → 데스크톱 (안정성)
  ├─ Ethernet → NAS (고속 전송)
  ├─ Wi-Fi → 스마트폰 (이동성)
  └─ Wi-Fi → 노트북 (편의성)
```

**Wi-Fi 보안**
- **WEP**: 매우 취약, 절대 사용 금지
- **WPA**: 취약
- **WPA2**: 안전 (최소 기준)
- **WPA3**: 매우 안전 (최신, 권장)

**Wi-Fi 주파수 대역**
- **2.4 GHz**:
  - 장점: 범위 넓음, 장애물 통과 우수
  - 단점: 느림, 간섭 많음 (Bluetooth, 전자레인지)
- **5 GHz**:
  - 장점: 빠름, 간섭 적음
  - 단점: 범위 좁음, 장애물 취약
- **6 GHz (Wi-Fi 6E)**:
  - 장점: 매우 빠름, 간섭 거의 없음
  - 단점: 범위 매우 좁음, 신규 기기만 지원

**성능 최적화**

**Wi-Fi**
- 5 GHz 대역 사용
- 채널 최적화 (중복 채널 회피)
- AP 위치 최적화 (중앙, 높은 곳)
- Mesh Wi-Fi (넓은 공간)

**Ethernet**
- Cat 6 이상 케이블 사용
- Gigabit 스위치 사용
- 케이블 품질 확인 (불량 케이블 교체)'
WHERE id = 'b0000000-0000-0000-0018-000000000018';

UPDATE questions SET explanation =
'**ICMP (Internet Control Message Protocol)**
- **계층**: OSI 네트워크 계층 (Layer 3), IP 프로토콜의 일부
- **목적**: **네트워크 진단 및 오류 보고**
- **특징**: 데이터 전송이 아닌 제어/관리 메시지

**주요 역할**
1. **오류 보고**: 패킷 전달 실패 알림
2. **네트워크 진단**: 연결 상태 확인 (ping)
3. **경로 추적**: 패킷이 거치는 라우터 확인 (traceroute)

**ICMP 메시지 유형**

**1. Echo Request / Echo Reply (Type 8 / Type 0)**
- **용도**: ping 명령어
- **동작**:
  ```
  클라이언트 → 서버: Echo Request (살아있니?)
  서버 → 클라이언트: Echo Reply (응, 살아있어!)
  ```
- **사용 예시**:
  ```bash
  ping google.com
  PING google.com (142.250.196.46): 56 data bytes
  64 bytes from 142.250.196.46: icmp_seq=0 ttl=117 time=10.5 ms
  ```

**2. Destination Unreachable (Type 3)**
- **용도**: 목적지에 도달할 수 없음을 알림
- **세부 코드**:
  - Code 0: Network Unreachable (네트워크 도달 불가)
  - Code 1: Host Unreachable (호스트 도달 불가)
  - Code 2: Protocol Unreachable (프로토콜 지원 안 됨)
  - Code 3: Port Unreachable (포트 닫혀있음)
  - Code 4: Fragmentation Needed (패킷 분할 필요하지만 DF 플래그)

**3. Time Exceeded (Type 11)**
- **용도**: TTL(Time To Live)이 0이 되어 패킷 폐기됨
- **사용**: traceroute 명령어의 핵심
- **동작**:
  ```
  패킷 TTL=1 → 첫 번째 라우터에서 TTL=0 → ICMP Time Exceeded 응답
  패킷 TTL=2 → 두 번째 라우터에서 TTL=0 → ICMP Time Exceeded 응답
  ...
  ```

**4. Redirect (Type 5)**
- **용도**: 더 나은 경로 알림
- **동작**: 라우터가 "이 목적지는 저쪽 라우터로 가는 게 더 빠름" 알림

**5. Timestamp Request / Reply (Type 13 / Type 14)**
- **용도**: 시간 동기화 (거의 사용 안 함, NTP 사용)

**사용 사례**

**1. ping - 네트워크 연결 확인**
```bash
ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8): 56 data bytes
64 bytes from 8.8.8.8: icmp_seq=0 ttl=117 time=10 ms
64 bytes from 8.8.8.8: icmp_seq=1 ttl=117 time=11 ms

# 옵션
ping -c 4 google.com       # 4번만 전송 (Linux)
ping -n 4 google.com       # 4번만 전송 (Windows)
ping -i 2 google.com       # 2초 간격
```

**활용**:
- 서버 살아있는지 확인
- 네트워크 지연 측정
- 패킷 손실률 확인

**2. traceroute (Linux/Mac) / tracert (Windows)**
```bash
traceroute google.com
 1  192.168.0.1 (192.168.0.1)  1.234 ms  # 공유기
 2  10.1.1.1 (10.1.1.1)  5.678 ms        # ISP 첫 홉
 3  172.16.5.1 (172.16.5.1)  12.345 ms   # ISP 내부
 4  142.250.196.46 (142.250.196.46)  20 ms  # 목적지
```

**활용**:
- 네트워크 경로 추적
- 어느 구간에서 지연 발생하는지 파악
- 라우팅 문제 진단

**3. Path MTU Discovery**
- 경로상 최대 전송 단위(MTU) 크기 발견
- DF(Don''t Fragment) 플래그 + ICMP Type 3 Code 4 활용

**ICMP 보안 이슈**

**1. Ping Flood (DDoS 공격)**
- 대량의 ICMP Echo Request 전송
- 서버 리소스 고갈
- **방어**: Rate Limiting, 방화벽에서 ICMP 제한

**2. Ping of Death**
- 비정상적으로 큰 ICMP 패킷 전송
- 버퍼 오버플로우 유발 (구식 공격, 현대 OS는 방어)

**3. Smurf Attack**
- 출발지 IP를 피해자로 위조한 ICMP Echo Request를 브로드캐스트
- 모든 기기가 피해자에게 Echo Reply 전송
- **방어**: 브로드캐스트 주소로의 ICMP 차단

**4. ICMP Redirect 공격**
- 악의적인 ICMP Redirect로 트래픽 경로 변조
- **방어**: ICMP Redirect 무시 설정

**실무 설정**

**ICMP 허용 (권장)**
```
장점:
- 네트워크 진단 가능
- 문제 해결 용이

주의:
- Rate Limiting 설정
- 중요 서버는 외부 ICMP 차단 고려
```

**ICMP 차단 (보안 중시)**
```
단점:
- ping, traceroute 불가
- 네트워크 문제 진단 어려움

적용 대상:
- 공격 표면 최소화가 중요한 서버
- DMZ 내부 서버
```

**방화벽 설정 예시**
```bash
# Linux iptables
# ICMP Echo Request 허용 (ping 허용)
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# ICMP Echo Request 차단 (ping 차단)
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# Rate Limiting (초당 1개로 제한)
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
```

**ICMP vs TCP/UDP**
- **ICMP**: 제어/진단, 신뢰성 없음
- **TCP**: 데이터 전송, 신뢰성 있음
- **UDP**: 데이터 전송, 신뢰성 없음

**정리**
- ICMP는 **네트워크 진단의 핵심**
- ping, traceroute의 기반 프로토콜
- 보안과 진단의 균형이 중요
- 적절한 Rate Limiting으로 공격 방어'
WHERE id = 'b0000000-0000-0000-0018-000000000019';

UPDATE questions SET explanation =
'**QoS (Quality of Service)란?**
- 네트워크에서 **특정 트래픽에 우선순위**를 부여하여 **성능을 보장**하는 기술
- 목적: 중요한 트래픽(음성, 영상)의 품질을 유지

**왜 필요한가?**
- 네트워크 대역폭은 **유한**함
- 모든 트래픽을 동등하게 처리하면 중요한 서비스가 지연될 수 있음
```
예시: 회의 중 화상 통화가 끊김 (동시에 대용량 파일 다운로드 중)
→ QoS로 화상 통화에 우선순위 부여
```

**QoS 핵심 개념**

**1. 대역폭 (Bandwidth)**
- 일정 시간 동안 전송 가능한 데이터양
- 단위: bps, Mbps, Gbps

**2. 지연 (Latency/Delay)**
- 데이터가 출발지에서 목적지까지 가는 시간
- 실시간 서비스(VoIP, 게임)에 중요
- 목표: < 150ms (VoIP 기준)

**3. 지터 (Jitter)**
- 지연 시간의 **변동폭**
- 예: 패킷 1은 10ms, 패킷 2는 50ms → 지터 40ms
- 실시간 통신에서 치명적
- 목표: < 30ms

**4. 패킷 손실 (Packet Loss)**
- 전송 중 손실되는 패킷 비율
- 목표: < 1% (VoIP), < 0.1% (영상)

**QoS 구현 기술**

**1. 분류 (Classification)**
- 트래픽을 **종류별로 식별**
- 기준:
  - IP 주소 (출발지/목적지)
  - 포트 번호 (HTTP:80, HTTPS:443, VoIP:5060)
  - 프로토콜 (TCP, UDP, ICMP)
  - DSCP (Differentiated Services Code Point)

**2. 마킹 (Marking)**
- 패킷에 **우선순위 태그** 부여
- **ToS (Type of Service)** 필드 사용 (IP 헤더)
- **DSCP 값**:
  - EF (Expedited Forwarding): 최고 우선순위 (VoIP)
  - AF (Assured Forwarding): 보장된 전달
  - BE (Best Effort): 최선형 (일반 인터넷)

**3. 대기열 관리 (Queuing)**
- 우선순위에 따라 **대기열**에 배치
- **알고리즘**:
  - **FIFO (First In First Out)**: 기본, 우선순위 없음
  - **PQ (Priority Queuing)**: 높은 우선순위 먼저 전송
  - **WFQ (Weighted Fair Queuing)**: 가중치 기반 공평 분배
  - **CBWFQ (Class-Based WFQ)**: 클래스별 대역폭 보장

**4. 대역폭 제어**
- **폴리싱 (Policing)**: 초과 트래픽 **폐기**
  - 예: 최대 10Mbps 제한, 초과 시 버림
- **셰이핑 (Shaping)**: 초과 트래픽 **지연** (버퍼에 저장)
  - 예: 최대 10Mbps, 초과 시 큐에 대기

**5. 혼잡 회피 (Congestion Avoidance)**
- **RED (Random Early Detection)**: 혼잡 전에 미리 일부 패킷 폐기
- 네트워크 혼잡을 미리 방지

**QoS 우선순위 예시**

| 우선순위 | 트래픽 종류         | 특성                  | DSCP  |
|----------|---------------------|-----------------------|-------|
| 1 (최고) | 음성 (VoIP)         | 지연 민감, 작은 대역폭 | EF    |
| 2        | 영상 회의           | 지연 민감, 큰 대역폭   | AF41  |
| 3        | 중요 업무 데이터    | 손실 민감             | AF31  |
| 4        | 일반 웹 브라우징    | 최선형                | BE    |
| 5 (최하) | 파일 다운로드       | 지연 허용             | BE    |

**실무 시나리오**

**예시 1: 기업 네트워크**
```
100 Mbps 회선:
- VoIP: 10 Mbps 보장 (최고 우선순위)
- 영상 회의: 30 Mbps 보장
- 업무 애플리케이션: 40 Mbps 보장
- 인터넷 서핑: 나머지 (Best Effort)
```

**예시 2: ISP (통신사)**
```
고객 대역폭 제한:
- 기본 요금제: 100 Mbps (Policing)
- 프리미엄 요금제: 500 Mbps + 낮은 지연 보장
```

**라우터/스위치 설정 예시 (Cisco)**
```
# 클래스 정의
class-map match-any VOIP
  match protocol rtp audio  # VoIP 트래픽

class-map match-any VIDEO
  match protocol rtp video  # 영상 트래픽

# 정책 정의
policy-map QOS_POLICY
  class VOIP
    priority percent 20      # 대역폭의 20% 우선 보장
  class VIDEO
    bandwidth percent 40     # 대역폭의 40% 보장
  class class-default
    fair-queue              # 나머지는 공평 분배
```

**QoS 프로토콜**

**1. DiffServ (Differentiated Services)**
- **확장성**: 대규모 네트워크에 적합
- **방식**: 패킷 헤더에 DSCP 마킹
- **현대 표준**

**2. IntServ (Integrated Services)**
- **방식**: 경로 예약 (RSVP)
- **단점**: 확장성 낮음
- **사용**: 거의 안 씀

**QoS 측정**

**1. Latency 측정**
```bash
ping -c 100 server.com
# Average round-trip time 확인
```

**2. Jitter 측정**
```bash
# VoIP 품질 측정 도구
iperf3 -u -c server -b 1M -t 60
```

**3. 패킷 손실 측정**
```bash
ping -c 1000 server.com
# packet loss 비율 확인
```

**QoS 없을 때 vs 있을 때**

**QoS 없음**
```
대용량 다운로드 시작
→ 모든 대역폭 사용
→ 화상 회의 끊김 (지연↑, 지터↑, 손실↑)
```

**QoS 적용**
```
대용량 다운로드 시작
→ QoS가 화상 회의에 우선순위 부여
→ 다운로드는 느려지지만, 회의는 안정적
```

**가정용 공유기 QoS**
- WMM (Wi-Fi Multimedia): Wi-Fi용 QoS
- 게임, 스트리밍 우선순위 설정 가능

**클라우드/CDN QoS**
- AWS: Transit Gateway, Global Accelerator
- Cloudflare: Argo Smart Routing (지연 최소화)

**결론**
- QoS는 **제한된 네트워크 자원을 효율적으로 분배**
- 실시간 서비스에 필수
- 네트워크 장비(라우터, 스위치)에서 설정'
WHERE id = 'b0000000-0000-0000-0018-000000000020';

UPDATE questions SET explanation =
'**전송 방식 비교**

**Unicast (유니캐스트)**
- **정의**: 1:1 통신
- **방식**: 특정 **하나의 수신자**에게만 전송

**특징**
- 가장 일반적인 통신 방식
- 송신자와 수신자 1:1 매핑
- 각 수신자마다 별도의 데이터 스트림

**예시**
```
웹 브라우징: 클라이언트 ↔ 서버
이메일: 송신자 → 특정 수신자
파일 다운로드: 사용자 ← 서버
```

**주소**
- 특정 IP 주소 (예: 192.168.1.10)

**장점**
- ✅ 대역폭 효율적 (필요한 만큼만 사용)
- ✅ 보안 (특정 수신자만)

**단점**
- ⚠️ N명에게 보내려면 N번 전송 (비효율)

**Broadcast (브로드캐스트)**
- **정의**: 1:전체 통신
- **방식**: 같은 네트워크의 **모든 기기**에게 전송

**특징**
- 로컬 네트워크(LAN) 내에서만 동작
- 라우터를 넘어가지 않음
- 모든 기기가 수신 후 자신의 패킷인지 확인

**예시**
```
ARP 요청: "192.168.1.10의 MAC 주소가 누구예요?" (전체에게 물어봄)
DHCP 요청: "IP 주소 주세요!" (DHCP 서버를 찾기 위해 전체에게)
NetBIOS: Windows 네트워크 탐색
```

**주소**
- IPv4 브로드캐스트 주소: `255.255.255.255` (전체)
- 네트워크별 브로드캐스트: `192.168.1.255` (192.168.1.0/24 네트워크)

**장점**
- ✅ 빠른 전파 (한 번에 모두에게)

**단점**
- ⚠️ 네트워크 부하 증가 (모든 기기가 처리)
- ⚠️ 보안 취약 (누구나 받음)
- ⚠️ 브로드캐스트 스톰 가능

**IPv6에서는?**
- 브로드캐스트 **없음**
- 대신 멀티캐스트로 대체

**Multicast (멀티캐스트)**
- **정의**: 1:다수 통신
- **방식**: **특정 그룹**의 수신자에게만 전송

**특징**
- 관심 있는 수신자만 **그룹에 가입**
- 송신자는 1번만 전송, 네트워크가 복제하여 전달
- 라우터 지원 필요

**예시**
```
IPTV: 방송사 → 시청자 그룹
영상 회의: 발표자 → 참여자 그룹
주식 시세: 거래소 → 구독자 그룹
온라인 게임: 서버 → 플레이어 그룹
```

**주소**
- **IPv4**: 224.0.0.0 ~ 239.255.255.255 (Class D)
  - 224.0.0.1: 모든 호스트
  - 224.0.0.2: 모든 라우터
  - 239.0.0.0/8: 조직 내부용
- **IPv6**: ff00::/8

**그룹 관리 프로토콜**
- **IGMP (Internet Group Management Protocol)**: IPv4
- **MLD (Multicast Listener Discovery)**: IPv6

**장점**
- ✅ **대역폭 효율**: 1번 전송으로 N명에게 전달
- ✅ **서버 부하 감소**: 송신자는 1개 스트림만 생성
- ✅ **확장성**: 수신자 증가해도 송신자 부담 동일

**단점**
- ⚠️ 라우터/스위치 지원 필요
- ⚠️ 설정 복잡
- ⚠️ 인터넷 전체에서는 제한적 (ISP 지원 필요)

**비교 표**

| 항목          | Unicast           | Broadcast         | Multicast         |
|---------------|-------------------|-------------------|-------------------|
| 수신자        | 1명               | 전체              | 특정 그룹         |
| 대역폭        | N명 → N배         | 1번 전송          | 1번 전송          |
| 범위          | 제한 없음         | LAN만             | 라우터 지원 시 확장 |
| 주소 (IPv4)   | 특정 IP           | 255.255.255.255   | 224.0.0.0/4       |
| 효율성        | 낮음 (다수 전송)  | 중간              | 높음              |
| 사용 예시     | 웹, 이메일        | ARP, DHCP         | IPTV, 스트리밍    |

**시각화**

**Unicast**
```
송신자 ───→ 수신자 1
송신자 ───→ 수신자 2
송신자 ───→ 수신자 3
(3번 전송)
```

**Broadcast**
```
송신자 ───→ [ 스위치 ] ───┬→ 기기 1
                         ├→ 기기 2
                         ├→ 기기 3
                         └→ 기기 4 (모두 받음)
(1번 전송, 모두에게 전달)
```

**Multicast**
```
송신자 ───→ [ 라우터 ] ───┬→ 그룹 멤버 1
                         ├→ 그룹 멤버 2
                         └→ 그룹 멤버 3
         (비멤버는 받지 않음)
(1번 전송, 그룹에게만 전달)
```

**실무 시나리오**

**스트리밍 서비스 (1만 명 시청)**

**Unicast 사용 시**
```
서버 부하: 10,000개 스트림 생성
대역폭: 10 Mbps × 10,000 = 100 Gbps
→ 서버 폭발!
```

**Multicast 사용 시**
```
서버 부하: 1개 스트림만 생성
대역폭: 10 Mbps × 1 = 10 Mbps
→ 네트워크가 복제하여 전달
```

**Multicast 그룹 가입**
```
1. 클라이언트: "224.5.5.5 그룹에 가입하고 싶어요"
2. IGMP Join 메시지 전송
3. 라우터: 해당 그룹 트래픽을 이 포트로도 전송
4. 스트림 수신 시작
```

**Anycast (애니캐스트)**
- **정의**: 1:최근접 통신
- **방식**: 여러 서버가 **같은 IP**를 공유, 가장 가까운 서버가 응답
- **사용**: DNS (1.1.1.1은 전 세계 여러 곳에 서버)
- **장점**: 부하 분산, 지연 감소

**정리**
- **Unicast**: 일반 통신 (웹, 이메일)
- **Broadcast**: 네트워크 전체 알림 (ARP, DHCP)
- **Multicast**: 효율적인 그룹 통신 (스트리밍)
- **Anycast**: 가장 가까운 서버로 (DNS, CDN)'
WHERE id = 'b0000000-0000-0000-0018-000000000021';

UPDATE questions SET explanation =
'**VPN (Virtual Private Network)**
- **정의**: 공용 네트워크(인터넷)를 통해 **가상의 사설 네트워크**를 구성하는 기술
- **목적**: 안전한 원격 접속, 프라이버시 보호

**핵심 개념**
- 인터넷을 마치 **전용선처럼** 사용
- 데이터를 **암호화**하여 전송
- **터널링**: 암호화된 연결 통로 생성

**VPN의 주요 기능**

**1. 암호화 (Encryption)**
- 데이터를 암호화하여 도청 방지
- 일반적으로 AES-256 사용

**2. 인증 (Authentication)**
- 사용자 신원 확인
- 방법: 비밀번호, 인증서, 2FA

**3. 터널링 (Tunneling)**
- 공용 네트워크 위에 가상의 사설 연결 구축
- 패킷을 캡슐화하여 전송

**4. 무결성 (Integrity)**
- 데이터 변조 방지
- HMAC, SHA-256 등 사용

**VPN 동작 방식**
```
[사용자 PC] ←─암호화 터널─→ [VPN 서버] ←──→ [인터넷/내부망]
   (집)                        (회사)          (회사 내부)

1. VPN 클라이언트가 VPN 서버에 연결
2. 인증 (사용자명/비밀번호 또는 인증서)
3. 암호화된 터널 생성
4. 모든 트래픽이 터널을 통해 전송
5. VPN 서버에서 복호화하여 목적지로 전달
```

**VPN 사용 사례**

**1. 원격 근무 (Remote Access VPN)**
- **시나리오**: 집에서 회사 내부망 접속
- **방식**: 개인 PC → VPN 서버 → 회사 내부
```
재택근무자 → 인터넷 → 회사 VPN 게이트웨이 → 회사 내부 서버
(집)                    (회사 방화벽)           (사내망)
```
- **프로토콜**: OpenVPN, WireGuard, IKEv2
- **예시**: 회사 내부 시스템, 파일 서버 접근

**2. 사이트 간 연결 (Site-to-Site VPN)**
- **시나리오**: 본사-지사 간 사설망 연결
- **방식**: 본사 라우터 ↔ 지사 라우터 (VPN 터널)
```
본사 LAN ─ 본사 VPN 라우터 ←─ 인터넷 ─→ 지사 VPN 라우터 ─ 지사 LAN
```
- **장점**: 전용선보다 저렴
- **단점**: 인터넷 품질에 의존

**3. 프라이버시 보호 (Consumer VPN)**
- **시나리오**: 개인 사용자가 익명성 유지
- **방식**: 사용자 → VPN 서버 (타국) → 웹사이트
```
사용자 → VPN(미국 서버) → 웹사이트
→ 웹사이트는 미국 IP로 인식
```
- **용도**:
  - IP 주소 숨기기
  - 지역 제한 콘텐츠 우회 (Netflix 등)
  - 공공 Wi-Fi에서 보안 강화
  - 검열 우회
- **서비스**: NordVPN, ExpressVPN, ProtonVPN

**4. 보안 강화 (공공 Wi-Fi)**
- **시나리오**: 카페, 공항 Wi-Fi 사용 시
- **위험**: 중간자 공격, 패킷 스니핑
- **해결**: VPN으로 모든 트래픽 암호화

**VPN 프로토콜**

**1. OpenVPN**
- **특징**: 오픈소스, 안전, 유연
- **포트**: UDP 1194 (기본)
- **장점**: 방화벽 우회 쉬움
- **단점**: 속도 중간

**2. WireGuard**
- **특징**: 최신, 매우 빠름, 간결한 코드
- **암호화**: ChaCha20, Curve25519
- **장점**: 빠르고 안전
- **단점**: 비교적 신기술

**3. IPsec (Internet Protocol Security)**
- **특징**: IP 계층 암호화
- **모드**: IKEv2/IPsec
- **장점**: 네이티브 지원 (Windows, iOS)
- **사용**: Site-to-Site VPN

**4. PPTP (Point-to-Point Tunneling Protocol)**
- **특징**: 구식, 빠름
- **보안**: ❌ 취약 (절대 사용 금지)

**5. L2TP/IPsec**
- **특징**: L2TP + IPsec 조합
- **장점**: 안정적
- **단점**: 느림, 방화벽 차단 가능

**프로토콜 비교**

| 프로토콜      | 속도  | 보안  | 호환성 | 권장      |
|--------------|-------|-------|--------|-----------|
| WireGuard    | ⭐⭐⭐ | ⭐⭐⭐ | 중간   | ✅ 최고   |
| OpenVPN      | ⭐⭐   | ⭐⭐⭐ | 우수   | ✅ 권장   |
| IPsec/IKEv2  | ⭐⭐   | ⭐⭐⭐ | 우수   | ✅ 권장   |
| L2TP/IPsec   | ⭐     | ⭐⭐   | 우수   | △ 차선   |
| PPTP         | ⭐⭐⭐ | ❌     | 우수   | ❌ 금지   |

**VPN vs Proxy**

| 항목          | VPN                       | Proxy                    |
|---------------|---------------------------|--------------------------|
| 암호화        | ✅ 전체 트래픽             | ❌ 없음 (일부 예외)       |
| 범위          | 모든 앱/프로그램          | 브라우저/특정 앱만       |
| 속도          | 느림 (암호화 오버헤드)    | 빠름                     |
| 보안          | 높음                      | 낮음                     |
| 용도          | 보안, 원격 접속           | 간단한 IP 변경           |

**VPN 장단점**

**장점**
- ✅ 데이터 암호화 (보안)
- ✅ IP 주소 숨기기 (프라이버시)
- ✅ 원격 접속 (재택 근무)
- ✅ 지역 제한 우회
- ✅ 공공 Wi-Fi 보안

**단점**
- ⚠️ 속도 저하 (암호화 오버헤드)
- ⚠️ VPN 서버 신뢰 필요 (모든 트래픽이 VPN 서버 경유)
- ⚠️ 일부 웹사이트에서 차단 (Netflix, 게임 등)
- ⚠️ 로그 정책 확인 필요 (프라이버시)

**기업용 VPN 설정 예시**
```
# OpenVPN 서버 설정
port 1194
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh2048.pem
server 10.8.0.0 255.255.255.0  # VPN 내부 IP 대역
push "route 192.168.1.0 255.255.255.0"  # 회사 내부망 라우팅
```

**개인용 VPN 선택 기준**
1. **No-log 정책**: 로그를 저장하지 않는가?
2. **속도**: 빠른가?
3. **서버 위치**: 필요한 국가에 서버가 있는가?
4. **프로토콜**: WireGuard, OpenVPN 지원?
5. **가격**: 합리적인가?

**주의사항**
- 무료 VPN은 **로그 수집, 광고 주입** 위험
- VPN 사용 = 익명성 보장 ❌ (VPN 업체는 알 수 있음)
- 불법 행위는 VPN으로도 추적 가능

**결론**
- **기업**: 원격 근무, 사이트 간 연결에 필수
- **개인**: 공공 Wi-Fi, 프라이버시 보호에 유용
- **프로토콜**: WireGuard 또는 OpenVPN 권장'
WHERE id = 'b0000000-0000-0000-0018-000000000022';

UPDATE questions SET explanation =
'**TCP 헤더 구조**
```
0                   1                   2                   3
0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|          Source Port          |       Destination Port        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                        Sequence Number                        |  ← 중요!
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                    Acknowledgment Number                      |  ← 중요!
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  Data |           |U|A|P|R|S|F|                               |
| Offset| Reserved  |R|C|S|S|Y|I|            Window             |
|       |           |G|K|H|T|N|N|                               |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

**시퀀스 번호 (Sequence Number)**
- **크기**: 32비트
- **역할**: 송신한 **데이터의 순서 번호**
- **의미**: "내가 지금 보내는 데이터는 X번째 바이트부터 시작이야"

**특징**
1. **바이트 단위**: 패킷 단위가 아닌 **바이트 단위** 번호
2. **초기값**: 랜덤 (ISN, Initial Sequence Number)
   - 보안상 예측 불가능한 값 사용
3. **순환**: 2^32 = 4,294,967,296 이후 0으로 돌아옴

**확인 응답 번호 (Acknowledgment Number, ACK Number)**
- **크기**: 32비트
- **역할**: **다음에 받고 싶은** 바이트 번호
- **의미**: "X번째 바이트까지 잘 받았으니, 다음엔 X+1번째 보내줘"

**동작 원리**

**예시: 파일 전송**
```
클라이언트가 "HELLO"(5바이트) 전송

[클라이언트 → 서버]
Seq=100
데이터: "HELLO" (5바이트)
→ 서버가 받을 데이터는 100~104 바이트

[서버 → 클라이언트]
ACK=105  (다음엔 105번부터 보내줘)
→ "100~104까지 잘 받았어"

[클라이언트 → 서버]
Seq=105
데이터: "WORLD" (5바이트)
→ 105~109 바이트

[서버 → 클라이언트]
ACK=110
→ "105~109까지 잘 받았어"
```

**3-way Handshake에서의 동작**
```
[1단계: SYN]
Client → Server
SYN flag=1
Seq=1000 (ISN, 랜덤 초기값)
ACK=-     (아직 없음)

[2단계: SYN-ACK]
Server → Client
SYN flag=1, ACK flag=1
Seq=2000 (서버의 ISN)
ACK=1001 (클라이언트의 다음 seq 기대)

[3단계: ACK]
Client → Server
ACK flag=1
Seq=1001
ACK=2001 (서버의 다음 seq 기대)
```

**데이터 전송 시나리오**

**정상 전송**
```
Client                          Server
  │                               │
  │──① Seq=100, 데이터(100바이트)→│
  │                               │
  │←─② ACK=200 (잘 받았어!)──────│
  │                               │
  │──③ Seq=200, 데이터(50바이트)─→│
  │                               │
  │←─④ ACK=250 ──────────────────│
```

**패킷 손실 시**
```
Client                          Server
  │                               │
  │──① Seq=100, 데이터(100바이트)→│
  │                               │
  │──② Seq=200, 데이터(50바이트)─→│ (손실!)
  │                               │
  │←─③ ACK=200 (다시 200부터!)───│
  │                               │
  │──④ Seq=200, 재전송───────────→│
  │                               │
  │←─⑤ ACK=250 ──────────────────│
```

**순서 뒤바뀐 경우**
```
Client → Server
Seq=100 (100바이트)
Seq=200 (50바이트)

서버 수신 순서:
1. Seq=200 도착 (버퍼에 임시 저장, ACK 안 보냄)
2. Seq=100 도착 → 순서 맞춰서 애플리케이션에 전달
   → ACK=250 전송 (100~249까지 모두 받음)
```

**중복 ACK (Duplicate ACK)**
```
패킷 손실 감지 메커니즘:

Server → Client
ACK=200
ACK=200 (중복)
ACK=200 (중복)
ACK=200 (중복, 3번째!)

→ Fast Retransmit: Seq=200 패킷 즉시 재전송
(타임아웃 기다리지 않고)
```

**Selective Acknowledgment (SACK)**
- 확장 기능 (TCP 옵션)
- 어떤 부분을 받았는지 상세히 알림
```
일반 ACK:
ACK=200 (200부터 다시 보내줘)

SACK:
ACK=200, SACK=300-400, SACK=500-600
→ "200~299는 못 받았고, 300~400, 500~600은 받았어"
→ 송신자는 200~299만 재전송
```

**Window Size (흐름 제어)**
- ACK와 함께 전송
- "내 버퍼에 X 바이트 공간 남았어"
```
ACK=1000, Window=5000
→ "1000번부터 받을 준비됐고, 최대 5000바이트까지 한 번에 보내도 돼"
```

**실제 패킷 예시 (Wireshark)**
```
Transmission Control Protocol
    Source Port: 49152
    Destination Port: 80
    Sequence Number: 1000 (상대적)
    Acknowledgment Number: 5000
    Flags: 0x018 (PSH, ACK)
        ACK flag: Set
    Window Size: 65535
```

**시퀀스/ACK 번호 계산**
```
송신:
Seq = 이전 Seq + 이전 데이터 크기

수신 후 ACK:
ACK = 받은 Seq + 받은 데이터 크기

예시:
보낸 데이터: Seq=1000, 크기=100
→ 다음 Seq=1100

받은 데이터: Seq=1000, 크기=100
→ 보낼 ACK=1100
```

**보안: TCP 시퀀스 예측 공격**
- **구식 취약점**: Seq를 예측하여 위조 패킷 주입
- **방어**: 랜덤 ISN 사용 (RFC 6528)

**성능 튜닝**
- **Window Scaling**: Window Size를 2^14배 확장 (고속 네트워크)
- **Timestamps**: RTT 정확히 측정

**정리**
- **Seq**: 내가 보낸 데이터의 바이트 위치
- **ACK**: 상대방이 다음에 보내줬으면 하는 바이트 위치
- **역할**: 순서 보장, 재전송 제어, 흐름 제어
- TCP의 신뢰성의 핵심'
WHERE id = 'b0000000-0000-0000-0018-000000000023';

UPDATE questions SET explanation =
'**TCP 혼잡 제어 (Congestion Control)**
- **목적**: 네트워크 혼잡을 감지하고 **전송 속도를 조절**하여 혼잡 붕괴 방지
- **핵심**: **CWND (Congestion Window)** 크기를 동적으로 조정

**핵심 개념**

**1. CWND (Congestion Window)**
- 혼잡 윈도우: 한 번에 보낼 수 있는 최대 데이터 양
- 송신자가 자체적으로 관리

**2. RWND (Receiver Window)**
- 수신 윈도우: 수신자 버퍼 크기
- 수신자가 ACK로 알림

**실제 윈도우 = min(CWND, RWND)**

**3. SSThresh (Slow Start Threshold)**
- 느린 시작과 혼잡 회피를 구분하는 임계값

**혼잡 감지 방법**
1. **타임아웃**: 패킷 손실 (심각한 혼잡)
2. **중복 ACK 3개**: 패킷 손실 (경미한 혼잡)

**TCP Tahoe (1988)**

**4가지 단계**

**1. Slow Start (느린 시작)**
```
초기: CWND = 1 MSS (Maximum Segment Size)
매 ACK마다: CWND × 2 (지수적 증가)

CWND: 1 → 2 → 4 → 8 → 16 → 32 ...
(매우 빠르게 증가, "느린"이 아님!)

종료 조건: CWND >= SSThresh
→ Congestion Avoidance로 전환
```

**2. Congestion Avoidance (혼잡 회피)**
```
매 RTT마다: CWND += 1 MSS (선형 증가)

CWND: 32 → 33 → 34 → 35 ...
(천천히 증가)

종료 조건: 패킷 손실 감지
```

**3. 패킷 손실 감지 시 (타임아웃 or 중복 ACK)**
```
SSThresh = CWND / 2  (현재의 절반으로 설정)
CWND = 1 MSS         (초기화)
→ Slow Start로 돌아감
```

**시각화 (Tahoe)**
```
CWND
  │
64│         ╱╲
  │        ╱  ╲
32│      ╱│    ╲
  │    ╱  │     ╲___/│
16│  ╱    │          ╲
  │╱      │           ╲
 1└───────┼────────────┼─→ 시간
      SSThresh       패킷손실
      (처음=32)      (CWND=1로 초기화)
```

**TCP Reno (1990)**

**Tahoe와의 차이: Fast Recovery 추가**

**Fast Retransmit (빠른 재전송)**
- 중복 ACK 3개 수신 시 즉시 재전송 (타임아웃 기다리지 않음)

**Fast Recovery (빠른 회복)**
```
중복 ACK 3개 감지 시:
1. SSThresh = CWND / 2
2. CWND = SSThresh + 3 MSS  ← Tahoe와 다름! (1이 아님)
3. Congestion Avoidance 진입

→ Slow Start로 돌아가지 않음
```

**타임아웃 발생 시**
```
SSThresh = CWND / 2
CWND = 1 MSS
→ Slow Start로 (Tahoe와 동일)
```

**시각화 (Reno)**
```
CWND
  │
64│         ╱╲    ╱╲
  │        ╱  ╲  ╱  ╲
32│      ╱│    ╲╱│   ╲
  │    ╱  │      │    ╲___
16│  ╱    │      │
  │╱      │      │
 1└───────┼──────┼─────────→ 시간
      타임아웃  중복ACK
      (CWND=1)  (CWND=절반)
```

**Tahoe vs Reno 비교**

| 항목              | Tahoe               | Reno                      |
|-------------------|---------------------|---------------------------|
| 출시              | 1988                | 1990                      |
| Slow Start        | O                   | O                         |
| Congestion Avoid  | O                   | O                         |
| Fast Retransmit   | X                   | O (중복 ACK 3개)          |
| Fast Recovery     | X                   | O                         |
| 패킷 손실 대응    | 항상 CWND=1         | 중복 ACK: CWND=절반       |
|                   |                     | 타임아웃: CWND=1          |
| 성능              | 느림                | 빠름 (회복 빠름)          |

**동작 차이 예시**

**시나리오: 패킷 1개 손실**

**Tahoe**
```
1. CWND=64에서 패킷 손실
2. SSThresh=32, CWND=1로 초기화
3. Slow Start: 1→2→4→8→16→32
4. Congestion Avoidance: 32→33→34...
→ 회복에 오래 걸림
```

**Reno**
```
1. CWND=64에서 중복 ACK 3개
2. SSThresh=32, CWND=32+3=35
3. Congestion Avoidance: 35→36→37...
→ 빠르게 회복
```

**현대 알고리즘 (참고)**

**TCP NewReno (1999)**
- Reno 개선: 여러 패킷 손실 처리 향상

**TCP CUBIC (2008)**
- Linux 기본값 (현재 가장 널리 사용)
- CWND를 3차 함수로 증가

**TCP BBR (2016)**
- Google 개발
- 병목 대역폭 + RTT 기반
- 패킷 손실을 혼잡 신호로 보지 않음

**실무 확인**
```bash
# Linux에서 현재 혼잡 제어 알고리즘 확인
sysctl net.ipv4.tcp_congestion_control

# 변경
sudo sysctl -w net.ipv4.tcp_congestion_control=cubic
```

**성능 비교**
```
고속 네트워크 (1 Gbps+):
Tahoe < Reno < CUBIC < BBR

패킷 손실 많은 환경:
Tahoe (매우 느림) < Reno (느림) < CUBIC (좋음) < BBR (최고)
```

**정리**
- **Tahoe**: 패킷 손실 시 항상 CWND=1로 초기화 (보수적)
- **Reno**: Fast Recovery로 빠른 회복 (중복 ACK 시 절반으로만 감소)
- **핵심 차이**: 중복 ACK 3개 감지 시
  - Tahoe: CWND=1 (Slow Start)
  - Reno: CWND=절반 (Fast Recovery)
- **결과**: Reno가 Tahoe보다 **훨씬 빠르게 회복**'
WHERE id = 'b0000000-0000-0000-0018-000000000024';

UPDATE questions SET explanation =
'**SSH (Secure Shell)**
- **정의**: 네트워크를 통해 다른 컴퓨터에 **안전하게 원격 접속**하는 프로토콜
- **포트**: **22** (기본)
- **계층**: OSI 응용 계층 (Layer 7)

**주요 특징**
1. **암호화**: 모든 데이터(명령, 비밀번호, 파일) 암호화
2. **인증**: 비밀번호 또는 공개키 인증
3. **무결성**: 데이터 변조 방지
4. **압축**: 데이터 압축으로 전송 효율 향상

**SSH vs Telnet**

| 항목      | SSH                  | Telnet              |
|-----------|----------------------|---------------------|
| 암호화    | ✅ 전체 암호화        | ❌ 평문 전송         |
| 보안      | 높음                 | 매우 낮음           |
| 포트      | 22                   | 23                  |
| 사용      | 현대 표준            | 구식 (사용 금지)    |

**주요 용도**

**1. 원격 서버 관리 (가장 일반적)**
```bash
# 서버 접속
ssh user@server.com

# 특정 포트 지정
ssh -p 2222 user@server.com

# 명령 실행 후 종료
ssh user@server.com ''ls -la''
```

**사용 예시**:
- 클라우드 서버 관리 (AWS EC2, GCP VM)
- 리눅스 서버 설정, 로그 확인
- 애플리케이션 배포, 재시작

**2. 파일 전송 (SCP, SFTP)**

**SCP (Secure Copy)**
```bash
# 로컬 → 서버
scp file.txt user@server:/path/to/destination

# 서버 → 로컬
scp user@server:/path/to/file.txt ./

# 디렉토리 전체 복사
scp -r folder/ user@server:/path/
```

**SFTP (SSH File Transfer Protocol)**
```bash
sftp user@server
sftp> get remote_file.txt    # 다운로드
sftp> put local_file.txt     # 업로드
sftp> ls                      # 파일 목록
sftp> exit
```

**3. 터널링 (포트 포워딩)**

**로컬 포트 포워딩**
```bash
ssh -L 8080:localhost:80 user@server

# 의미:
로컬 8080 포트 → 서버의 80 포트로 포워딩

# 사용 예시:
브라우저에서 localhost:8080 접속
→ 서버의 80 포트로 전달 (암호화된 터널)
```

**원격 포트 포워딩**
```bash
ssh -R 9090:localhost:3000 user@server

# 의미:
서버의 9090 포트 → 로컬의 3000 포트로 포워딩

# 사용 예시:
서버에서 localhost:9090 접속
→ 내 로컬 PC의 3000 포트로 전달
```

**동적 포트 포워딩 (SOCKS 프록시)**
```bash
ssh -D 1080 user@server

# SOCKS 프록시 서버 생성
브라우저 프록시 설정: localhost:1080
→ 모든 트래픽이 서버를 통해 전송
```

**4. Git 사용 (GitHub, GitLab)**
```bash
# SSH 키로 GitHub 접속
git clone git@github.com:user/repo.git

# HTTPS보다 안전하고 편리 (비밀번호 입력 불필요)
```

**5. X11 포워딩 (GUI 애플리케이션)**
```bash
ssh -X user@server

# 서버의 GUI 애플리케이션을 로컬에서 실행
server$ firefox  # 로컬 화면에 Firefox 실행
```

**인증 방식**

**1. 비밀번호 인증**
```bash
ssh user@server
Password: *******

# 간편하지만 보안 약함
```

**2. 공개키 인증 (권장)**

**키 생성**
```bash
# RSA 키 생성 (4096비트)
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# ED25519 키 생성 (최신, 더 안전)
ssh-keygen -t ed25519 -C "your_email@example.com"

# 생성 위치:
~/.ssh/id_rsa (개인키, 절대 공유 금지!)
~/.ssh/id_rsa.pub (공개키, 서버에 등록)
```

**공개키 서버에 등록**
```bash
# 방법 1: ssh-copy-id (자동)
ssh-copy-id user@server

# 방법 2: 수동
cat ~/.ssh/id_rsa.pub | ssh user@server "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

**접속**
```bash
ssh user@server
# 비밀번호 입력 없이 바로 접속!
```

**SSH 설정 파일**

**클라이언트 설정 (~/.ssh/config)**
```
Host myserver
    HostName server.example.com
    User admin
    Port 2222
    IdentityFile ~/.ssh/id_rsa

# 사용:
ssh myserver  # 간단하게 접속
```

**서버 설정 (/etc/ssh/sshd_config)**
```
Port 22                         # 포트 변경 권장 (예: 2222)
PermitRootLogin no              # root 로그인 금지
PasswordAuthentication no       # 비밀번호 인증 비활성화
PubkeyAuthentication yes        # 공개키 인증만 허용
AllowUsers admin developer      # 특정 사용자만 허용
```

**보안 Best Practices**

1. **포트 변경**
   ```
   Port 2222  # 22 대신 다른 포트 사용 (스캐닝 회피)
   ```

2. **root 로그인 금지**
   ```
   PermitRootLogin no
   ```

3. **공개키 인증만 허용**
   ```
   PasswordAuthentication no
   PubkeyAuthentication yes
   ```

4. **Fail2Ban 설치**
   - 반복 로그인 실패 시 IP 차단

5. **방화벽 설정**
   ```bash
   # 특정 IP만 SSH 허용
   sudo ufw allow from 203.123.45.67 to any port 22
   ```

6. **2FA (Two-Factor Authentication)**
   ```bash
   # Google Authenticator 연동
   sudo apt install libpam-google-authenticator
   ```

**SSH 에이전트**
```bash
# 개인키를 메모리에 캐시하여 반복 입력 방지
ssh-agent bash
ssh-add ~/.ssh/id_rsa

# 이후 비밀번호 입력 없이 접속 가능
```

**SSH 점프 호스트 (Bastion Host)**
```bash
# 중간 서버를 거쳐 접속
ssh -J jumphost user@finalserver

# 또는
ssh -o ProxyJump=jumphost user@finalserver
```

**실무 활용**

**DevOps**
- 서버 배포 (Ansible, Capistrano)
- CI/CD 파이프라인 (Jenkins, GitLab CI)

**개발**
- 원격 개발 환경 (VS Code Remote SSH)
- 데이터베이스 터널링 (로컬에서 원격 DB 접속)

**보안**
- VPN 대안 (SSH 터널링)
- Reverse Proxy (ngrok 대안)

**주의사항**
- 개인키(`id_rsa`)는 절대 외부 공유 금지
- 공개키(`id_rsa.pub`)만 서버에 등록
- 권한: `chmod 600 ~/.ssh/id_rsa` (소유자만 읽기 가능)

**정리**
- SSH는 **안전한 원격 접속**의 표준
- 암호화, 인증, 무결성 보장
- 서버 관리, 파일 전송, 터널링 등 다양한 용도
- 공개키 인증 + 포트 변경 + root 금지 = 필수 보안 설정'
WHERE id = 'b0000000-0000-0000-0018-000000000025';

UPDATE questions SET explanation =
'**네트워크 지연 (Latency)이란?**
- **정의**: 데이터가 출발지에서 목적지까지 **도착하는 데 걸리는 시간**
- **단위**: ms (밀리초)
- **측정**: 보통 RTT (Round-Trip Time, 왕복 시간)

**지연의 구성 요소**

**1. 전파 지연 (Propagation Delay)**
- **의미**: 신호가 물리적 매체를 통과하는 시간
- **요인**: 거리, 매체(광섬유 vs 구리선)
- **공식**: 거리 / 전파 속도
```
예시: 서울 ↔ 뉴욕 (약 11,000km)
광섬유 속도: 빛의 약 2/3 (200,000 km/s)
전파 지연: 11,000 / 200,000 = 55ms (편도)
RTT ≈ 110ms (왕복)
```
- **해결**: 물리적 한계, **CDN**으로 완화

**2. 전송 지연 (Transmission Delay)**
- **의미**: 패킷을 **네트워크에 올리는** 시간
- **요인**: 대역폭, 패킷 크기
- **공식**: 패킷 크기 / 대역폭
```
예시: 1500바이트 패킷, 100Mbps 회선
전송 지연: (1500 × 8) / 100,000,000 = 0.12ms
```
- **해결**: 대역폭 증가

**3. 처리 지연 (Processing Delay)**
- **의미**: 라우터/스위치에서 **패킷을 처리**하는 시간
- **요인**: 라우팅 테이블 조회, 체크섬 확인, 큐 관리
- **일반**: < 1ms (현대 장비)
- **해결**: 고성능 장비, 최적화

**4. 대기열 지연 (Queuing Delay)**
- **의미**: 라우터/스위치 **큐에서 대기**하는 시간
- **요인**: 네트워크 혼잡도
- **가변적**: 0ms ~ 수백 ms (혼잡 시)
- **해결**: QoS, 대역폭 확대, 트래픽 분산

**총 지연**
```
총 지연 = 전파 지연 + 전송 지연 + 처리 지연 + 대기열 지연
```

**지연 줄이는 방법**

**1. 물리적 거리 단축**

**CDN (Content Delivery Network)**
```
Before (CDN 없음):
사용자 (한국) → 서버 (미국)
RTT: 200ms

After (CDN):
사용자 (한국) → CDN 엣지 서버 (서울)
RTT: 10ms

→ 20배 개선!
```

**서비스**:
- Cloudflare, Akamai, AWS CloudFront
- 정적 파일(이미지, CSS, JS)을 전 세계 엣지 서버에 캐싱

**2. 대역폭 증가**
```
100Mbps → 1Gbps
전송 지연 1/10으로 감소

특히 대용량 데이터 전송 시 효과적
```

**주의**: 전파 지연은 개선 안 됨 (물리적 한계)

**3. 라우팅 최적화**

**BGP Anycast**
```
DNS 1.1.1.1 (Cloudflare):
전 세계 여러 서버가 같은 IP 공유
→ 가장 가까운 서버로 자동 라우팅
```

**Peering (피어링)**
```
ISP 간 직접 연결
Before: ISP A → 중간 ISP 5개 → ISP B
After: ISP A ↔ ISP B (직접 연결)
→ 홉 수 감소, 지연 감소
```

**4. 프로토콜 최적화**

**HTTP/2, HTTP/3**
```
HTTP/1.1:
- 요청 6개 → 6번 왕복 (순차 처리)

HTTP/2:
- 요청 6개 → 1번 연결 (멀티플렉싱)
→ 지연 1/6

HTTP/3 (QUIC):
- UDP 기반, 0-RTT 연결 재개
- 패킷 손실 시 전체 차단 방지
```

**Keep-Alive (지속 연결)**
```
HTTP/1.0:
요청마다 TCP 3-way handshake (1.5 RTT)

HTTP/1.1 Keep-Alive:
한 번 연결 → 여러 요청 재사용
→ 핸드셰이크 비용 제거
```

**5. DNS 최적화**

**DNS 캐싱**
```
첫 요청: DNS 조회 (50ms) + HTTP 요청 (200ms) = 250ms
이후: 캐시에서 (0ms) + HTTP 요청 (200ms) = 200ms
```

**DNS Prefetching**
```html
<link rel="dns-prefetch" href="//cdn.example.com">
<!-- 미리 DNS 조회 -->
```

**빠른 DNS 서버**
```
Google: 8.8.8.8
Cloudflare: 1.1.1.1 (가장 빠름)
```

**6. 캐싱**

**브라우저 캐싱**
```http
Cache-Control: max-age=31536000
→ 1년간 로컬에 캐시, 서버 요청 안 함
```

**애플리케이션 캐싱**
- Redis, Memcached로 DB 조회 결과 캐싱
- DB 지연 100ms → 캐시 지연 1ms

**7. 데이터 압축**
```
gzip 압축:
HTML 100KB → 20KB (5배 감소)
→ 전송 시간 1/5
```

**HTTP 헤더**:
```http
Content-Encoding: gzip
```

**8. 코드 최적화**

**리소스 최소화**
```
Before:
CSS 10개, JS 15개 → 25번 요청

After (번들링):
CSS 1개, JS 1개 → 2번 요청
→ 왕복 횟수 감소
```

**Lazy Loading (지연 로딩)**
```html
<img loading="lazy" src="image.jpg">
<!-- 화면에 보일 때만 로드 -->
```

**9. 하드웨어 업그레이드**

**SSD vs HDD**
```
HDD 읽기: 10~20ms
SSD 읽기: 0.1~0.5ms
→ 20~200배 빠름
```

**고성능 라우터/스위치**
- 처리 지연 감소
- 대기열 크기 증가 (버퍼 오버플로우 방지)

**10. 네트워크 토폴로지 개선**

**Mesh 네트워크**
```
Before (Star): 모든 트래픽이 중앙 라우터 경유
After (Mesh): 직접 경로로 통신
→ 홉 수 감소
```

**11. QoS (Quality of Service)**
```
중요한 트래픽(영상 회의)에 우선순위 부여
→ 대기열 지연 감소
```

**12. TCP 튜닝**

**TCP Fast Open (TFO)**
```
일반 TCP: 3-way handshake (1.5 RTT) 후 데이터 전송
TFO: 첫 SYN에 데이터 포함
→ 1 RTT 절약
```

**Window Scaling**
```
수신 윈도우 크기 확대
→ 한 번에 더 많은 데이터 전송
```

**13. 지역별 서버 배포**
```
글로벌 서비스:
- 아시아 서버 (서울, 도쿄, 싱가포르)
- 유럽 서버 (런던, 프랑크푸르트)
- 미국 서버 (버지니아, 캘리포니아)

→ 사용자가 가장 가까운 서버 접속
```

**측정 도구**
```bash
# RTT 측정
ping google.com

# 경로 추적 (각 홉의 지연)
traceroute google.com

# HTTP 지연 분해
curl -w "@curl-format.txt" -o /dev/null -s https://example.com
```

**curl-format.txt**:
```
time_namelookup:  %{time_namelookup}s  # DNS 조회
time_connect:     %{time_connect}s     # TCP 연결
time_starttransfer: %{time_starttransfer}s  # 첫 바이트
time_total:       %{time_total}s       # 전체
```

**실무 목표**
- 웹사이트: < 100ms (First Byte)
- API: < 50ms
- 게임: < 30ms
- VoIP: < 150ms

**정리**
1. **CDN**: 물리적 거리 단축 (가장 효과적)
2. **HTTP/2, HTTP/3**: 프로토콜 최적화
3. **캐싱**: 불필요한 요청 제거
4. **압축**: 전송 크기 감소
5. **QoS**: 중요 트래픽 우선순위
6. **대역폭 증가**: 전송 지연 감소
7. **라우팅 최적화**: 홉 수 감소'
WHERE id = 'b0000000-0000-0000-0018-000000000026';
