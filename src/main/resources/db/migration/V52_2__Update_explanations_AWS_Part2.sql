-- AWS 질문에 대한 답변 추가 (Part 2: 19-25번)

UPDATE questions SET explanation =
'**클라우드 보안 강화 조치**

**1. IAM 보안**

**최소 권한 원칙**
- 필요한 권한만 부여
- 와일드카드(*) 사용 최소화

**MFA (다중 인증) 활성화**
- 루트 계정 필수
- 모든 사용자 권장

**액세스 키 관리**
- 정기적 교체 (90일)
- 미사용 키 삭제
- 코드에 하드코딩 금지

**IAM 역할 사용**
- EC2에 IAM 역할 연결
- 액세스 키 대신 임시 자격 증명

---

**2. 네트워크 보안**

**VPC 격리**
```
퍼블릭 서브넷: ELB만
프라이빗 서브넷: EC2, RDS
  → 인터넷 직접 노출 금지
```

**보안 그룹**
- 최소 필요 포트만 개방
- 0.0.0.0/0 (모든 IP) 사용 주의
- 인바운드만 허용, 아웃바운드는 필요 시만

**Network ACL**
- 서브넷 레벨 추가 방화벽
- 특정 IP 차단

**VPN / Direct Connect**
- 온프레미스 안전한 연결
- 퍼블릭 인터넷 우회

---

**3. 데이터 암호화**

**전송 중 암호화**
- HTTPS/TLS 사용 (ELB, CloudFront)
- SSL 인증서 (ACM 무료 제공)

**저장 시 암호화**
- S3: 서버 측 암호화 (SSE-S3, SSE-KMS)
- RDS: 암호화 활성화
- EBS: 볼륨 암호화

**KMS (Key Management Service)**
- 암호화 키 중앙 관리
- 키 교체, 감사 로그

---

**4. 모니터링 및 로깅**

**CloudTrail**
- 모든 API 호출 기록
- 중앙 S3에 저장
- 변경 불가능한 감사 로그

**CloudWatch Logs**
- 애플리케이션 로그 수집
- 이상 패턴 감지 알람

**Config**
- 리소스 구성 변경 추적
- 규정 준수 확인

**GuardDuty**
- AI 기반 위협 탐지
- 악의적인 활동 자동 감지

---

**5. DDoS 보호**

**AWS Shield**
- Standard: 무료 (자동 적용)
- Advanced: 유료 (대규모 DDoS 대응)

**WAF (Web Application Firewall)**
- SQL Injection, XSS 차단
- IP 속도 제한
- 지리적 차단

**CloudFront + Shield**
- 엣지에서 공격 흡수
- 오리진 보호

---

**6. 규정 준수**

**AWS Artifact**
- 규정 준수 리포트
- SOC, PCI-DSS, ISO 인증

**AWS Compliance Programs**
- HIPAA (의료)
- PCI-DSS (결제)
- GDPR (개인정보)

---

**7. 백업 및 복구**

**자동 백업**
- RDS 자동 백업 (7-35일 보관)
- S3 버전 관리
- EBS 스냅샷

**재해 복구 (DR)**
- 멀티 AZ 배포
- 멀티 리전 복제
- Pilot Light, Warm Standby

---

**8. 침해 대응**

**AWS Security Hub**
- 보안 상태 통합 대시보드
- 자동 규정 준수 검사

**Incident Response 플랜**
- 침해 시나리오 사전 준비
- 자동화된 격리 및 복구

---

**9. 서드파티 도구**

**취약점 스캔**
- Amazon Inspector (EC2 스캔)
- 정기적인 보안 감사

**SIEM 통합**
- Splunk, Datadog
- 중앙 보안 모니터링

---

**10. 교육 및 정책**

**보안 교육**
- 개발자 보안 인식 교육
- Phishing 시뮬레이션

**정책 수립**
- 비밀번호 정책
- 액세스 검토 주기

---

**보안 체크리스트**
- [ ] 루트 계정 MFA 활성화
- [ ] IAM 사용자/역할 최소 권한
- [ ] VPC 프라이빗 서브넷 사용
- [ ] 보안 그룹 최소 포트 개방
- [ ] S3/RDS/EBS 암호화
- [ ] CloudTrail 활성화
- [ ] GuardDuty 활성화
- [ ] WAF 규칙 설정
- [ ] 정기 백업 확인
- [ ] Security Hub 검토

**실무 경험**
GuardDuty로 비정상적인 API 호출을 탐지하여 침해 시도를 조기 차단했고, S3 버킷 암호화와 버킷 정책으로 데이터 유출을 방지했으며, CloudTrail 로그 분석으로 보안 감사를 수행했습니다.'
WHERE id = 'b0000000-0000-0000-0015-000000000012';

UPDATE questions SET explanation =
'**멀티 리전 (Multi-Region) 배포**

**이점**

**1. 낮은 지연시간**
사용자와 가까운 리전에서 서비스를 제공하여 응답 속도를 향상시킵니다.
```
한국 사용자 → 서울 리전 (10ms)
미국 사용자 → 버지니아 리전 (10ms)
```

