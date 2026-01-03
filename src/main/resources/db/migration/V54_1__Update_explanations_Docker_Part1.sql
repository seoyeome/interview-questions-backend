-- V54_1: Update explanations for Docker questions (Part 1: Questions 0-13)

-- Question 0: Docker란 무엇이며 어떤 문제를 해결하기 위해 등장했나요?
UPDATE questions SET explanation =
'**Docker란?**

애플리케이션을 컨테이너로 패키징하여 어디서나 일관되게 실행할 수 있게 해주는 플랫폼입니다.

**등장 배경: "내 컴퓨터에서는 되는데..." 문제**

**전통적인 배포의 문제점:**
```
개발자 로컬:
- Ubuntu 20.04
- Python 3.8
- MySQL 5.7
→ 정상 작동!

프로덕션 서버:
- CentOS 7
- Python 3.6
- MySQL 8.0
→ 실행 안 됨!
```

**Docker가 해결하는 문제**

**1. 환경 불일치 문제**
```
Before Docker:
"내 컴퓨터에서는 되는데 서버에서는 안 돼요"
- OS 차이
- 라이브러리 버전 차이
- 설정 차이

After Docker:
"컨테이너는 어디서나 똑같이 실행됩니다"
- 모든 의존성을 컨테이너에 포함
- 개발/스테이징/프로덕션 환경 동일
```

**2. 의존성 충돌**
```
Before Docker:
서버 1대에 여러 앱 실행 시:
App A → Python 2.7 필요
App B → Python 3.8 필요
→ 충돌!

After Docker:
각 앱을 독립된 컨테이너로 실행:
Container A → Python 2.7
Container B → Python 3.8
→ 격리되어 충돌 없음
```

**3. 빠른 배포 및 확장**
```
Before Docker (VM):
새 서버 준비 → 30분
OS 설치 → 20분
의존성 설치 → 15분
= 총 65분

After Docker:
Docker 이미지 다운로드 → 2분
컨테이너 실행 → 5초
= 총 2분 5초
```

**Docker의 핵심 개념**

**컨테이너 (Container):**
```
┌───────────────────────┐
│   App + 의존성 전부    │ ← 컨테이너
│  (코드, 라이브러리,    │
│   설정, OS 도구)      │
└───────────────────────┘
        ↓
   어디서나 실행 가능
```

**이미지 (Image):**
```
컨테이너의 템플릿
- 읽기 전용
- 레이어로 구성
- 재사용 가능

예: nginx 이미지
- Ubuntu base
- Nginx 설치
- 설정 파일
→ 이 이미지로 여러 컨테이너 생성 가능
```

**실제 사용 예시**

**Dockerfile (애플리케이션 패키징):**
```dockerfile
FROM openjdk:17-slim
COPY build/libs/myapp.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
```

**실행:**
```bash
# 이미지 빌드
docker build -t myapp:1.0 .

# 컨테이너 실행
docker run -p 8080:8080 myapp:1.0

# 어떤 서버에서든 동일하게 작동!
```

**Docker vs 가상 머신 (VM)**

| 특징 | Docker | VM |
|------|--------|-----|
| 부팅 시간 | 초 단위 | 분 단위 |
| 리소스 | 경량 (MB) | 무거움 (GB) |
| 격리 수준 | 프로세스 수준 | 하드웨어 수준 |
| 성능 | 거의 네이티브 | 오버헤드 있음 |

**실무 경험**
이전 회사에서 수동 배포 시 환경 차이로 인한 버그가 자주 발생했습니다. Docker 도입 후 모든 환경(개발, 스테이징, 프로덕션)이 동일한 컨테이너로 실행되어 "내 컴퓨터에서는 되는데" 문제가 사라졌고, 배포 시간이 1시간에서 5분으로 단축되었습니다.'

WHERE id = 'b0000000-0000-0000-0013-000000000000';

-- Question 1: 컨테이너와 가상 머신의 차이는 무엇인가요?
UPDATE questions SET explanation =
'**컨테이너 vs 가상 머신 (VM) 비교**

**아키텍처 차이**

**가상 머신 (VM):**
```
┌──────────────────────────┐
│   App A   │   App B      │
│  (Guest OS)│ (Guest OS)  │ ← 각각 전체 OS
├──────────────────────────┤
│    Hypervisor            │ ← VM 관리
├──────────────────────────┤
│    Host OS               │
├──────────────────────────┤
│    Hardware              │
└──────────────────────────┘
```

**컨테이너 (Container):**
```
┌──────────────────────────┐
│ Container A│Container B  │ ← 앱만 격리
├──────────────────────────┤
│   Docker Engine          │ ← 컨테이너 관리
├──────────────────────────┤
│   Host OS                │ ← OS 공유
├──────────────────────────┤
│   Hardware               │
└──────────────────────────┘
```

**핵심 차이점**

**1. 격리 수준**

**VM:**
- 하드웨어 가상화
- 완전히 독립된 OS
- 강력한 격리

**Container:**
- OS 레벨 가상화
- 같은 커널 공유
- 프로세스 수준 격리

**2. 리소스 사용량**

| 항목 | VM | Container |
|------|-----|-----------|
| 메모리 | GB 단위 (OS 포함) | MB 단위 (앱만) |
| 디스크 | 10-100GB | 100MB-1GB |
| 부팅 시간 | 분 단위 | 초 단위 |
| 성능 | 오버헤드 10-20% | 거의 네이티브 |

**실제 예시:**

**VM으로 3개 서비스 실행:**
```
VM 1: Web Server
  ├─ CentOS 7 (2GB)
  ├─ Nginx (100MB)
  └─ 총 2.1GB

VM 2: App Server
  ├─ Ubuntu 20.04 (2GB)
  ├─ Java App (500MB)
  └─ 총 2.5GB

VM 3: Database
  ├─ Ubuntu 20.04 (2GB)
  ├─ PostgreSQL (200MB)
  └─ 총 2.2GB

전체: 6.8GB
```

**Container로 3개 서비스 실행:**
```
Container 1: Nginx (150MB)
Container 2: Java App (500MB)
Container 3: PostgreSQL (300MB)

전체: 950MB (약 7배 절감)
```

**3. 시작 시간**

**VM:**
```
1. BIOS 부팅
2. OS 커널 로드
3. Init 프로세스 실행
4. 시스템 서비스 시작
5. 애플리케이션 실행

= 30초 ~ 2분
```

**Container:**
```
1. 네임스페이스 생성
2. 컨테이너 프로세스 실행

= 1-5초
```

**4. 이식성 (Portability)**

**VM:**
```
VMware → VirtualBox 이동 시:
- VM 이미지 변환 필요
- 설정 재조정 필요
- 호환성 문제 가능
```

**Container:**
```
Docker → 어디든 이동:
- 같은 이미지 그대로 사용
- 클라우드 간 이동 쉬움
- "Build once, run anywhere"
```

**5. 보안 및 격리**

**VM (강한 격리):**
```
VM 1이 해킹당해도
VM 2는 완전히 독립적
→ 안전함

각 VM은 별도의 커널
→ 커널 취약점 영향 격리
```

**Container (약한 격리):**
```
Container 1이 해킹당하면
같은 호스트 커널 공유
→ 잠재적 위험

커널 취약점 시
모든 컨테이너 영향 가능
```

**언제 무엇을 사용할까?**

**VM 사용 시:**
```
✓ 서로 다른 OS 필요
  (Linux, Windows 동시 운영)
✓ 강력한 보안 격리 필요
  (멀티 테넌트 환경)
✓ 레거시 애플리케이션
  (전체 OS 환경 필요)
```

