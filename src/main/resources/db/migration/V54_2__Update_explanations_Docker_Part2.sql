-- V54_2: Update explanations for Docker questions (Part 2: Questions 14-26)

-- Question 14 (0xE): 컨테이너에 들어가서 명령을 실행하려면 어떻게 하나요?
UPDATE questions SET explanation =
'**컨테이너 내부 명령 실행**

**주요 명령어**

**1. docker exec (실행 중인 컨테이너)**

**기본 형식:**
```bash
docker exec [OPTIONS] CONTAINER COMMAND
```

**쉘 접속:**
```bash
# Bash 쉘 접속
docker exec -it web bash

# Alpine 이미지 (sh 사용)
docker exec -it web sh

# 특정 작업 디렉토리에서 시작
docker exec -it -w /app web bash
```

**일회성 명령 실행:**
```bash
# 파일 확인
docker exec web ls -la /app

# 환경 변수 확인
docker exec web env

# 프로세스 확인
docker exec web ps aux

# 로그 파일 확인
docker exec web cat /var/log/app.log
```

**2. -it 옵션 (인터랙티브 + TTY)**

```bash
# -i: 표준 입력 유지
# -t: TTY 할당 (터미널 에뮬레이션)

# ✅ -it 함께 사용 (권장)
docker exec -it web bash
# 인터랙티브 쉘, 색상 출력, 편집 가능

# ❌ -it 없이
docker exec web bash
# 바로 종료됨
```

**3. 실전 예시**

**데이터베이스 작업:**
```bash
# PostgreSQL
docker exec -it postgres psql -U admin -d mydb

# MySQL
docker exec -it mysql mysql -u root -p

# Redis
docker exec -it redis redis-cli
```

**로그 확인:**
```bash
# 실시간 로그
docker exec web tail -f /var/log/nginx/access.log

# 최근 100줄
docker exec web tail -100 /var/log/app.log

# grep과 조합
docker exec web sh -c "cat /var/log/app.log | grep ERROR"
```

**파일 수정:**
```bash
# vi 편집기
docker exec -it web vi /etc/nginx/nginx.conf

# 파일 생성
docker exec web sh -c "echo 'test' > /tmp/test.txt"

# 파일 복사 (호스트 → 컨테이너)
docker cp local-file.txt web:/app/
```

**디버깅:**
```bash
# 네트워크 테스트
docker exec web ping google.com
docker exec web curl http://api:8080/health

# DNS 확인
docker exec web nslookup postgres

# 포트 확인
docker exec web netstat -tulpn
```

**4. docker attach vs docker exec**

**docker attach (기존 프로세스에 연결):**
```bash
docker attach web
# PID 1 프로세스에 연결
# Ctrl+C로 종료 시 컨테이너도 종료!
```

**docker exec (새 프로세스 실행):**
```bash
docker exec -it web bash
# 독립적인 프로세스
# exit해도 컨테이너 유지
```

**5. 루트 사용자로 실행**

```bash
# 기본 사용자
docker exec -it web bash

# 루트 사용자로 강제 실행
docker exec -it -u root web bash

# 패키지 설치 등 권한 필요 작업
docker exec -u root web apt-get update
```

**6. 환경 변수 설정**

```bash
# 환경 변수 주입
docker exec -e MY_VAR=value web env

# 여러 변수
docker exec \
  -e DB_HOST=localhost \
  -e DB_PORT=5432 \
  web python script.py
```

**7. Docker Compose에서 실행**

```bash
# 서비스 이름으로 실행
docker-compose exec web bash

# 여러 서비스
docker-compose exec db psql -U admin
docker-compose exec redis redis-cli
docker-compose exec backend python manage.py shell
```

**실전 시나리오**

**문제 진단:**
```bash
# 1. 컨테이너 접속
docker exec -it web bash

# 2. 로그 확인
cd /var/log
tail -f app.log

# 3. 설정 파일 확인
cat /etc/nginx/nginx.conf

# 4. 프로세스 확인
ps aux | grep nginx

# 5. 포트 확인
netstat -tulpn
```

**임시 수정 (테스트용):**
```bash
# 설정 변경
docker exec web sh -c "echo 'new config' >> /etc/app/config.yml"

# 서비스 재시작
docker exec web nginx -s reload

# ⚠️ 주의: 컨테이너 재시작 시 변경사항 손실
# 영구 반영은 Dockerfile 또는 볼륨 사용
```

**실무 경험**
프로덕션 문제 발생 시 docker exec로 컨테이너에 접속하여 실시간 로그를 확인하고 디버깅합니다. 하지만 컨테이너 내부 파일 수정은 일시적이므로, 근본 해결은 항상 Dockerfile이나 설정 파일을 수정하여 재배포합니다.'

WHERE id = 'b0000000-0000-0000-0013-00000000000E';

-- Question 15 (0xF): 컨테이너를 중지(stop)와 kill하는 것의 차이는?
UPDATE questions SET explanation =
'**docker stop vs docker kill**

**핵심 차이**

| 명령어 | 시그널 | 대기 시간 | 정리 작업 | 사용 시기 |
|--------|--------|----------|----------|---------|
| **docker stop** | SIGTERM → SIGKILL | 기본 10초 | ✅ 가능 | 정상 종료 |
| **docker kill** | SIGKILL | 즉시 | ❌ 불가능 | 강제 종료 |

**1. docker stop (정상 종료)**

**동작 방식:**
```
1. SIGTERM 시그널 전송 (종료 요청)
2. 애플리케이션이 정리 작업 수행
   - DB 연결 종료
   - 파일 저장
   - 진행 중인 요청 완료
3. 10초 대기
4. 아직 종료 안 되면 SIGKILL (강제 종료)
```

**명령어:**
```bash
# 기본 (10초 대기)
docker stop web

# 대기 시간 지정 (30초)
docker stop -t 30 web

# 여러 컨테이너
docker stop web api db
```

**2. docker kill (강제 종료)**

**동작 방식:**
```
1. SIGKILL 시그널 즉시 전송
2. 프로세스 즉시 종료
3. 정리 작업 없음
```

**명령어:**
```bash
# 즉시 강제 종료
docker kill web

# 특정 시그널 전송
docker kill -s SIGUSR1 web
```

**3. 실제 동작 비교**

**Node.js 애플리케이션 예시:**

```javascript
// server.js
process.on(''SIGTERM'', () => {
  console.log(''SIGTERM received, closing server...'');

  server.close(() => {
    // DB 연결 종료
    db.disconnect();

    // 진행 중인 작업 완료
    queue.finish();

    console.log(''Graceful shutdown completed'');
    process.exit(0);
  });
});
```

