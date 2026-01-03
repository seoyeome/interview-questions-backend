-- V53_1: Update explanations for CI/CD questions (Part 1: Questions 0-9)

-- Question 0: CI/CD란 무엇이며 왜 중요한가요?
UPDATE questions SET explanation =
$md$
**CI/CD란?**

**CI (Continuous Integration)**
개발자들이 작성한 코드를 자주 통합하고, 자동으로 빌드 및 테스트하는 프로세스입니다.

**CD (Continuous Delivery/Deployment)**
- **Continuous Delivery**: 언제든 배포 가능한 상태로 유지
- **Continuous Deployment**: 자동으로 프로덕션까지 배포

**왜 중요한가?**

**1. 빠른 피드백**
```
코드 커밋 → 자동 빌드 → 자동 테스트 → 즉시 결과 확인
(수동: 며칠 소요 → 자동: 수분 내)
```

**2. 품질 향상**
- 모든 코드 변경마다 자동 테스트 실행
- 버그를 조기에 발견하여 수정 비용 절감

**3. 배포 속도 증가**
- 수동 배포: 주 1회, 몇 시간 소요
- CI/CD: 하루 수십 회, 몇 분 내 완료

**4. 위험 감소**
- 작은 단위로 자주 배포 → 문제 발생 시 영향 범위 최소화
- 롤백이 쉬움

**실무 경험**
이전 프로젝트에서 CI/CD 도입 전에는 주 1회 수동 배포로 인해 긴장감이 높았고, 배포 후 버그 발견 시 롤백이 어려웠습니다. GitHub Actions를 도입한 후 하루 10회 이상 안전하게 배포하며, 테스트 자동화로 배포 자신감이 크게 향상되었습니다.
$md$


WHERE id = 'b0000000-0000-0000-0016-000000000000';

-- Question 1: Continuous Integration, Delivery, Deployment의 차이는 무엇인가요?
UPDATE questions SET explanation =
$md$
**CI/CD 세 가지 개념 비교**

| 개념 | 설명 | 자동화 범위 | 배포 |
|------|------|-------------|------|
| **CI** (Continuous Integration) | 코드 통합 및 테스트 자동화 | 빌드 + 테스트 | 배포 X |
| **CD** (Continuous Delivery) | 배포 가능 상태 유지 | 빌드 + 테스트 + 스테이징 배포 | 수동 승인 후 프로덕션 배포 |
| **CD** (Continuous Deployment) | 완전 자동 배포 | 빌드 + 테스트 + 모든 배포 | 자동 프로덕션 배포 |

**1. Continuous Integration (CI)**
```
개발자 코드 커밋
  ↓
자동 빌드
  ↓
자동 테스트 (유닛, 통합)
  ↓
피드백 (성공/실패)
```
- 목표: 코드 통합 시 발생하는 문제를 조기에 발견

**2. Continuous Delivery (CD)**
```
CI 단계 통과
  ↓
자동으로 스테이징 환경 배포
  ↓
수동 승인 (PM, QA 검증)
  ↓
프로덕션 배포 (버튼 클릭)
```
- 목표: 언제든 배포 가능한 상태 유지

**3. Continuous Deployment (CD)**
```
CI 단계 통과
  ↓
자동으로 스테이징 환경 배포
  ↓
자동 테스트 통과
  ↓
자동으로 프로덕션 배포
```
- 목표: 사람 개입 없이 완전 자동 배포

**실무 적용**
금융 서비스에서는 Continuous Delivery를 사용하여 QA 팀의 최종 승인 후 배포했고, 내부 개발 도구에서는 Continuous Deployment로 테스트 통과 시 즉시 배포했습니다.
$md$


WHERE id = 'b0000000-0000-0000-0016-000000000001';

-- Question 2: CI를 구현하면 얻는 주요 이점은 무엇인가요?
UPDATE questions SET explanation =
$md$
**CI 구현의 주요 이점**