**2. 재해 복구 (Disaster Recovery)**
한 리전 장애 시 다른 리전으로 자동 전환하여 서비스 중단을 최소화합니다.

**3. 규제 준수**
데이터 주권 요구사항을 충족합니다 (예: EU 데이터는 EU 리전에 저장).

**4. 고가용성**
전체 리전 장애에도 서비스 지속 가능합니다.

---

**고려사항**

**1. 데이터 일관성**

**동기 복제 vs 비동기 복제**
- 동기: 강한 일관성, 느림
- 비동기: 약한 일관성 (최종 일관성), 빠름

**글로벌 데이터베이스**
- Aurora Global Database: 1초 미만 복제 지연
- DynamoDB Global Tables: 자동 양방향 복제

**2. 복제 지연**
리전 간 네트워크 지연으로 데이터 복제에 시간이 소요됩니다.
```
서울 → 버지니아: 150-200ms
서울 → 도쿄: 30-50ms
```

**3. 복잡성 증가**
- 배포 파이프라인 복잡화
- 모니터링 범위 확대
- 비용 관리 어려움

**4. 비용**
- 리전 간 데이터 전송 비용
- 중복 리소스 비용
- 글로벌 서비스 추가 비용

---

**멀티 리전 아키텍처 패턴**

**1. Active-Passive (재해 복구)**
```
Primary Region (서울) - 활성
  ↓ 비동기 복제
Secondary Region (도쿄) - 대기
  → 장애 시에만 활성화
```

**장점**: 비용 효율적
**단점**: 장애 전환 시간 소요

**2. Active-Active (고가용성)**
```
서울 리전 ← Route 53 (지리적 라우팅) → 버지니아 리전
   ↓                                        ↓
한국 사용자                              미국 사용자
```

**장점**: 최상의 성능, 즉시 전환
**단점**: 높은 비용, 데이터 일관성 관리

**3. 읽기 전용 복제**
```
Primary (서울): 쓰기
  ↓ 복제
Read Replicas (도쿄, 싱가포르, 버지니아): 읽기 전용
```

---

**멀티 리전 구현**

**1. Route 53 (DNS 라우팅)**

**지리적 라우팅**
```
한국 IP → 서울 리전
미국 IP → 버지니아 리전
```

**장애 조치 라우팅**
```
서울 리전 헬스 체크 실패
  → 트래픽을 도쿄 리전으로 자동 전환
```

**지연 시간 기반 라우팅**
```
사용자에게 가장 낮은 지연시간을 제공하는 리전으로 라우팅
```

**2. CloudFront (CDN)**
전 세계 엣지 로케이션에서 콘텐츠를 캐싱하여 글로벌 배포를 간소화합니다.

**3. S3 Cross-Region Replication**
```
서울 S3 버킷
  → 자동 복제
버지니아 S3 버킷
```

**4. DynamoDB Global Tables**
```
서울 테이블 ← 양방향 복제 → 버지니아 테이블
  ↑                            ↑
한국 쓰기                    미국 쓰기
```

**5. Aurora Global Database**
```
Primary (서울): 읽기/쓰기
  ↓ 1초 미만 복제
Secondary (도쿄, 버지니아): 읽기 전용
  → 승격 가능 (1분 이내)
```

---

**실무 아키텍처 예시**

**글로벌 웹 애플리케이션**
```
사용자
  ↓
Route 53 (지리적 라우팅)
  ├─ 서울 리전
  │  ├─ CloudFront (CDN)
  │  ├─ ELB → EC2
  │  └─ Aurora (Primary)
  └─ 버지니아 리전
     ├─ CloudFront (CDN)
     ├─ ELB → EC2
     └─ Aurora (Secondary)
```

---

**배포 전략**

**1. Blue-Green 배포**
```
리전 A: Blue (현재 버전)
리전 B: Green (새 버전 배포 및 테스트)
  → 검증 완료 후 Route 53으로 트래픽 전환
```

**2. 카나리 배포**
```
Route 53 가중치 라우팅
  ├─ 90% → 기존 버전
  └─ 10% → 새 버전
  → 점진적으로 100% 전환
```

---

**비용 최적화**

**리전 간 데이터 전송**
- 필요한 데이터만 복제
- CloudFront로 전송 비용 절감
- VPC Peering보다 Transit Gateway 검토

**리소스 효율**
- 각 리전에 필요한 리소스만 배치
- Spot 인스턴스 활용
- Auto Scaling으로 유휴 리소스 제거

---

**체크리스트**
- [ ] 비즈니스 요구사항 (DR RTO/RPO)
- [ ] 데이터 일관성 요구사항
- [ ] Route 53 라우팅 전략
- [ ] 데이터 복제 방법 (Aurora, DynamoDB, S3)
- [ ] 모니터링 (각 리전 CloudWatch)
- [ ] 비용 추정 (리전 간 전송, 중복 리소스)
- [ ] 배포 파이프라인 (멀티 리전 CI/CD)
- [ ] 장애 전환 테스트

**실무 경험**
서울/도쿄/버지니아 3개 리전에 Active-Active로 배포하여 글로벌 사용자 응답 속도를 평균 300ms에서 50ms로 개선했고, Aurora Global Database로 1초 미만 복제 지연을 달성했습니다.'
WHERE id = 'b0000000-0000-0000-0015-000000000013';