**Container 사용 시:**
```
✓ 마이크로서비스 아키텍처
✓ CI/CD 파이프라인
✓ 빠른 확장/축소 필요
✓ 클라우드 네이티브 앱
✓ 동일 OS 환경
```

**실무 예시**

**하이브리드 접근:**
```
Cloud Provider
  └─ VM Instance (Ubuntu 20.04)
      ├─ Container: Web Server
      ├─ Container: App Server
      ├─ Container: Cache (Redis)
      └─ Container: Message Queue

→ VM으로 기본 격리 제공
→ Container로 애플리케이션 배포
```

**실전 비교:**
```bash
# VM 시작
vagrant up
# 1분 30초 소요

# Container 시작
docker run nginx
# 2초 소요
```

**리소스 사용 비교:**
```bash
# VM 메모리 사용
VirtualBox VM: 2048MB (기본 할당)

# Container 메모리 사용
docker stats
nginx: 5MB (실제 사용량)
```

**실무 경험**
클라우드 비용 절감을 위해 VM에서 Container로 전환했습니다. 기존 10개 VM (각 2GB)을 Docker로 전환하여 전체 메모리 사용량을 20GB에서 4GB로 줄였고, 월 클라우드 비용이 $500에서 $100로 80% 절감되었습니다. 또한 배포 시간이 5분에서 30초로 단축되어 개발 속도도 크게 향상되었습니다.'

WHERE id = 'b0000000-0000-0000-0013-000000000001';

-- Question 2: Docker 이미지와 컨테이너의 차이는?
UPDATE questions SET explanation =
'**Docker 이미지 vs 컨테이너**

**핵심 개념**

**이미지 (Image):**
- **설계도/템플릿**
- 읽기 전용 (Read-Only)
- 실행 파일과 모든 의존성 포함
- 한 번 빌드하면 변경 불가 (Immutable)

**컨테이너 (Container):**
- **실행 중인 인스턴스**
- 읽기/쓰기 가능
- 이미지를 기반으로 생성
- 여러 개 생성 가능

**비유**

```
이미지    = 클래스 (Class)
컨테이너  = 객체 (Object/Instance)

class Car {  ← 이미지
  drive() { }
}

Car myCar = new Car();  ← 컨테이너 1
Car yourCar = new Car(); ← 컨테이너 2
```

**관계**

```
┌─────────────┐
│  nginx 이미지 │ ← 템플릿 (읽기 전용)
└─────────────┘
       ↓ docker run
  ┌─────────┬─────────┬─────────┐
  │Container│Container│Container│ ← 실행 중 (읽기/쓰기)
  │    1    │    2    │    3    │
  └─────────┴─────────┴─────────┘
```

**레이어 구조**

**이미지는 레이어로 구성:**
```dockerfile
FROM ubuntu:20.04          # Layer 1: Ubuntu base (100MB)
RUN apt-get update         # Layer 2: 업데이트 (50MB)
RUN apt-get install nginx  # Layer 3: Nginx 설치 (30MB)
COPY index.html /var/www/  # Layer 4: 파일 복사 (1KB)

총 이미지 크기: 180MB (레이어 합산)
```

**컨테이너는 이미지 위에 쓰기 가능 레이어 추가:**
```
┌────────────────────┐
│ Container Layer    │ ← 쓰기 가능 (읽기/쓰기)
├────────────────────┤
│ Layer 4: index.html│
│ Layer 3: nginx     │ ← 읽기 전용 (이미지)
│ Layer 2: apt update│
│ Layer 1: ubuntu    │
└────────────────────┘
```

**실제 명령어 비교**

**이미지 관련 명령어:**
```bash
# 이미지 목록 확인
docker images

# 이미지 빌드
docker build -t myapp:1.0 .

# 이미지 다운로드
docker pull nginx:latest

# 이미지 삭제
docker rmi nginx:latest

# 이미지 푸시
docker push myapp:1.0
```

**컨테이너 관련 명령어:**
```bash
# 컨테이너 실행 (이미지로부터 생성)
docker run -d --name web nginx

# 실행 중인 컨테이너 목록
docker ps

# 모든 컨테이너 목록 (중지된 것 포함)
docker ps -a

# 컨테이너 중지
docker stop web

# 컨테이너 삭제
docker rm web
```

**생명주기**

**이미지:**
```
빌드 → 저장 → 다운로드 → 삭제
(생성 후 변경 불가)
```

**컨테이너:**
```
생성 → 실행 → 중지 → 재시작 → 삭제
(상태 변경 가능)
```

**실제 예시**

**1. 하나의 이미지로 여러 컨테이너:**
```bash
# nginx 이미지 하나
docker pull nginx:latest

# 이 이미지로 3개 컨테이너 실행
docker run -d -p 8081:80 --name web1 nginx
docker run -d -p 8082:80 --name web2 nginx
docker run -d -p 8083:80 --name web3 nginx

# 같은 이미지, 다른 컨테이너
```

**2. 컨테이너 수정 vs 이미지 불변:**
```bash
# 컨테이너에 파일 생성
docker exec web1 sh -c "echo 'Hello' > /tmp/test.txt"

# web1 컨테이너에만 영향
# web2, web3 컨테이너에는 영향 없음
# 원본 nginx 이미지도 변경되지 않음
```

**3. 컨테이너를 이미지로 저장:**
```bash
# 컨테이너 변경사항을 새 이미지로 커밋
docker commit web1 custom-nginx:1.0

# 새 이미지 생성됨
docker images | grep custom-nginx
# custom-nginx  1.0  abc123  2 seconds ago  135MB
```

**크기 비교**

**이미지:**
```bash
docker images
REPOSITORY    TAG      SIZE
nginx         latest   142MB  ← 디스크에 저장된 크기
redis         latest   117MB
postgres      latest   376MB
```

**컨테이너:**
```bash
docker ps -s
CONTAINER ID   IMAGE    SIZE
abc123         nginx    2B (virtual 142MB)
                        ↑        ↑
                   변경 크기   전체 크기
```

**메모리 관점**

```
┌──────────────────────────┐
│  이미지 (디스크에 저장)    │
│  - nginx: 142MB           │
│  - redis: 117MB           │
│  - postgres: 376MB        │
└──────────────────────────┘

        ↓ docker run

┌──────────────────────────┐
│  컨테이너 (메모리에서 실행)│
│  - nginx: 5MB (실제 사용) │
│  - redis: 10MB            │
│  - postgres: 50MB         │
└──────────────────────────┘
```

**실무 시나리오**

**시나리오 1: 배포**
```bash
# 개발 환경
docker build -t myapp:1.0 .
docker push myregistry.com/myapp:1.0

# 프로덕션 서버
docker pull myregistry.com/myapp:1.0
docker run -d myregistry.com/myapp:1.0

# 같은 이미지 = 동일한 환경
```

**시나리오 2: 확장**
```bash
# 트래픽 증가 시
docker run -d --name app1 myapp:1.0
docker run -d --name app2 myapp:1.0
docker run -d --name app3 myapp:1.0

# 이미지 1개 → 컨테이너 3개
# 빠른 수평 확장
```

**비교표**

| 항목 | 이미지 | 컨테이너 |
|------|--------|----------|
| 역할 | 템플릿/설계도 | 실행 인스턴스 |
| 상태 | 읽기 전용 | 읽기/쓰기 가능 |
| 변경 | 불가능 (Immutable) | 가능 (Mutable) |
| 생성 | docker build | docker run |
| 확인 | docker images | docker ps |
| 저장 위치 | 디스크 | 메모리 + 디스크 |
| 개수 | 1개 | N개 (같은 이미지로) |