**1. 조기 버그 발견**
```
Before CI:
코드 작성 (3일) → 통합 (1일) → 버그 발견 (4일 후)
→ 컨텍스트 손실, 수정 어려움

After CI:
코드 커밋 (즉시) → 자동 테스트 (5분) → 버그 발견 (즉시)
→ 빠른 수정, 낮은 비용
```

**2. 통합 지옥(Integration Hell) 방지**
- **문제**: 여러 개발자가 오래 작업 후 한 번에 통합 → 충돌 다발
- **해결**: 매일 여러 번 통합 → 작은 충돌을 즉시 해결

**3. 코드 품질 향상**
- 모든 커밋마다 자동 테스트 실행
- 린트, 코드 스타일 검사 자동화
- 코드 커버리지 측정

**4. 개발 생산성 증가**
```
수동 빌드/테스트:
개발 1시간 → 빌드 10분 → 테스트 30분 → 반복
→ 하루 3-4회 테스트

자동 CI:
개발 → 커밋 → 자동 빌드/테스트 (백그라운드)
→ 하루 20-30회 테스트
```

**5. 배포 신뢰도 증가**
- 모든 코드가 항상 테스트된 상태
- "내 로컬에서는 작동했는데" 문제 사라짐
- 일관된 빌드 환경

**6. 문서화 효과**
- 빌드 스크립트가 실행 가능한 문서 역할
- 새 팀원 온보딩 시간 단축

**실무 경험**
CI 도입 전에는 주말마다 통합 작업으로 야근했지만, GitHub Actions 도입 후 통합 문제가 90% 감소했고, 버그 수정 시간이 평균 3일에서 30분으로 단축되었습니다.
$md$


WHERE id = 'b0000000-0000-0000-0016-000000000002';

-- Question 3: 빌드 파이프라인(Build Pipeline)이란 무엇인가요?
UPDATE questions SET explanation =
$md$
**빌드 파이프라인이란?**

소스 코드를 실행 가능한 소프트웨어로 변환하는 일련의 자동화된 단계들입니다.

**기본 파이프라인 구조**
```
[소스 코드]
  ↓
[1. 코드 체크아웃]
  ↓
[2. 의존성 설치]
  ↓
[3. 빌드]
  ↓
[4. 테스트]
  ↓
[5. 패키징]
  ↓
[6. 배포]
```

**실제 예시: Spring Boot 애플리케이션**
```yaml
# GitHub Actions 예시
steps:
  - name: 코드 체크아웃
    uses: actions/checkout@v2

  - name: Java 설정
    uses: actions/setup-java@v2
    with:
      java-version: '17'

  - name: Gradle 빌드
    run: ./gradlew build

  - name: 테스트 실행
    run: ./gradlew test

  - name: Docker 이미지 빌드
    run: docker build -t myapp:${{ github.sha }} .

  - name: Docker Hub 푸시
    run: docker push myapp:${{ github.sha }}

  - name: 배포
    run: kubectl apply -f k8s/
```

**파이프라인의 주요 특징**

**1. 단계별 진행**
- 각 단계는 이전 단계 성공 시에만 실행
- 실패 시 즉시 중단 및 알림

**2. 병렬 처리**
```
빌드 완료 후:
  ├─ 유닛 테스트 (2분)
  ├─ 통합 테스트 (5분)
  └─ E2E 테스트 (10분)
(순차: 17분 → 병렬: 10분)
```

**3. 환경 분리**
```
개발 브랜치 → Dev 환경 배포
Main 브랜치 → Staging 배포
Tag 생성 → Production 배포
```

**실무 경험**
마이크로서비스 프로젝트에서 Jenkins Pipeline을 사용하여 빌드-테스트-도커라이징-배포까지 자동화했고, 전체 파이프라인이 15분 내에 완료되어 하루 30회 이상 배포할 수 있었습니다.
$md$


WHERE id = 'b0000000-0000-0000-0016-000000000003';

-- Question 4: CI/CD 파이프라인의 주요 단계를 설명해 주세요
UPDATE questions SET explanation =
$md$
**CI/CD 파이프라인의 주요 단계**