UPDATE questions SET explanation =
'**AWS 공동 책임 모델 (Shared Responsibility Model)**

AWS와 고객이 보안 책임을 나누어 가지는 모델입니다.

**AWS 책임: "클라우드 자체의 보안"**
AWS가 관리하는 인프라 및 서비스의 보안입니다.

**AWS가 책임지는 부분**
- 물리적 데이터 센터 보안 (건물, 냉각, 전력)
- 네트워크 인프라 (라우터, 스위치)
- 호스트 운영체제 및 가상화 계층
- 하드웨어 (서버, 디스크)
- 리전 및 가용 영역 인프라

---

**고객 책임: "클라우드 안의 보안"**
고객이 AWS에서 생성하고 관리하는 것들의 보안입니다.

**고객이 책임지는 부분**

**1. 데이터 보안**
- 데이터 암호화 (전송 중, 저장 시)
- 데이터 분류 및 백업
- S3 버킷 정책, 퍼블릭 액세스 설정

**2. 플랫폼 및 애플리케이션**
- 게스트 OS 패치 및 업데이트 (EC2)
- 애플리케이션 보안 (코드, 라이브러리)
- 방화벽 설정 (보안 그룹, NACL)

**3. IAM (Identity and Access Management)**
- 사용자 및 역할 관리
- 액세스 키 관리
- MFA 설정

**4. 네트워크 구성**
- VPC 설정
- 서브넷, 라우팅 테이블
- 보안 그룹, Network ACL

**5. 클라이언트 측 암호화**
- 애플리케이션 레벨 암호화
- SSL/TLS 인증서 관리

---

**서비스별 책임 구분**

**IaaS (Infrastructure as a Service)**
예: EC2, EBS, VPC

| 책임 | AWS | 고객 |
|-----|-----|------|
| 물리적 인프라 | ✓ | |
| 하이퍼바이저 | ✓ | |
| 게스트 OS | | ✓ |
| 애플리케이션 | | ✓ |
| 데이터 | | ✓ |
| 보안 그룹 | | ✓ |

**PaaS (Platform as a Service)**
예: RDS, Elastic Beanstalk

| 책임 | AWS | 고객 |
|-----|-----|------|
| 물리적 인프라 | ✓ | |
| OS 패치 | ✓ | |
| 플랫폼 관리 | ✓ | |
| 애플리케이션 | | ✓ |
| 데이터 | | ✓ |
| 암호화 설정 | | ✓ |

**SaaS (Software as a Service)**
예: S3, DynamoDB

| 책임 | AWS | 고객 |
|-----|-----|------|
| 인프라 | ✓ | |
| 플랫폼 | ✓ | |
| 애플리케이션 | ✓ | |
| 데이터 | | ✓ |
| 액세스 제어 | | ✓ |

---

**시각화**
```
           [고객 책임]
━━━━━━━━━━━━━━━━━━━━━━━━━
         데이터
  플랫폼, 애플리케이션, IAM
   게스트 OS, 방화벽, 암호화
━━━━━━━━━━━━━━━━━━━━━━━━━
           [AWS 책임]
     네트워크, 하이퍼바이저
    스토리지, 컴퓨팅, 데이터베이스
  리전, AZ, 엣지 로케이션
     물리적 보안
```

---

**서비스별 예시**

**EC2 (IaaS)**
- AWS: 하드웨어, 하이퍼바이저
- 고객: OS 패치, 애플리케이션, 방화벽, 데이터 암호화

**RDS (PaaS)**
- AWS: 하드웨어, OS 패치, DB 엔진 업데이트
- 고객: DB 사용자 관리, 암호화 설정, 백업 정책

**S3 (SaaS)**
- AWS: 인프라, 내구성, 가용성
- 고객: 버킷 정책, 암호화, 버전 관리, 퍼블릭 액세스 설정

**Lambda (FaaS)**
- AWS: 인프라, 런타임, 스케일링
- 고객: 함수 코드, IAM 역할, 환경 변수 암호화

---

**고객 보안 책임 체크리스트**

**데이터**
- [ ] 데이터 암호화 (S3, RDS, EBS)
- [ ] 백업 및 복구 계획
- [ ] 데이터 분류 및 접근 제어

**IAM**
- [ ] 최소 권한 원칙
- [ ] MFA 활성화
- [ ] 액세스 키 정기 교체

**네트워크**
- [ ] VPC 격리
- [ ] 보안 그룹 최소 포트 개방
- [ ] HTTPS/TLS 사용

**애플리케이션**
- [ ] 코드 보안 검토
- [ ] 취약점 스캔
- [ ] 보안 패치 적용

**모니터링**
- [ ] CloudTrail 활성화
- [ ] CloudWatch 알람 설정
- [ ] GuardDuty 활성화

---

**잘못된 이해 예시**

**❌ 잘못된 생각**
"AWS를 사용하면 AWS가 모든 보안을 책임진다."

**✅ 올바른 이해**
"AWS는 인프라 보안을 책임지고, 내 데이터와 애플리케이션 보안은 내가 책임진다."

