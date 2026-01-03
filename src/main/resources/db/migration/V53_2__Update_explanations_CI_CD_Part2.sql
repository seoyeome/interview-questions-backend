-- V53_2: Update explanations for CI/CD questions (Part 2: Questions 10-18)

-- Question 10 (0xA): CI 도구를 선택할 때 고려사항은?
UPDATE questions SET explanation =
'**CI 도구 선택 시 고려사항**

**1. 비용**

| 도구 | 비용 모델 | 적합한 경우 |
|------|----------|-----------|
| **Jenkins** | 무료 (인프라 비용만) | 자체 서버 보유, 비용 절감 우선 |
| **GitHub Actions** | 2000분/월 무료 | GitHub 사용, 소규모 프로젝트 |
| **GitLab CI/CD** | 400분/월 무료 | GitLab 사용, 통합 환경 선호 |
| **CircleCI** | 30000크레딧/월 무료 | 대규모 프로젝트, 병렬 처리 중요 |

**2. 통합 및 호환성**

**버전 관리 시스템 통합**
- GitHub → GitHub Actions (완벽한 통합)
- GitLab → GitLab CI/CD (Built-in)
- 다양한 VCS → Jenkins (플러그인 지원)

**기술 스택 지원**
```yaml
# 다양한 언어 지원 예시
jobs:
  test-java:
    uses: actions/setup-java@v3

  test-node:
    uses: actions/setup-node@v3

  test-python:
    uses: actions/setup-python@v3
```

**3. 러닝 커브 및 유지보수**

**난이도 비교**
```
쉬움 ←―――――――――――――――――――→ 어려움
GitHub Actions   CircleCI   Jenkins
(YAML)          (YAML)     (Groovy + UI)
```

**4. 확장성 및 성능**

**병렬 처리 능력**
```yaml
# GitHub Actions - Matrix 빌드
strategy:
  matrix:
    os: [ubuntu, macos, windows]
    node: [14, 16, 18]
# 총 9개 job 동시 실행
```

**분산 빌드**
```
Jenkins Master-Agent:
Master (조율)
  ├─ Agent 1 (10 jobs)
  ├─ Agent 2 (10 jobs)
  └─ Agent 3 (10 jobs)
```

**5. 보안**

**Secrets 관리**
- GitHub Actions: GitHub Secrets
- GitLab CI/CD: GitLab Variables
- Jenkins: Credentials Plugin

**격리 수준**
- 컨테이너 기반 (Docker)
- VM 기반 (더 높은 격리)

**6. 커뮤니티 및 생태계**

**플러그인/Actions 수**
- Jenkins: 2000+
- GitHub Actions: 20000+
- GitLab CI: Built-in features

**7. 클라우드 vs 온프레미스**

| 요구사항 | 추천 도구 |
|---------|---------|
| 클라우드 선호, 관리 최소화 | GitHub Actions, CircleCI |
| 온프레미스 필수 (보안/규제) | Jenkins, GitLab CI (self-hosted) |
| 하이브리드 | Jenkins, GitLab CI |

**실무 의사결정 예시**

**케이스 1: 스타트업**
- 선택: GitHub Actions
- 이유: 무료 티어, 빠른 설정, GitHub 통합

**케이스 2: 대기업**
- 선택: Jenkins
- 이유: 온프레미스 가능, 완전한 커스터마이징, 규제 준수

**케이스 3: DevOps 팀**
- 선택: GitLab CI/CD
- 이유: Git + CI/CD + Container Registry 통합

**실무 경험**
프로젝트 초기에는 GitHub Actions로 빠르게 시작했고, 프로젝트가 커지면서 빌드 시간이 길어져 Jenkins로 마이그레이션했습니다. 온프레미스 Jenkins로 전환 후 빌드 비용이 70% 절감되었고, 복잡한 파이프라인 커스터마이징이 가능해졌습니다.'

WHERE id = 'b0000000-0000-0000-0016-00000000000A';

-- Question 11 (0xB): CI/CD 도입 시 나타날 수 있는 도전과제는 무엇인가요?
UPDATE questions SET explanation =
'**CI/CD 도입 시 주요 도전과제**

**1. 레거시 코드베이스**

**문제점:**
- 테스트 코드 부족
- 복잡한 의존성
- 수동 빌드 프로세스

**해결 방법:**
```
1단계: 기본 CI 구축 (빌드만)
  ↓
2단계: 간단한 테스트 추가
  ↓
3단계: 통합 테스트 추가
  ↓
4단계: 배포 자동화
```

**2. 느린 빌드 시간**

**문제:**
```
전체 빌드: 60분
  ├─ 빌드: 10분
  ├─ 테스트: 45분
  └─ 배포: 5분
→ 하루 2-3회만 빌드 가능
```

**해결 방법:**
```yaml
# 병렬 테스트 실행
jobs:
  test:
    strategy:
      matrix:
        shard: [1, 2, 3, 4, 5]
    steps:
      - run: npm test --shard=${{ matrix.shard }}/5

# 캐시 활용
- uses: actions/cache@v3
  with:
    path: ~/.gradle/caches
    key: gradle-${{ hashFiles('**/*.gradle*') }}

# 45분 → 10분으로 단축
```

**3. 테스트 불안정성 (Flaky Tests)**

**문제:**
```
같은 코드인데:
  ✓ 첫 번째 실행: 성공
  ✗ 두 번째 실행: 실패
  ✓ 세 번째 실행: 성공
→ 파이프라인 신뢰도 하락
```

**해결 방법:**
- 타이밍 의존성 제거
- 외부 API 모킹
- 독립적인 테스트 작성
- 실패 시 재시도 (최대 3회)

```yaml
- name: Run tests
  run: npm test
  retry:
    max_attempts: 3
    command: npm test
```

**4. 조직 문화 및 저항**

**흔한 반대 의견:**
- "우리는 항상 수동으로 해왔어요"
- "CI/CD 구축할 시간이 없어요"
- "기존 방식이 더 안전해요"

**해결 전략:**
```
1. 작은 프로젝트부터 시작 (성공 사례 만들기)
2. 숫자로 증명:
   - 배포 시간: 2시간 → 10분
   - 버그 발견: 3일 후 → 즉시
   - 배포 빈도: 주 1회 → 일 5회
3. 점진적 도입 (CI만, 그 다음 CD)
```

**5. 환경 불일치**

**문제:**
```
로컬: Java 11, Ubuntu 20.04
CI: Java 17, Ubuntu 22.04
프로덕션: Java 11, RHEL 8
→ "내 로컬에서는 됐는데" 문제
```

**해결 방법:**
```dockerfile
# Docker로 환경 통일
FROM openjdk:11-jre-slim
COPY build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]

# 로컬, CI, 프로덕션 모두 동일 환경
```

**6. 시크릿 관리**

**문제:**
- API 키, 비밀번호를 어디에 저장?
- 개발자 접근 제어

**해결 방법:**
```yaml
# GitHub Secrets 사용
- name: Deploy
  env:
    AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
    AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
  run: aws s3 sync ./build s3://my-bucket

# 또는 Vault 사용
vault kv get -field=api_key secret/app/api_key
```