**전체 흐름**
```
[코드 커밋] → [빌드] → [테스트] → [패키징] → [배포]
```

**1. 소스 코드 체크아웃**
```bash
git clone https://github.com/user/repo.git
git checkout main
```
- Git 저장소에서 최신 코드 가져오기
- 특정 브랜치나 커밋 지정

**2. 빌드 (Build)**
```bash
# Java
./gradlew clean build

# Node.js
npm run build

# Go
go build -o app
```
- 소스 코드를 실행 가능한 형태로 컴파일
- 의존성 다운로드 및 설치

**3. 테스트 (Test)**
```
유닛 테스트 (Unit Tests)
  ↓
통합 테스트 (Integration Tests)
  ↓
E2E 테스트 (End-to-End Tests)
```

예시:
```bash
# 유닛 테스트
./gradlew test

# 통합 테스트
./gradlew integrationTest

# 코드 커버리지 검사
./gradlew jacocoTestReport
```

**4. 정적 분석 (Static Analysis)**
```bash
# 코드 품질 검사
./gradlew sonarqube

# 보안 취약점 스캔
./gradlew dependencyCheckAnalyze
```

**5. 패키징 (Packaging)**
```dockerfile
# Docker 이미지 생성
docker build -t myapp:1.0.0 .
docker push myapp:1.0.0
```

**6. 배포 (Deployment)**

**Stage 1: 스테이징 환경**
```bash
kubectl apply -f k8s/staging/
```

**Stage 2: 프로덕션 환경**
```bash
# 수동 승인 후
kubectl apply -f k8s/production/
```

**7. 모니터링 & 알림**
```
배포 완료
  ↓
헬스 체크 (5분)
  ↓
성공 → Slack 알림
실패 → 자동 롤백 + PagerDuty 알림
```

**실무 예시: GitLab CI/CD**
```yaml
stages:
  - build
  - test
  - package
  - deploy

build:
  stage: build
  script:
    - ./gradlew build

test:
  stage: test
  script:
    - ./gradlew test
    - ./gradlew integrationTest

package:
  stage: package
  script:
    - docker build -t myapp .

deploy:
  stage: deploy
  script:
    - kubectl apply -f k8s/
  only:
    - main
```

**실무 경험**
전체 파이프라인을 빌드 3분, 테스트 5분, 배포 2분으로 최적화하여 총 10분 내에 완료되도록 구성했고, 병렬 테스트 실행으로 시간을 50% 단축했습니다.
$md$


WHERE id = 'b0000000-0000-0000-0016-000000000004';

-- Question 5: 버전 관리 시스템(예: Git)을 CI/CD에서 어떻게 활용하나요?
UPDATE questions SET explanation =
$md$
**Git을 CI/CD에서 활용하는 방법**

**1. 트리거 역할**

**브랜치별 파이프라인**
```yaml
# GitHub Actions
on:
  push:
    branches:
      - main        # → Production 배포
      - develop     # → Staging 배포
      - feature/*   # → Dev 배포 + 테스트만
```

**태그 기반 배포**
```yaml
on:
  push:
    tags:
      - 'v*.*.*'    # v1.0.0 → Production 릴리스
```

**Pull Request 검증**
```yaml
on:
  pull_request:
    branches: [main]
# PR 생성 시 자동으로 빌드/테스트
```

**2. 브랜칭 전략과 CI/CD 통합**

**Git Flow 예시**
```
feature/login → develop → release/1.0 → main
    ↓              ↓           ↓          ↓
  테스트만      Dev 배포    Staging    Production
```

**Trunk-Based Development**
```
feature → main (항상 배포 가능)
    ↓        ↓
  테스트   자동 배포
```

**3. 버전 관리**

**Git 태그로 버전 추적**
```bash
# 자동 버전 태깅
git tag -a v1.2.3 -m "Release 1.2.3"
git push origin v1.2.3

# CI에서 버전 사용
docker build -t myapp:$(git describe --tags) .
```