---

**실무 시나리오**

**S3 버킷 유출 사고**
- 고객 실수: 퍼블릭 액세스 허용
- 고객 책임: 버킷 정책 설정
- AWS 책임: S3 서비스 가용성 및 내구성

**EC2 해킹**
- 고객 실수: 보안 그룹 22번 포트 0.0.0.0/0 허용, OS 패치 미적용
- 고객 책임: 방화벽 설정, OS 보안
- AWS 책임: 하이퍼바이저 격리

**실무 경험**
공동 책임 모델을 이해하여 S3 버킷 암호화와 버킷 정책을 직접 설정했고, EC2 보안 그룹을 최소 권한으로 구성하여 보안을 강화했습니다.'
WHERE id = 'b0000000-0000-0000-0015-000000000014';

UPDATE questions SET explanation =
'**확장성 있고 내결함성 있는 웹 애플리케이션 설계**

**아키텍처 설계**

```
사용자
  ↓
Route 53 (DNS, 헬스 체크)
  ↓
CloudFront (CDN, 정적 콘텐츠 캐싱)
  ↓
WAF (웹 방화벽)
  ↓
ELB (로드 밸런서)
  ├─ AZ-A: Auto Scaling Group
  │  ├─ EC2 (웹/앱 서버)
  │  └─ ElastiCache (캐시)
  ├─ AZ-B: Auto Scaling Group
  │  ├─ EC2 (웹/앱 서버)
  │  └─ ElastiCache (캐시)
  └─ AZ-C: Auto Scaling Group
     └─ EC2 (웹/앱 서버)
  ↓
RDS Multi-AZ (마스터/스탠바이)
Read Replicas (읽기 부하 분산)
```

---

**확장성 구현**

**1. Auto Scaling**
트래픽에 따라 자동으로 EC2 인스턴스 추가/제거
```
최소: 3대 (각 AZ 1대)
최대: 30대
CPU > 70%: 인스턴스 추가
CPU < 30%: 인스턴스 제거
```

**2. 수평 확장**
- 상태 비저장(Stateless) 설계
- 세션은 ElastiCache 또는 DynamoDB에 저장
- 파일은 S3에 저장 (로컬 디스크 미사용)

**3. 캐싱 전략**
- CloudFront: 정적 파일 (이미지, CSS, JS)
- ElastiCache: 데이터베이스 쿼리 결과
- S3: 객체 스토리지

**4. 데이터베이스 확장**
- Read Replica: 읽기 부하 분산
- 쓰기는 Master, 읽기는 Replica
- Aurora Auto Scaling: Reader 자동 확장

---

**내결함성 (Fault Tolerance) 구현**

**1. Multi-AZ 배포**
최소 3개 가용 영역에 리소스 분산
```
AZ-A 장애 발생
  → ELB가 자동으로 트래픽을 AZ-B, AZ-C로 전환
  → 서비스 중단 없음
```

**2. ELB (Elastic Load Balancer)**
- 헬스 체크로 비정상 인스턴스 제외
- 트래픽 자동 분산
- AZ 간 자동 장애 조치

**3. RDS Multi-AZ**
- 자동 페일오버 (30-120초)
- 마스터 장애 시 스탠바이가 마스터로 승격
- 애플리케이션 코드 변경 불필요 (같은 엔드포인트)

**4. 자동 복구**
- EC2 Auto Recovery: 하드웨어 장애 시 자동 재시작
- Auto Scaling: 비정상 인스턴스 자동 교체

**5. 백업**
- RDS 자동 백업 (일일 스냅샷)
- S3 버전 관리 및 Cross-Region Replication
- EBS 스냅샷

---

**보안**

**1. 네트워크 격리**
```
VPC
├─ 퍼블릭 서브넷: ELB, NAT Gateway
└─ 프라이빗 서브넷: EC2, RDS
   → RDS는 인터넷 직접 노출 안 함
```

**2. 보안 계층**
- WAF: SQL Injection, XSS 차단
- 보안 그룹: 최소 포트만 개방
- Network ACL: 서브넷 레벨 방화벽
- IAM 역할: 최소 권한

**3. 데이터 암호화**
- HTTPS (ELB SSL/TLS)
- RDS 암호화
- S3 암호화

---

**모니터링 및 알람**

**CloudWatch**
- CPU, 메모리, 네트워크 모니터링
- 알람 설정 (CPU > 80%, 디스크 > 90%)

**CloudTrail**
- 모든 API 호출 로깅
- 보안 감사

**X-Ray**
- 분산 추적
- 병목 지점 파악

---

**비용 최적화**

**1. Auto Scaling**
- 유휴 시간 인스턴스 자동 축소
- 평균 활용률 60-70% 유지

**2. 예약 인스턴스**
- 베이스라인 워크로드 (최소 2-3대)
- 1년 약정으로 30-40% 할인

**3. Spot 인스턴스**
- 배치 작업, 비critical 워크로드
- 최대 90% 할인

**4. S3 Lifecycle**
- 오래된 로그는 Glacier로 이동

---

**CI/CD 파이프라인**