**docker stop 실행:**
```bash
$ docker stop web
# 출력:
# SIGTERM received, closing server...
# Closing database connections...
# Finishing queued jobs...
# Graceful shutdown completed
# (10초 이내 종료)
```

**docker kill 실행:**
```bash
$ docker kill web
# 즉시 종료
# 정리 작업 없음
# DB 연결 끊김, 진행 중인 작업 손실 가능
```

**4. 언제 무엇을 사용하나?**

**✅ docker stop 사용 (권장):**
```
- 정상적인 서비스 종료
- 프로덕션 환경
- 데이터 무결성 중요
- 진행 중인 작업 완료 필요
```

**docker kill 사용:**
```
- 응답 없는 컨테이너 (hang)
- 긴급 상황
- 10초 대기도 불가능한 경우
- 테스트 환경에서 빠른 재시작
```

**5. 실전 예시**

**정상 종료 프로세스:**
```bash
# 1. 트래픽 차단 (로드 밸런서에서)

# 2. 정상 종료 (진행 중인 요청 완료)
docker stop -t 60 web

# 3. 컨테이너 삭제
docker rm web

# 4. 새 버전 시작
docker run -d --name web myapp:v2
```

**응답 없는 컨테이너 처리:**
```bash
# 1. 정상 종료 시도
docker stop web
# 10초 대기...

# 2. 여전히 종료 안 되면 강제 종료
docker kill web
```

**6. 신호 (Signals) 이해**

| 시그널 | 설명 | 차단 가능 | 용도 |
|--------|------|----------|------|
| SIGTERM | 종료 요청 | ✅ | 정상 종료 |
| SIGKILL | 강제 종료 | ❌ | 즉시 종료 |
| SIGINT | 인터럽트 (Ctrl+C) | ✅ | 사용자 중단 |
| SIGHUP | 재시작 요청 | ✅ | 설정 재로드 |

**커스텀 시그널 처리:**
```bash
# HUP 시그널로 설정 재로드
docker kill -s SIGHUP nginx

# USR1 시그널로 로그 로테이션
docker kill -s SIGUSR1 nginx
```

**7. Docker Compose에서**

```bash
# 정상 종료 (모든 컨테이너)
docker-compose stop

# 강제 종료
docker-compose kill

# 정상 종료 + 삭제
docker-compose down
```

**8. 재시작 정책과의 관계**

```bash
# 재시작 정책 설정
docker run -d --restart unless-stopped web

# docker stop: 재시작 안 함
docker stop web

# docker kill: 재시작 정책에 따라 재시작됨
docker kill web
# → 자동 재시작!
```

**데이터베이스 예시:**

**PostgreSQL 정상 종료:**
```bash
docker stop postgres
# PostgreSQL 로그:
# LOG: received smart shutdown request
# LOG: shutting down
# LOG: database system is shut down
```

**PostgreSQL 강제 종료:**
```bash
docker kill postgres
# 즉시 종료
# 체크포인트 없음
# 다음 시작 시 복구 모드
```

**실무 경험**
프로덕션 배포 시 항상 docker stop을 사용하여 진행 중인 요청이 완료될 때까지 대기합니다. 60초 타임아웃을 설정하여 충분한 정리 시간을 제공하고, 애플리케이션이 SIGTERM을 올바르게 처리하도록 구현하여 데이터 손실을 방지합니다. docker kill은 테스트 환경이나 비상 상황에서만 제한적으로 사용합니다.'

WHERE id = 'b0000000-0000-0000-0013-00000000000F';

-- Question 16 (0x10): Docker Swarm은 무엇이며, Kubernetes와 비교하면?
UPDATE questions SET explanation =
'**Docker Swarm vs Kubernetes**

**Docker Swarm이란?**

Docker 내장 컨테이너 오케스트레이션 도구입니다. 여러 Docker 호스트를 클러스터로 관리합니다.

**비교표**

| 특징 | Docker Swarm | Kubernetes |
|------|-------------|------------|
| 설치 | 매우 쉬움 (Docker 내장) | 복잡함 |
| 러닝 커브 | 낮음 | 높음 |
| 확장성 | 중소규모 | 대규모 |
| 생태계 | 제한적 | 매우 풍부 |
| 자동 복구 | 기본 | 고급 |
| 로드 밸런싱 | 내장 | Ingress/Service |
| 설정 | docker-compose 유사 | YAML (복잡) |
| 커뮤니티 | 작음 | 매우 큼 |
| 기업 지원 | 제한적 | 광범위 |

**Docker Swarm 기본 사용**

**1. Swarm 초기화:**
```bash
# Manager 노드에서
docker swarm init
# Swarm initialized: current node is now a manager

# Worker 노드 추가 토큰
docker swarm join-token worker
```

**2. 서비스 배포:**
```bash
# 서비스 생성 (3개 레플리카)
docker service create \
  --name web \
  --replicas 3 \
  --publish 80:80 \
  nginx

# 확인
docker service ls
docker service ps web
```

**3. 스케일링:**
```bash
# 5개로 확장
docker service scale web=5

# 자동 업데이트
docker service update --image nginx:latest web
```

**4. 스택 배포 (docker-compose와 유사):**
```yaml
# stack.yml
version: ''3.8''

services:
  web:
    image: nginx
    deploy:
      replicas: 3
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
    ports:
      - "80:80"

  api:
    image: myapi
    deploy:
      replicas: 5
    environment:
      - DB_HOST=postgres
```

```bash
# 스택 배포
docker stack deploy -c stack.yml myapp

# 확인
docker stack ls
docker stack services myapp
```

**Kubernetes 기본 사용**

**1. 클러스터 설정:**
```bash
# Minikube (로컬)
minikube start

# 또는 클라우드
# GKE, EKS, AKS
```

**2. Deployment 생성:**
```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```

```bash
kubectl apply -f deployment.yaml
kubectl get pods
```

**3. Service 생성:**
```yaml
# service.yaml
apiVersion: v1
kind: Service
metadata:
  name: web
spec:
  type: LoadBalancer
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80
```

**주요 차이점 상세**

**1. 설치 및 설정**

**Swarm:**
```bash
# 1줄로 시작
docker swarm init
```

**Kubernetes:**
```bash
# 많은 설정 필요
kubeadm init
kubectl apply -f calico.yaml
kubectl taint nodes...
# 30분 이상 소요
```

**2. 확장성**

**Swarm:**
- 최대 ~1000 노드
- 소규모/중규모 적합

**Kubernetes:**
- 최대 5000 노드
- 대규모 엔터프라이즈

**3. 로드 밸런싱**

**Swarm:**
- 자동 내장
- 간단한 라운드 로빈