**커밋 해시로 추적**
```bash
# 이미지에 커밋 해시 포함
docker build -t myapp:${GITHUB_SHA} .

# 어떤 코드가 배포되었는지 추적 가능
```

**4. 코드 리뷰 자동화**

**PR에 자동 체크 추가**
```yaml
# .github/workflows/pr-check.yml
on: [pull_request]

jobs:
  code-quality:
    - run: npm run lint
    - run: npm test
    - run: npm run build

  security-scan:
    - run: npm audit
```

**GitHub 상태 체크**
```
✓ Build succeeded
✓ All tests passed
✓ Code coverage > 80%
✓ No security vulnerabilities
→ "Merge" 버튼 활성화
```

**5. 롤백 지원**

**이전 커밋으로 쉽게 롤백**
```bash
# 문제 발생 시
git revert HEAD
git push

# CI/CD가 자동으로 이전 버전 배포
```

**실무 경험**
Git Flow를 사용하여 feature 브랜치는 테스트만, develop은 Dev 환경, main은 Production 배포로 자동화했습니다. PR마다 자동 테스트가 실행되어 코드 품질이 크게 향상되었고, 태그 기반 릴리스로 버전 관리가 명확해졌습니다.
$md$


WHERE id = 'b0000000-0000-0000-0016-000000000005';

-- Question 6: Jenkins는 무엇이며 어떤 역할을 하나요?
UPDATE questions SET explanation =
$md$
**Jenkins란?**

오픈소스 CI/CD 자동화 서버로, 빌드, 테스트, 배포를 자동화하는 도구입니다.

**주요 역할**

**1. CI/CD 파이프라인 실행**
```
코드 커밋 감지
  ↓
자동 빌드
  ↓
자동 테스트
  ↓
배포
```

**2. 스케줄링**
```groovy
// Jenkinsfile
pipeline {
  triggers {
    cron('H 2 * * *')  // 매일 새벽 2시 빌드
    pollSCM('H/5 * * * *')  // 5분마다 Git 변경 확인
  }
}
```

**3. 분산 빌드**
```
Jenkins Master
  ├─ Agent 1 (Linux) → Java 프로젝트 빌드
  ├─ Agent 2 (Windows) → .NET 프로젝트 빌드
  └─ Agent 3 (Mac) → iOS 앱 빌드
```

**Jenkins의 핵심 기능**

**1. 플러그인 생태계**
- 2000+ 플러그인으로 확장 가능
- Git, Docker, Kubernetes, Slack 등 통합

**2. Pipeline as Code**
```groovy
// Jenkinsfile
pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        sh './gradlew build'
      }
    }

    stage('Test') {
      steps {
        sh './gradlew test'
      }
    }

    stage('Deploy') {
      when { branch 'main' }
      steps {
        sh 'kubectl apply -f k8s/'
      }
    }
  }

  post {
    success {
      slackSend message: "Build Success!"
    }
    failure {
      slackSend message: "Build Failed!"
    }
  }
}
```

**3. 다양한 트리거**
- SCM 변경 감지 (Git push)
- 다른 Job 완료 후 실행
- 특정 시간에 실행 (cron)
- 수동 실행
- Webhook (GitHub, GitLab)

**Jenkins vs 다른 CI/CD 도구**

| 특징 | Jenkins | GitHub Actions | GitLab CI |
|------|---------|----------------|-----------|
| 설치 | 직접 설치 필요 | 클라우드 기반 | 클라우드 또는 온프레미스 |
| 비용 | 무료 (인프라 비용만) | 무료 (제한적) | 무료 (제한적) |
| 플러그인 | 2000+ | Marketplace | Built-in |
| 러닝 커브 | 높음 | 낮음 | 중간 |
| 커스터마이징 | 매우 높음 | 중간 | 높음 |