**실무 경험**
마이크로서비스 프로젝트에서 각 서비스마다 Docker 이미지를 빌드하여 Docker Hub에 저장했습니다. 프로덕션에서는 같은 이미지로 로드 밸런서 뒤에 10개 컨테이너를 실행하여 트래픽을 분산 처리했고, 트래픽 증가 시 컨테이너를 추가하는 것만으로 쉽게 확장할 수 있었습니다.'

WHERE id = 'b0000000-0000-0000-0013-000000000002';

-- Question 3: Dockerfile이란 무엇인가요?
UPDATE questions SET explanation =
'**Dockerfile이란?**

Docker 이미지를 빌드하기 위한 명령어들을 담은 텍스트 파일입니다. "이미지 빌드 스크립트"라고 생각하면 됩니다.

**기본 구조**

```dockerfile
# 베이스 이미지 지정
FROM ubuntu:20.04

# 메타데이터
LABEL maintainer="dev@company.com"

# 작업 디렉토리 설정
WORKDIR /app

# 파일 복사
COPY . /app

# 명령어 실행 (이미지 빌드 시)
RUN apt-get update && \
    apt-get install -y python3

# 환경 변수 설정
ENV APP_ENV=production

# 포트 노출
EXPOSE 8080

# 컨테이너 실행 시 실행될 명령어
CMD ["python3", "app.py"]
```

**주요 명령어**

**1. FROM (베이스 이미지)**
```dockerfile
# 공식 이미지 사용
FROM python:3.9-slim

# 특정 버전 지정
FROM node:18-alpine

# 멀티 스테이지 빌드
FROM golang:1.20 AS builder
...
FROM alpine:latest
```

**2. WORKDIR (작업 디렉토리)**
```dockerfile
WORKDIR /app

# 이후 모든 명령은 /app에서 실행
COPY . .  # 현재 디렉토리를 /app으로 복사
RUN ls -la  # /app 디렉토리에서 실행
```

**3. COPY vs ADD**
```dockerfile
# COPY (권장)
COPY package.json /app/
COPY src/ /app/src/

# ADD (특별한 기능)
ADD app.tar.gz /app/  # 자동 압축 해제
ADD https://example.com/file.txt /app/  # URL 다운로드
```

**4. RUN (빌드 시 실행)**
```dockerfile
# Shell 형식
RUN apt-get update
RUN apt-get install -y nginx

# Exec 형식 (권장)
RUN ["apt-get", "update"]

# 여러 명령어 결합 (레이어 최소화)
RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/*
```

**5. CMD vs ENTRYPOINT**

**CMD (기본 명령어, 오버라이드 가능):**
```dockerfile
CMD ["python", "app.py"]

# 실행:
docker run myapp  # python app.py 실행
docker run myapp python test.py  # python test.py 실행 (CMD 무시)
```

**ENTRYPOINT (고정 명령어):**
```dockerfile
ENTRYPOINT ["python"]
CMD ["app.py"]

# 실행:
docker run myapp  # python app.py
docker run myapp test.py  # python test.py
```

**실제 예시**

**Spring Boot 애플리케이션:**
```dockerfile
# 멀티 스테이지 빌드
FROM gradle:7.6-jdk17 AS builder
WORKDIR /app
COPY build.gradle settings.gradle ./
COPY src ./src
RUN gradle build -x test

FROM openjdk:17-slim
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar

EXPOSE 8080

ENV JAVA_OPTS="-Xmx512m -Xms256m"

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
```

**Node.js 애플리케이션:**
```dockerfile
FROM node:18-alpine

WORKDIR /usr/src/app

# package.json만 먼저 복사 (캐싱 최적화)
COPY package*.json ./

# 의존성 설치
RUN npm ci --only=production

# 소스 코드 복사
COPY . .

EXPOSE 3000

# 일반 사용자로 실행 (보안)
USER node

CMD ["node", "server.js"]
```

**Python Flask 애플리케이션:**
```dockerfile
FROM python:3.9-slim

WORKDIR /app

# 의존성 설치
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 애플리케이션 복사
COPY app.py .
COPY templates/ templates/

EXPOSE 5000

ENV FLASK_APP=app.py
ENV FLASK_ENV=production

CMD ["flask", "run", "--host=0.0.0.0"]
```

**최적화 기법**

**1. 레이어 캐싱 활용**
```dockerfile
# ❌ 나쁜 예: 소스 변경 시 npm install 재실행
COPY . .
RUN npm install

# ✅ 좋은 예: package.json 변경 시에만 npm install
COPY package*.json ./
RUN npm install
COPY . .
```

**2. 멀티 스테이지 빌드**
```dockerfile
# 빌드 스테이지
FROM node:18 AS builder
WORKDIR /app
COPY . .
RUN npm run build  # 빌드 도구 포함 (500MB)

# 실행 스테이지
FROM node:18-alpine  # 경량 이미지
WORKDIR /app
COPY --from=builder /app/dist ./dist  # 빌드 결과만 복사
COPY package*.json ./
RUN npm ci --only=production

CMD ["node", "dist/server.js"]

# 최종 이미지: 100MB (빌드 도구 제외)
```

**3. .dockerignore 사용**
```.dockerignore
node_modules
npm-debug.log
.git
.env
*.md
.DS_Store
coverage/

# Docker 빌드 시 제외할 파일
```

**빌드 및 실행**

```bash
# 이미지 빌드
docker build -t myapp:1.0 .

# 특정 Dockerfile 사용
docker build -t myapp:1.0 -f Dockerfile.prod .

# 빌드 인자 전달
docker build --build-arg VERSION=1.0 -t myapp .

# 빌드 캐시 무시
docker build --no-cache -t myapp .

# 컨테이너 실행
docker run -p 8080:8080 myapp:1.0
```

**환경별 Dockerfile**

**개발 환경 (Dockerfile.dev):**
```dockerfile
FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm install  # devDependencies 포함
COPY . .
CMD ["npm", "run", "dev"]  # Hot reload
```

**프로덕션 환경 (Dockerfile.prod):**
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production  # 프로덕션 의존성만
COPY . .
CMD ["node", "server.js"]  # 최적화된 실행
```

**실무 경험**
Spring Boot 프로젝트에서 멀티 스테이지 빌드를 사용하여 이미지 크기를 800MB에서 250MB로 줄였습니다. 빌드 스테이지에서는 Gradle과 JDK를 사용하여 JAR를 빌드하고, 실행 스테이지에서는 JRE만 포함하여 불필요한 도구를 제외했습니다. 또한 레이어 캐싱을 활용하여 의존성이 변경되지 않은 경우 빌드 시간을 5분에서 30초로 단축했습니다.'

WHERE id = 'b0000000-0000-0000-0013-000000000003';

-- Question 4: Docker Hub는 어떤 서비스인가요?
UPDATE questions SET explanation =
'**Docker Hub란?**

Docker 이미지를 저장하고 공유할 수 있는 클라우드 기반 레지스트리 서비스입니다. "Docker의 GitHub"라고 생각하면 됩니다.

**주요 기능**

**1. 공식 이미지 제공**
```bash
# 공식 이미지 다운로드
docker pull nginx
docker pull postgres
docker pull redis

# Docker Hub에서 자동으로 다운로드
# https://hub.docker.com/_/nginx
```

**2. 이미지 저장 및 공유**
```bash
# 로그인
docker login

# 이미지 태그 지정
docker tag myapp:1.0 username/myapp:1.0

# Docker Hub에 푸시
docker push username/myapp:1.0