```
Git Push
  ↓
CodePipeline
  ├─ CodeBuild (빌드 및 테스트)
  ├─ CodeDeploy (Blue-Green 배포)
  └─ CloudFormation (인프라 코드)
```

---

**재해 복구 (DR)**

**RTO/RPO 목표**
- RTO (Recovery Time Objective): 1시간
- RPO (Recovery Point Objective): 5분

**전략**
- Multi-Region Backup
- Aurora Global Database: 1초 미만 복제
- Route 53 Failover: 리전 장애 시 자동 전환

---

**성능 최적화**

**1. CDN**
- CloudFront로 정적 파일 엣지 캐싱
- 원본 부하 90% 감소

**2. 데이터베이스**
- ElastiCache로 자주 조회되는 데이터 캐싱
- Read Replica로 읽기 성능 향상

**3. 비동기 처리**
- SQS + Lambda로 무거운 작업 비동기 처리
- 사용자 응답 속도 향상

---

**핵심 설계 원칙**

**확장성**
- ✓ Auto Scaling Group
- ✓ Stateless 애플리케이션
- ✓ ElastiCache, Read Replica

**내결함성**
- ✓ Multi-AZ (최소 3개)
- ✓ ELB 헬스 체크
- ✓ RDS Multi-AZ

**보안**
- ✓ VPC 격리
- ✓ WAF, 보안 그룹
- ✓ 암호화 (HTTPS, RDS, S3)

**실무 경험**
이 아키텍처로 일 100만 사용자를 처리했으며, AZ 장애 발생 시에도 서비스 중단 없이 운영했고, Auto Scaling으로 트래픽 10배 증가에도 안정적으로 대응했습니다.'
WHERE id = 'b0000000-0000-0000-0015-000000000015';

UPDATE questions SET explanation =
'**시나리오: 사용자 갑자기 급증 상황 대응**

예: 뉴스 포털에 긴급 뉴스로 평소 1000명에서 10만 명으로 급증

---

**1. 즉시 대응 (자동)**

**Auto Scaling 자동 확장**
```
현재 상태: EC2 3대 (CPU 30%)
  ↓ 트래픽 급증
CPU 사용률 > 70%
  ↓ Auto Scaling 트리거
EC2 인스턴스 자동 추가 (3대 → 20대)
  ↓ 5분 이내
부하 분산 완료
```

**ELB 자동 분산**
- 새로운 인스턴스에 트래픽 자동 분산
- 헬스 체크 통과 후 트래픽 전송 시작

---

**2. 캐싱 활용**

**CloudFront (CDN)**
- 정적 콘텐츠 엣지 캐싱
- 오리진 트래픽 90% 감소
- 전 세계 사용자 빠른 응답

**ElastiCache (Redis/Memcached)**
```
사용자 요청
  ↓
ElastiCache 확인 (캐시 히트 80%)
  ↓ 캐시 미스 (20%)
RDS 조회 → 캐시에 저장
```

**애플리케이션 레벨 캐싱**
- 뉴스 기사 30초 캐싱
- 댓글 목록 5분 캐싱

---

**3. 데이터베이스 최적화**

**Read Replica 활용**
```
Master (쓰기)
  ↓
Read Replica 1, 2, 3, 4, 5 (읽기 분산)
```

**읽기/쓰기 분리**
- 읽기: Read Replica (90%)
- 쓰기: Master (10%)

**쿼리 최적화**
- 인덱스 활용
- 불필요한 JOIN 제거
- LIMIT 사용

---

**4. 비동기 처리**

**SQS (메시지 큐)**
```
사용자 요청 (댓글 작성)
  ↓ 즉시 응답
SQS에 메시지 전송
  ↓ 나중에 처리
Lambda/Worker가 실제 저장
```

**Lambda 활용**
- 실시간 처리 불필요한 작업
- 예: 알림 전송, 이미지 리사이징

---

**5. 정적 콘텐츠 S3 전환**

**S3 + CloudFront**
```
이미지, CSS, JS → S3
  ↓
CloudFront 캐싱
  ↓
전 세계 배포 (초고속)
```

**EC2 부하 제거**
- 정적 파일 요청이 EC2로 가지 않음
- 애플리케이션 리소스 절약

---

**6. WAF로 악의적 트래픽 차단**

**Rate Limiting**
```
IP당 초당 100 요청 제한
  → DDoS 공격 차단
```

**Geo Blocking**
- 특정 국가 차단 (필요시)

---

**7. 데이터베이스 연결 풀링**

**RDS Proxy**
- 데이터베이스 연결 재사용
- 연결 수 폭발 방지
- Lambda에서 유용

---

**8. 모니터링 및 알람**

**CloudWatch 알람**
```
CPU > 80% → SNS 알림
DB 연결 수 > 90% → 긴급 알림
ELB 오류율 > 1% → 알림
```

**실시간 대시보드**
- 트래픽 현황
- 인스턴스 상태
- 응답 시간

---

**9. 사전 준비 (Proactive)**

**Load Testing**
- 정기적인 부하 테스트
- 피크 트래픽의 2배 대비

**Auto Scaling 정책 최적화**
```
예측 스케일링 (Predictive Scaling)
  → 과거 패턴 학습
  → 트래픽 증가 전에 미리 확장
```