**Kubernetes:**
- Ingress, Service, Istio 등
- 고급 트래픽 관리

**4. 자동 스케일링**

**Swarm:**
- 수동 스케일링
```bash
docker service scale web=10
```

**Kubernetes:**
- HPA (자동 스케일링)
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
spec:
  maxReplicas: 10
  minReplicas: 3
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

**5. 생태계**

**Swarm:**
- 제한적인 플러그인
- 기본 기능에 집중

**Kubernetes:**
- Helm (패키지 매니저)
- Istio (서비스 메시)
- Prometheus (모니터링)
- ArgoCD (GitOps)
- 수천 개 도구

**언제 무엇을 사용하나?**

**Docker Swarm 선택:**
```
✅ Docker에 익숙함
✅ 빠르게 시작하고 싶음
✅ 소규모 프로젝트 (< 20 서비스)
✅ 단순한 아키텍처
✅ 작은 팀
```

**Kubernetes 선택:**
```
✅ 대규모 프로젝트
✅ 복잡한 마이크로서비스
✅ 자동 스케일링 필요
✅ 클라우드 중립성
✅ 장기 투자
✅ 풍부한 생태계 필요
```

**마이그레이션 경로**

```
소규모 시작
  ↓
Docker Compose (개발)
  ↓
Docker Swarm (소규모 프로덕션)
  ↓
성장 (100+ 서비스)
  ↓
Kubernetes (엔터프라이즈)
```

**실무 경험**
초기 스타트업에서는 Docker Swarm으로 빠르게 시작했습니다. 3개 노드로 20개 서비스를 운영하며 설정이 간단하고 Docker Compose와 유사하여 팀 전체가 쉽게 사용했습니다. 하지만 서비스가 100개 이상으로 늘어나고 자동 스케일링, 복잡한 트래픽 관리가 필요해지면서 Kubernetes로 마이그레이션했고, 현재는 대부분의 기업이 Kubernetes를 표준으로 사용하고 있습니다.'

WHERE id = 'b0000000-0000-0000-0013-000000000010';

-- Question 17 (0x11): Kubernetes와 Docker는 어떤 관계인가요?
UPDATE questions SET explanation =
'**Kubernetes와 Docker의 관계**

**핵심 이해**

Kubernetes와 Docker는 **경쟁 관계가 아니라 협력 관계**입니다.

```
Docker: 컨테이너를 만들고 실행
Kubernetes: 여러 컨테이너를 관리하고 조율
```

**역할 구분**

| 도구 | 역할 | 비유 |
|------|------|------|
| **Docker** | 컨테이너 런타임 | 자동차 (개별 차량) |
| **Kubernetes** | 오케스트레이션 | 교통 관제 시스템 |

**1. Docker의 역할**

**컨테이너 생성 및 실행:**
```bash
# Dockerfile로 이미지 빌드
docker build -t myapp:1.0 .

# 컨테이너 실행
docker run -d -p 8080:8080 myapp:1.0
```

**Kubernetes 없이 Docker만 사용:**
- 단일 호스트
- 수동 관리
- 간단한 워크로드

**2. Kubernetes의 역할**

**여러 컨테이너 조율:**
```yaml
# Deployment로 관리
apiVersion: apps/v1
kind: Deployment
spec:
  replicas: 10  # 10개 컨테이너 자동 관리
  template:
    spec:
      containers:
      - name: app
        image: myapp:1.0
```

**Kubernetes가 제공하는 것:**
- 자동 스케일링
- 로드 밸런싱
- 자가 복구
- 롤링 업데이트
- 서비스 디스커버리

**3. 함께 사용하는 방법**

**워크플로우:**
```
1. Docker로 이미지 빌드
   docker build -t myapp:1.0 .

2. Registry에 푸시
   docker push myregistry.io/myapp:1.0

3. Kubernetes가 이미지 사용
   kubectl apply -f deployment.yaml

4. Kubernetes가 Docker 컨테이너 실행
   (내부적으로 container runtime 사용)
```

**4. 컨테이너 런타임**

**Kubernetes는 다양한 런타임 지원:**

```
Kubernetes
  ├─ Docker (과거 기본)
  ├─ containerd (현재 주류)
  ├─ CRI-O
  └─ gVisor (보안 강화)
```

**Docker 대신 containerd:**
```
과거:
Kubernetes → Docker → containerd → 컨테이너

현재 (Dockershim 제거):
Kubernetes → containerd → 컨테이너

더 빠르고 효율적!
```

**5. 실전 사용 예시**

**개발 환경:**
```bash
# 로컬에서 Docker 사용
docker-compose up

# 개발 중:
docker build -t myapp:dev .
docker run -d myapp:dev
```

**프로덕션 환경:**
```bash
# Docker로 빌드
docker build -t myapp:1.0 .
docker push registry.io/myapp:1.0

# Kubernetes로 배포
kubectl set image deployment/myapp myapp=registry.io/myapp:1.0

# Kubernetes가 자동으로:
# - 10개 Pod 생성
# - 로드 밸런서 설정
# - 헬스 체크
# - 자동 재시작
```

**6. 역사적 관계**

**2014-2020:**
```
Kubernetes + Docker
- Docker가 기본 컨테이너 런타임
- 긴밀한 통합
```

**2020년 이후:**
```
Kubernetes deprecates Dockershim
- Docker 지원 중단 발표
- containerd로 직접 통신
- Docker는 여전히 개발 도구로 사용
```

**영향:**
- ✅ 개발자: Docker 계속 사용 가능
- ✅ 빌드: docker build 계속 사용
- ⚠️ Kubernetes: containerd 직접 사용

**7. 대안 및 생태계**

**컨테이너 빌드:**
```bash
# Docker
docker build -t myapp .

# Buildah (Docker 없이)
buildah bud -t myapp .

# Kaniko (Kubernetes 내부)
```

**컨테이너 실행:**
```bash
# Docker
docker run myapp

# Podman (Docker 호환)
podman run myapp

# containerd (Kubernetes 기본)
```

**8. 실무 통합 예시**

**CI/CD 파이프라인:**
```yaml
# GitHub Actions
- name: Build Docker image
  run: docker build -t myapp:${{ github.sha }} .

- name: Push to registry
  run: docker push myregistry.io/myapp:${{ github.sha }}

- name: Deploy to Kubernetes
  run: |
    kubectl set image deployment/myapp \
      myapp=myregistry.io/myapp:${{ github.sha }}
```

**9. 핵심 정리**

**잘못된 생각:**
```
❌ Kubernetes vs Docker (경쟁)
❌ Kubernetes가 Docker를 대체
```