# 다른 서버에서 풀
docker pull username/myapp:1.0
```

**3. 자동 빌드 (Automated Builds)**
```
GitHub/Bitbucket 연동
  ↓
코드 푸시 시 자동으로 Docker 이미지 빌드
  ↓
Docker Hub에 자동 업로드
```

**공식 이미지 vs 사용자 이미지**

**공식 이미지 (Official Images):**
```
nginx          ← 검증된 공식 이미지
postgres
node
python
```

**사용자 이미지 (User Images):**
```
username/myapp      ← 개인/조직 이미지
company/frontend
myteam/backend
```

**실무 사용 예시**

**CI/CD 파이프라인:**
```yaml
# GitHub Actions
- name: Build and Push to Docker Hub
  run: |
    docker login -u ${{ secrets.DOCKER_USERNAME }} -p ${{ secrets.DOCKER_PASSWORD }}
    docker build -t mycompany/myapp:${{ github.sha }} .
    docker push mycompany/myapp:${{ github.sha }}
```

**무료 vs 유료**

| 기능 | 무료 | 유료 (Pro) |
|------|------|-----------|
| Public 저장소 | 무제한 | 무제한 |
| Private 저장소 | 1개 | 무제한 |
| 이미지 Pull | 200 requests/6h | 무제한 |
| 자동 빌드 | 제한적 | 무제한 |

**Private Registry 대안**
- AWS ECR (Elastic Container Registry)
- Google Container Registry (GCR)
- Azure Container Registry (ACR)
- Harbor (Self-hosted)

**실무 경험**
Docker Hub를 사용하여 마이크로서비스 이미지들을 저장하고 있습니다. GitHub Actions에서 코드 푸시 시 자동으로 이미지를 빌드하여 Docker Hub에 올리고, Kubernetes 클러스터가 이를 자동으로 배포합니다.'

WHERE id = 'b0000000-0000-0000-0013-000000000004';

-- Question 5: docker run 명령어의 주요 옵션은?
UPDATE questions SET explanation =
'**docker run 주요 옵션**

**기본 형식**
```bash
docker run [OPTIONS] IMAGE [COMMAND]
```

**주요 옵션**

**1. -d (detached mode - 백그라운드 실행)**
```bash
# 포그라운드 (터미널 점유)
docker run nginx
# Ctrl+C로 종료 시 컨테이너도 종료

# 백그라운드 (터미널 해제)
docker run -d nginx
# 컨테이너 ID 반환 후 터미널 반환
```

**2. -p (포트 매핑)**
```bash
# 호스트:컨테이너
docker run -p 8080:80 nginx
# localhost:8080 → 컨테이너 80 포트

# 여러 포트
docker run -p 80:80 -p 443:443 nginx

# 모든 인터페이스
docker run -p 0.0.0.0:8080:80 nginx
```

**3. --name (컨테이너 이름)**
```bash
# 이름 없이
docker run -d nginx
# 랜덤 이름: elegant_euler, happy_darwin...

# 이름 지정
docker run -d --name web nginx
# 관리 쉬움: docker stop web
```

**4. -v (볼륨 마운트)**
```bash
# 호스트 디렉토리 마운트
docker run -v /host/path:/container/path nginx

# 실제 예시
docker run -v $(pwd)/html:/usr/share/nginx/html nginx
# 로컬 html 폴더를 nginx 웹 루트로 마운트

# Named volume
docker run -v mydata:/data postgres
```

**5. -e (환경 변수)**
```bash
# 단일 변수
docker run -e DATABASE_URL=postgresql://localhost/db myapp

# 여러 변수
docker run \
  -e DB_HOST=localhost \
  -e DB_USER=admin \
  -e DB_PASS=secret \
  myapp

# .env 파일 사용
docker run --env-file .env myapp
```

**6. --rm (자동 삭제)**
```bash
# 종료 후 자동 삭제
docker run --rm ubuntu echo "Hello"
# 일회성 작업에 유용

# 기본 동작 (삭제 안 됨)
docker run ubuntu echo "Hello"
# docker ps -a에 남음
```

**7. -it (인터랙티브 + TTY)**
```bash
# 인터랙티브 쉘 실행
docker run -it ubuntu bash
# 컨테이너 내부 쉘 접속

# -i: 표준 입력 열기
# -t: 가상 터미널 할당
```

**8. --network (네트워크 설정)**
```bash
# 기본 브리지 네트워크
docker run --network bridge nginx

# 커스텀 네트워크
docker network create mynetwork
docker run --network mynetwork nginx

# 호스트 네트워크 (포트 매핑 불필요)
docker run --network host nginx
```

**9. --restart (재시작 정책)**
```bash
# 항상 재시작
docker run --restart always redis

# 실패 시에만 재시작
docker run --restart on-failure nginx

# 재시작 안 함 (기본값)
docker run --restart no nginx
```

**10. -w (작업 디렉토리)**
```bash
# 작업 디렉토리 지정
docker run -w /app node npm test
# /app 디렉토리에서 명령 실행
```

**실전 조합 예시**

**웹 서버 실행:**
```bash
docker run -d \
  --name web \
  -p 80:80 \
  -v $(pwd)/html:/usr/share/nginx/html \
  --restart always \
  nginx
```

**데이터베이스 실행:**
```bash
docker run -d \
  --name postgres \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=secret \
  -e POSTGRES_DB=mydb \
  -v pgdata:/var/lib/postgresql/data \
  --restart always \
  postgres:14
```

**개발 환경 (일회성):**
```bash
docker run -it --rm \
  -v $(pwd):/app \
  -w /app \
  -p 3000:3000 \
  node:18 \
  npm start
```

**리소스 제한:**
```bash
docker run -d \
  --name app \
  --memory="512m" \
  --cpus="1.0" \
  myapp
```

**전체 옵션 조합:**
```bash
docker run -d \
  --name myapp \
  -p 8080:8080 \
  -v $(pwd)/data:/data \
  -e APP_ENV=production \
  -e DB_HOST=postgres \
  --network mynetwork \
  --restart on-failure \
  --memory="1g" \
  --cpus="2.0" \
  myapp:1.0
```

**실무 경험**
프로덕션 환경에서는 항상 -d, --name, --restart always를 조합하여 사용합니다. 볼륨 마운트로 데이터 영속성을 보장하고, 환경 변수로 설정을 분리하여 같은 이미지를 여러 환경에서 사용할 수 있도록 구성했습니다.'

WHERE id = 'b0000000-0000-0000-0013-000000000005';

-- Question 6: 이미지 빌드 시 최적화 사항은?
UPDATE questions SET explanation =
'**Docker 이미지 빌드 최적화**

**1. 베이스 이미지 선택**

**크기 비교:**
```dockerfile
# ❌ Full 이미지 (1.1GB)
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y python3

# ✅ Slim 이미지 (200MB)
FROM python:3.9-slim

# ✅ Alpine 이미지 (50MB)
FROM python:3.9-alpine
```

**2. 레이어 최소화**

**❌ 나쁜 예 (3개 레이어):**
```dockerfile
RUN apt-get update
RUN apt-get install -y nginx
RUN apt-get clean
```

**✅ 좋은 예 (1개 레이어):**
```dockerfile
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

**3. 빌드 캐시 활용**

**❌ 나쁜 예 (항상 재빌드):**
```dockerfile
COPY . /app
RUN npm install
```

**✅ 좋은 예 (의존성 캐싱):**
```dockerfile
# package.json만 먼저 복사
COPY package*.json /app/
RUN npm install
# 소스 코드는 나중에
COPY . /app
```

**4. 멀티 스테이지 빌드**