**Warm-up Period**
- 새 인스턴스 헬스 체크 전 준비 시간
- 애플리케이션 초기화

---

**10. 긴급 대응 (수동)**

**즉시 인스턴스 추가**
```bash
# Auto Scaling 희망 용량 수동 증가
aws autoscaling set-desired-capacity \
  --auto-scaling-group-name my-asg \
  --desired-capacity 50
```

**RDS 인스턴스 타입 업그레이드**
- db.t3.medium → db.r5.xlarge
- 재부팅 필요 (5-10분 다운타임)

**ElastiCache 노드 추가**
- Redis 클러스터 확장

---

**대응 시나리오 예시**

**오후 6시: 긴급 뉴스 발행**
```
6:00 PM: 트래픽 급증 시작
  ├─ CloudFront: 정적 파일 캐시 히트율 95%
  ├─ ElastiCache: DB 부하 80% 감소
  └─ Auto Scaling: 3대 → 10대 (2분)

6:02 PM: Auto Scaling 완료
  ├─ ELB: 10대에 트래픽 분산
  └─ 응답 시간 정상화 (50ms → 80ms)

6:05 PM: 추가 확장
  └─ Auto Scaling: 10대 → 20대

6:10 PM: 안정화
  ├─ CPU 평균 50%
  ├─ 응답 시간 60ms
  └─ 에러율 0.01%
```

**오후 9시: 트래픽 감소**
```
9:00 PM: 트래픽 점진적 감소
  └─ Auto Scaling: 20대 → 10대 (15분)

10:00 PM: 정상 수준 복귀
  └─ Auto Scaling: 10대 → 3대
```

---

**비용 관리**

**급증 시간 비용**
- 3대 → 20대 (3시간 운영)
- 추가 비용: $10-20 (t3.medium 기준)

**비용 vs 서비스 중단**
- 서비스 중단 시 매출 손실: $10,000
- Auto Scaling 비용: $20
- ROI: 500배

---

**체크리스트**
- [x] Auto Scaling 설정 및 테스트
- [x] CloudFront CDN 활성화
- [x] ElastiCache 캐싱 구현
- [x] Read Replica 구성
- [x] S3로 정적 파일 이동
- [x] CloudWatch 알람 설정
- [x] WAF Rate Limiting
- [x] 비동기 처리 (SQS)
- [x] 정기 부하 테스트

**실무 경험**
블랙 프라이데이 세일에서 평소 대비 50배 트래픽 급증 시 Auto Scaling + CloudFront + ElastiCache 조합으로 서비스 중단 없이 운영했고, 응답 시간을 50ms로 유지했습니다.'
WHERE id = 'b0000000-0000-0000-0015-000000000016';

UPDATE questions SET explanation =
'**RDS 대신 DynamoDB 선택 시나리오**

**DynamoDB를 선택해야 하는 경우**

**1. 예측 불가능한 대량 트래픽**

**시나리오: 소셜 미디어 앱**
```
갑자기 바이럴 콘텐츠 발생
  → 초당 10만 건 요청
  → DynamoDB 자동 확장
  → RDS는 수직 확장 한계
```

**이유**
- DynamoDB: 무제한 수평 확장
- RDS: 인스턴스 크기 한계

---

**2. 단순한 키-값 조회**

**시나리오: 세션 저장소**
```
사용자 로그인
  → session_id로 세션 데이터 조회
  → 밀리초 응답 필요
```

**DynamoDB**
```python
# Primary Key로 즉시 조회
response = table.get_item(Key={''session_id'': ''abc123''})
```

**RDS**
```sql
SELECT * FROM sessions WHERE session_id = ''abc123'';
-- 인덱스 있어도 DynamoDB보다 느림
```

**이유**
- DynamoDB: 키 기반 조회 1ms 미만
- RDS: SQL 파싱, 실행 계획 수립 필요

---

**3. 간단한 데이터 모델**

**시나리오: IoT 센서 데이터**
```
센서 ID + 타임스탬프 → 측정값
  → JOIN 불필요
  → 단순 저장 및 조회
```

**데이터**
```
sensor_id (Partition Key)
timestamp (Sort Key)
temperature, humidity, pressure
```

**이유**
- 복잡한 쿼리 불필요
- RDS의 관계형 기능 활용 못함
- DynamoDB가 더 빠르고 저렴

---

**4. 엄청난 쓰기 처리량**

**시나리오: 게임 리더보드**
```
수백만 게임 플레이어
  → 실시간 점수 업데이트 (초당 10만 건)
  → DynamoDB 자동 확장
```

**RDS 문제**
- 쓰기 병목 (Master 하나만)
- 샤딩 직접 구현 필요 (복잡)

**DynamoDB 해결**
- 자동 파티셔닝
- 무제한 쓰기 확장

---

**5. 서버리스 아키텍처**

**시나리오: 이벤트 기반 처리**
```
API Gateway
  ↓
Lambda (서버리스)
  ↓
DynamoDB (서버리스)
```

**이유**
- RDS는 연결 관리 부담 (RDS Proxy 필요)
- DynamoDB는 HTTP API (연결 풀 불필요)
- Lambda와 찰떡 궁합