**올바른 이해:**
```
✅ Kubernetes + Docker (협력)
✅ Docker로 빌드 → Kubernetes로 관리
✅ Docker: 개발 도구
✅ Kubernetes: 운영 플랫폼
```

**간단한 비유:**
```
Docker = 화물 컨테이너 (표준화된 박스)
Kubernetes = 항만 관리 시스템 (컨테이너 적재, 운송, 관리)

둘 다 필요!
```

**실무 경험**
로컬 개발은 Docker와 Docker Compose를 사용하여 빠르게 반복합니다. CI 파이프라인에서 Docker로 이미지를 빌드하고, Kubernetes 클러스터에 배포합니다. Kubernetes가 컨테이너 오케스트레이션을 담당하지만, 개발자는 여전히 Docker 명령어로 이미지를 빌드하고 로컬 테스트를 수행합니다. 두 도구는 서로 보완적으로 사용됩니다.'

WHERE id = 'b0000000-0000-0000-0013-000000000011';

-- Question 18 (0x12): 컨테이너 오케스트레이션이 필요한 이유는?
UPDATE questions SET explanation =
'**컨테이너 오케스트레이션이 필요한 이유**

**문제 상황: 수동 관리의 한계**

**시나리오 1: 서비스 10개 운영**
```bash
# 각 서비스마다 수동 실행
docker run -d --name service1 app1:1.0
docker run -d --name service2 app2:1.0
...
docker run -d --name service10 app10:1.0

# 문제:
# - 컨테이너 하나 죽으면? → 수동 재시작
# - 트래픽 증가하면? → 수동으로 복사본 실행
# - 업데이트는? → 하나씩 중지/시작
# - 로드 밸런싱은? → 직접 설정
```

**시나리오 2: 장애 발생**
```bash
# 새벽 3시, 컨테이너 크래시
docker ps
# service3이 Exited 상태!

# 누가 재시작하나?
# → 담당자 호출
# → 수동 재시작
# → 다운타임 15분
```

**오케스트레이션 솔루션**

**자동화된 관리:**
```
문제              오케스트레이션 해결
─────────────────────────────────────
컨테이너 죽음      자동 재시작 (Self-healing)
트래픽 증가        자동 스케일링 (Auto-scaling)
업데이트          롤링 업데이트 (Zero-downtime)
로드 밸런싱        자동 분산 (Service discovery)
리소스 부족        자동 배치 (Scheduling)
```

**오케스트레이션이 제공하는 기능**

**1. 자동 복구 (Self-Healing)**

**수동:**
```bash
# 컨테이너 모니터링 스크립트
while true; do
  if ! docker ps | grep service1; then
    docker start service1
  fi
  sleep 10
done
```

**Kubernetes:**
```yaml
apiVersion: apps/v1
kind: Deployment
spec:
  replicas: 3  # 항상 3개 유지
  # 1개 죽으면 자동으로 새로 생성
```

**2. 자동 스케일링**

**수동:**
```bash
# 트래픽 모니터링
# CPU > 70% 감지
# → 수동으로 컨테이너 추가
docker run -d --name web4 myapp
docker run -d --name web5 myapp
# → 로드 밸런서 설정 수정
```

**Kubernetes:**
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
spec:
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        averageUtilization: 70

# CPU 70% 초과 시 자동 확장
# CPU 낮아지면 자동 축소
```

**3. 롤링 업데이트 (Zero Downtime)**

**수동:**
```bash
# v1 → v2 업데이트
docker stop web1 && docker rm web1
docker run -d --name web1 myapp:v2

docker stop web2 && docker rm web2
docker run -d --name web2 myapp:v2
# ...

# 문제: 다운타임 발생!
```

**Kubernetes:**
```yaml
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1        # 1개씩 추가
      maxUnavailable: 0   # 다운 없음

# kubectl set image deployment/web web=myapp:v2
# 자동으로 하나씩 교체, 다운타임 0
```

**4. 서비스 디스커버리**

**수동:**
```bash
# service1이 service2 호출
# service2의 IP를 어떻게 알까?
docker inspect service2 | grep IPAddress
# → 하드코딩 또는 환경 변수

# service2가 재시작되면 IP 변경!
# → service1 재설정 필요
```

**Kubernetes:**
```yaml
# Service로 자동 DNS
apiVersion: v1
kind: Service
metadata:
  name: service2
spec:
  selector:
    app: service2

# service1에서:
# curl http://service2:8080
# IP 변경되어도 이름으로 접근 가능!
```

**5. 로드 밸런싱**

**수동:**
```bash
# Nginx 설정
upstream backend {
  server 172.17.0.2:8080;
  server 172.17.0.3:8080;
  server 172.17.0.4:8080;
}

# 컨테이너 추가/제거 시마다 수동 업데이트
# Nginx 재시작 필요
```

**Kubernetes:**
```yaml
apiVersion: v1
kind: Service
spec:
  type: LoadBalancer
  selector:
    app: backend
  # 자동으로 모든 backend Pod에 분산
  # Pod 추가/제거 시 자동 업데이트
```

**6. 리소스 관리**

**수동:**
```bash
# 어느 서버에 배포할까?
# → 수동으로 CPU/메모리 확인
# → 가장 여유로운 서버 선택
# → docker run...
```

**Kubernetes:**
```yaml
resources:
  requests:
    memory: "256Mi"
    cpu: "250m"
  limits:
    memory: "512Mi"
    cpu: "500m"

# Scheduler가 자동으로 최적 노드 선택
# 리소스 부족 시 대기
```

**실전 규모별 비교**

**소규모 (< 10 컨테이너):**
```
수동 관리 가능
Docker Compose 충분
```

**중규모 (10-50 컨테이너):**
```
수동 관리 어려움
Docker Swarm 추천
```

**대규모 (50+ 컨테이너):**
```
수동 관리 불가능
Kubernetes 필수
```

**비용 비교**

**수동 관리:**
```
서버 10대 운영
  ↓
트래픽 증가 (10% 사용)
  ↓
과다 프로비저닝 (미래 대비)
  ↓
비용: $1000/월
활용률: 20%
```

**오케스트레이션:**
```
서버 10대 운영
  ↓
트래픽 증가
  ↓
자동 스케일링 (필요한 만큼만)
  ↓