**7. 비용 관리**

**문제:**
```
GitHub Actions:
- 공개 저장소: 무료
- 비공개: 2000분/월 → 초과 시 $0.008/분
→ 월 10000분 사용 시 $64
```

**해결 방법:**
- Self-hosted runners 사용
- 불필요한 빌드 최소화 (특정 경로만 트리거)
- 빌드 시간 최적화

```yaml
on:
  push:
    paths:
      - 'src/**'
      - 'build.gradle'
# docs 변경 시에는 빌드 안 함
```

**8. 마이크로서비스 복잡도**

**문제:**
```
10개 서비스:
  ├─ 각각 빌드/테스트/배포
  ├─ 서비스 간 의존성
  └─ 순서 관리
```

**해결 방법:**
```yaml
# Monorepo + 변경 감지
jobs:
  detect-changes:
    outputs:
      user-service: ${{ steps.filter.outputs.user-service }}
      order-service: ${{ steps.filter.outputs.order-service }}

  build-user-service:
    needs: detect-changes
    if: needs.detect-changes.outputs.user-service == 'true'
    runs-on: ubuntu-latest
    # user-service 변경 시에만 빌드
```

**실무 경험**
CI/CD 도입 초기에 빌드 시간이 60분으로 너무 길어 개발자들이 불만을 가졌습니다. 테스트를 5개 샤드로 병렬화하고 Gradle 캐시를 적용하여 15분으로 단축했고, 이후 팀 전체가 CI/CD의 가치를 인정하게 되었습니다.'

WHERE id = 'b0000000-0000-0000-0016-00000000000B';

-- Question 12 (0xC): 배포 자동화를 위해 어떤 전략이나 도구를 사용해봤나요?
UPDATE questions SET explanation =
'**배포 자동화 전략 및 도구**

**1. 배포 전략**

**Blue-Green 배포**
```
[Blue: v1.0 (현재)]
  ↓ v2.0 배포
[Blue: v1.0] [Green: v2.0 (신규)]
  ↓ 트래픽 전환
[Blue: v1.0 (대기)] [Green: v2.0 (활성)]
  ↓ 문제 없으면
[Green: v2.0만 유지]
```

**구현 예시 (Kubernetes):**
```yaml
# 기존 Service는 Blue를 가리킴
apiVersion: v1
kind: Service
metadata:
  name: myapp
spec:
  selector:
    app: myapp
    version: blue

# Green 배포 생성
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-green
spec:
  template:
    metadata:
      labels:
        app: myapp
        version: green

# 트래픽 전환 (Service selector 변경)
kubectl patch service myapp -p '{"spec":{"selector":{"version":"green"}}}'
```

**Canary 배포**
```
v1.0 (100%)
  ↓
v1.0 (95%) + v2.0 (5%)  ← 소수 사용자에게 테스트
  ↓ 문제 없으면
v1.0 (50%) + v2.0 (50%)
  ↓
v2.0 (100%)
```

**구현 예시 (Istio):**
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: myapp
spec:
  http:
  - match:
    - headers:
        canary:
          exact: "true"
    route:
    - destination:
        host: myapp
        subset: v2
  - route:
    - destination:
        host: myapp
        subset: v1
      weight: 95
    - destination:
        host: myapp
        subset: v2
      weight: 5
```

**Rolling Update**
```
Pod 1 (v1.0) ←――――┐
Pod 2 (v1.0)      │ 순차적으로
Pod 3 (v1.0)      │ v2.0으로 교체
  ↓               │
Pod 1 (v2.0) ←――――┘
Pod 2 (v1.0)
Pod 3 (v1.0)
  ↓
Pod 1 (v2.0)
Pod 2 (v2.0)
Pod 3 (v2.0)
```

**2. 배포 도구**

**Kubernetes (kubectl)**
```bash
# 간단한 배포
kubectl apply -f k8s/

# Rolling update 설정
kubectl set image deployment/myapp myapp=myapp:v2.0

# Rollout 상태 확인
kubectl rollout status deployment/myapp

# 롤백
kubectl rollout undo deployment/myapp
```

**Helm (Kubernetes 패키지 매니저)**
```bash
# Chart 설치
helm install myapp ./myapp-chart

# 업그레이드
helm upgrade myapp ./myapp-chart --set image.tag=v2.0

# 롤백
helm rollback myapp 1
```

**Helm Chart 예시:**
```yaml
# values.yaml
image:
  repository: myapp
  tag: v1.0
  pullPolicy: IfNotPresent

replicaCount: 3

service:
  type: LoadBalancer
  port: 80
```

**ArgoCD (GitOps)**
```yaml
# Application 정의
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp
spec:
  source:
    repoURL: https://github.com/company/k8s-manifests
    path: apps/myapp
    targetRevision: main
  destination:
    server: https://kubernetes.default.svc
    namespace: production
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

**장점:**
- Git = Source of Truth
- 모든 변경사항 추적 가능
- 자동 동기화 및 복구

**3. CI/CD 파이프라인 통합**

**GitHub Actions + Kubernetes**
```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Build Docker image
        run: |
          docker build -t myapp:${{ github.sha }} .
          docker push myapp:${{ github.sha }}

      - name: Deploy to Kubernetes
        run: |
          kubectl set image deployment/myapp myapp=myapp:${{ github.sha }}
          kubectl rollout status deployment/myapp

      - name: Smoke test
        run: |
          curl --fail https://myapp.com/health || kubectl rollout undo deployment/myapp
```

**4. 고급 배포 기법**

**Feature Flags (기능 토글)**
```java
@Service
public class PaymentService {
    @Autowired
    private FeatureFlagService featureFlags;

    public void processPayment() {
        if (featureFlags.isEnabled("new-payment-flow")) {
            // 새 결제 로직 (일부 사용자만)
            processNewPayment();
        } else {
            // 기존 결제 로직
            processOldPayment();
        }
    }
}
```

**배포와 릴리스 분리:**
- 배포: 코드를 프로덕션에 올림 (기능 비활성)
- 릴리스: Feature Flag로 기능 활성화

**5. 배포 모니터링 및 검증**

**헬스 체크**
```yaml
apiVersion: apps/v1
kind: Deployment
spec:
  template:
    spec:
      containers:
      - name: myapp
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
```

**메트릭 기반 자동 롤백**
```yaml
# Flagger (Progressive Delivery)
apiVersion: flagger.app/v1beta1
kind: Canary
spec:
  analysis:
    metrics:
    - name: request-success-rate
      thresholdRange:
        min: 99
    - name: request-duration
      thresholdRange:
        max: 500
  # 메트릭이 임계값 미달 시 자동 롤백
```

**실무 경험**
마이크로서비스 환경에서 ArgoCD를 사용하여 GitOps를 구현했습니다. Git에 Kubernetes manifest를 푸시하면 자동으로 배포되었고, 모든 변경사항이 Git history에 남아 추적이 쉬웠습니다. Canary 배포로 5%의 트래픽부터 점진적으로 확대하여 프로덕션 배포의 안정성을 크게 향상시켰습니다.'

WHERE id = 'b0000000-0000-0000-0016-00000000000C';