**실무 사용 예시**
```groovy
pipeline {
  agent any

  stages {
    stage('Build & Test') {
      steps {
        sh './gradlew clean build test'
      }
    }

    stage('Deploy to Dev') {
      when { branch 'develop' }
      steps {
        sh 'kubectl apply -f k8s/dev/'
      }
    }

    stage('Deploy to Prod') {
      when { branch 'main' }
      steps {
        input message: 'Deploy to Production?'
        sh 'kubectl apply -f k8s/prod/'
      }
    }
  }
}
```

**실무 경험**
Jenkins를 사용하여 10개 마이크로서비스의 빌드/배포를 자동화했습니다. Master-Agent 구조로 빌드를 병렬화하여 전체 빌드 시간을 60분에서 15분으로 단축했고, Slack 플러그인으로 팀 전체가 배포 상태를 실시간 확인할 수 있었습니다.
$md$


WHERE id = 'b0000000-0000-0000-0016-000000000006';

-- Question 7: Jenkins의 파이프라인(Pipeline) 기능은 무엇인가요?
UPDATE questions SET explanation =
$md$
**Jenkins Pipeline이란?**

빌드, 테스트, 배포 과정을 코드로 정의하는 Jenkins의 핵심 기능입니다. "Pipeline as Code" 개념을 구현합니다.

**Pipeline의 주요 장점**

**1. 코드로 관리 (Jenkinsfile)**
```groovy
// Git 저장소에 Jenkinsfile 저장
pipeline {
  agent any
  stages {
    stage('Build') {
      steps { sh './gradlew build' }
    }
  }
}
```
- Git으로 버전 관리
- 코드 리뷰 가능
- 재사용 가능

**2. 복잡한 워크플로우 구현**
```groovy
pipeline {
  agent any

  stages {
    stage('Parallel Tests') {
      parallel {
        stage('Unit Test') {
          steps { sh 'npm run test:unit' }
        }
        stage('Integration Test') {
          steps { sh 'npm run test:integration' }
        }
        stage('E2E Test') {
          steps { sh 'npm run test:e2e' }
        }
      }
    }

    stage('Deploy') {
      steps {
        script {
          if (env.BRANCH_NAME == 'main') {
            sh 'kubectl apply -f k8s/prod/'
          } else {
            sh 'kubectl apply -f k8s/dev/'
          }
        }
      }
    }
  }
}
```

**Pipeline 주요 구성 요소**

**1. Agent (실행 환경)**
```groovy
pipeline {
  agent {
    docker {
      image 'maven:3.8.1-jdk-11'
    }
  }
}

// 또는 특정 노드
agent {
  label 'linux-build-server'
}
```

**2. Stages (단계)**
```groovy
stages {
  stage('Checkout') { ... }
  stage('Build') { ... }
  stage('Test') { ... }
  stage('Deploy') { ... }
}
```

**3. Steps (실행 명령)**
```groovy
steps {
  sh 'echo "Building..."'
  sh './gradlew build'
  junit '**/target/*.xml'
}
```

**4. Post Actions (후처리)**
```groovy
post {
  always {
    junit '**/test-results/*.xml'
  }
  success {
    slackSend channel: '#builds',
              message: "Build Successful: ${env.JOB_NAME}"
  }
  failure {
    mail to: 'team@company.com',
         subject: "Build Failed: ${env.JOB_NAME}"
  }
}
```

**실무 예시**
```groovy
pipeline {
  agent any

  environment {
    DOCKER_REGISTRY = 'myregistry.io'
    APP_NAME = 'user-service'
  }

  stages {
    stage('Build') {
      steps {
        sh './gradlew clean build'
      }
    }

    stage('Test') {
      parallel {
        stage('Unit') {
          steps { sh './gradlew test' }
        }
        stage('Integration') {
          steps { sh './gradlew integrationTest' }
        }
      }
    }

    stage('Docker Build') {
      steps {
        sh """
          docker build -t ${DOCKER_REGISTRY}/${APP_NAME}:${BUILD_NUMBER} .
          docker push ${DOCKER_REGISTRY}/${APP_NAME}:${BUILD_NUMBER}
        """
      }
    }

    stage('Deploy to Dev') {
      when { branch 'develop' }
      steps {
        sh 'kubectl set image deployment/user-service user-service=${DOCKER_REGISTRY}/${APP_NAME}:${BUILD_NUMBER}'
      }
    }
  }

  post {
    success {
      slackSend message: "Pipeline Success: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
    }
  }
}
```