---

**6. 글로벌 배포**

**시나리오: 글로벌 모바일 앱**
```
DynamoDB Global Tables
  ├─ 서울 테이블 ← 양방향 복제 → 버지니아 테이블
  ↑                                  ↑
한국 사용자                        미국 사용자
```

**이유**
- DynamoDB: 자동 글로벌 복제
- RDS: 수동 복제 설정, 복잡

---

**7. 비용 효율 (작은 규모)**

**시나리오: 스타트업 초기**
```
월 100만 건 요청
  → DynamoDB 무료 티어 (월 25 GB, 200M 요청)
  → RDS: 최소 $15/월 (t3.micro)
```

**이유**
- 작은 트래픽: DynamoDB 무료 또는 매우 저렴
- RDS: 인스턴스 유지 비용

---

**8. 시간대별 트래픽 변동**

**시나리오: 뉴스 앱**
```
아침 7-9시: 피크 (10만 RCU)
낮 12-1시: 피크 (10만 RCU)
심야: 최저 (1000 RCU)
```

**DynamoDB On-Demand**
- 사용한 만큼만 비용
- Auto Scaling 불필요

**RDS**
- 피크에 맞춰 인스턴스 크기 결정
- 유휴 시간에도 비용 발생

---

**DynamoDB가 부적합한 경우**

**복잡한 쿼리 (JOIN)**
```sql
-- RDS: 가능
SELECT u.name, o.total
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.created_at > ''2024-01-01'';

-- DynamoDB: 불가능 (애플리케이션에서 처리)
```

**ACID 트랜잭션 (여러 테이블)**
- RDS: 완벽한 트랜잭션 지원
- DynamoDB: 제한적 (단일 테이블, 최대 25 아이템)

**집계 쿼리**
```sql
-- RDS: 간단
SELECT department, AVG(salary) FROM employees GROUP BY department;

-- DynamoDB: 모든 데이터 스캔 (매우 비효율)
```

---

**선택 기준 요약**

| 요구사항 | RDS | DynamoDB |
|---------|-----|----------|
| 복잡한 쿼리 (JOIN, 집계) | ✓ | ✗ |
| 대량 트래픽 (10만+ TPS) | 한계 있음 | ✓ |
| 단순 키-값 조회 | △ | ✓✓ |
| ACID 트랜잭션 | ✓✓ | 제한적 |
| 수평 확장 | 샤딩 필요 | ✓ 자동 |
| 서버리스 | RDS Proxy | ✓✓ |
| 비용 (소규모) | $15+/월 | 무료~저렴 |
| 글로벌 복제 | 수동 | ✓ 자동 |

---

**실무 의사결정 예시**

**주문 시스템 (RDS)**
- 주문, 사용자, 상품 관계
- JOIN 필요
- 트랜잭션 중요
- 선택: RDS

**사용자 세션 (DynamoDB)**
- session_id → 세션 데이터
- 단순 조회
- 빠른 속도 필요
- 선택: DynamoDB

**게임 리더보드 (DynamoDB)**
- player_id → 점수
- 실시간 업데이트 (초당 10만 건)
- 선택: DynamoDB

**금융 거래 (RDS)**
- 복잡한 비즈니스 로직
- 완벽한 ACID 필수
- 선택: RDS

**실무 경험**
채팅 앱의 메시지 저장은 DynamoDB로 구현하여 초당 10만 건의 메시지를 처리했고, 주문 시스템은 RDS로 구현하여 복잡한 재고 관리와 트랜잭션을 안전하게 처리했습니다.'
WHERE id = 'b0000000-0000-0000-0015-000000000017';

UPDATE questions SET explanation =
'**Lambda를 활용해야 하는 애플리케이션 시나리오**

**1. 이벤트 기반 파일 처리**

**시나리오: 이미지 썸네일 생성**
```
사용자 → S3 업로드 (원본 이미지)
  ↓ S3 이벤트 트리거
Lambda 실행 (이미지 리사이징)
  ↓
S3 저장 (썸네일)
```

**장점**
- 업로드 즉시 자동 처리
- 서버 불필요
- 비용: 실행 시간만 과금 (월 100만 건 무료)

**코드 예시**
```python
import boto3
from PIL import Image

def lambda_handler(event, context):
    s3 = boto3.client(''s3'')
    bucket = event[''Records''][0][''s3''][''bucket''][''name'']
    key = event[''Records''][0][''s3''][''object''][''key'']

    # 이미지 다운로드 및 리사이징
    s3.download_file(bucket, key, ''/tmp/original.jpg'')
    img = Image.open(''/tmp/original.jpg'')
    img.thumbnail((200, 200))
    img.save(''/tmp/thumb.jpg'')

    # 썸네일 업로드
    s3.upload_file(''/tmp/thumb.jpg'', bucket, f''thumbnails/{key}'')
```

---

**2. 서버리스 API 백엔드**

**시나리오: 간단한 REST API**
```
모바일 앱
  ↓ HTTPS 요청
API Gateway
  ↓
Lambda (비즈니스 로직)
  ↓
DynamoDB (데이터 저장)
  ↓ 응답
모바일 앱
```