-- Question 13 (0xD): 롤백 전략은 CI/CD에서 왜 중요하며 어떻게 구현하나요?
UPDATE questions SET explanation =
'**롤백 전략의 중요성과 구현**

**왜 롤백이 중요한가?**

**1. 빠른 복구**
```
배포 후 장애 발생
  ↓ 롤백 없이
원인 파악 (30분) → 수정 (1시간) → 재배포 (30분)
= 2시간 다운타임

  ↓ 롤백 있으면
즉시 롤백 (2분) → 안정화 → 여유있게 수정
= 2분 다운타임
```

**2. 사용자 영향 최소화**
```
신규 배포 → 버그 발견 → 즉시 롤백
→ 사용자 99%는 버그를 경험하지 않음
```

**롤백 구현 방법**

**1. Kubernetes Rolling Update 롤백**

**기본 롤백:**
```bash
# 배포
kubectl apply -f deployment.yaml

# 문제 발생 시 이전 버전으로 롤백
kubectl rollout undo deployment/myapp

# 특정 리비전으로 롤백
kubectl rollout history deployment/myapp
kubectl rollout undo deployment/myapp --to-revision=3

# 롤백 상태 확인
kubectl rollout status deployment/myapp
```

**자동 롤백 (헬스 체크 기반):**
```yaml
apiVersion: apps/v1
kind: Deployment
spec:
  progressDeadlineSeconds: 600  # 10분 내 배포 완료 안 되면 롤백
  template:
    spec:
      containers:
      - name: myapp
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          failureThreshold: 3  # 3번 실패 시 Pod 재시작
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          failureThreshold: 3  # 3번 실패 시 트래픽 차단
```

**2. Blue-Green 배포 롤백**

```bash
# Green으로 전환
kubectl patch service myapp -p '{"spec":{"selector":{"version":"green"}}}'

# 문제 발생 시 즉시 Blue로 롤백
kubectl patch service myapp -p '{"spec":{"selector":{"version":"blue"}}}'

# 즉시 전환되어 다운타임 거의 없음
```

**3. Database 마이그레이션 롤백**

**문제:**
```
V1: users 테이블
  ↓
V2: email 컬럼 추가
  ↓ 롤백하면?
V1 코드가 email 컬럼을 사용하려다 에러
```

**해결: 하위 호환성 유지**
```sql
-- Migration V2 (email 추가)
ALTER TABLE users ADD COLUMN email VARCHAR(255);

-- Migration V3 (코드 배포 후)
ALTER TABLE users MODIFY COLUMN email VARCHAR(255) NOT NULL;

-- 롤백 시: V3만 롤백하면 V2 상태로 유지 (안전)
```

**Flyway 롤백 예시:**
```sql
-- V1__Create_users.sql
CREATE TABLE users (
    id BIGINT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- V2__Add_email.sql
ALTER TABLE users ADD COLUMN email VARCHAR(255);

-- V2__Add_email.rollback.sql (롤백 스크립트)
ALTER TABLE users DROP COLUMN email;
```

**4. Git 기반 롤백 (GitOps)**

**ArgoCD 롤백:**
```bash
# Git 커밋 히스토리
abc123 - Deploy v2.0 (현재)
def456 - Deploy v1.9
ghi789 - Deploy v1.8

# 이전 버전으로 롤백
git revert abc123
git push

# ArgoCD가 자동으로 이전 상태로 배포
```

**5. Feature Flag 기반 롤백**

**코드 롤백 없이 기능만 비활성화:**
```java
@Service
public class OrderService {
    @Autowired
    private FeatureFlagService flags;

    public void createOrder(Order order) {
        if (flags.isEnabled("new-order-system")) {
            // 새 주문 시스템 (문제 발생 시)
            createOrderV2(order);
        } else {
            // 기존 주문 시스템 (안전)
            createOrderV1(order);
        }
    }
}
```

**문제 발생 시:**
```bash
# 코드 배포나 롤백 없이 즉시 기능 비활성화
curl -X POST https://flags.company.com/api/flags/new-order-system -d '{"enabled": false}'

# 1초 내에 모든 사용자가 안전한 버전 사용
```

**6. 자동 롤백 파이프라인**

**GitHub Actions 예시:**
```yaml
name: Deploy with Auto Rollback

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy new version
        id: deploy
        run: |
          kubectl set image deployment/myapp myapp=myapp:v2.0
          kubectl rollout status deployment/myapp --timeout=5m

      - name: Run smoke tests
        id: smoke
        run: |
          sleep 30
          curl --fail https://myapp.com/health
          curl --fail https://myapp.com/api/status

      - name: Check metrics
        id: metrics
        run: |
          # Prometheus에서 에러율 확인
          ERROR_RATE=$(curl -s 'http://prometheus/api/v1/query?query=rate(http_errors[5m])' | jq '.data.result[0].value[1]')
          if (( $(echo "$ERROR_RATE > 0.01" | bc -l) )); then
            echo "Error rate too high: $ERROR_RATE"
            exit 1
          fi

      - name: Rollback on failure
        if: failure()
        run: |
          echo "Deployment failed, rolling back"
          kubectl rollout undo deployment/myapp
          # Slack 알림
          curl -X POST https://hooks.slack.com/... -d '{"text": "Deployment failed, rolled back to previous version"}'
```

**7. 롤백 테스트**

**정기적인 롤백 훈련:**
```bash
# 매월 1회 롤백 연습
1. 새 버전 배포
2. 의도적으로 롤백 실행
3. 모든 시스템 정상 작동 확인
4. 롤백 시간 측정 및 개선
```

**롤백 체크리스트**
```
□ 애플리케이션 버전 롤백
□ Database 마이그레이션 체크
□ 캐시 무효화
□ CDN 퍼지
□ Feature flags 확인
□ 모니터링 대시보드 확인
□ 롤백 완료 공지
```

**실무 경험**
프로덕션 배포 후 결제 오류가 발생하여 즉시 Kubernetes 롤백을 실행했고, 2분 내에 이전 버전으로 복구하여 피해를 최소화했습니다. 이후 자동 롤백 파이프라인을 구축하여 smoke test 실패 시 자동으로 롤백되도록 개선했고, 배포 안정성이 크게 향상되었습니다.'

WHERE id = 'b0000000-0000-0000-0016-00000000000D';

-- Question 14 (0xE): CI 파이프라인에서 테스트 자동화는 어떻게 구성하나요?
UPDATE questions SET explanation =
'**CI 파이프라인에서 테스트 자동화 구성**

**테스트 피라미드**
```
       /\
      /E2E\        ← 느림, 비쌈, 적은 수
     /______\
    /        \
   /Integration\ ← 중간 속도, 중간 비용
  /____________\
 /              \
/  Unit Tests    \ ← 빠름, 저렴, 많은 수
/________________\
```

**1. Unit Test (단위 테스트)**

**목표: 빠르고 많은 테스트**
```java
@Test
public void testCalculateTotalPrice() {
    OrderService service = new OrderService();
    Order order = new Order();
    order.addItem(new Item(1000, 2));  // 2000원
    order.addItem(new Item(5000, 1));  // 5000원

    assertEquals(7000, service.calculateTotal(order));
}
```

