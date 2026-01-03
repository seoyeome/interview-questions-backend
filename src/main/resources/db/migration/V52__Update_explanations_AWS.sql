-- AWS 질문에 대한 답변 추가

UPDATE questions SET explanation =
$md$
**AWS(Amazon Web Services)란?**
아마존이 제공하는 클라우드 컴퓨팅 플랫폼으로, 서버, 스토리지, 데이터베이스, 네트워킹 등 IT 인프라를 온디맨드로 제공하는 서비스입니다.

**널리 사용되는 이유**

**1. 종량제 요금**
- 사용한 만큼만 비용 지불
- 초기 인프라 투자 불필요
- 리소스 확장/축소에 따라 비용 조정

**2. 광범위한 서비스**
- 200개 이상의 서비스 제공
- 컴퓨팅, 스토리지, DB, AI/ML, IoT 등
- 대부분의 요구사항을 AWS 내에서 해결

**3. 글로벌 인프라**
- 전 세계 30개 이상의 리전
- 낮은 지연시간, 높은 가용성
- 재해 복구 및 백업 용이

**4. 확장성과 유연성**
- 트래픽 증가에 즉시 대응
- Auto Scaling으로 자동 리소스 조정
- 수분 내에 서버 증설 가능

**5. 보안**
- 데이터 센터 물리적 보안
- 다양한 보안 도구 및 서비스 제공
- 규제 준수 (HIPAA, PCI-DSS 등)

**주요 서비스**
- EC2: 가상 서버
- S3: 객체 스토리지
- RDS: 관계형 데이터베이스
- Lambda: 서버리스 컴퓨팅

**실무 경험**
온프레미스에서 AWS로 마이그레이션하여 서버 관리 부담을 90% 줄이고, Auto Scaling으로 트래픽 급증 시 자동 대응하여 서비스 안정성을 확보했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0015-000000000000';

UPDATE questions SET explanation =
$md$
**EC2 (Elastic Compute Cloud)**
가상 서버를 제공하는 서비스로, 원하는 사양의 서버를 몇 분 만에 생성하고 사용할 수 있습니다.

**주요 특징**
- 다양한 인스턴스 타입 (CPU, 메모리, 스토리지 조합)
- Linux, Windows 등 여러 OS 지원
- Auto Scaling으로 자동 확장/축소
- 온디맨드, 예약, Spot 인스턴스 등 다양한 요금제

**사용 사례**
- 웹 애플리케이션 서버
- 데이터 처리 및 분석
- 게임 서버

**예시**
```bash
# t2.micro 인스턴스 생성 (무료 티어)
aws ec2 run-instances --instance-type t2.micro --image-id ami-xxxxx
```

---

**S3 (Simple Storage Service)**
무제한 객체 스토리지 서비스로, 파일을 안전하게 저장하고 웹에서 접근할 수 있습니다.

**주요 특징**
- 무제한 용량
- 99.999999999% (11 nines) 내구성
- 정적 웹사이트 호스팅 가능
- 버전 관리, 수명 주기 정책

**사용 사례**
- 정적 파일 호스팅 (이미지, CSS, JS)
- 백업 및 아카이브
- 데이터 레이크
- CDN(CloudFront)과 연동

**스토리지 클래스**
- Standard: 자주 접근하는 데이터
- Glacier: 아카이브 (저렴하지만 느림)
- Intelligent-Tiering: 자동 최적화

**실무 경험**
사용자 업로드 이미지를 S3에 저장하고 CloudFront로 전 세계에 빠르게 배포했으며, Lifecycle Policy로 30일 이상 된 데이터를 Glacier로 이동하여 비용을 70% 절감했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0015-000000000001';

UPDATE questions SET explanation =
$md$
**리전 (Region)**
AWS 데이터 센터가 위치한 물리적인 지역으로, 전 세계 30개 이상 존재합니다.

**특징**
- 지리적으로 완전히 독립된 위치
- 각 리전은 여러 가용 영역 포함
- 서로 다른 리전은 물리적으로 격리됨

**예시**
- ap-northeast-2 (서울)
- us-east-1 (버지니아 북부)
- eu-west-1 (아일랜드)

**선택 기준**
- 사용자와의 물리적 거리 (지연시간)
- 데이터 주권 및 규제 준수
- 서비스 가용성
- 비용

---

**가용 영역 (Availability Zone, AZ)**
하나의 리전 내에 있는 독립적인 데이터 센터 그룹입니다.

**특징**
- 한 리전에 보통 3개 이상의 AZ
- 각 AZ는 물리적으로 분리 (수 km~수십 km)
- 저지연 네트워크로 연결
- 전력, 냉각, 네트워크 독립적

**예시**
- ap-northeast-2a (서울 AZ-A)
- ap-northeast-2b (서울 AZ-B)
- ap-northeast-2c (서울 AZ-C)
- ap-northeast-2d (서울 AZ-D)

**고가용성 구현**
```
리전: ap-northeast-2 (서울)
  ├─ AZ-A: EC2 인스턴스 1
  ├─ AZ-B: EC2 인스턴스 2
  └─ AZ-C: EC2 인스턴스 3
```

**차이점 비교**
| 구분 | 리전 | 가용 영역 |
|-----|------|---------|
| 범위 | 국가/대륙 | 리전 내 데이터센터 |
| 독립성 | 완전 독립 | 리전 내 부분 독립 |
| 지연시간 | 높음 (ms~수백ms) | 낮음 (1ms 이하) |
| 용도 | 글로벌 배포, DR | 고가용성 |

**실무 경험**
서울 리전의 3개 AZ에 EC2 인스턴스를 분산 배치하여 하나의 AZ 장애 시에도 서비스가 중단되지 않도록 했으며, 글로벌 서비스를 위해 서울, 도쿄, 버지니아 리전에 멀티 리전 배포를 구축했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0015-000000000002';

UPDATE questions SET explanation =
$md$
**확장성 (Scalability)**
트래픽 증가에 따라 리소스를 늘리는 능력입니다.

**수직 확장 (Scale Up)**
- 인스턴스 타입 업그레이드 (t2.micro → t2.large)
- 단순하지만 한계 존재

**수평 확장 (Scale Out)**
- 인스턴스 개수 증가
- Auto Scaling Group 활용
- 무제한 확장 가능

**Auto Scaling**
트래픽에 따라 자동으로 EC2 인스턴스를 추가/제거합니다.
```
CPU 사용률 > 70% → 인스턴스 추가
CPU 사용률 < 30% → 인스턴스 제거
```

---

**고가용성 (High Availability)**
장애 발생 시에도 서비스가 중단되지 않도록 하는 설계입니다.

**구현 방법**