**❌ 단일 스테이지 (800MB):**
```dockerfile
FROM node:18
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build
CMD ["npm", "start"]
# node_modules, 빌드 도구 전부 포함
```

**✅ 멀티 스테이지 (150MB):**
```dockerfile
# 빌드 스테이지
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# 실행 스테이지
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
CMD ["node", "dist/server.js"]
# 빌드 도구 제외, 결과물만 포함
```

**5. .dockerignore 사용**

```.dockerignore
# 빌드에서 제외
node_modules
npm-debug.log
.git
.env
*.md
.DS_Store
coverage/
.vscode/
*.log
```

**6. 불필요한 파일 제거**

```dockerfile
RUN apt-get update && \
    apt-get install -y python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \  # 패키지 캐시 삭제
    rm -rf /tmp/* && \                # 임시 파일 삭제
    rm -rf /root/.cache                # 캐시 삭제
```

**7. 특정 버전 지정**

**❌ 나쁜 예 (재현성 없음):**
```dockerfile
FROM node:latest
RUN npm install express
```

**✅ 좋은 예 (재현 가능):**
```dockerfile
FROM node:18.16.0-alpine
RUN npm install express@4.18.2
```

**실전 최적화 예시**

**Spring Boot 최적화:**
```dockerfile
# 빌드 스테이지
FROM gradle:7.6-jdk17 AS builder
WORKDIR /app

# 의존성 캐싱
COPY build.gradle settings.gradle ./
RUN gradle dependencies --no-daemon

# 소스 빌드
COPY src ./src
RUN gradle build -x test --no-daemon

# 실행 스테이지
FROM openjdk:17-slim
WORKDIR /app

# JAR만 복사
COPY --from=builder /app/build/libs/*.jar app.jar

# 비 root 사용자로 실행 (보안)
RUN addgroup --system --gid 1001 spring && \
    adduser --system --uid 1001 --ingroup spring spring
USER spring

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

# 최종 크기: 250MB (빌드 도구 제외)
```

**Node.js 최적화:**
```dockerfile
# 빌드 스테이지
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && \
    npm cache clean --force

# 실행 스테이지
FROM node:18-alpine
WORKDIR /app

# 필요한 파일만 복사
COPY --from=builder /app/node_modules ./node_modules
COPY . .

# 비 root 사용자
USER node

EXPOSE 3000
CMD ["node", "server.js"]

# 최종 크기: 100MB
```

**이미지 크기 비교**

**최적화 전:**
```
REPOSITORY   TAG      SIZE
myapp        v1       1.2GB
├─ Ubuntu base: 900MB
├─ Build tools: 200MB
├─ node_modules: 80MB
└─ Source: 20MB
```

**최적화 후:**
```
REPOSITORY   TAG      SIZE
myapp        v2       150MB
├─ Alpine base: 50MB
├─ Production deps: 80MB
└─ Built assets: 20MB

절감: 87.5%
```

**빌드 시간 최적화**

```bash
# 캐시 없이 (5분)
docker build --no-cache -t myapp .

# 캐시 활용 (30초)
docker build -t myapp .
# package.json 변경 없으면 npm install 스킵

# BuildKit 사용 (더 빠름)
DOCKER_BUILDKIT=1 docker build -t myapp .
```

**실무 경험**
Node.js 프로젝트에서 멀티 스테이지 빌드를 도입하여 이미지 크기를 1.2GB에서 150MB로 줄였습니다. Alpine 베이스 이미지와 .dockerignore를 활용하여 불필요한 파일을 제외했고, 의존성 캐싱으로 빌드 시간을 5분에서 30초로 단축했습니다. 이를 통해 Docker Hub 전송 시간과 배포 시간이 크게 개선되었습니다.'

WHERE id = 'b0000000-0000-0000-0013-000000000006';

-- Question 7: 도커 컴포즈는 무엇이고 언제 사용하나요?
UPDATE questions SET explanation =
'**Docker Compose란?**

여러 컨테이너를 정의하고 실행하는 도구입니다. YAML 파일로 다중 컨테이너 애플리케이션을 설정하고 한 번에 관리할 수 있습니다.

**문제 상황**

**Docker 명령어로 실행 (복잡):**
```bash
# 1. 네트워크 생성
docker network create mynetwork

# 2. PostgreSQL 실행
docker run -d \
  --name postgres \
  --network mynetwork \
  -e POSTGRES_PASSWORD=secret \
  -v pgdata:/var/lib/postgresql/data \
  postgres:14

# 3. Redis 실행
docker run -d \
  --name redis \
  --network mynetwork \
  redis:7

# 4. 백엔드 실행
docker run -d \
  --name backend \
  --network mynetwork \
  -e DATABASE_URL=postgresql://postgres:5432/db \
  -e REDIS_URL=redis://redis:6379 \
  -p 8080:8080 \
  myapp:latest

# 5. 프론트엔드 실행
docker run -d \
  --name frontend \
  --network mynetwork \
  -p 3000:3000 \
  frontend:latest

# → 명령어 4개, 관리 복잡, 재현 어려움
```

**Docker Compose로 실행 (간단):**
```yaml
# docker-compose.yml
version: '3.8'

services:
  postgres:
    image: postgres:14
    environment:
      POSTGRES_PASSWORD: secret
    volumes:
      - pgdata:/var/lib/postgresql/data

  redis:
    image: redis:7

  backend:
    image: myapp:latest
    ports:
      - "8080:8080"
    environment:
      DATABASE_URL: postgresql://postgres:5432/db
      REDIS_URL: redis://redis:6379
    depends_on:
      - postgres
      - redis

  frontend:
    image: frontend:latest
    ports:
      - "3000:3000"
    depends_on:
      - backend

volumes:
  pgdata:
```

**실행:**
```bash
# 모든 서비스 시작
docker-compose up -d

# 모든 서비스 종료 및 삭제
docker-compose down
```

**주요 기능**

**1. 서비스 정의**
```yaml
services:
  web:
    image: nginx
    ports:
      - "80:80"

  app:
    build: .  # Dockerfile로 빌드
    ports:
      - "8080:8080"
```

**2. 의존성 관리**
```yaml
services:
  db:
    image: postgres

  backend:
    depends_on:
      - db  # db 먼저 시작
```

**3. 환경 변수 관리**
```yaml
services:
  app:
    environment:
      - NODE_ENV=production
      - API_KEY=${API_KEY}  # .env 파일에서 로드
    env_file:
      - .env
```

**4. 볼륨 관리**
```yaml
services:
  db:
    volumes:
      - dbdata:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql

volumes:
  dbdata:
```

**5. 네트워크 자동 생성**
```yaml
# 자동으로 네트워크 생성
# 모든 서비스가 서비스 이름으로 통신 가능

services:
  backend:
    # postgres:5432로 접근 가능
  postgres:
    image: postgres
```

**실전 예시**

**풀스택 애플리케이션:**
```yaml
version: '3.8'

services:
  # Database
  postgres:
    image: postgres:14
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: secret
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  # Cache
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  # Backend API
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    environment:
      DATABASE_URL: postgresql://admin:secret@postgres:5432/myapp
      REDIS_URL: redis://redis:6379
      JWT_SECRET: ${JWT_SECRET}
    depends_on:
      - postgres
      - redis
    volumes:
      - ./backend:/app
      - /app/node_modules

  # Frontend
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      REACT_APP_API_URL: http://localhost:8080
    depends_on:
      - backend
    volumes:
      - ./frontend:/app
      - /app/node_modules

volumes:
  postgres_data:
```