**CI 파이프라인 통합:**
```yaml
# GitHub Actions
- name: Run Unit Tests
  run: ./gradlew test

- name: Upload Test Results
  if: always()
  uses: actions/upload-artifact@v3
  with:
    name: unit-test-results
    path: build/test-results/

- name: Publish Test Report
  uses: dorny/test-reporter@v1
  with:
    name: Unit Tests
    path: build/test-results/**/*.xml
    reporter: java-junit
```

**2. Integration Test (통합 테스트)**

**목표: 컴포넌트 간 상호작용 검증**
```java
@SpringBootTest
@AutoConfigureTestDatabase
class UserServiceIntegrationTest {

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepository userRepository;

    @Test
    void testCreateUser() {
        User user = new User("test@example.com", "password");
        User saved = userService.createUser(user);

        assertNotNull(saved.getId());
        assertTrue(userRepository.findById(saved.getId()).isPresent());
    }
}
```

**CI에서 Database 설정:**
```yaml
# GitHub Actions
services:
  postgres:
    image: postgres:14
    env:
      POSTGRES_DB: testdb
      POSTGRES_USER: test
      POSTGRES_PASSWORD: test
    ports:
      - 5432:5432

steps:
  - name: Run Integration Tests
    env:
      DATABASE_URL: postgresql://test:test@localhost:5432/testdb
    run: ./gradlew integrationTest
```

**3. E2E Test (End-to-End 테스트)**

**목표: 실제 사용자 시나리오 검증**
```javascript
// Playwright 예시
import { test, expect } from '@playwright/test';

test('user can login and view dashboard', async ({ page }) => {
  // 로그인 페이지 이동
  await page.goto('https://myapp.com/login');

  // 로그인
  await page.fill('#email', 'test@example.com');
  await page.fill('#password', 'password123');
  await page.click('button[type="submit"]');

  // 대시보드 확인
  await expect(page).toHaveURL('https://myapp.com/dashboard');
  await expect(page.locator('.welcome')).toContainText('Welcome');
});
```

**CI에서 E2E 테스트:**
```yaml
# GitHub Actions
- name: Run E2E Tests
  run: npx playwright test

- name: Upload Playwright Report
  if: always()
  uses: actions/upload-artifact@v3
  with:
    name: playwright-report
    path: playwright-report/
```

**4. 테스트 병렬 실행**

**문제:**
```
순차 실행:
Unit (5분) + Integration (10분) + E2E (20분) = 35분
```

**해결:**
```yaml
# GitHub Actions - Matrix Strategy
jobs:
  test:
    strategy:
      matrix:
        test-type: [unit, integration, e2e]
    runs-on: ubuntu-latest
    steps:
      - name: Run ${{ matrix.test-type }} tests
        run: ./gradlew ${{ matrix.test-type }}Test

# 병렬 실행: 20분 (가장 긴 E2E 테스트 시간)
```

**5. 테스트 샤딩 (Sharding)**

**큰 테스트 suite 분할:**
```yaml
jobs:
  e2e-test:
    strategy:
      matrix:
        shard: [1, 2, 3, 4]
    runs-on: ubuntu-latest
    steps:
      - name: Run E2E Tests (Shard ${{ matrix.shard }}/4)
        run: npx playwright test --shard=${{ matrix.shard }}/4

# 20분 → 5분으로 단축
```

**6. 코드 커버리지**

**JaCoCo (Java) 예시:**
```groovy
// build.gradle
plugins {
    id 'jacoco'
}

jacoco {
    toolVersion = "0.8.8"
}

test {
    finalizedBy jacocoTestReport
}

jacocoTestReport {
    reports {
        xml.required = true
        html.required = true
    }
}

jacocoTestCoverageVerification {
    violationRules {
        rule {
            limit {
                minimum = 0.80  // 80% 이상 요구
            }
        }
    }
}
```

**CI 통합:**
```yaml
- name: Run Tests with Coverage
  run: ./gradlew test jacocoTestReport

- name: Upload Coverage to Codecov
  uses: codecov/codecov-action@v3
  with:
    files: build/reports/jacoco/test/jacocoTestReport.xml

- name: Check Coverage Threshold
  run: ./gradlew jacocoTestCoverageVerification
```

**7. Flaky Test 관리**

**문제 감지:**
```yaml
# 같은 테스트 3회 실행
- name: Detect Flaky Tests
  run: |
    for i in {1..3}; do
      ./gradlew test || echo "Run $i failed" >> failures.txt
    done
    if [ -f failures.txt ]; then
      echo "Flaky tests detected!"
      exit 1
    fi
```

**재시도 전략:**
```java
// JUnit 5 재시도
@RepeatedTest(3)
void flakyTest() {
    // 최대 3회 재시도
}

// 또는 Gradle 설정
test {
    retry {
        maxRetries = 3
        maxFailures = 20
    }
}
```

**8. 실전 CI 파이프라인 예시**

```yaml
name: CI Pipeline

on: [push, pull_request]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Linter
        run: ./gradlew checkstyleMain

  unit-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Unit Tests
        run: ./gradlew test
      - name: Upload Coverage
        uses: codecov/codecov-action@v3

  integration-test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:14
    steps:
      - uses: actions/checkout@v3
      - name: Run Integration Tests
        run: ./gradlew integrationTest

  e2e-test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        shard: [1, 2, 3, 4]
    steps:
      - uses: actions/checkout@v3
      - name: Run E2E Tests
        run: npx playwright test --shard=${{ matrix.shard }}/4

  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Security Scan
        run: ./gradlew dependencyCheckAnalyze

  all-tests-passed:
    needs: [lint, unit-test, integration-test, e2e-test, security-scan]
    runs-on: ubuntu-latest
    steps:
      - name: All tests passed
        run: echo "All tests passed successfully!"
```

**실무 경험**
초기에는 모든 테스트를 순차 실행하여 35분이 소요되었으나, Matrix Strategy로 병렬화하고 E2E 테스트를 4개 샤드로 분할하여 전체 파이프라인을 10분으로 단축했습니다. 코드 커버리지 80% 규칙을 적용하여 테스트 품질도 크게 향상되었습니다.'

WHERE id = 'b0000000-0000-0000-0016-00000000000E';

-- Question 15 (0xF): CD 파이프라인에서 Canary 배포와 Blue-Green 배포는 무엇인가요?
UPDATE questions SET explanation =
'**Canary 배포 vs Blue-Green 배포**

**1. Blue-Green 배포**

**개념:**
```
[Blue: v1.0 - 100% 트래픽]
         ↓
[Blue: v1.0 - 100%] [Green: v2.0 - 0%] (준비)
         ↓
[Blue: v1.0 - 0%] [Green: v2.0 - 100%] (전환)
         ↓
[Green: v2.0 - 100%] (Blue 제거)
```

**장점:**
- 즉시 전환 가능 (다운타임 없음)
- 쉬운 롤백 (Blue로 다시 전환)
- 전체 환경 테스트 가능

**단점:**
- 2배의 인프라 비용 (동시에 2개 환경)
- 데이터베이스 마이그레이션 복잡