**1. Multi-AZ 배포**
여러 가용 영역에 리소스 분산
```
ELB
 ├─ AZ-A: EC2 (활성)
 ├─ AZ-B: EC2 (활성)
 └─ AZ-C: EC2 (활성)
```

**2. Elastic Load Balancer (ELB)**
- 트래픽을 여러 인스턴스에 분산
- 헬스 체크로 비정상 인스턴스 제외
- Application LB, Network LB, Classic LB

**3. RDS Multi-AZ**
- 자동 페일오버 (30-120초)
- 마스터 장애 시 스탠바이로 전환

**4. Route 53**
- DNS 기반 장애 조치
- 헬스 체크 및 자동 라우팅

**아키텍처 예시**
```
사용자
  ↓
Route 53 (DNS)
  ↓
CloudFront (CDN)
  ↓
ELB (로드 밸런서)
  ├─ AZ-A: EC2 + RDS 마스터
  ├─ AZ-B: EC2 + RDS 스탠바이
  └─ AZ-C: EC2
```

**서비스 조합**
| 목적 | 서비스 |
|-----|--------|
| 확장성 | Auto Scaling, ELB |
| 고가용성 | Multi-AZ, ELB, Route 53 |
| 내구성 | S3, EBS 스냅샷 |

**실무 경험**
Auto Scaling으로 평소 2대에서 피크 시간 10대로 자동 확장하여 비용을 60% 절감했으며, Multi-AZ 배포로 AZ 장애 시에도 서비스 중단 없이 운영했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0015-000000000003';

UPDATE questions SET explanation =
$md$
**RDS (Relational Database Service)**
관리형 관계형 데이터베이스 서비스로, MySQL, PostgreSQL, Oracle 등을 제공합니다.

**특징**
- 자동 백업, 패치, 모니터링
- Multi-AZ로 고가용성 제공
- Read Replica로 읽기 성능 향상
- 수직 확장 (인스턴스 타입 변경)

**장점**
- DB 관리 부담 감소
- ACID 트랜잭션 보장
- 복잡한 쿼리 (JOIN, 집계) 가능
- SQL 표준 사용

**사용 사례**
- 트랜잭션이 중요한 시스템 (금융, 주문)
- 복잡한 관계형 데이터
- 기존 SQL 애플리케이션

---

**DynamoDB**
완전 관리형 NoSQL 데이터베이스로, 키-값 및 문서 데이터를 저장합니다.

**특징**
- 서버리스 (프로비저닝 불필요)
- 무제한 수평 확장
- 밀리초 미만 응답 속도
- 자동 복제 및 백업

**장점**
- 매우 빠른 읽기/쓰기
- 자동 확장 (트래픽 급증 대응)
- 완전 관리형 (운영 부담 제로)
- 저렴한 비용 (작은 규모)

**사용 사례**
- 높은 처리량이 필요한 경우
- 간단한 키-값 조회
- 게임 점수, 세션 저장
- IoT 데이터

**비교**
| 구분 | RDS | DynamoDB |
|-----|-----|----------|
| 타입 | 관계형 (SQL) | NoSQL (키-값) |
| 스키마 | 고정적 | 유연함 |
| 쿼리 | SQL (복잡한 쿼리 가능) | 키 기반 (제한적) |
| 확장 | 수직 확장 (한계 있음) | 수평 확장 (무제한) |
| 트랜잭션 | 강력한 ACID | 제한적 |
| 사용 사례 | 금융, 주문, 복잡한 관계 | 세션, 캐시, IoT |

**선택 기준**
- **RDS 선택**: 복잡한 쿼리, JOIN, 트랜잭션 필수
- **DynamoDB 선택**: 빠른 속도, 대량 트래픽, 단순 조회

**실무 경험**
주문 시스템은 RDS로 트랜잭션 보장을 확보했고, 사용자 세션은 DynamoDB로 빠른 읽기/쓰기를 구현했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0015-000000000004';

UPDATE questions SET explanation =
$md$
**CloudFront란?**
AWS의 CDN(Content Delivery Network) 서비스로, 전 세계 엣지 로케이션을 통해 콘텐츠를 빠르게 배포합니다.

**동작 원리**

**1. 콘텐츠 캐싱**
```
사용자 (서울)
  ↓ 요청
엣지 로케이션 (서울) ← 캐시 없으면
  ↓
오리진 (S3 버지니아) ← 원본 가져옴
  ↓
엣지 로케이션 (캐시 저장)
  ↓ 응답
사용자 (빠른 응답)
```

**2. 캐시 히트**
- 두 번째 요청부터는 엣지에서 즉시 응답
- 오리진 부하 감소
- 지연시간 대폭 감소

**주요 기능**

**1. 글로벌 배포**
- 전 세계 450개 이상의 엣지 로케이션
- 사용자와 가까운 곳에서 콘텐츠 제공

**2. HTTPS 지원**
- SSL/TLS 인증서 무료 제공
- 암호화 통신

**3. 캐시 제어**
- TTL(Time To Live) 설정
- 캐시 무효화 (Invalidation)

**4. 오리진 유형**
- S3 버킷
- EC2 인스턴스
- ELB
- 커스텀 HTTP 서버

**설정 예시**
```
CloudFront Distribution
  ├─ Origin: my-bucket.s3.amazonaws.com
  ├─ Cache Behavior: TTL 86400초 (24시간)
  ├─ SSL Certificate: ACM 인증서
  └─ Edge Locations: 전 세계
```

**장점**
- **빠른 응답 속도**: 엣지에서 제공 (10-50ms)
- **비용 절감**: 오리진 트래픽 감소
- **DDoS 보호**: AWS Shield 기본 제공
- **보안**: SSL/TLS, 서명된 URL/Cookie

**사용 사례**
- 정적 웹사이트 배포
- 동영상 스트리밍
- API 가속화
- 소프트웨어 다운로드

**실무 경험**
S3에 저장된 이미지를 CloudFront로 배포하여 글로벌 사용자의 로딩 속도를 5초에서 0.5초로 단축했으며, S3 데이터 전송 비용을 80% 절감했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0015-000000000005';

UPDATE questions SET explanation =
$md$
**AWS Lambda란?**
서버를 관리하지 않고 코드를 실행할 수 있는 서버리스 컴퓨팅 서비스입니다.

**주요 특징**
- 서버 프로비저닝 불필요
- 자동 확장 (동시 실행 수천 개)
- 실행 시간만큼만 과금 (100ms 단위)
- 이벤트 기반 트리거

**지원 언어**
- Python, Node.js, Java, Go, Ruby, .NET

**동작 방식**
```
이벤트 발생 (예: S3 업로드)
  ↓
Lambda 트리거
  ↓
함수 실행 (코드 실행)
  ↓
결과 반환 또는 다른 서비스 호출
```