**개발 환경 설정:**
```yaml
# docker-compose.dev.yml
version: '3.8'

services:
  backend:
    build:
      context: ./backend
      target: development  # Dockerfile의 dev 스테이지
    volumes:
      - ./backend:/app  # Hot reload
    command: npm run dev

  frontend:
    build:
      context: ./frontend
    volumes:
      - ./frontend:/app
    command: npm start
```

**실행:**
```bash
docker-compose -f docker-compose.dev.yml up
```

**주요 명령어**

```bash
# 시작 (포그라운드)
docker-compose up

# 시작 (백그라운드)
docker-compose up -d

# 중지
docker-compose stop

# 중지 및 삭제
docker-compose down

# 중지, 삭제, 볼륨도 삭제
docker-compose down -v

# 로그 확인
docker-compose logs -f backend

# 특정 서비스만 시작
docker-compose up -d postgres redis

# 재빌드
docker-compose build

# 재빌드 및 시작
docker-compose up -d --build

# 실행 중인 서비스 확인
docker-compose ps

# 서비스 스케일링
docker-compose up -d --scale backend=3
```

**언제 사용하나?**

**✅ Docker Compose 사용:**
- 로컬 개발 환경
- 통합 테스트 환경
- 소규모 프로젝트
- 단일 호스트 배포
- 마이크로서비스 로컬 테스트

**❌ 프로덕션 대신 사용:**
- Kubernetes (대규모, 멀티 호스트)
- Docker Swarm (오케스트레이션)
- ECS, GKE (클라우드 관리형)

**실무 경험**
로컬 개발 환경을 Docker Compose로 구성하여 팀 전체가 동일한 환경에서 작업할 수 있게 했습니다. 신규 팀원이 "docker-compose up" 한 번으로 전체 스택(DB, 캐시, API, 프론트엔드)을 실행할 수 있어 온보딩 시간이 하루에서 10분으로 단축되었습니다.'

WHERE id = 'b0000000-0000-0000-0013-000000000007';

-- Question 8: 여러 개의 컨테이너를 오케스트레이션하기 위해 어떤 도구를 사용해봤나요?
UPDATE questions SET explanation =
'**컨테이너 오케스트레이션 도구 사용 경험**

**주요 도구**

| 도구 | 규모 | 복잡도 | 사용 사례 |
|------|------|--------|---------|
| Docker Compose | 소규모 | 낮음 | 로컬 개발, 단일 호스트 |
| Docker Swarm | 중규모 | 중간 | 간단한 프로덕션 |
| Kubernetes | 대규모 | 높음 | 엔터프라이즈 프로덕션 |

**1. Kubernetes (주로 사용)**

**기능:**
- 자동 스케일링 (HPA)
- 자동 롤링 업데이트
- 자가 복구 (Self-healing)
- 서비스 디스커버리
- 로드 밸런싱

**실무 사용 예시:**
```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 3  # 3개 인스턴스 유지
  template:
    spec:
      containers:
      - name: backend
        image: myapp:1.0
        resources:
          limits:
            memory: "512Mi"
            cpu: "500m"
---
# service.yaml
apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  type: LoadBalancer
  selector:
    app: backend
  ports:
  - port: 80
    targetPort: 8080
```

**2. Docker Swarm**

**특징:**
- Kubernetes보다 간단
- Docker 명령어와 유사
- 소규모 클러스터에 적합

**예시:**
```bash
# Swarm 초기화
docker swarm init

# 서비스 배포
docker service create \
  --name web \
  --replicas 3 \
  --publish 80:80 \
  nginx

# 스케일링
docker service scale web=5
```

**3. AWS ECS (Elastic Container Service)**

**특징:**
- AWS 완전 관리형
- Kubernetes보다 러닝 커브 낮음
- AWS 서비스와 통합

**실무 경험:**
```json
{
  "family": "myapp",
  "taskDefinition": {
    "containerDefinitions": [{
      "name": "app",
      "image": "myapp:latest",
      "memory": 512,
      "cpu": 256
    }]
  },
  "desiredCount": 3
}
```

**실무에서 Kubernetes 선택 이유:**
1. 클라우드 중립적 (AWS, GCP, Azure 모두 지원)
2. 강력한 커뮤니티와 생태계
3. 엔터프라이즈 수준 기능
4. Helm으로 패키지 관리 용이
5. 자동화된 복구 및 스케일링

**실무 경험**
프로덕션에서 Kubernetes를 사용하여 20개 마이크로서비스를 오케스트레이션하고 있습니다. HPA로 트래픽에 따라 자동 스케일링하며, 롤링 업데이트로 무중단 배포를 구현했습니다. 로컬 개발은 Docker Compose를 사용하여 간편하게 관리하고 있습니다.'

WHERE id = 'b0000000-0000-0000-0013-000000000008';

-- Question 9: 도커에서 볼륨은 무엇이며 왜 필요한가요?
UPDATE questions SET explanation =
'**Docker 볼륨 (Volume)이란?**

컨테이너가 삭제되어도 데이터를 보존하기 위한 영속적 저장소입니다.

**문제: 컨테이너는 일시적 (Ephemeral)**

```bash
# 컨테이너에 데이터 저장
docker run --name db postgres
docker exec db psql -c "CREATE TABLE users..."

# 컨테이너 삭제
docker rm -f db

# 데이터 모두 사라짐!
docker run --name db postgres
# 빈 데이터베이스로 시작
```

**해결: 볼륨 사용**

```bash
# Named volume 생성
docker volume create pgdata

# 볼륨 마운트
docker run -d \
  --name db \
  -v pgdata:/var/lib/postgresql/data \
  postgres

# 컨테이너 삭제해도 데이터 유지
docker rm -f db

# 같은 볼륨으로 재시작 → 데이터 복구!
docker run -d --name db -v pgdata:/var/lib/postgresql/data postgres
```

**볼륨 종류**

**1. Named Volume (권장)**
```bash
# 생성
docker volume create mydata

# 사용
docker run -v mydata:/app/data myapp

# 관리
docker volume ls
docker volume rm mydata
```

**2. Bind Mount (호스트 디렉토리)**
```bash
# 호스트 경로를 컨테이너에 마운트
docker run -v /host/path:/container/path myapp

# 개발 시 유용 (실시간 반영)
docker run -v $(pwd):/app node:18 npm start
```

**3. tmpfs Mount (메모리)**
```bash
# 민감한 데이터를 메모리에만 저장
docker run --tmpfs /tmp myapp
```

**실전 사용 예시**

**데이터베이스 영속성:**
```bash
docker run -d \
  --name postgres \
  -v pgdata:/var/lib/postgresql/data \
  postgres:14

# 컨테이너 업데이트 시
docker stop postgres
docker rm postgres
docker run -d --name postgres -v pgdata:/var/lib/postgresql/data postgres:15
# 데이터 유지됨!
```

**개발 환경 (Hot Reload):**
```bash
docker run -d \
  --name dev \
  -v $(pwd)/src:/app/src \
  -v node_modules:/app/node_modules \
  node:18 npm run dev

# 로컬 파일 수정 → 컨테이너에 즉시 반영
```

**로그 수집:**
```bash
docker run -d \
  --name app \
  -v /var/log/app:/app/logs \
  myapp

# 호스트에서 로그 확인 가능
tail -f /var/log/app/app.log
```

**볼륨 vs Bind Mount**

| 특징 | Volume | Bind Mount |
|------|--------|-----------|
| 위치 | Docker 관리 | 호스트 경로 |
| 이식성 | 높음 | 낮음 |
| 백업 | 쉬움 | 어려움 |
| 성능 | 최적화됨 | OS 의존적 |
| 사용 | 프로덕션 | 개발 |