비용: $600/월
활용률: 70%
```

**운영 인력**

**수동:**
```
24/7 모니터링 필요
야간 장애 대응
휴먼 에러 발생
```

**오케스트레이션:**
```
자동 복구
최소 개입
안정적 운영
```

**실무 경험**
초기에 Docker만으로 5개 서비스를 수동 관리했지만, 서비스가 20개로 늘어나면서 수동 관리의 한계를 느꼈습니다. 새벽에 컨테이너 크래시로 인한 장애 알림을 받고 급히 대응하는 일이 잦았습니다. Kubernetes 도입 후 자동 복구, 자동 스케일링으로 운영 부담이 80% 감소했고, 개발자가 인프라 관리보다 기능 개발에 집중할 수 있게 되었습니다.'

WHERE id = 'b0000000-0000-0000-0013-000000000012';

-- Question 19 (0x13): Docker에서 포트 포워딩은 어떻게 하나요?
UPDATE questions SET explanation =
'**Docker 포트 포워딩 (Port Binding)**

**기본 개념**

컨테이너 내부 포트를 호스트 포트에 매핑하여 외부에서 접근 가능하게 합니다.

```
외부 → 호스트:8080 → 컨테이너:80
```

**기본 문법**

```bash
docker run -p [호스트포트]:[컨테이너포트] [이미지]
```

**1. 기본 포트 매핑**

```bash
# 단일 포트
docker run -d -p 8080:80 nginx
# localhost:8080 → nginx:80

# 여러 포트
docker run -d \
  -p 80:80 \
  -p 443:443 \
  nginx
```

**2. 모든 인터페이스 vs 특정 IP**

```bash
# 모든 인터페이스 (기본)
docker run -p 8080:80 nginx
# 0.0.0.0:8080 → 어디서든 접근 가능

# 특정 IP만
docker run -p 127.0.0.1:8080:80 nginx
# localhost에서만 접근 가능

# 특정 네트워크 인터페이스
docker run -p 192.168.1.100:8080:80 nginx
```

**3. 동적 포트 할당**

```bash
# 호스트 포트 자동 할당
docker run -d -p 80 nginx
# 랜덤 포트 (예: 32768) → 80

# 할당된 포트 확인
docker port [container_name]
# 80/tcp -> 0.0.0.0:32768
```

**4. UDP 포트**

```bash
# TCP (기본)
docker run -p 8080:80/tcp nginx

# UDP
docker run -p 53:53/udp dns-server

# TCP + UDP 동시
docker run \
  -p 8080:80/tcp \
  -p 53:53/udp \
  myapp
```

**5. 포트 범위 매핑**

```bash
# 포트 범위
docker run -p 8000-8010:8000-8010 myapp
# 8000-8010 모두 매핑
```

**실전 예시**

**웹 애플리케이션:**
```bash
docker run -d \
  --name web \
  -p 80:8080 \
  myapp

# 접근:
curl http://localhost:80
# → 컨테이너 8080 포트로 전달
```

**데이터베이스:**
```bash
docker run -d \
  --name postgres \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=secret \
  postgres

# 로컬에서 연결:
psql -h localhost -p 5432 -U postgres
```

**여러 서비스:**
```bash
# 웹 서버
docker run -d -p 80:80 --name web nginx

# API 서버
docker run -d -p 8080:8080 --name api myapi

# 데이터베이스
docker run -d -p 5432:5432 --name db postgres

# 각각 다른 포트로 접근 가능
```

**Docker Compose에서:**

```yaml
version: ''3.8''

services:
  web:
    image: nginx
    ports:
      - "80:80"        # 호스트:컨테이너
      - "443:443"

  api:
    image: myapi
    ports:
      - "8080:8080"

  db:
    image: postgres
    ports:
      - "127.0.0.1:5432:5432"  # 로컬에서만 접근
```

**포트 충돌 해결**

**문제:**
```bash
# 이미 80 포트 사용 중
docker run -p 80:80 nginx
# Error: port is already allocated
```

**해결:**
```bash
# 다른 호스트 포트 사용
docker run -p 8080:80 nginx
# localhost:8080으로 접근
```

**다중 컨테이너 같은 이미지:**
```bash
# 같은 nginx 이미지, 다른 포트
docker run -d -p 8081:80 --name web1 nginx
docker run -d -p 8082:80 --name web2 nginx
docker run -d -p 8083:80 --name web3 nginx

# 각각 다른 포트로 접근
curl http://localhost:8081
curl http://localhost:8082
curl http://localhost:8083
```

**포트 확인 방법**

```bash
# 특정 컨테이너 포트 확인
docker port web
# 80/tcp -> 0.0.0.0:8080

# 모든 컨테이너 포트 확인
docker ps --format "table {{.Names}}\t{{.Ports}}"

# 상세 정보
docker inspect web | grep -A 10 PortBindings
```

**네트워크 모드별 포트 매핑**

**Bridge (기본):**
```bash
docker run -p 8080:80 nginx
# 포트 매핑 필요
```

**Host 네트워크:**
```bash
docker run --network host nginx
# 포트 매핑 불필요
# 컨테이너가 호스트 네트워크 직접 사용
# localhost:80 직접 접근
```

**보안 고려사항**

**❌ 위험:**
```bash
# 모든 인터페이스에 노출
docker run -p 5432:5432 postgres
# 인터넷에서 접근 가능!
```

**✅ 안전:**
```bash
# 로컬에서만 접근
docker run -p 127.0.0.1:5432:5432 postgres

# 또는 방화벽 설정
ufw allow from 192.168.1.0/24 to any port 5432
```

**실무 경험**
프로덕션에서는 데이터베이스와 같은 민감한 서비스는 127.0.0.1로 바인딩하여 로컬에서만 접근 가능하게 하고, 웹 서버만 외부에 노출합니다. 개발 환경에서는 여러 마이크로서비스를 다른 포트로 실행하여 동시에 테스트할 수 있도록 구성합니다.'

WHERE id = 'b0000000-0000-0000-0013-000000000013';

-- Question 20 (0x14): docker run -d -p 80:80 nginx 명령 설명
UPDATE questions SET explanation =
'**docker run -d -p 80:80 nginx 명령 분석**

**전체 명령어:**
```bash
docker run -d -p 80:80 nginx
```

**각 부분 설명:**

**1. docker run**
- Docker 컨테이너 실행 명령어
- 이미지로부터 새 컨테이너 생성 및 시작

**2. -d (detached mode)**
- 백그라운드에서 실행
- 터미널과 분리
- 컨테이너 ID만 출력하고 즉시 반환

```bash
# -d 있을 때:
$ docker run -d nginx
abc123def456  # 컨테이너 ID 반환
$  # 즉시 프롬프트 반환