**Kubernetes 구현:**
```yaml
# Blue Deployment (현재 운영 중)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-blue
spec:
  replicas: 3
  template:
    metadata:
      labels:
        app: myapp
        version: blue
    spec:
      containers:
      - name: myapp
        image: myapp:v1.0

---
# Service (Blue를 가리킴)
apiVersion: v1
kind: Service
metadata:
  name: myapp
spec:
  selector:
    app: myapp
    version: blue  # 이 부분만 변경하면 전환
  ports:
  - port: 80

---
# Green Deployment (새 버전)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-green
spec:
  replicas: 3
  template:
    metadata:
      labels:
        app: myapp
        version: green
    spec:
      containers:
      - name: myapp
        image: myapp:v2.0
```

**전환 스크립트:**
```bash
# 1. Green 배포
kubectl apply -f myapp-green.yaml
kubectl wait --for=condition=available deployment/myapp-green

# 2. Green 테스트
curl http://myapp-green-service/health

# 3. 트래픽 전환
kubectl patch service myapp -p '{"spec":{"selector":{"version":"green"}}}'

# 4. 모니터링 (문제 없으면 Blue 제거)
kubectl delete deployment myapp-blue
```

**2. Canary 배포**

**개념:**
```
v1.0 (100%)
    ↓
v1.0 (95%) + v2.0 (5%)   ← 소수 사용자 테스트
    ↓ 에러율 모니터링
v1.0 (90%) + v2.0 (10%)
    ↓
v1.0 (50%) + v2.0 (50%)
    ↓
v1.0 (0%) + v2.0 (100%)  ← 완전 전환
```

**장점:**
- 점진적 롤아웃 (위험 최소화)
- 실제 프로덕션 트래픽으로 테스트
- 문제 발생 시 영향 범위 작음

**단점:**
- 전환 시간이 김
- 복잡한 트래픽 관리 필요
- 2개 버전 동시 운영 복잡도

**Kubernetes + Istio 구현:**
```yaml
# VirtualService로 트래픽 분배
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: myapp
spec:
  hosts:
  - myapp
  http:
  - route:
    - destination:
        host: myapp
        subset: v1
      weight: 95
    - destination:
        host: myapp
        subset: v2
      weight: 5  # 5% 트래픽만 v2로

---
# DestinationRule
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: myapp
spec:
  host: myapp
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
```

**자동 Canary (Flagger):**
```yaml
apiVersion: flagger.app/v1beta1
kind: Canary
metadata:
  name: myapp
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: myapp
  service:
    port: 80
  analysis:
    interval: 1m
    threshold: 5
    maxWeight: 50
    stepWeight: 10
    metrics:
    - name: request-success-rate
      thresholdRange:
        min: 99
    - name: request-duration
      thresholdRange:
        max: 500
  # 자동으로 10% → 20% → ... → 50%까지 증가
  # 에러율이 99% 미만이면 자동 롤백
```

**3. 비교표**

| 특징 | Blue-Green | Canary |
|------|-----------|--------|
| 전환 속도 | 즉시 | 점진적 (수 시간) |
| 롤백 속도 | 즉시 | 빠름 |
| 인프라 비용 | 2배 (일시적) | 1-1.2배 |
| 위험도 | 중간 | 낮음 |
| 구현 복잡도 | 낮음 | 높음 |
| 실제 사용자 테스트 | 전환 후에만 | 소수부터 가능 |

**4. 실무 선택 기준**

**Blue-Green 사용:**
```
- 빠른 롤아웃 필요
- 인프라 비용 여유
- 데이터베이스 변경 없음
- 예: 프론트엔드 배포, 마케팅 캠페인 런칭
```

**Canary 사용:**
```
- 안정성이 최우선
- 대규모 아키텍처 변경
- 사용자 영향 최소화 필요
- 예: 결제 시스템, 핵심 API 변경
```

**5. 실전 CI/CD 파이프라인**

**GitHub Actions + Canary 배포:**
```yaml
name: Canary Deployment

on:
  push:
    branches: [main]

jobs:
  deploy-canary:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy v2 (0% traffic)
        run: kubectl apply -f k8s/myapp-v2.yaml

      - name: Canary 5%
        run: kubectl apply -f istio/canary-5.yaml

      - name: Wait and Monitor (5 minutes)
        run: |
          sleep 300
          ERROR_RATE=$(curl -s prometheus/api/v1/query?query=error_rate | jq)
          if [ "$ERROR_RATE" -gt "0.01" ]; then
            kubectl apply -f istio/canary-0.yaml  # 롤백
            exit 1
          fi

      - name: Canary 25%
        run: kubectl apply -f istio/canary-25.yaml

      - name: Wait and Monitor (10 minutes)
        run: sleep 600

      - name: Canary 50%
        run: kubectl apply -f istio/canary-50.yaml

      - name: Wait and Monitor (10 minutes)
        run: sleep 600

      - name: Canary 100%
        run: kubectl apply -f istio/canary-100.yaml

      - name: Cleanup old version
        run: kubectl delete deployment myapp-v1
```

**실무 경험**
결제 시스템 개편 시 Canary 배포를 사용했습니다. 5% 트래픽부터 시작하여 2주에 걸쳐 100%까지 점진적으로 확대했고, 중간에 소수 사용자에게서 버그를 발견하여 롤백한 후 수정해서 재배포했습니다. 덕분에 전체 사용자 중 5%만 버그를 경험했고, 대규모 장애를 방지할 수 있었습니다.'

WHERE id = 'b0000000-0000-0000-0016-00000000000F';

-- Question 16 (0x10): Infrastructure as Code(IaC)는 무엇이며 CI/CD에서 어떻게 활용되나요?
UPDATE questions SET explanation =
'**Infrastructure as Code (IaC)란?**

인프라를 코드로 정의하고 관리하는 방식입니다. 서버, 네트워크, 데이터베이스 등을 코드 파일로 작성하여 버전 관리하고 자동화할 수 있습니다.

**전통적 방식 vs IaC**

**전통적 방식 (수동):**
```
1. AWS 콘솔 로그인
2. EC2 → "Launch Instance" 클릭
3. AMI 선택, 인스턴스 타입 선택
4. 보안 그룹 수동 설정
5. 키 페어 생성
6. 30분 소요, 재현 어려움
```

**IaC 방식:**
```hcl
# Terraform 코드
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "my-key"

  tags = {
    Name = "WebServer"
  }
}

# terraform apply 명령 한 번으로 완료 (2분)
# 코드로 관리되어 재현 가능, 버전 관리 가능
```

**IaC의 주요 장점**

**1. 재현 가능성 (Reproducibility)**
```
같은 코드 → 같은 인프라
Dev, Staging, Production 환경을 동일하게 생성 가능
```

**2. 버전 관리**
```bash
git log infrastructure.tf

commit abc123
Author: John Doe
Date: 2024-01-15
"Add production RDS instance"

commit def456
Author: Jane Smith
Date: 2024-01-10
"Increase EC2 instance count to 5"

# 변경 이력 추적 가능, 롤백 가능
```