**실무 경험**
Jenkinsfile을 Git에 저장하여 파이프라인을 코드 리뷰하고 버전 관리했습니다. 병렬 테스트 실행으로 테스트 시간을 30분에서 10분으로 단축했고, 모든 마이크로서비스가 동일한 파이프라인 구조를 공유하여 일관성을 유지했습니다.
$md$


WHERE id = 'b0000000-0000-0000-0016-000000000007';

-- Question 8: Jenkins Scripted 파이프라인과 Declarative 파이프라인의 차이는?
UPDATE questions SET explanation =
$md$
**Jenkins Pipeline 두 가지 스타일**

| 특징 | Declarative Pipeline | Scripted Pipeline |
|------|---------------------|-------------------|
| 문법 | 선언적, 구조화됨 | 명령형, Groovy 스크립트 |
| 러닝 커브 | 쉬움 | 어려움 |
| 유연성 | 제한적 | 매우 높음 |
| 추천 대상 | 대부분의 경우 | 복잡한 로직 필요 시 |

**1. Declarative Pipeline (권장)**

**구조**
```groovy
pipeline {
  agent any

  environment {
    APP_NAME = 'myapp'
  }

  stages {
    stage('Build') {
      steps {
        sh './gradlew build'
      }
    }

    stage('Test') {
      steps {
        sh './gradlew test'
      }
    }
  }

  post {
    always {
      junit '**/test-results/*.xml'
    }
  }
}
```

**장점:**
- 읽기 쉽고 유지보수 용이
- 표준화된 구조
- 문법 검증 기능
- Blue Ocean UI 완벽 지원

**2. Scripted Pipeline**

**구조**
```groovy
node {
  def appName = 'myapp'

  try {
    stage('Build') {
      sh './gradlew build'
    }

    stage('Test') {
      sh './gradlew test'
    }

    stage('Deploy') {
      if (env.BRANCH_NAME == 'main') {
        sh 'kubectl apply -f k8s/'
      }
    }
  } catch (Exception e) {
    currentBuild.result = 'FAILURE'
    throw e
  } finally {
    junit '**/test-results/*.xml'
  }
}
```

**장점:**
- 완전한 Groovy 프로그래밍 가능
- 복잡한 조건문과 로직
- 동적 파이프라인 생성

**실무 비교 예시**

**복잡한 조건 처리**

**Declarative:**
```groovy
pipeline {
  agent any

  stages {
    stage('Deploy') {
      when {
        anyOf {
          branch 'main'
          branch 'develop'
        }
      }
      steps {
        script {
          if (env.BRANCH_NAME == 'main') {
            sh 'kubectl apply -f k8s/prod/'
          } else {
            sh 'kubectl apply -f k8s/dev/'
          }
        }
      }
    }
  }
}
```

**Scripted:**
```groovy
node {
  stage('Deploy') {
    if (env.BRANCH_NAME == 'main' || env.BRANCH_NAME == 'develop') {
      def environment = (env.BRANCH_NAME == 'main') ? 'prod' : 'dev'
      sh "kubectl apply -f k8s/${environment}/"
    }
  }
}
```

**언제 어떤 것을 사용할까?**

**Declarative 사용:**
- 표준적인 CI/CD 파이프라인 (90% 케이스)
- 팀 협업 (읽기 쉬움)
- Jenkins 초보자

**Scripted 사용:**
- 복잡한 비즈니스 로직
- 동적 파이프라인 생성
- Groovy 전문가

**실무 경험**
대부분의 프로젝트에서 Declarative Pipeline을 사용했고, 필요한 경우에만 `script {}` 블록으로 Groovy 코드를 추가했습니다. 이 방식이 가독성과 유연성의 균형을 잘 맞췄습니다.
$md$