# -d 없을 때:
$ docker run nginx
...로그 출력...
# Ctrl+C로 종료 시 컨테이너도 종료
```

**3. -p 80:80 (포트 매핑)**
- `-p [호스트포트]:[컨테이너포트]`
- 호스트의 80번 포트를 컨테이너의 80번 포트로 매핑
- 외부에서 localhost:80으로 접근 가능

```
외부 요청 → 호스트:80 → 컨테이너:80 → nginx
```

**4. nginx (이미지 이름)**
- 사용할 Docker 이미지
- 태그 생략 시 `latest` 자동 사용
- 완전한 형식: `nginx:latest`

**실행 과정:**

```
1. 로컬에 nginx 이미지 확인
   ├─ 있음 → 바로 사용
   └─ 없음 → Docker Hub에서 pull

2. 이미지로부터 컨테이너 생성
   ├─ 파일 시스템 생성
   ├─ 네트워크 설정
   └─ 포트 매핑 설정

3. 컨테이너 시작
   ├─ nginx 프로세스 실행
   └─ 80 포트 리스닝

4. 백그라운드로 전환
   └─ 터미널 반환
```

**실행 결과:**

```bash
$ docker run -d -p 80:80 nginx
abc123def456789...  # 컨테이너 ID

# 확인
$ docker ps
CONTAINER ID   IMAGE   COMMAND                  PORTS                NAMES
abc123def456   nginx   "/docker-entrypoint…"    0.0.0.0:80->80/tcp   eloquent_euler

# 접근 테스트
$ curl http://localhost
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
...
```

**동등한 명령어 (더 명시적):**

```bash
docker run \
  --detach \
  --publish 80:80 \
  --name my-nginx \
  nginx:latest

# 또는 더 상세하게
docker run \
  -d \
  -p 0.0.0.0:80:80/tcp \
  --name my-nginx \
  --restart unless-stopped \
  nginx:latest
```

**추가 옵션 예시:**

```bash
# 이름 지정
docker run -d -p 80:80 --name web nginx

# 환경 변수
docker run -d -p 80:80 -e NGINX_PORT=80 nginx

# 볼륨 마운트
docker run -d -p 80:80 -v $(pwd)/html:/usr/share/nginx/html nginx

# 재시작 정책
docker run -d -p 80:80 --restart always nginx

# 리소스 제한
docker run -d -p 80:80 --memory="512m" --cpus="1.0" nginx
```

**전체 흐름 다이어그램:**

```
[docker run 명령]
  ↓
[이미지 확인]
  ↓
[컨테이너 생성]
  ├─ 파일 시스템
  ├─ 네트워크 (포트 80 → 80)
  └─ 프로세스 (nginx)
  ↓
[백그라운드 실행 (-d)]
  ↓
[컨테이너 ID 반환]
  ↓
[사용자 → localhost:80 → nginx]
```

**실무 사용 패턴:**

**개발 환경:**
```bash
# 로컬 파일 실시간 반영
docker run -d \
  -p 8080:80 \
  -v $(pwd)/html:/usr/share/nginx/html \
  --name dev-web \
  nginx
```

**프로덕션:**
```bash
# 안정적인 운영
docker run -d \
  -p 80:80 \
  --name prod-web \
  --restart always \
  --memory="1g" \
  --cpus="2.0" \
  nginx:1.21-alpine
```

**정리 및 재시작:**

```bash
# 컨테이너 중지
docker stop [컨테이너ID 또는 이름]

# 컨테이너 삭제
docker rm [컨테이너ID]

# 한 번에
docker rm -f [컨테이너ID]

# 동일 명령으로 재생성
docker run -d -p 80:80 nginx
```

**실무 경험**
빠른 테스트 시 `docker run -d -p 80:80 nginx` 명령으로 즉시 웹 서버를 띄워 확인합니다. 프로덕션에서는 --name, --restart, 리소스 제한 등 추가 옵션을 항상 사용하여 안정적이고 관리하기 쉽게 구성합니다.'

WHERE id = 'b0000000-0000-0000-0013-000000000014';

-- Question 21 (0x15): 컨테이너 내 애플리케이션 로그를 확인하려면?
UPDATE questions SET explanation =
'**Docker 로그 확인 방법**

**기본 명령어:**
```bash
docker logs [CONTAINER]
```

**주요 옵션**

**1. 전체 로그 보기**
```bash
# 모든 로그 출력
docker logs web

# 출력:
# 2024-01-15 10:30:00 Server started
# 2024-01-15 10:30:01 Listening on port 8080
# ...
```

**2. 실시간 로그 (-f, follow)**
```bash
# tail -f 처럼 실시간 추적
docker logs -f web

# 새로운 로그가 실시간으로 출력됨
# Ctrl+C로 종료 (컨테이너는 계속 실행)
```

**3. 최근 N줄만 (--tail)**
```bash
# 최근 100줄
docker logs --tail 100 web

# 최근 10줄만 실시간 추적
docker logs -f --tail 10 web
```

**4. 타임스탬프 포함 (-t)**
```bash
# 타임스탬프와 함께 출력
docker logs -t web

# 출력:
# 2024-01-15T10:30:00.123Z Server started
# 2024-01-15T10:30:01.456Z Listening on port 8080
```

**5. 특정 시간 이후 로그 (--since)**
```bash
# 10분 전부터
docker logs --since 10m web

# 특정 시간부터
docker logs --since 2024-01-15T10:00:00 web

# 1시간 전부터 실시간 추적
docker logs -f --since 1h web
```

**6. 특정 시간까지 (--until)**
```bash
# 10분 전까지
docker logs --until 10m web

# 특정 시간까지
docker logs --until 2024-01-15T10:00:00 web

# 시간 범위
docker logs --since 2024-01-15T09:00:00 --until 2024-01-15T10:00:00 web
```

**조합 사용**

```bash
# 최근 1시간 로그 100줄, 실시간 추적
docker logs -f --tail 100 --since 1h -t web

# 오늘 로그만
docker logs --since $(date +%Y-%m-%d) web

# 에러 로그만 필터링
docker logs web 2>&1 | grep ERROR

# 특정 패턴 검색
docker logs web | grep "404"
```

**Docker Compose에서:**

```bash
# 특정 서비스 로그
docker-compose logs web

# 모든 서비스 로그
docker-compose logs

# 실시간 추적
docker-compose logs -f

# 특정 서비스만 실시간
docker-compose logs -f backend

# 여러 서비스
docker-compose logs -f backend db redis
```

**실전 디버깅**

**시나리오 1: 에러 발생**
```bash
# 1. 최근 로그 확인
docker logs --tail 50 web

# 2. 에러 검색
docker logs web | grep -i error

# 3. 전체 스택트레이스 확인
docker logs web 2>&1 | grep -A 20 "Exception"

# 4. 실시간 모니터링
docker logs -f web
```

**시나리오 2: 성능 문제**
```bash
# 1. 특정 시간대 로그 분석
docker logs --since "2024-01-15T14:00:00" --until "2024-01-15T15:00:00" web