**3. 협업**
```
Pull Request로 인프라 변경 리뷰
└─ "EC2 t2.micro → t2.large 변경"
   ├─ "비용 영향: $8/월 → $75/월"
   ├─ "승인 필요"
   └─ Merge 후 자동 배포
```

**주요 IaC 도구**

**1. Terraform (HashiCorp)**

**예시: AWS 인프라 구축**
```hcl
# provider.tf
provider "aws" {
  region = "ap-northeast-2"
}

# vpc.tf
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"
}

# ec2.tf
resource "aws_instance" "web" {
  count         = 3
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "web-${count.index}"
  }
}

# rds.tf
resource "aws_db_instance" "postgres" {
  identifier        = "mydb"
  engine            = "postgres"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  username          = "admin"
  password          = var.db_password  # 변수로 관리
}
```

**실행:**
```bash
terraform init
terraform plan   # 변경 사항 미리보기
terraform apply  # 인프라 생성

# 출력:
# Plan: 5 to add, 0 to change, 0 to destroy
```

**2. AWS CloudFormation**

**예시: ECS 클러스터**
```yaml
AWSTemplateFormatVersion: '2010-09-09'
Resources:
  ECSCluster:
    Type: AWS::ECS::Cluster
    Properties:
      ClusterName: production-cluster

  ECSTaskDefinition:
    Type: AWS::ECS::TaskDefinition
    Properties:
      Family: myapp
      Cpu: 256
      Memory: 512
      NetworkMode: awsvpc
      ContainerDefinitions:
        - Name: myapp
          Image: myapp:latest
          PortMappings:
            - ContainerPort: 8080

  ECSService:
    Type: AWS::ECS::Service
    Properties:
      Cluster: !Ref ECSCluster
      TaskDefinition: !Ref ECSTaskDefinition
      DesiredCount: 3
```

**3. Kubernetes Manifests (선언적 IaC)**

```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  template:
    spec:
      containers:
      - name: myapp
        image: myapp:v1.0
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
```

**CI/CD에서 IaC 활용**

**1. 인프라 배포 자동화**

**GitHub Actions + Terraform:**
```yaml
name: Infrastructure Deployment

on:
  push:
    paths:
      - 'terraform/**'
    branches: [main]

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2

      - name: Terraform Init
        run: terraform init

      - name: Terraform Plan
        run: terraform plan -out=tfplan

      - name: Terraform Apply
        if: github.ref == 'refs/heads/main'
        run: terraform apply -auto-approve tfplan

      - name: Output Infrastructure Info
        run: terraform output
```

**2. 환경별 인프라 관리**

```hcl
# variables.tf
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
}

# dev.tfvars
environment    = "dev"
instance_count = 1

# prod.tfvars
environment    = "production"
instance_count = 10
```

**배포:**
```bash
# Dev 환경
terraform apply -var-file="dev.tfvars"

# Production 환경
terraform apply -var-file="prod.tfvars"
```

**3. Pull Request로 인프라 리뷰**

```yaml
# .github/workflows/terraform-pr.yml
on: [pull_request]

jobs:
  terraform-plan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: hashicorp/setup-terraform@v2

      - name: Terraform Plan
        id: plan
        run: terraform plan -no-color

      - name: Comment PR
        uses: actions/github-script@v6
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: 'Terraform Plan:\n\n```\n${{ steps.plan.outputs.stdout }}\n```'
            })

# PR에 Terraform Plan 결과가 자동으로 코멘트됨
# 리뷰어가 인프라 변경사항 확인 가능
```

**4. GitOps와 IaC**

**ArgoCD + Terraform:**
```
1. 개발자가 Terraform 코드 수정
2. Git Push
3. CI에서 Terraform 실행
4. 인프라 변경
5. ArgoCD가 변경 감지
6. 애플리케이션 자동 재배포
```

**5. 비밀 정보 관리**

**Terraform + AWS Secrets Manager:**
```hcl
# secrets.tf
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "prod/db/password"
}

resource "aws_db_instance" "postgres" {
  password = data.aws_secretsmanager_secret_version.db_password.secret_string
  # 코드에 직접 비밀번호 노출 안 함
}
```

**실전 패턴**

**1. Immutable Infrastructure (불변 인프라)**
```
기존 서버 수정 (X)
└─ 문제: 환경 차이, "작동했었는데" 문제

새 서버 생성 후 교체 (O)
└─ 항상 깨끗한 상태, 재현 가능
```

**2. Blue-Green 인프라**
```hcl
resource "aws_instance" "blue" {
  count = var.environment == "blue" ? 3 : 0
  # Blue 환경
}

resource "aws_instance" "green" {
  count = var.environment == "green" ? 3 : 0
  # Green 환경
}

# 전환: environment 변수만 변경
```

**실무 경험**
Terraform으로 전체 AWS 인프라를 코드화했습니다. 새로운 마이크로서비스 추가 시 Terraform 파일만 수정하면 VPC, ECS, RDS, ALB가 자동으로 생성되었고, 인프라 구축 시간이 하루에서 10분으로 단축되었습니다. PR 리뷰로 인프라 변경을 사전 검토하여 실수를 방지했고, Git history로 모든 변경 이력을 추적할 수 있었습니다.'

WHERE id = 'b0000000-0000-0000-0016-000000000010';

-- Question 17 (0x11): CI/CD 환경에서 보안(예: 시크릿 관리)은 어떻게 구현하고 있나요?
UPDATE questions SET explanation =
'**CI/CD 환경에서 보안 구현**

**1. 시크릿 관리 (Secrets Management)**

**❌ 절대 금지:**
```yaml
# ❌ 코드에 직접 작성
env:
  DATABASE_PASSWORD: "mypassword123"
  AWS_ACCESS_KEY: "AKIAIOSFODNN7EXAMPLE"

# ❌ Git에 커밋
config.yml:
  api_key: "sk-1234567890abcdef"

# → Git history에 영구 보존, 누구나 볼 수 있음
```

**✅ 올바른 방법:**

**GitHub Secrets 사용:**
```yaml
# .github/workflows/deploy.yml
env:
  DATABASE_PASSWORD: ${{ secrets.DATABASE_PASSWORD }}
  AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
  AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}

# GitHub 웹 UI에서 설정:
# Settings → Secrets → New repository secret
```

**AWS Secrets Manager:**
```bash
# CI/CD에서 시크릿 가져오기
#!/bin/bash
DB_PASSWORD=$(aws secretsmanager get-secret-value \
  --secret-id prod/db/password \
  --query SecretString \
  --output text)

# 환경 변수로 주입
export DATABASE_PASSWORD=$DB_PASSWORD
./gradlew bootRun
```

**HashiCorp Vault:**
```yaml
# GitHub Actions
- name: Import Secrets from Vault
  uses: hashicorp/vault-action@v2
  with:
    url: https://vault.company.com
    method: approle
    roleId: ${{ secrets.VAULT_ROLE_ID }}
    secretId: ${{ secrets.VAULT_SECRET_ID }}
    secrets: |
      secret/data/prod/db password | DATABASE_PASSWORD
      secret/data/prod/api key | API_KEY

# Vault에서 가져온 시크릿이 환경 변수로 주입됨
```