**언제 사용하면 좋은가?**

**1. 이벤트 기반 처리**
```python
# S3에 이미지 업로드 시 썸네일 생성
def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    # 이미지 다운로드 → 리사이징 → S3 업로드
```

**2. 스케줄 작업**
```
CloudWatch Events (Cron)
  → Lambda (매일 자정 데이터 백업)
```

**3. API 백엔드**
```
API Gateway → Lambda → DynamoDB
(서버리스 REST API)
```

**4. 데이터 처리**
- 로그 분석
- 실시간 데이터 변환
- ETL 파이프라인

**5. 짧은 작업**
- 최대 15분 실행 제한
- 간단하고 빠른 작업에 적합

**장점**
- **비용 효율**: 실행 시간만 과금, 유휴 시간 무료
- **자동 확장**: 트래픽 급증 시 자동 대응
- **운영 부담 제로**: 서버 관리 불필요
- **빠른 배포**: 코드만 업로드

**단점**
- 실행 시간 제한 (최대 15분)
- 콜드 스타트 지연 (첫 실행 느림)
- 상태 비저장 (stateless)

**요금**
- 월 100만 건 무료 요청
- 월 40만 GB-초 무료 컴퓨팅
- 이후 매우 저렴한 요금

**실무 경험**
사용자 이미지 업로드 시 Lambda로 자동 리사이징하여 EC2 서버 부하를 제거했고, 야간 배치 작업을 Lambda + CloudWatch Events로 대체하여 서버 비용을 100% 절감했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0015-000000000006';

UPDATE questions SET explanation =
$md$
**S3 버킷 정책 (Bucket Policy)**
S3 버킷에 대한 접근 권한을 JSON 형식으로 정의하는 리소스 기반 정책입니다.

**주요 용도**
- 특정 사용자/계정에 접근 권한 부여
- IP 주소 기반 제한
- 퍼블릭 액세스 설정
- 크로스 계정 접근

**정책 예시**