# 2. 응답 시간 확인
docker logs web | grep "response_time"

# 3. 슬로우 쿼리 찾기
docker logs web | grep "slow query"
```

**로그 저장 및 분석**

```bash
# 파일로 저장
docker logs web > web.log

# 에러만 저장
docker logs web 2>&1 | grep ERROR > errors.log

# 압축하여 저장
docker logs web | gzip > web-$(date +%Y%m%d).log.gz

# 큰 로그 파일 분석
docker logs web | head -n 10000 | less
```

**여러 컨테이너 로그 동시 확인**

```bash
# 모든 컨테이너 로그
docker ps -q | xargs -L 1 docker logs

# 특정 패턴의 컨테이너
docker ps --filter "name=api" -q | xargs -L 1 docker logs -f

# Docker Compose
docker-compose logs --tail=100 -f
```

**로그 드라이버 설정**

**기본 (json-file):**
```bash
docker run -d \
  --log-driver json-file \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  nginx
```

**Syslog:**
```bash
docker run -d \
  --log-driver syslog \
  --log-opt syslog-address=udp://192.168.1.100:514 \
  nginx
```

**없음 (로그 저장 안 함):**
```bash
docker run -d --log-driver none nginx
```

**로그 위치**

```bash
# 기본 로그 파일 위치
/var/lib/docker/containers/[container-id]/[container-id]-json.log

# 직접 확인
sudo tail -f /var/lib/docker/containers/$(docker inspect --format="{{.Id}}" web)/$(docker inspect --format="{{.Id}}" web)-json.log
```

**실전 팁**

**1. 로그 로테이션 설정:**
```bash
# docker-compose.yml
services:
  web:
    image: nginx
    logging:
      driver: "json-file"
      options:
        max-size: "10m"      # 최대 10MB
        max-file: "3"         # 최대 3개 파일
```

**2. 중앙화된 로깅:**
```bash
# ELK Stack (Elasticsearch, Logstash, Kibana)
docker run -d \
  --log-driver gelf \
  --log-opt gelf-address=udp://logstash:12201 \
  myapp

# Fluentd
docker run -d \
  --log-driver fluentd \
  --log-opt fluentd-address=localhost:24224 \
  myapp
```

**3. 로그 필터링:**
```bash
# JSON 로그 파싱
docker logs web | jq ''.log''

# 특정 레벨만
docker logs web | grep "\[ERROR\]"

# 시간대별 그룹화
docker logs web | awk ''{print $1, $2}'' | uniq -c
```

**실무 경험**
프로덕션에서는 로그 로테이션을 반드시 설정하여 디스크 공간을 관리합니다. 중요한 서비스는 ELK Stack이나 CloudWatch로 중앙화된 로깅을 구성하여 여러 컨테이너의 로그를 한 곳에서 검색하고 분석합니다. 개발 중에는 docker logs -f로 실시간 로그를 모니터링하여 빠르게 디버깅합니다.'

WHERE id = 'b0000000-0000-0000-0013-000000000015';

-- Question 22 (0x16): 레지스트리란 무엇이며 프라이빗 레지스트리를 구축해본 적 있나요?
UPDATE questions SET explanation =
'**Docker Registry란?**

Docker 이미지를 저장하고 공유하는 저장소입니다.

**종류**

| 레지스트리 | 공개 | 비용 | 사용 사례 |
|-----------|------|------|---------|
| Docker Hub | Public/Private | 무료 (제한적) | 오픈소스, 개인 |
| AWS ECR | Private | 종량제 | AWS 환경 |
| Google GCR | Private | 종량제 | GCP 환경 |
| Harbor (Self-hosted) | Private | 인프라 비용 | 온프레미스 |

**프라이빗 레지스트리 구축 (Harbor)**

```yaml
# docker-compose.yml
version: ''3.8''

services:
  registry:
    image: registry:2
    ports:
      - "5000:5000"
    volumes:
      - ./registry-data:/var/lib/registry

# 실행
docker-compose up -d

# 이미지 푸시
docker tag myapp:1.0 localhost:5000/myapp:1.0
docker push localhost:5000/myapp:1.0

# 다른 서버에서 풀
docker pull registry.company.com:5000/myapp:1.0
```

**실무 경험**
회사 내부에서 Harbor를 사용하여 프라이빗 레지스트리를 구축했습니다. 보안이 중요한 이미지는 외부 노출을 방지하고, 이미지 스캔 기능으로 취약점을 자동 검사하여 안전한 배포를 보장했습니다.'

WHERE id = 'b0000000-0000-0000-0013-000000000016';

-- Question 23 (0x17): 이미 실행 중인 컨테이너를 수정하려면?
UPDATE questions SET explanation =
'**실행 중인 컨테이너 수정**

**기본 원칙: 불변성 (Immutability)**

**❌ 권장하지 않음:**
```bash
# 컨테이너 내부 파일 직접 수정
docker exec web vi /etc/nginx/nginx.conf
# → 컨테이너 재시작 시 변경사항 손실!
```

**✅ 올바른 방법:**

**1. 영구적 수정: Dockerfile 또는 볼륨 사용**
```dockerfile
# Dockerfile 수정
FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf

# 재빌드 및 재배포
docker build -t myapp:1.1 .
docker stop web
docker rm web
docker run -d --name web myapp:1.1
```

**2. 설정 파일 볼륨 마운트**
```bash
# 호스트 설정 파일 마운트
docker run -d \
  -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf \
  --name web \
  nginx

# 호스트 파일 수정 후
docker exec web nginx -s reload
```

**3. docker commit (임시, 비권장)**
```bash
# 현재 컨테이너를 새 이미지로 저장
docker commit web myapp:1.1

# 새 컨테이너로 교체
docker stop web && docker rm web
docker run -d --name web myapp:1.1
```

**4. 환경 변수 업데이트**
```bash
# 재시작 필요
docker stop web
docker rm web
docker run -d -e NEW_VAR=value --name web myapp
```

**실무 경험**
프로덕션에서는 컨테이너 내부를 직접 수정하지 않습니다. 모든 변경사항은 Dockerfile이나 설정 파일에 반영한 후 이미지를 재빌드하여 롤링 업데이트로 무중단 배포합니다.'

WHERE id = 'b0000000-0000-0000-0013-000000000017';

-- Question 24 (0x18): 하나의 호스트에서 컨테이너 간 네트워크 통신을 가능하게 하려면?
UPDATE questions SET explanation =
'**컨테이너 간 네트워크 통신**

**사용자 정의 네트워크 생성 (권장)**

```bash
# 네트워크 생성
docker network create mynetwork