**Docker Compose에서 볼륨:**
```yaml
version: '3.8'

services:
  postgres:
    image: postgres:14
    volumes:
      - pgdata:/var/lib/postgresql/data  # Named volume
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql  # Bind mount

  app:
    build: .
    volumes:
      - ./src:/app/src  # 개발 시 실시간 반영
      - node_modules:/app/node_modules  # 익명 볼륨

volumes:
  pgdata:  # Named volume 정의
  node_modules:
```

**볼륨 관리 명령어:**
```bash
# 볼륨 목록
docker volume ls

# 볼륨 상세 정보
docker volume inspect pgdata

# 미사용 볼륨 삭제
docker volume prune

# 볼륨 백업
docker run --rm -v pgdata:/data -v $(pwd):/backup ubuntu tar czf /backup/pgdata.tar.gz /data

# 볼륨 복원
docker run --rm -v pgdata:/data -v $(pwd):/backup ubuntu tar xzf /backup/pgdata.tar.gz -C /
```

**실무 경험**
프로덕션 데이터베이스를 Docker로 실행하며 볼륨으로 데이터를 영속화하고 있습니다. 매일 밤 자동으로 볼륨을 백업하여 S3에 저장하고, 컨테이너 업데이트 시에도 데이터 손실 없이 안전하게 진행할 수 있습니다.'

WHERE id = 'b0000000-0000-0000-0013-000000000009';

-- Question 10 (0xA): Docker에서 네트워킹은 어떻게 구성되나요?
UPDATE questions SET explanation =
'**Docker 네트워킹**

**기본 네트워크 드라이버**

| 드라이버 | 설명 | 사용 사례 |
|---------|------|---------|
| bridge | 기본 네트워크 (격리) | 단일 호스트 컨테이너 통신 |
| host | 호스트 네트워크 직접 사용 | 최고 성능 필요 시 |
| none | 네트워크 없음 | 격리된 컨테이너 |
| overlay | 멀티 호스트 네트워크 | Docker Swarm |

**1. Bridge Network (기본)**

**자동 생성된 기본 브리지:**
```bash
# 기본 브리지 사용
docker run -d --name web1 nginx
docker run -d --name web2 nginx

# web1과 web2는 같은 네트워크
# 하지만 이름으로 통신 불가 (IP만 가능)
```

**사용자 정의 브리지 (권장):**
```bash
# 네트워크 생성
docker network create mynetwork

# 컨테이너 실행
docker run -d --name backend --network mynetwork myapp
docker run -d --name postgres --network mynetwork postgres

# 서비스 이름으로 통신 가능!
# backend 컨테이너 내부에서:
# curl http://postgres:5432
```

**2. 컨테이너 간 통신**

**같은 네트워크의 컨테이너:**
```bash
docker network create app-network

docker run -d \
  --name db \
  --network app-network \
  postgres

docker run -d \
  --name api \
  --network app-network \
  -e DATABASE_URL=postgresql://db:5432/mydb \
  myapi

# api 컨테이너가 "db:5432"로 접근 가능
```

**3. 포트 매핑 (외부 접근)**

```bash
# 호스트:컨테이너
docker run -d -p 8080:80 --name web nginx

# 접근:
# localhost:8080 → 컨테이너 80 포트
```

**4. 네트워크 격리**

```bash
# 프론트엔드 네트워크
docker network create frontend-net

# 백엔드 네트워크
docker network create backend-net

# 프론트엔드 (frontend-net만)
docker run -d --name web --network frontend-net nginx

# API (두 네트워크 모두)
docker run -d --name api \
  --network frontend-net \
  myapi
docker network connect backend-net api

# DB (backend-net만)
docker run -d --name db --network backend-net postgres

# 결과:
# web ← → api ← → db
# web -X- db (직접 통신 불가)
```

**Docker Compose 네트워킹:**

```yaml
version: '3.8'

services:
  frontend:
    image: nginx
    networks:
      - frontend-net
    ports:
      - "80:80"

  backend:
    image: myapi
    networks:
      - frontend-net  # 프론트엔드와 통신
      - backend-net   # DB와 통신
    environment:
      DATABASE_URL: postgresql://db:5432/mydb

  db:
    image: postgres
    networks:
      - backend-net  # 백엔드와만 통신

networks:
  frontend-net:
  backend-net:
```

**5. 네트워크 명령어**

```bash
# 네트워크 목록
docker network ls

# 네트워크 생성
docker network create mynetwork

# 네트워크 상세 정보
docker network inspect mynetwork

# 실행 중인 컨테이너를 네트워크에 연결
docker network connect mynetwork container1

# 네트워크에서 분리
docker network disconnect mynetwork container1

# 네트워크 삭제
docker network rm mynetwork

# 미사용 네트워크 정리
docker network prune
```

**6. Host Network**

```bash
# 호스트 네트워크 직접 사용
docker run -d --network host nginx

# 포트 매핑 불필요
# localhost:80으로 바로 접근 가능
# 성능 최고, 하지만 격리 없음
```

**7. DNS와 서비스 디스커버리**

**사용자 정의 네트워크의 장점:**
```bash
# 자동 DNS 해석
docker network create mynet

docker run -d --name db --network mynet postgres
docker run -d --name api --network mynet myapi

# api 컨테이너 내부에서:
ping db  # ✅ 작동!
curl http://db:5432  # ✅ 작동!

# 기본 브리지에서는:
# ping db  # ❌ 실패 (IP만 가능)
```

**실전 마이크로서비스 네트워크:**

```yaml
version: '3.8'

services:
  # 프록시 (외부 노출)
  nginx:
    image: nginx
    ports:
      - "80:80"
    networks:
      - frontend

  # API Gateway
  api-gateway:
    image: api-gateway
    networks:
      - frontend
      - backend

  # User Service
  user-service:
    image: user-service
    networks:
      - backend
      - database-net

  # Order Service
  order-service:
    image: order-service
    networks:
      - backend
      - database-net

  # PostgreSQL
  postgres:
    image: postgres
    networks:
      - database-net

networks:
  frontend:    # nginx ← → api-gateway
  backend:     # api-gateway ← → services
  database-net:  # services ← → postgres
```

**네트워크 보안:**
```bash
# 컨테이너를 특정 네트워크에만 격리
docker run -d \
  --name sensitive-app \
  --network isolated-net \
  --network-alias secure-db \
  myapp

# 다른 네트워크와 통신 불가
```

**실무 경험**
마이크로서비스 환경에서 서비스별로 네트워크를 분리하여 보안을 강화했습니다. API Gateway만 외부에 노출하고, 내부 서비스들은 private 네트워크로 격리하여 직접 접근을 차단했습니다. Docker의 내장 DNS로 서비스 이름으로 통신하여 IP 관리 부담을 줄였습니다.'

WHERE id = 'b0000000-0000-0000-0013-00000000000A';

-- Question 11 (0xB): 이미지 최적화를 위해 고려해야 할 사항은?
UPDATE questions SET explanation =
'**Docker 이미지 최적화 전략**

**(이미 Question 6에서 상세히 다룸)**

**핵심 요약:**

**1. 작은 베이스 이미지 사용**
```dockerfile
FROM python:3.9-alpine  # 50MB
# vs
FROM python:3.9         # 900MB
```

**2. 멀티 스테이지 빌드**
```dockerfile
# 빌드 스테이지 (도구 포함)
FROM node:18 AS builder
RUN npm run build

# 실행 스테이지 (결과물만)
FROM node:18-alpine
COPY --from=builder /app/dist ./dist
```