**2. 접근 제어 (Access Control)**

**최소 권한 원칙 (Principle of Least Privilege):**

**AWS IAM Role (좋은 예):**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::my-deploy-bucket/*"
    }
  ]
}

// ✅ 배포에 필요한 최소한의 권한만 부여
// ❌ Administrator 권한 부여 금지
```

**GitHub Actions:**
```yaml
permissions:
  contents: read      # 코드 읽기만
  pull-requests: write  # PR 코멘트 작성
# 필요한 권한만 명시적으로 부여
```

**3. 코드 스캔 및 취약점 검사**

**비밀 정보 스캔 (Secret Scanning):**
```yaml
# .github/workflows/security.yml
- name: Scan for secrets
  uses: trufflesecurity/trufflehog@main
  with:
    path: ./
    base: main
    head: HEAD

# Git history에서 API 키, 비밀번호 검색
# 발견 시 CI 실패
```

**의존성 취약점 검사:**
```yaml
# Dependabot (GitHub)
version: 2
updates:
  - package-ecosystem: "gradle"
    directory: "/"
    schedule:
      interval: "weekly"
    # 취약한 의존성 발견 시 자동 PR 생성

# OWASP Dependency Check
- name: Run Dependency Check
  run: ./gradlew dependencyCheckAnalyze

- name: Upload Report
  uses: actions/upload-artifact@v3
  with:
    name: dependency-check-report
    path: build/reports/dependency-check-report.html
```

**코드 취약점 스캔 (SAST):**
```yaml
# SonarQube
- name: SonarQube Scan
  env:
    SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
  run: ./gradlew sonarqube

# CodeQL (GitHub)
- name: Initialize CodeQL
  uses: github/codeql-action/init@v2
  with:
    languages: java

- name: Perform CodeQL Analysis
  uses: github/codeql-action/analyze@v2
```

**컨테이너 이미지 스캔:**
```yaml
- name: Build Docker image
  run: docker build -t myapp:${{ github.sha }} .

- name: Scan Docker image
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: myapp:${{ github.sha }}
    severity: 'CRITICAL,HIGH'
    exit-code: '1'  # 취약점 발견 시 CI 실패
```

**4. 네트워크 보안**

**Self-hosted Runners 격리:**
```yaml
# Private network에서 실행
jobs:
  deploy:
    runs-on: [self-hosted, production]
    # VPC 내부 Runner 사용
    # 민감한 배포는 외부 인터넷 노출 X
```

**IP 화이트리스트:**
```hcl
# Terraform
resource "aws_security_group" "ci_cd" {
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "192.0.2.0/24",  # GitHub Actions IP 범위
      "198.51.100.0/24"
    ]
  }
}
```

**5. 감사 및 로깅 (Audit Logging)**

**모든 CI/CD 활동 로깅:**
```yaml
- name: Log deployment
  run: |
    echo "Deployment started by ${{ github.actor }}"
    echo "Commit: ${{ github.sha }}"
    echo "Branch: ${{ github.ref }}"
    # CloudWatch Logs로 전송
    aws logs put-log-events \
      --log-group-name /ci-cd/deployments \
      --log-stream-name production \
      --log-events "timestamp=$(date +%s000),message=Deployment started"
```

**누가, 언제, 무엇을 배포했는지 추적:**
```
2024-01-15 14:30:00 | john@company.com | deployed user-service v2.0 to production
2024-01-15 14:35:00 | jane@company.com | rolled back user-service to v1.9
```

**6. 승인 프로세스 (Approval Gates)**

**프로덕션 배포 시 승인 필요:**
```yaml
# GitHub Environments
jobs:
  deploy-prod:
    runs-on: ubuntu-latest
    environment:
      name: production
      url: https://myapp.com
    # Environment에 Reviewers 설정
    # 지정된 사람의 승인 없이는 배포 불가

    steps:
      - name: Deploy to production
        run: kubectl apply -f k8s/prod/
```

**7. 보안 체크리스트 자동화**

```yaml
name: Security Checks

on: [push, pull_request]

jobs:
  security-gate:
    runs-on: ubuntu-latest
    steps:
      - name: 1. Secret Scan
        uses: trufflesecurity/trufflehog@main

      - name: 2. Dependency Vulnerability Scan
        run: ./gradlew dependencyCheckAnalyze

      - name: 3. Code Security Scan
        uses: github/codeql-action/analyze@v2

      - name: 4. Container Image Scan
        uses: aquasecurity/trivy-action@master

      - name: 5. License Compliance Check
        run: ./gradlew checkLicense

      - name: 6. OWASP Top 10 Check
        run: ./gradlew owaspCheck

      - name: All Security Checks Passed
        run: echo "✅ Security gate passed"

# 하나라도 실패하면 배포 중단
```

**8. 실전 보안 사고 예방**

**사고 예시:**
```
❌ GitHub Public Repository에 AWS 키 커밋
  → 5분 내 봇이 발견
  → 암호화폐 채굴에 악용
  → AWS 청구서 $50,000
```

**예방 방법:**
```yaml
# Pre-commit Hook (로컬)
# .git/hooks/pre-commit
#!/bin/bash
if git diff --cached | grep -E '(password|secret|key|token).*=.*['"]'; then
  echo "⚠️  Potential secret detected!"
  echo "Please remove secrets before committing."
  exit 1
fi

# Git Guardian (자동 스캔)
# 커밋 즉시 스캔, 시크릿 발견 시 알림
```

**비상 대응 프로세스:**
```
1. 시크릿 노출 감지
  ↓
2. 즉시 시크릿 회전 (Rotate)
  - AWS 키 삭제 및 재생성
  - 데이터베이스 비밀번호 변경
  ↓
3. Git history에서 제거
  - git filter-branch 또는 BFG Repo-Cleaner
  ↓
4. 영향 분석
  - 로그 확인: 악용 여부
  ↓
5. 팀 교육
```

**실무 경험**
프로젝트 초기에 개발자가 실수로 AWS 키를 커밋하여 GitHub Secret Scanning이 이를 즉시 감지했습니다. 자동 알림을 받고 5분 내에 키를 회전시켜 피해를 방지했습니다. 이후 pre-commit hook과 CI 단계에서 이중 검사를 추가하여 유사한 사고를 원천 차단했습니다.'

WHERE id = 'b0000000-0000-0000-0016-000000000011';

-- Question 18 (0x12): 모놀리틱과 마이크로서비스 아키텍처에서 CI/CD의 차이는?
UPDATE questions SET explanation =
'**모놀리틱 vs 마이크로서비스 CI/CD 차이**

**1. 아키텍처 비교**

**모놀리틱 (Monolithic):**
```
┌─────────────────────────┐
│   Single Application    │
│  ┌──────────────────┐   │
│  │   User Module    │   │
│  │  Order Module    │   │
│  │ Payment Module   │   │
│  │ Inventory Module │   │
│  └──────────────────┘   │
│     Single Database     │
└─────────────────────────┘

- 하나의 저장소
- 하나의 배포 단위
- 하나의 데이터베이스
```

**마이크로서비스 (Microservices):**
```
┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐
│  User    │  │  Order   │  │ Payment  │  │Inventory │
│ Service  │  │ Service  │  │ Service  │  │ Service  │
│   +DB    │  │   +DB    │  │   +DB    │  │   +DB    │
└──────────┘  └──────────┘  └──────────┘  └──────────┘

- 4개의 저장소 (또는 Monorepo)
- 4개의 독립적인 배포
- 4개의 데이터베이스
```

**2. CI/CD 파이프라인 차이**

**모놀리틱 CI/CD:**

```yaml
# 단일 파이프라인
name: Monolithic CI/CD

on:
  push:
    branches: [main]

jobs:
  build-test-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Build entire app
        run: ./gradlew build

      - name: Run all tests
        run: ./gradlew test
        # 모든 모듈 테스트 (30분)

      - name: Deploy entire app
        run: |
          docker build -t myapp:latest .
          kubectl set image deployment/myapp myapp=myapp:latest

# 장점: 간단함
# 단점: User 모듈만 수정해도 전체 재배포
```

**마이크로서비스 CI/CD:**

```yaml
# 각 서비스마다 별도 파이프라인
name: User Service CI/CD

on:
  push:
    paths:
      - 'services/user/**'  # user 서비스 변경 시에만
    branches: [main]

jobs:
  build-user-service:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Build user service only
        run: ./gradlew :user-service:build

      - name: Run user service tests
        run: ./gradlew :user-service:test
        # user 서비스만 테스트 (5분)

      - name: Deploy user service only
        run: |
          docker build -t user-service:latest ./services/user
          kubectl set image deployment/user-service user-service=user-service:latest

# 장점: 독립적 배포, 빠른 빌드
# 단점: 파이프라인 관리 복잡
```

**3. 빌드 시간 비교**

**모놀리틱:**
```
User 모듈 수정 (10줄)
  ↓
전체 애플리케이션 빌드 (10분)
  ↓
전체 테스트 실행 (30분)
  ↓
전체 재배포 (5분)
= 총 45분
```

**마이크로서비스:**
```
User Service 수정 (10줄)
  ↓
User Service만 빌드 (2분)
  ↓
User Service만 테스트 (5분)
  ↓
User Service만 배포 (2분)
= 총 9분
```

**4. 배포 전략 차이**

**모놀리틱 배포:**
```
V1.0 (전체)
  ↓
V1.1 (전체) - User + Order + Payment + Inventory 모두 업데이트
  ↓
문제 발생 시 전체 롤백
```

**마이크로서비스 배포:**
```
User Service v1.1
Order Service v1.0  (변경 없음)
Payment Service v1.0  (변경 없음)
Inventory Service v1.0  (변경 없음)

문제 발생 시 User Service만 롤백
→ 다른 서비스는 영향 없음
```

**5. 테스트 전략 차이**

**모놀리틱 테스트:**
```yaml
# 모든 테스트 한 번에
- run: ./gradlew test

# 통합 테스트도 한 번에
- run: ./gradlew integrationTest

# 테스트 격리 어려움
```

**마이크로서비스 테스트:**
```yaml
# 서비스별 독립 테스트
services:
  user-service:
    - run: ./gradlew :user-service:test

  order-service:
    - run: ./gradlew :order-service:test

# Contract Testing (서비스 간 계약 검증)
- name: Run Contract Tests
  run: |
    # Pact 사용
    ./gradlew :user-service:pactVerify
    ./gradlew :order-service:pactVerify

# End-to-End Tests (전체 흐름)
- run: npm run test:e2e
```

**6. 의존성 관리**

**모놀리틱:**
```
Payment 모듈이 User 모듈 의존
  ↓
User 변경 시 Payment도 재빌드 필요
  ↓
빌드 순서 관리 필요
```

**마이크로서비스:**
```
Payment Service → (HTTP/gRPC) → User Service
  ↓
User Service 변경 시
  ↓
API 계약(Contract)이 유지되면 Payment Service 재배포 불필요
  ↓
독립적 배포 가능
```

**7. Monorepo vs Polyrepo**

**Monorepo (하나의 저장소):**
```
my-company/
├─ services/
│  ├─ user/
│  ├─ order/
│  ├─ payment/
│  └─ inventory/
└─ .github/workflows/
   ├─ user-service.yml
   ├─ order-service.yml
   └─ ...
```

**장점:**
- 코드 공유 쉬움
- 통합 검색 가능
- 일관된 도구 및 설정

**Polyrepo (각 서비스별 저장소):**
```
user-service/
  └─ .github/workflows/ci.yml

order-service/
  └─ .github/workflows/ci.yml

payment-service/
  └─ .github/workflows/ci.yml
```

**장점:**
- 완전한 독립성
- 팀별 권한 관리 쉬움
- 저장소 크기 작음

**8. 복잡도 비교**

| 측면 | 모놀리틱 | 마이크로서비스 |
|------|---------|---------------|
| 파이프라인 개수 | 1개 | N개 (서비스 수만큼) |
| 빌드 시간 | 길음 (전체) | 짧음 (개별) |
| 배포 빈도 | 낮음 (위험 높음) | 높음 (위험 낮음) |
| 롤백 범위 | 전체 | 개별 서비스 |
| 테스트 복잡도 | 낮음 | 높음 (통합 테스트) |
| 인프라 비용 | 낮음 | 높음 |
| 관리 복잡도 | 낮음 | 매우 높음 |

**9. 실전 마이크로서비스 CI/CD**

**변경 감지 기반 빌드:**
```yaml
name: Microservices CI/CD

on: [push]

jobs:
  detect-changes:
    runs-on: ubuntu-latest
    outputs:
      user: ${{ steps.filter.outputs.user }}
      order: ${{ steps.filter.outputs.order }}
    steps:
      - uses: actions/checkout@v3
      - uses: dorny/paths-filter@v2
        id: filter
        with:
          filters: |
            user:
              - 'services/user/**'
            order:
              - 'services/order/**'

  build-user:
    needs: detect-changes
    if: needs.detect-changes.outputs.user == 'true'
    runs-on: ubuntu-latest
    steps:
      - name: Build User Service
        run: ./gradlew :user-service:build

  build-order:
    needs: detect-changes
    if: needs.detect-changes.outputs.order == 'true'
    runs-on: ubuntu-latest
    steps:
      - name: Build Order Service
        run: ./gradlew :order-service:build
```

**Service Mesh 통합 (Istio):**
```yaml
# Canary 배포 자동화
- name: Deploy User Service Canary
  run: |
    kubectl apply -f user-service-v2.yaml
    kubectl apply -f istio-canary-5.yaml
    # 5% 트래픽만 v2로

# 각 서비스 독립적으로 Canary 가능
```

**실무 경험**
모놀리틱에서 마이크로서비스로 전환하면서 CI/CD 파이프라인을 12개로 분리했습니다. 초기에는 복잡도가 증가했지만, 각 팀이 독립적으로 빠르게 배포할 수 있게 되어 전체 배포 빈도가 주 1회에서 일 20회로 증가했고, 배포 실패 시 영향 범위가 크게 줄어들었습니다.'

WHERE id = 'b0000000-0000-0000-0016-000000000012';