**장점**
- 서버 관리 제로
- 자동 확장 (동시 1000+ 실행)
- 저렴한 비용

**사용 사례**
- 모바일 앱 백엔드
- 마이크로서비스 API
- Webhook 처리

---

**3. 스케줄 작업 (Cron Job)**

**시나리오: 일일 보고서 생성**
```
CloudWatch Events (매일 자정)
  ↓
Lambda 트리거
  ↓
RDS 쿼리 → 리포트 생성 → S3 저장 → Email 전송
```

**기존 방식 (EC2)**
- 서버 24시간 유지
- 23시간 50분은 유휴 상태
- 월 $15

**Lambda 방식**
- 필요할 때만 실행 (10분)
- 월 $0.01

---

**4. 실시간 데이터 처리**

**시나리오: DynamoDB Streams 처리**
```
DynamoDB 테이블 변경 (INSERT/UPDATE/DELETE)
  ↓ DynamoDB Streams
Lambda 트리거
  ↓
실시간 알림, 데이터 동기화, 분석
```

**예시**
- 주문 생성 → Lambda → 사용자에게 Email/SMS
- 재고 감소 → Lambda → 알림 발송

---

**5. 데이터 변환 ETL**

**시나리오: 로그 데이터 변환**
```
애플리케이션 로그 → S3 (원본)
  ↓ S3 이벤트
Lambda (파싱 및 변환)
  ↓
Elasticsearch / Athena (분석용)
```

**장점**
- 파일 도착 즉시 처리
- 병렬 처리 (파일당 Lambda 인스턴스)

---

**6. ChatOps / Slack Bot**

**시나리오: Slack 명령 처리**
```
/deploy production
  ↓ Slack Webhook
API Gateway → Lambda
  ↓
CodePipeline 트리거 → 배포 시작
  ↓
Slack 응답: "배포 시작됨"
```

**장점**
- 간단한 통합
- 비용 효율

---

**7. IoT 데이터 수집**

**시나리오: 스마트 홈 센서**
```
IoT 디바이스 (온도, 습도)
  ↓ MQTT
AWS IoT Core
  ↓
Lambda (데이터 검증 및 저장)
  ↓
DynamoDB
```

**장점**
- 수백만 디바이스 동시 처리
- 자동 확장

---

**8. 알림 및 이메일 발송**

**시나리오: 회원 가입 환영 이메일**
```
사용자 가입 → DynamoDB
  ↓ DynamoDB Streams
Lambda
  ↓
SES (이메일 발송)
```

**장점**
- 비동기 처리 (사용자는 즉시 응답 받음)
- 재시도 로직 내장

---

**9. A/B 테스트 / Feature Flag**

**시나리오: CloudFront Lambda@Edge**
```
사용자 요청 → CloudFront
  ↓ Lambda@Edge (엣지에서 실행)
사용자 50% → 버전 A
사용자 50% → 버전 B
```

**사용 사례**
- 지역별 컨텐츠 변경
- A/B 테스트
- URL 리다이렉션

---

**10. Webhook 처리**

**시나리오: GitHub Webhook**
```
GitHub Push 이벤트
  ↓ Webhook
API Gateway → Lambda
  ↓
슬랙 알림 / CI/CD 트리거
```

---

**Lambda가 부적합한 경우**

**1. 장시간 실행 (15분 이상)**
- Lambda 최대 실행 시간: 15분
- 대안: ECS, Fargate, Batch

**2. 상태 저장 (Stateful)**
- Lambda는 stateless
- 세션/상태는 DynamoDB, ElastiCache에 저장

**3. 대용량 메모리/CPU (10GB 이상)**
- Lambda 최대 메모리: 10GB
- 대안: EC2, ECS

**4. 실시간 응답 (콜드 스타트 민감)**
- 콜드 스타트: 100ms~1초
- 대안: 프로비전된 동시성 (비용 증가)

---

**Lambda 설계 패턴**

**1. 단일 목적**
- 하나의 Lambda는 하나의 작업만
- 작고 재사용 가능하게

**2. 멱등성 (Idempotency)**
- 같은 입력 → 같은 출력
- 재시도 시 중복 처리 방지

**3. 오류 처리**
- DLQ (Dead Letter Queue)로 실패 메시지 저장
- 재시도 정책 설정

**4. 환경 변수**
- API 키, DB 엔드포인트 등
- 코드에 하드코딩 금지

---

**비용 예시**

**시나리오: 일일 이미지 처리 1000건**
```
Lambda:
  - 실행 시간: 건당 2초
  - 메모리: 512MB
  - 월 비용: $0.20

EC2 (t3.small):
  - 24시간 실행
  - 월 비용: $15

절감: 98%
```

---

**실무 경험**
사용자 프로필 이미지 업로드 시 Lambda로 3가지 크기 썸네일을 자동 생성하여 EC2 서버 부하를 완전히 제거했고, 야간 배치 작업을 Lambda + CloudWatch Events로 대체하여 월 $50 비용을 $0.1로 절감했습니다.'
WHERE id = 'b0000000-0000-0000-0015-000000000018';