**3. 레이어 캐싱 활용**
```dockerfile
# 의존성 먼저 (변경 적음)
COPY package.json .
RUN npm install

# 소스 나중에 (변경 많음)
COPY . .
```

**4. .dockerignore 사용**
```
node_modules
.git
*.md
.env
```

**5. 레이어 최소화**
```dockerfile
# 한 RUN에서 처리
RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/*
```

자세한 내용은 Question 6 참조.'

WHERE id = 'b0000000-0000-0000-0013-00000000000B';

-- Question 12 (0xC): Docker 컨테이너 상태를 보는 명령은?
UPDATE questions SET explanation =
'**Docker 컨테이너 상태 확인**

**주요 명령어**

**1. docker ps (실행 중인 컨테이너)**
```bash
# 실행 중인 컨테이너만
docker ps

# 출력:
# CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
# abc123         nginx     ...       2min ago  Up 2min   80/tcp    web
```

**2. docker ps -a (모든 컨테이너)**
```bash
# 중지된 컨테이너 포함
docker ps -a

# 출력:
# CONTAINER ID   STATUS
# abc123         Up 2 minutes
# def456         Exited (0) 5 minutes ago
# ghi789         Exited (1) 1 hour ago
```

**3. 상태 종류**

| 상태 | 의미 | 원인 |
|------|------|------|
| **Up** | 실행 중 | 정상 작동 |
| **Exited (0)** | 정상 종료 | 작업 완료 |
| **Exited (1)** | 비정상 종료 | 에러 발생 |
| **Restarting** | 재시작 중 | 자동 재시작 중 |
| **Paused** | 일시 중지 | docker pause 실행 |
| **Dead** | 제거 불가 | 시스템 문제 |

**4. 상세 정보 확인**

```bash
# 컨테이너 상세 정보
docker inspect web

# JSON 형식으로 모든 정보 출력
# 네트워크, 볼륨, 환경 변수 등
```

**5. 리소스 사용량**

```bash
# 실시간 리소스 모니터링
docker stats

# 출력:
# CONTAINER  CPU %  MEM USAGE / LIMIT    MEM %   NET I/O
# web        0.5%   50MiB / 1GiB        5%      1.2kB / 0B
# db         2.0%   200MiB / 2GiB       10%     5kB / 2kB
```

**6. 로그 확인**

```bash
# 로그 보기
docker logs web

# 실시간 로그 (tail -f)
docker logs -f web

# 최근 100줄
docker logs --tail 100 web

# 타임스탬프 포함
docker logs -t web
```

**7. 프로세스 확인**

```bash
# 컨테이너 내부 프로세스
docker top web

# 출력:
# UID   PID   PPID   CMD
# root  1234  1233   nginx: master process
```

**8. 이벤트 모니터링**

```bash
# 실시간 Docker 이벤트
docker events

# 특정 컨테이너만
docker events --filter container=web

# 출력:
# 2024-01-15 start container=web
# 2024-01-15 die container=web
```

**실전 시나리오**

**문제 진단:**
```bash
# 1. 컨테이너 상태 확인
docker ps -a

# 2. Exited 상태라면 로그 확인
docker logs web

# 3. 재시작 시도
docker start web

# 4. 여전히 실패하면 상세 정보
docker inspect web | grep Error
```

**헬스 체크:**
```bash
# docker-compose에서 헬스 체크 설정
services:
  web:
    image: nginx
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

# 상태 확인
docker ps
# STATUS: Up 2 minutes (healthy)
```

**실무 경험**
프로덕션에서 docker stats로 실시간 리소스를 모니터링하고, Prometheus와 Grafana로 시각화하여 이상 징후를 빠르게 파악합니다. 컨테이너가 Exited 상태가 되면 즉시 로그를 확인하여 원인을 분석하고 재시작 정책을 조정합니다.'

WHERE id = 'b0000000-0000-0000-0013-00000000000C';

-- Question 13 (0xD): docker ps와 docker images 명령의 차이는?
UPDATE questions SET explanation =
'**docker ps vs docker images 비교**

**핵심 차이**

| 명령어 | 대상 | 상태 | 목적 |
|--------|------|------|------|
| **docker ps** | 컨테이너 (실행 인스턴스) | 동적 | 실행 중인 컨테이너 확인 |
| **docker images** | 이미지 (템플릿) | 정적 | 저장된 이미지 확인 |

**1. docker ps (컨테이너)**

```bash
# 실행 중인 컨테이너
docker ps

# 출력:
# CONTAINER ID  IMAGE    COMMAND   CREATED    STATUS    PORTS        NAMES
# abc123        nginx    ...       2min ago   Up 2min   80/tcp       web

# 모든 컨테이너 (중지된 것 포함)
docker ps -a

# 출력:
# CONTAINER ID  IMAGE    STATUS
# abc123        nginx    Up 2 minutes
# def456        redis    Exited (0) 5 minutes ago
```

**주요 옵션:**
```bash
# 최근 생성된 N개
docker ps -n 5

# 특정 형식 출력
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# 컨테이너 ID만
docker ps -q

# 크기 포함
docker ps -s
```

**2. docker images (이미지)**

```bash
# 로컬 이미지 목록
docker images

# 출력:
# REPOSITORY    TAG      IMAGE ID    CREATED      SIZE
# nginx         latest   abc123      2 days ago   142MB
# postgres      14       def456      1 week ago   376MB
# myapp         1.0      ghi789      1 hour ago   250MB
```

**주요 옵션:**
```bash
# 모든 이미지 (중간 레이어 포함)
docker images -a

# 특정 형식 출력
docker images --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}"

# 이미지 ID만
docker images -q

# Dangling 이미지만 (<none>:<none>)
docker images -f "dangling=true"
```

**3. 관계**

```
docker images       docker ps
    ↓                  ↓
 [이미지]  →  docker run  →  [컨테이너]
 (템플릿)              (실행 인스턴스)

예:
nginx 이미지 1개
  ↓
web1, web2, web3 컨테이너 3개
```

**실제 예시:**

```bash
# 1. 이미지 다운로드
docker pull nginx
docker images
# nginx latest

# 2. 컨테이너 3개 생성
docker run -d --name web1 nginx
docker run -d --name web2 nginx
docker run -d --name web3 nginx

docker ps
# web1, web2, web3 (3개)

docker images
# nginx (1개)
```

**삭제 차이:**

```bash
# 컨테이너 삭제
docker rm web1

# 이미지 삭제 (모든 컨테이너 먼저 삭제 필요)
docker rmi nginx
# Error: image is being used by web2, web3

# 모든 컨테이너 중지 및 삭제 후
docker stop web2 web3
docker rm web2 web3
docker rmi nginx  # ✅ 성공
```

**정리 명령어:**

```bash
# 중지된 모든 컨테이너 삭제
docker container prune

# 미사용 이미지 삭제
docker image prune

# 모든 미사용 리소스 삭제
docker system prune -a
```

**실무 팁:**

```bash
# 이미지 → 컨테이너 추적
docker ps --filter ancestor=nginx

# 컨테이너 → 이미지 확인
docker inspect web1 | grep Image

# 이미지 크기 확인하여 최적화 대상 찾기
docker images --format "{{.Repository}}:{{.Tag}}\t{{.Size}}" | sort -k2 -hr
```

**실무 경험**
개발 중 docker images로 불필요한 이미지를 주기적으로 정리하여 디스크 공간을 확보합니다. docker ps -a로 Exited 상태의 컨테이너들을 찾아 삭제하고, docker system prune으로 전체 정리를 자동화하여 매주 실행합니다.'

WHERE id = 'b0000000-0000-0000-0013-00000000000D';