WHERE id = 'b0000000-0000-0000-0016-000000000008';

-- Question 9: GitLab CI/CD나 GitHub Actions를 사용해본 경험이 있나요?
UPDATE questions SET explanation =
$md$
**GitLab CI/CD와 GitHub Actions 경험**

**GitHub Actions 사용 경험**

**1. 기본 워크플로우**
```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Set up JDK 17
        uses: actions/setup-java@v3
        with:
          java-version: '17'
          distribution: 'temurin'

      - name: Build with Gradle
        run: ./gradlew build

      - name: Run tests
        run: ./gradlew test

      - name: Upload test results
        uses: actions/upload-artifact@v3
        with:
          name: test-results
          path: build/test-results/

  deploy:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'

    steps:
      - uses: actions/checkout@v3

      - name: Deploy to Production
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        run: |
          aws eks update-kubeconfig --name prod-cluster
          kubectl apply -f k8s/
```

**2. GitHub Actions 주요 기능 활용**

**Matrix Strategy (병렬 테스트)**
```yaml
jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
        java-version: [11, 17, 21]

    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with:
          java-version: ${{ matrix.java-version }}
      - run: ./gradlew test
```

**Reusable Workflows**
```yaml
# .github/workflows/deploy.yml
on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying to ${{ inputs.environment }}"
```

**GitLab CI/CD 사용 경험**

**1. 기본 파이프라인**
```yaml
# .gitlab-ci.yml
stages:
  - build
  - test
  - deploy

variables:
  DOCKER_IMAGE: registry.gitlab.com/myproject/app

build:
  stage: build
  image: gradle:7.6-jdk17
  script:
    - ./gradlew build
  artifacts:
    paths:
      - build/libs/*.jar
    expire_in: 1 week

test:
  stage: test
  image: gradle:7.6-jdk17
  script:
    - ./gradlew test
  coverage: '/Total.*?([0-9]{1,3})%/'

deploy_prod:
  stage: deploy
  image: bitnami/kubectl:latest
  script:
    - kubectl apply -f k8s/
  only:
    - main
  when: manual
  environment:
    name: production
    url: https://myapp.com
```

**2. GitLab 고급 기능**

**Dynamic Child Pipelines**
```yaml
generate:
  stage: build
  script:
    - echo "include:" > pipeline.yml
    - echo "  - local: ./service-a/ci.yml" >> pipeline.yml
    - echo "  - local: ./service-b/ci.yml" >> pipeline.yml
  artifacts:
    paths:
      - pipeline.yml

trigger:
  stage: deploy
  trigger:
    include:
      - artifact: pipeline.yml
        job: generate
```

**비교표**

| 특징 | GitHub Actions | GitLab CI/CD |
|------|----------------|--------------|
| 설정 파일 | `.github/workflows/` | `.gitlab-ci.yml` |
| 러너 | GitHub-hosted 또는 self-hosted | GitLab Runner (self-hosted) |
| 마켓플레이스 | 매우 풍부 | 제한적 |
| 가격 | 2000분/월 무료 (Public 무제한) | 400분/월 무료 |
| 환경 관리 | Environments | Environments |
| 아티팩트 | 최대 500MB | 최대 1GB (설정 가능) |

**실무 경험**

**GitHub Actions:**
오픈소스 프로젝트에서 사용했고, Marketplace의 다양한 Actions를 활용하여 빠르게 파이프라인을 구성했습니다. PR마다 자동으로 테스트와 코드 품질 검사를 수행하여 코드 리뷰 효율이 크게 향상되었습니다.

**GitLab CI/CD:**
회사 내부 프로젝트에서 사용했고, GitLab Runner를 자체 서버에 설치하여 비용을 절감했습니다. Auto DevOps 기능으로 초기 설정을 빠르게 완료했고, Built-in Container Registry와 통합하여 편리하게 사용했습니다.
$md$


WHERE id = 'b0000000-0000-0000-0016-000000000009';