**1. 퍼블릭 읽기 허용**
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "PublicReadGetObject",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::my-bucket/*"
  }]
}
```

**2. 특정 IP만 허용**
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::my-bucket/*",
    "Condition": {
      "IpAddress": {
        "aws:SourceIp": "203.0.113.0/24"
      }
    }
  }]
}
```

**3. CloudFront만 접근 허용**
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {
      "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity"
    },
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::my-bucket/*"
  }]
}
```

**구성 요소**
- **Effect**: Allow 또는 Deny
- **Principal**: 누구에게 (사용자, 계정, 서비스)
- **Action**: 무엇을 (s3:GetObject, s3:PutObject 등)
- **Resource**: 어디에 (버킷 또는 객체 ARN)
- **Condition**: 조건 (IP, 시간 등)

**IAM 정책 vs 버킷 정책**
| 구분 | IAM 정책 | 버킷 정책 |
|-----|---------|---------|
| 부여 대상 | 사용자, 역할 | 버킷 자체 |
| 크로스 계정 | 복잡함 | 간단함 |
| 퍼블릭 액세스 | 불가능 | 가능 |

**주의사항**
- **퍼블릭 액세스는 신중하게**: 민감한 데이터 노출 위험
- **최소 권한 원칙**: 필요한 권한만 부여
- **버킷 정책 검증**: AWS Policy Simulator 사용

**실무 경험**
정적 웹사이트용 S3 버킷에 퍼블릭 읽기 정책을 적용하고, CloudFront OAI로만 접근하도록 제한하여 직접 S3 접근을 차단했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0015-000000000007';

UPDATE questions SET explanation =
$md$
**AWS CloudWatch란?**
AWS 리소스와 애플리케이션을 모니터링하는 서비스로, 메트릭 수집, 로그 관리, 알람 설정 등을 제공합니다.

**주요 기능**

**1. 메트릭 모니터링**
AWS 서비스의 성능 지표를 자동 수집합니다.

**EC2 메트릭**
- CPU 사용률
- 네트워크 입출력
- 디스크 I/O

**RDS 메트릭**
- DB 연결 수
- 쿼리 성능
- 스토리지 사용량

**2. 로그 관리 (CloudWatch Logs)**
애플리케이션 로그를 중앙에서 관리합니다.
```
EC2/Lambda → CloudWatch Logs → 검색/분석/알람
```

**3. 알람 (CloudWatch Alarms)**
메트릭이 임계값을 초과하면 알림을 보냅니다.
```
CPU > 80% → SNS 알림 → Email/SMS
CPU > 90% → Auto Scaling 트리거
```

**4. 대시보드**
- 여러 메트릭을 한 화면에서 시각화
- 커스텀 대시보드 생성 가능

**5. 이벤트 (EventBridge)**
- 스케줄 작업 (Cron)
- 이벤트 기반 자동화

**모니터링 항목**

**인프라**
- EC2: CPU, 메모리, 디스크, 네트워크
- ELB: 요청 수, 응답 시간, 헬스 체크
- RDS: 연결 수, 쿼리 지연시간

**애플리케이션**
- 커스텀 메트릭 (API 호출 수, 주문 수 등)
- 로그 분석 (에러 로그, 접속 로그)

**사용 예시**

**1. 알람 설정**
```
CPU 사용률 > 80% (5분 연속)
  → SNS 주제로 알림
  → 담당자 Email
```

**2. Auto Scaling 연동**
```
ELB RequestCount > 1000 (1분 평균)
  → Auto Scaling 정책 트리거
  → EC2 인스턴스 추가
```

**3. 로그 기반 알람**
```
CloudWatch Logs에서 "ERROR" 패턴 감지
  → 알람 발생
  → SNS 알림
```

**커스텀 메트릭**
```python
import boto3

cloudwatch = boto3.client('cloudwatch')
cloudwatch.put_metric_data(
    Namespace='MyApp',
    MetricData=[{
        'MetricName': 'OrderCount',
        'Value': 100,
        'Unit': 'Count'
    }]
)
```

**실무 경험**
CloudWatch 알람으로 CPU 80% 초과 시 자동 알림을 받아 장애를 사전 예방했으며, 커스텀 메트릭으로 비즈니스 지표(주문 수, 결제 성공률)를 모니터링했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0015-000000000008';

UPDATE questions SET explanation =
$md$
**AWS VPC (Virtual Private Cloud)**
AWS 클라우드에서 논리적으로 격리된 가상 네트워크를 정의하는 서비스입니다.

**주요 기능**
- 완전한 네트워크 제어 (IP 범위, 서브넷, 라우팅)
- 보안 그룹 및 네트워크 ACL로 트래픽 제어
- 인터넷 게이트웨이로 외부 연결
- VPN/Direct Connect로 온프레미스 연결

**VPC 구성**
```
VPC (10.0.0.0/16)
├─ 퍼블릭 서브넷 (10.0.1.0/24) - AZ-A
│  └─ 인터넷 게이트웨이 연결
├─ 프라이빗 서브넷 (10.0.2.0/24) - AZ-A
│  └─ NAT 게이트웨이로 외부 접근
├─ 퍼블릭 서브넷 (10.0.3.0/24) - AZ-B
└─ 프라이빗 서브넷 (10.0.4.0/24) - AZ-B
```

---

**서브넷 (Subnet)**
VPC 내에서 IP 주소 범위를 더 작게 나눈 네트워크 영역입니다.

**왜 필요한가?**

**1. 가용 영역 분리**
각 서브넷은 하나의 AZ에 속하므로, 여러 AZ에 리소스를 분산 배치할 수 있습니다.

**2. 보안 계층 구분**

**퍼블릭 서브넷**
- 인터넷과 직접 통신 가능
- 인터넷 게이트웨이 연결
- 사용 사례: ELB, Bastion Host

**프라이빗 서브넷**
- 인터넷과 직접 통신 불가
- NAT 게이트웨이를 통해 외부 접근
- 사용 사례: EC2 애플리케이션, RDS

**3. 네트워크 트래픽 제어**
서브넷별로 라우팅 테이블과 네트워크 ACL을 다르게 설정할 수 있습니다.

**아키텍처 예시**
```
인터넷
  ↓
인터넷 게이트웨이
  ↓
퍼블릭 서브넷 (ELB)
  ↓
프라이빗 서브넷 (EC2 애플리케이션)
  ↓
프라이빗 서브넷 (RDS)
```

**보안 제어**

**보안 그룹 (Security Group)**
- 인스턴스 레벨 방화벽
- 상태 저장 (Stateful)
- Allow 규칙만 가능

**네트워크 ACL**
- 서브넷 레벨 방화벽
- 상태 비저장 (Stateless)
- Allow/Deny 규칙 모두 가능

**실무 예시**
```
퍼블릭 서브넷 보안 그룹:
  - 인바운드: 80, 443 포트만 허용

프라이빗 서브넷 보안 그룹:
  - 인바운드: 퍼블릭 서브넷에서만 허용
```

**실무 경험**
Multi-AZ VPC에 퍼블릭/프라이빗 서브넷을 분리하여 웹 서버는 퍼블릭, DB는 프라이빗에 배치해 보안을 강화했으며, NAT 게이트웨이로 프라이빗 인스턴스의 안전한 외부 통신을 구현했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0015-000000000009';

UPDATE questions SET explanation =
$md$
**AWS IAM (Identity and Access Management)**
AWS 리소스에 대한 접근을 안전하게 제어하는 서비스로, 사용자, 그룹, 역할, 정책을 관리합니다.

**주요 역할**

**1. 인증 (Authentication)**
- 누가 접근하는지 확인
- 사용자 계정, 액세스 키, MFA

**2. 권한 부여 (Authorization)**
- 무엇을 할 수 있는지 제어
- 정책(Policy)으로 정의

**3. 최소 권한 원칙**
- 필요한 권한만 부여
- 보안 강화

**핵심 구성 요소**

**1. 사용자 (User)**
개별 사용자 계정으로, AWS 콘솔 또는 API 접근 가능합니다.
```
사용자: developer-john
  ├─ 콘솔 비밀번호
  ├─ 액세스 키 (프로그래밍 접근)
  └─ MFA (다중 인증)
```

**2. 그룹 (Group)**
여러 사용자를 묶어서 권한을 일괄 관리합니다.
```
그룹: Developers
  ├─ 사용자: john, jane, tom
  └─ 정책: EC2 읽기, S3 쓰기
```

**3. 역할 (Role)**
임시 자격 증명으로, EC2 인스턴스나 Lambda가 AWS 서비스에 접근할 때 사용합니다.
```
EC2 인스턴스
  → IAM 역할 (S3 읽기 권한)
  → S3 버킷 접근 (액세스 키 불필요)
```

**4. 정책 (Policy)**
JSON 형식으로 권한을 정의합니다.
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::my-bucket/*"
  }]
}
```

**정책 유형**

**관리형 정책**
- AWS 제공: AmazonS3FullAccess
- 사용자 생성: 재사용 가능

**인라인 정책**
- 특정 사용자/역할에만 직접 연결
- 일회성 권한

**실무 시나리오**

**1. 개발자 권한 설정**
```
그룹: Developers
  정책:
    - EC2 인스턴스 시작/중지
    - RDS 읽기 전용
    - S3 특정 버킷 접근
```

**2. EC2에서 S3 접근**
```
IAM 역할 생성 → EC2에 연결 → S3 접근 가능
(액세스 키를 코드에 넣지 않아도 됨)
```

**3. 크로스 계정 접근**
```
계정 A의 사용자 → 계정 B의 역할 → 계정 B의 리소스 접근
```

**보안 모범 사례**
- ✅ 루트 계정 사용 금지 (IAM 사용자 생성)
- ✅ MFA 활성화
- ✅ 최소 권한 원칙
- ✅ 액세스 키 정기 교체
- ✅ 역할 사용 (EC2, Lambda)
- ❌ 액세스 키를 코드에 하드코딩 금지

**실무 경험**
개발/운영 환경별로 IAM 그룹을 분리하여 권한을 관리했고, EC2 인스턴스에 IAM 역할을 부여하여 S3 접근 시 액세스 키 없이 안전하게 접근했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0015-00000000000A';

UPDATE questions SET explanation =
$md$
**로드 밸런서와 오토 스케일링의 협력**

**Elastic Load Balancer (ELB)**
여러 EC2 인스턴스에 트래픽을 분산하고 헬스 체크를 수행합니다.

**Auto Scaling**
트래픽이나 CPU 사용률에 따라 EC2 인스턴스를 자동으로 추가/제거합니다.

---

**협력 방식**

**1. 인스턴스 자동 등록**
```
Auto Scaling이 인스턴스 생성
  ↓
ELB에 자동 등록
  ↓
헬스 체크 통과 후 트래픽 분산 시작
```

**2. 헬스 체크 기반 교체**
```
ELB가 비정상 인스턴스 감지
  ↓
Auto Scaling에 알림
  ↓
Auto Scaling이 새 인스턴스 생성 및 비정상 인스턴스 제거
```

**3. 트래픽 기반 확장**
```
트래픽 증가 → ELB RequestCount 메트릭 상승
  ↓
Auto Scaling 정책 트리거
  ↓
새 인스턴스 추가 → ELB에 자동 등록
  ↓
트래픽 분산으로 부하 감소
```

**아키텍처**
```
사용자
  ↓
ELB (로드 밸런서)
  ├─ EC2-1 (정상)
  ├─ EC2-2 (정상)
  ├─ EC2-3 (비정상) ← 트래픽 차단
  └─ EC2-4 (추가 중) ← Auto Scaling
       ↑
Auto Scaling Group
  - 최소: 2대
  - 최대: 10대
  - 희망: 3대
```

**Auto Scaling 정책 예시**

**타겟 추적 스케일링**
```
CPU 사용률을 50% 유지
  → 50% 초과 시 인스턴스 추가
  → 50% 미만 시 인스턴스 제거
```

**단계별 스케일링**
```
CPU > 70%: 인스턴스 2대 추가
CPU > 90%: 인스턴스 5대 추가
```

**예약 스케일링**
```
평일 09:00: 인스턴스 10대로 확장
평일 18:00: 인스턴스 3대로 축소
```

**헬스 체크**

**ELB 헬스 체크**
- 주기적으로 인스턴스에 요청 전송
- 응답 없으면 비정상으로 판단
- 비정상 인스턴스는 트래픽 분산에서 제외

**Auto Scaling 헬스 체크**
- EC2 상태 체크 (인스턴스 실행 여부)
- ELB 헬스 체크 결과 사용 가능
- 비정상 인스턴스는 자동 종료 및 교체

**실무 시나리오**

**평상시**
```
ELB → [EC2-1, EC2-2] (최소 2대)
```

**트래픽 급증**
```
ELB RequestCount > 1000
  → Auto Scaling 트리거
  → 인스턴스 추가 (EC2-3, EC2-4, EC2-5)
  → ELB → [EC2-1, EC2-2, EC2-3, EC2-4, EC2-5]
```

**트래픽 감소**
```
ELB RequestCount < 300
  → Auto Scaling 축소
  → 인스턴스 제거 (EC2-3, EC2-4, EC2-5 종료)
  → ELB → [EC2-1, EC2-2]
```

**실무 경험**
ELB + Auto Scaling으로 평소 2대에서 피크 시간 15대로 자동 확장하여 서비스 안정성을 확보했고, 비용은 60% 절감했습니다. 헬스 체크로 장애 인스턴스를 자동 교체하여 다운타임을 최소화했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0015-00000000000B';

UPDATE questions SET explanation =
$md$
**데이터베이스 확장 방법**

**수직 확장 (Scale Up)**
인스턴스 타입을 더 강력한 것으로 업그레이드합니다.

**방법**
```
db.t3.small (2GB RAM)
  ↓ 업그레이드
db.t3.large (8GB RAM)
  ↓ 업그레이드
db.r5.xlarge (32GB RAM)
```

**장점**
- 구현이 간단함
- 애플리케이션 코드 변경 불필요
- 트랜잭션 일관성 유지

**단점**
- 확장 한계 존재 (최대 인스턴스 크기)
- 다운타임 발생 (재부팅 필요)
- 비용 증가폭이 큼

**사용 사례**
- 초기 단계 확장
- 읽기/쓰기가 모두 증가
- 관리 부담 최소화

---

**수평 확장 (Scale Out)**
데이터베이스 인스턴스 개수를 늘립니다.

**1. Read Replica (읽기 복제)**
읽기 전용 복제본을 생성하여 읽기 부하를 분산합니다.

**아키텍처**
```
애플리케이션
  ├─ 쓰기 → Master RDS
  └─ 읽기 → Read Replica 1, 2, 3
```

**특징**
- 비동기 복제
- 최대 15개 복제본 (Aurora는 더 많음)
- 읽기 성능 향상
- 쓰기는 여전히 Master만 가능

**2. 샤딩 (Sharding)**
데이터를 여러 DB로 분할합니다.

**예시: 사용자 ID 기반 샤딩**
```
사용자 ID 1~1000   → DB-1
사용자 ID 1001~2000 → DB-2
사용자 ID 2001~3000 → DB-3
```

**장점**
- 쓰기/읽기 모두 확장
- 무제한 확장 가능

**단점**
- 구현 복잡도 높음
- 크로스 샤드 쿼리 어려움
- 애플리케이션 레벨 관리 필요

**3. DynamoDB (NoSQL)**
완전 관리형 무제한 수평 확장을 제공합니다.

**특징**
- 자동 파티셔닝
- 수십 테라바이트까지 확장
- 밀리초 응답 속도

---

**RDS 확장 방법 비교**

| 방법 | 읽기 | 쓰기 | 복잡도 | 비용 |
|-----|------|------|--------|------|
| 수직 확장 | ✓ | ✓ | 낮음 | 높음 |
| Read Replica | ✓✓ | ✗ | 낮음 | 중간 |
| 샤딩 | ✓✓ | ✓✓ | 높음 | 높음 |
| DynamoDB | ✓✓✓ | ✓✓✓ | 낮음 | 변동 |

**실무 전략**

**1단계: Read Replica**
```
읽기 부하 증가 시
  → Read Replica 추가
  → 읽기 트래픽 분산
```

**2단계: 수직 확장**
```
쓰기 부하 증가 시
  → Master 인스턴스 타입 업그레이드
```

**3단계: 샤딩 또는 NoSQL**
```
수직 확장 한계 도달
  → DynamoDB 마이그레이션
  → 또는 샤딩 구현
```

**Aurora의 자동 확장**
```
Aurora
  ├─ Writer: 1개 (쓰기)
  └─ Reader: 0~15개 (자동 확장)
```
- Auto Scaling으로 Reader 자동 추가/제거
- 완전 관리형 수평 확장

**실무 경험**
읽기 트래픽이 80%인 서비스에서 Read Replica 3개를 추가하여 Master 부하를 75% 감소시켰고, 쓰기 성능이 한계에 도달한 서비스는 DynamoDB로 마이그레이션하여 무제한 확장을 구현했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0015-00000000000C';

UPDATE questions SET explanation =
$md$
**CloudFormation**
AWS가 제공하는 IaC(Infrastructure as Code) 도구로, AWS 리소스를 YAML/JSON 템플릿으로 정의하고 프로비저닝합니다.

**특징**
- AWS 네이티브 서비스
- AWS 서비스와 긴밀한 통합
- 무료 (리소스 비용만 발생)
- Change Set으로 변경 사항 미리 확인

**예시**
```yaml
Resources:
  MyEC2Instance:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: ami-12345678
      InstanceType: t2.micro
  MyS3Bucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: my-bucket
```

**장점**
- AWS 서비스 최신 기능 즉시 지원
- AWS 콘솔과 통합
- 드리프트 감지 (실제 리소스와 템플릿 비교)

**단점**
- AWS 전용 (멀티 클라우드 불가)
- JSON/YAML 문법이 복잡함
- 상태 관리가 AWS에 종속

---

**Terraform**
HashiCorp가 제공하는 오픈소스 IaC 도구로, 멀티 클라우드를 지원합니다.

**특징**
- 클라우드 중립적 (AWS, Azure, GCP, Kubernetes)
- HCL 언어 사용 (가독성 좋음)
- 로컬 상태 파일 또는 원격 백엔드

**예시**
```hcl
provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "data" {
  bucket = "my-bucket"
}
```

**장점**
- 멀티 클라우드 지원
- HCL 언어가 직관적
- 모듈로 재사용 가능
- 커뮤니티 활발 (Terraform Registry)

**단점**
- AWS 최신 기능 지원이 느릴 수 있음
- 상태 파일 관리 필요

---

**비교**

| 구분 | CloudFormation | Terraform |
|-----|---------------|-----------|
| 제공자 | AWS | HashiCorp |
| 언어 | YAML/JSON | HCL |
| 멀티 클라우드 | ✗ (AWS만) | ✓ (AWS, Azure, GCP 등) |
| 비용 | 무료 | 무료 (Enterprise 유료) |
| 상태 관리 | AWS 관리 | 로컬/원격 백엔드 |
| AWS 최신 기능 | 즉시 지원 | 약간 지연 |
| 러닝 커브 | 높음 | 중간 |
| 사용 사례 | AWS 전용 인프라 | 멀티 클라우드 |

**선택 기준**

**CloudFormation 선택**
- AWS만 사용하는 경우
- AWS 서비스와 긴밀한 통합 필요
- AWS 콘솔 사용 선호

**Terraform 선택**
- 멀티 클라우드 환경
- HCL 언어 선호
- 커뮤니티 모듈 활용

**워크플로우 비교**

**CloudFormation**
```
템플릿 작성 (YAML)
  → CloudFormation 스택 생성
  → AWS가 리소스 프로비저닝
  → 변경 시 스택 업데이트
```

**Terraform**
```
코드 작성 (HCL)
  → terraform plan (변경 사항 확인)
  → terraform apply (적용)
  → 상태 파일 업데이트
```

**실무 경험**
AWS 전용 프로젝트는 CloudFormation으로 인프라를 코드화했고, 멀티 클라우드 환경에서는 Terraform으로 AWS/GCP를 통합 관리하여 일관된 배포 프로세스를 구축했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0015-00000000000D';

UPDATE questions SET explanation =
$md$
**AWS 비용 최적화 방법**

**1. 적절한 인스턴스 타입 선택**

**Right Sizing**
- 과도한 스펙 제거
- CloudWatch 모니터링으로 실제 사용량 확인
- CPU 평균 10% 이하면 다운사이징

**인스턴스 타입**
- 범용: t3, t4g (버스터블, 저렴)
- 컴퓨팅 최적화: c5, c6g
- 메모리 최적화: r5, r6g
- Graviton (ARM): 20% 저렴

---

**2. 예약 인스턴스 & Savings Plans**

**예약 인스턴스 (RI)**
- 1년/3년 약정으로 최대 72% 할인
- 예측 가능한 워크로드에 적합

**Savings Plans**
- 시간당 사용량 약정
- 더 유연함 (인스턴스 패밀리 변경 가능)

**Spot 인스턴스**
- 최대 90% 할인
- 중단 가능한 워크로드 (배치, 빅데이터)

---

**3. Auto Scaling 활용**
```
트래픽 낮을 때: 최소 2대
트래픽 높을 때: 최대 10대
  → 평균 4대만 실행
  → 60% 비용 절감
```

---

**4. S3 스토리지 클래스 최적화**

**Lifecycle 정책**
```
생성 후 30일: Standard
생성 후 90일: Standard-IA (저렴)
생성 후 180일: Glacier (매우 저렴)
생성 후 365일: Deep Archive
```

**Intelligent-Tiering**
- 자동으로 최적 클래스 전환
- 접근 패턴에 따라 비용 절감

---

**5. 미사용 리소스 정리**

**정기 점검**
- 중지된 EC2 인스턴스 (EBS 비용 발생)
- 미사용 EBS 볼륨
- 오래된 스냅샷
- 미사용 Elastic IP
- 미사용 로드 밸런서

**예시**
```bash
# 미사용 EBS 볼륨 찾기
aws ec2 describe-volumes --filters Name=status,Values=available
```

---

**6. 데이터 전송 비용 줄이기**

**CloudFront 사용**
- S3 다이렉트 접근보다 저렴
- 엣지 캐싱으로 오리진 트래픽 감소

**VPC 엔드포인트**
- S3/DynamoDB 접근 시 인터넷 경유 안 함
- 데이터 전송 비용 제로

**리전 간 전송 최소화**
- 같은 리전 내에서 통신
- 리전 간 전송은 비용 발생

---

**7. 서버리스 활용**

**Lambda**
- 실행 시간만 과금
- 유휴 서버 비용 제로

**DynamoDB On-Demand**
- 사용량에 따라 자동 과금
- 예측 불가능한 워크로드

---

**8. 예산 및 알람 설정**

**AWS Budgets**
```
월 예산: $1000
  → $800 도달 시 알림
  → $1000 도달 시 긴급 알림
```

**Cost Explorer**
- 비용 분석 및 예측
- 태그별 비용 확인

---

**9. 태그 전략**

**리소스 태그**
```
Environment: Production
Team: Backend
Project: WebApp
```
- 팀/프로젝트별 비용 추적
- 불필요한 리소스 식별

---

**10. 개발/테스트 환경 관리**

**자동 시작/중지**
```
평일 09:00: 개발 서버 시작
평일 18:00: 개발 서버 중지
주말: 전체 중지
  → 50% 비용 절감
```

**작은 인스턴스 사용**
- Production: t3.large
- Development: t3.small

---

**비용 최적화 체크리스트**
- [ ] Right Sizing (적정 크기 인스턴스)
- [ ] 예약 인스턴스 / Savings Plans
- [ ] Spot 인스턴스 활용
- [ ] Auto Scaling 설정
- [ ] S3 Lifecycle 정책
- [ ] 미사용 리소스 정리
- [ ] CloudFront 사용
- [ ] Lambda/서버리스 검토
- [ ] 예산 알람 설정
- [ ] 태그 전략 수립

**실무 경험**
S3 Lifecycle Policy로 오래된 데이터를 Glacier로 이동하여 월 $500 절감했고, 개발 서버를 업무 시간에만 실행하여 EC2 비용을 50% 줄였으며, Spot 인스턴스로 배치 작업 비용을 80% 절감했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0015-00000000000E';

UPDATE questions SET explanation =
$md$
**AWS Well-Architected 프레임워크**
AWS가 제공하는 클라우드 아키텍처 설계 모범 사례로, 5가지(또는 6가지) 핵심 기둥(Pillar)로 구성됩니다.

**5가지 핵심 기둥**

**1. 운영 우수성 (Operational Excellence)**
시스템을 효과적으로 운영하고 지속적으로 개선하는 능력

**핵심 원칙**
- 코드로 운영 (IaC: CloudFormation, Terraform)
- 자동화 (CI/CD 파이프라인)
- 작은 단위로 자주 배포
- 장애 예측 및 학습
- 모니터링 및 로깅 (CloudWatch)

**예시**
- 인프라를 코드로 관리
- 자동화된 배포 파이프라인
- 정기적인 게임 데이 (장애 시뮬레이션)

---

**2. 보안 (Security)**
데이터와 시스템을 보호하는 능력

**핵심 원칙**
- 강력한 자격 증명 기반 (IAM, MFA)
- 추적 가능성 (CloudTrail, CloudWatch Logs)
- 모든 계층에 보안 적용
- 데이터 암호화 (전송 중, 저장 시)
- 최소 권한 원칙

**예시**
- IAM 역할로 최소 권한 부여
- S3 암호화, RDS 암호화
- VPC로 네트워크 격리
- WAF로 웹 공격 차단

---

**3. 안정성 (Reliability)**
장애를 복구하고 수요를 충족하는 능력

**핵심 원칙**
- 장애 자동 복구 (Auto Scaling, ELB)
- Multi-AZ 배포
- 수평 확장
- 자동 백업 (RDS 스냅샷)
- 장애 테스트 (Chaos Engineering)

**예시**
- Multi-AZ RDS로 자동 페일오버
- ELB + Auto Scaling으로 고가용성
- S3로 99.999999999% 내구성

---

**4. 성능 효율성 (Performance Efficiency)**
리소스를 효율적으로 사용하여 요구사항을 충족하는 능력

**핵심 원칙**
- 적절한 기술 선택 (EC2, Lambda, ECS)
- 글로벌 배포 (CloudFront, 멀티 리전)
- 서버리스 아키텍처 (Lambda, DynamoDB)
- 실험 및 최적화
- 기술 발전에 따른 업그레이드

**예시**
- CloudFront로 CDN 캐싱
- ElastiCache로 DB 부하 감소
- Lambda로 서버 관리 제거

---

**5. 비용 최적화 (Cost Optimization)**
불필요한 비용을 제거하고 최소 비용으로 목표를 달성하는 능력

**핵심 원칙**
- 사용한 만큼만 지불
- 리소스 사용량 측정 (Cost Explorer)
- 예약 인스턴스, Spot 인스턴스
- 적절한 서비스 선택
- 지속적인 최적화

**예시**
- Auto Scaling으로 유휴 리소스 제거
- S3 Lifecycle으로 스토리지 비용 절감
- Right Sizing으로 인스턴스 최적화

---

**(6번째 기둥) 지속 가능성 (Sustainability)**
환경 영향을 최소화하는 능력 (최근 추가됨)

**핵심 원칙**
- 탄소 발자국 최소화
- Graviton (ARM) 프로세서 사용
- 서버리스로 효율성 향상

---

**Well-Architected Tool**
AWS 콘솔에서 제공하는 무료 도구로, 아키텍처를 5가지 기둥으로 평가하고 개선 사항을 제안합니다.

**사용 흐름**
```
워크로드 정의
  ↓
질문에 답변 (각 기둥별)
  ↓
위험 요소 식별 (High/Medium Risk)
  ↓
개선 계획 수립
```

**실무 적용**
모든 AWS 아키텍처 설계 시 5가지 기둥을 기준으로 점검하여 균형 잡힌 시스템을 구축합니다.

**실무 경험**
Well-Architected Review를 통해 보안 취약점(IAM 과도한 권한)을 발견하여 최소 권한으로 개선했고, 비용 최적화를 통해 월 $1000 절감했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0015-00000000000F';

UPDATE questions SET explanation =
$md$
**AWS 서비스 간 통합: S3 이벤트로 Lambda 트리거**

**동작 원리**
S3 버킷에 파일이 업로드되면 자동으로 Lambda 함수가 실행됩니다.

**아키텍처**
```
사용자
  ↓ 파일 업로드
S3 버킷
  ↓ 이벤트 발생 (PutObject)
Lambda 트리거
  ↓ 함수 실행
Lambda 함수 (이미지 리사이징, 로그 처리 등)
  ↓
결과 저장 (S3, DynamoDB 등)
```

---

**설정 방법**

**1. Lambda 함수 생성**
```python
import boto3
import os
from PIL import Image

s3 = boto3.client('s3')

def lambda_handler(event, context):
    # S3 이벤트에서 버킷과 키 추출
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    # 파일 다운로드
    download_path = '/tmp/original.jpg'
    s3.download_file(bucket, key, download_path)

    # 이미지 리사이징
    image = Image.open(download_path)
    image.thumbnail((200, 200))

    # 썸네일 업로드
    upload_path = '/tmp/thumbnail.jpg'
    image.save(upload_path)
    s3.upload_file(upload_path, bucket, f'thumbnails/{key}')

    return {'statusCode': 200}
```

**2. S3 버킷 이벤트 알림 설정**
```
S3 버킷 → Properties → Event Notifications
  ├─ Event types: PUT (객체 생성)
  ├─ Prefix: images/ (특정 폴더만)
  ├─ Suffix: .jpg (확장자 필터)
  └─ Destination: Lambda 함수
```

**3. Lambda IAM 역할 설정**
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "s3:GetObject",
      "s3:PutObject"
    ],
    "Resource": "arn:aws:s3:::my-bucket/*"
  }]
}
```

---

**이벤트 유형**

**S3 이벤트**
- s3:ObjectCreated:* (모든 생성)
- s3:ObjectCreated:Put (PUT 업로드)
- s3:ObjectCreated:Post (POST 업로드)
- s3:ObjectRemoved:* (삭제)

---

**다른 서비스 간 통합 예시**

**1. DynamoDB Streams → Lambda**
```
DynamoDB 테이블 변경 (INSERT/UPDATE/DELETE)
  → DynamoDB Streams
  → Lambda 트리거
  → 실시간 데이터 처리 (알림, 동기화)
```

**2. SQS → Lambda**
```
SQS 큐에 메시지 도착
  → Lambda 자동 폴링
  → 메시지 처리
  → 큐에서 삭제
```

**3. CloudWatch Events → Lambda**
```
Cron 스케줄 (매일 자정)
  → CloudWatch Events
  → Lambda 트리거
  → 배치 작업 실행
```

**4. API Gateway → Lambda**
```
HTTP 요청 (POST /users)
  → API Gateway
  → Lambda 함수
  → DynamoDB 저장
  → HTTP 응답
```

**5. SNS → Lambda**
```
SNS 주제에 메시지 발행
  → Lambda 구독
  → 함수 실행 (이메일 전송, 알림 처리)
```

---

**실무 사용 사례**

**1. 이미지 썸네일 자동 생성**
```
사용자 → S3 업로드 → Lambda (리사이징) → S3 저장
```

**2. 로그 실시간 분석**
```
애플리케이션 → CloudWatch Logs → Lambda (필터링) → DynamoDB
```

**3. 파일 처리 파이프라인**
```
S3 업로드 → Lambda (검증) → SQS → Lambda (변환) → S3 저장
```

**4. 서버리스 API**
```
클라이언트 → API Gateway → Lambda → DynamoDB → 응답
```

---

**장점**
- **완전 자동화**: 수동 개입 불필요
- **서버리스**: 서버 관리 제로
- **확장성**: 동시 수천 건 처리
- **비용 효율**: 실행 시간만 과금

**실무 경험**
사용자 프로필 이미지 업로드 시 S3 이벤트로 Lambda를 트리거하여 자동으로 3가지 크기의 썸네일을 생성했고, CSV 파일 업로드 시 Lambda로 파싱하여 DynamoDB에 자동 저장하는 파이프라인을 구축했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0015-000000000010';

UPDATE questions SET explanation =
$md$
**다중 계정 운영 고려사항**

**왜 다중 계정을 사용하나?**
- 환경 격리 (개발/스테이징/프로덕션)
- 보안 강화 (계정 레벨 격리)
- 비용 관리 (팀/프로젝트별 분리)
- 규제 준수 (데이터 주권)

---

**AWS Organizations**
여러 AWS 계정을 중앙에서 관리하는 서비스입니다.

**구조**
```
마스터 계정 (루트)
├─ OU: Production
│  ├─ 프로덕션 계정 1
│  └─ 프로덕션 계정 2
├─ OU: Development
│  ├─ 개발 계정 1
│  └─ 개발 계정 2
└─ OU: Security
   └─ 보안/감사 계정
```

---

**주요 고려사항**

**1. 계정 구조 설계**

**환경별 분리**
```
Dev 계정: 개발 환경
Staging 계정: 스테이징 환경
Prod 계정: 프로덕션 환경
```

**팀별 분리**
```
Backend 팀 계정
Frontend 팀 계정
Data 팀 계정
```

**워크로드별 분리**
```
웹 애플리케이션 계정
데이터 파이프라인 계정
ML/AI 계정
```

---

**2. 통합 결제 (Consolidated Billing)**
모든 계정의 비용을 마스터 계정에서 통합 관리합니다.

**장점**
- 한 곳에서 모든 비용 확인
- 볼륨 할인 적용 (사용량 합산)
- 계정별 비용 추적

---

**3. 크로스 계정 접근 (IAM Role)**
다른 계정의 리소스에 안전하게 접근합니다.

**예시**
```
개발자 (Dev 계정)
  → AssumeRole
  → Prod 계정의 IAM 역할
  → Prod 리소스 접근 (읽기 전용)
```

**설정**
```json
// Prod 계정의 신뢰 정책
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {
      "AWS": "arn:aws:iam::DEV-ACCOUNT-ID:root"
    },
    "Action": "sts:AssumeRole"
  }]
}
```

---

**4. Service Control Policies (SCP)**
OU 또는 계정에 적용하는 권한 경계입니다.

**예시: 특정 리전만 허용**
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Deny",
    "Action": "*",
    "Resource": "*",
    "Condition": {
      "StringNotEquals": {
        "aws:RequestedRegion": ["ap-northeast-2", "us-east-1"]
      }
    }
  }]
}
```

**예시: Dev 계정에서 프로덕션 리소스 삭제 금지**
```json
{
  "Effect": "Deny",
  "Action": [
    "rds:DeleteDBInstance",
    "s3:DeleteBucket"
  ],
  "Resource": "*"
}
```

---

**5. 중앙화된 로그 관리**

**아키텍처**
```
모든 계정 (Dev, Staging, Prod)
  → CloudTrail, CloudWatch Logs
  → 중앙 로그 계정 (S3)
  → 감사 및 분석
```

---

**6. 네트워크 설계**

**Transit Gateway**
여러 VPC를 중앙에서 연결합니다.
```
Transit Gateway (허브)
  ├─ Dev VPC
  ├─ Staging VPC
  └─ Prod VPC
```

**VPC Peering**
두 VPC를 1:1로 연결합니다.

---

**7. 보안 모범 사례**

**마스터 계정 보호**
- 최소한의 사용자만 접근
- MFA 필수
- 일상적인 작업에 사용 금지

**각 계정 분리**
- Dev 계정 침해 시 Prod 영향 최소화
- 최소 권한 원칙

**감사 계정**
- 모든 CloudTrail 로그 수집
- Config로 규정 준수 확인
- GuardDuty로 위협 탐지

---

**8. 자동화 및 표준화**

**AWS Control Tower**
- 자동으로 계정 프로비저닝
- 가드레일로 정책 자동 적용
- 랜딩 존 설정

**CloudFormation StackSets**
- 여러 계정에 동일한 인프라 배포
- 중앙에서 관리

---

**실무 아키텍처 예시**
```
AWS Organizations
├─ 마스터 계정 (결제, Organizations 관리)
├─ Security 계정 (CloudTrail, GuardDuty, Config)
├─ Shared Services 계정 (Transit Gateway, Directory)
├─ Prod OU
│  └─ Production 계정 (프로덕션 워크로드)
├─ Non-Prod OU
│  ├─ Dev 계정
│  └─ Staging 계정
└─ Sandbox OU
   └─ 개발자 개인 계정 (실험용)
```

---

**체크리스트**
- [ ] 계정 구조 설계 (환경/팀/워크로드)
- [ ] AWS Organizations 설정
- [ ] 통합 결제 구성
- [ ] SCP로 가드레일 적용
- [ ] 크로스 계정 IAM 역할 설정
- [ ] 중앙 로그 수집 (CloudTrail, Config)
- [ ] Transit Gateway 또는 VPC Peering
- [ ] 자동화 (CloudFormation StackSets)

**실무 경험**
Dev/Staging/Prod 계정을 분리하여 개발 중 실수로 프로덕션 DB를 삭제하는 사고를 원천 차단했고, SCP로 특정 리전만 허용하여 의도치 않은 리전 사용을 방지했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0015-000000000011';

-- 나머지 질문들은 글자 수 제한으로 인해 다음 파일에 계속...