# 컨테이너들을 같은 네트워크에 연결
docker run -d --name db --network mynetwork postgres
docker run -d --name api --network mynetwork myapi

# api 컨테이너 내부에서 db에 접근
# docker exec api ping db
# curl http://db:5432
```

**Docker Compose (더 간편)**

```yaml
version: ''3.8''

services:
  db:
    image: postgres
    networks:
      - backend

  api:
    image: myapi
    networks:
      - backend
    environment:
      DATABASE_URL: postgresql://db:5432/mydb
      # "db"라는 이름으로 접근 가능!

networks:
  backend:
```

**주요 특징:**
- 자동 DNS: 컨테이너 이름으로 통신
- 격리: 같은 네트워크에 있는 컨테이너만 통신
- 동적 업데이트: 컨테이너 추가/제거 시 자동 반영

**실무 경험**
마이크로서비스 환경에서 서비스별로 네트워크를 분리하여 보안을 강화합니다. API Gateway만 외부 네트워크에 연결하고, 내부 서비스들은 private 네트워크로 격리하여 직접 접근을 차단합니다.'

WHERE id = 'b0000000-0000-0000-0013-000000000018';

-- Question 25 (0x19): 이미지의 태그는 어떤 목적으로 사용되나요?
UPDATE questions SET explanation =
'**Docker 이미지 태그 (Tag)**

**목적: 버전 관리**

```bash
# 형식: [레지스트리/][사용자/]이미지:태그
docker pull nginx:1.21
docker pull nginx:latest
docker pull myregistry.io/myapp:v1.0.0
```

**주요 사용 패턴**

**1. 버전 관리**
```bash
myapp:1.0.0  # 특정 버전
myapp:1.1.0  # 업그레이드
myapp:2.0.0  # 메이저 버전
```

**2. 환경 구분**
```bash
myapp:dev        # 개발
myapp:staging    # 스테이징
myapp:production # 프로덕션
```

**3. Git 커밋 해시**
```bash
# CI/CD에서 자동 태깅
docker build -t myapp:${GIT_SHA} .
docker push myapp:abc123def456

# 정확한 버전 추적 가능
```

**4. 시맨틱 버저닝 + latest**
```bash
docker build -t myapp:1.2.3 .
docker tag myapp:1.2.3 myapp:1.2
docker tag myapp:1.2.3 myapp:1
docker tag myapp:1.2.3 myapp:latest

# 유연한 버전 선택
```

**❌ latest 태그 주의사항:**
```bash
# latest는 "최신"이 아닐 수 있음!
docker pull nginx  # nginx:latest와 동일
# 특정 버전을 명시하는 것이 안전
docker pull nginx:1.21-alpine
```

**실무 사용**

```bash
# CI/CD 파이프라인
docker build -t myapp:${VERSION} .
docker tag myapp:${VERSION} myapp:latest
docker push myapp:${VERSION}
docker push myapp:latest

# Kubernetes 배포
kubectl set image deployment/myapp myapp=myapp:1.2.3
```

**실무 경험**
프로덕션에서는 latest 태그를 사용하지 않고 항상 명확한 버전 번호를 사용합니다. Git 커밋 해시를 태그로 사용하여 배포된 코드를 정확히 추적할 수 있도록 구성했습니다.'

WHERE id = 'b0000000-0000-0000-0013-000000000019';

-- Question 26 (0x1A): Docker 컨테이너의 자원 할당은 어떻게 설정하나요?
UPDATE questions SET explanation =
'**Docker 컨테이너 리소스 제한**

**주요 옵션**

**1. 메모리 제한**

```bash
# 최대 메모리
docker run -d --memory="512m" nginx

# 메모리 + 스왑
docker run -d \
  --memory="512m" \
  --memory-swap="1g" \
  nginx

# 스왑 비활성화
docker run -d \
  --memory="512m" \
  --memory-swap="512m" \
  nginx
```

**2. CPU 제한**

```bash
# CPU 개수 제한
docker run -d --cpus="1.5" nginx
# 1.5 코어 사용

# CPU 셰어 (상대적 가중치)
docker run -d --cpu-shares=512 nginx

# 특정 CPU 코어 지정
docker run -d --cpuset-cpus="0,1" nginx
# 0번, 1번 코어만 사용
```

**3. 디스크 I/O 제한**

```bash
# 읽기/쓰기 속도 제한
docker run -d \
  --device-read-bps /dev/sda:1mb \
  --device-write-bps /dev/sda:1mb \
  nginx
```

**Docker Compose에서:**

```yaml
version: ''3.8''

services:
  web:
    image: nginx
    deploy:
      resources:
        limits:
          cpus: ''1.0''      # 최대 1 코어
          memory: 512M       # 최대 512MB
        reservations:
          cpus: ''0.5''      # 최소 0.5 코어 보장
          memory: 256M       # 최소 256MB 보장
```

**리소스 사용량 모니터링:**

```bash
# 실시간 모니터링
docker stats

# 출력:
# CONTAINER  CPU %   MEM USAGE/LIMIT   MEM %   NET I/O
# web        0.5%    100MB/512MB       20%     1.2kB/0B
# api        2.0%    200MB/1GB         20%     5kB/2kB
```

**실전 예시:**

**웹 애플리케이션:**
```bash
docker run -d \
  --name web \
  --memory="1g" \
  --cpus="2.0" \
  --restart always \
  myapp
```

**데이터베이스:**
```bash
docker run -d \
  --name postgres \
  --memory="4g" \
  --memory-reservation="2g" \
  --cpus="4.0" \
  -v pgdata:/var/lib/postgresql/data \
  postgres:14
```

**OOM (Out of Memory) 방지:**

```bash
# OOM Killer 비활성화 (신중히 사용)
docker run -d \
  --memory="512m" \
  --oom-kill-disable \
  nginx

# 메모리 부족 시 스왑 사용
docker run -d \
  --memory="512m" \
  --memory-swap="1g" \
  nginx
```

**Kubernetes에서 (참고):**

```yaml
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: app
    image: myapp
    resources:
      requests:
        memory: "256Mi"
        cpu: "250m"
      limits:
        memory: "512Mi"
        cpu: "500m"
```

**실무 경험**
프로덕션에서는 모든 컨테이너에 리소스 제한을 설정하여 한 컨테이너가 전체 호스트 리소스를 독점하는 것을 방지합니다. docker stats로 실제 사용량을 모니터링하여 적절한 제한값을 찾고, 여유를 두어 피크 시간대에도 안정적으로 운영되도록 합니다.'

WHERE id = 'b0000000-0000-0000-0013-00000000001A';