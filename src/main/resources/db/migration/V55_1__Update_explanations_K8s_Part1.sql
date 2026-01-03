-- This file contains Kubernetes explanations Part 1 (Questions 0-11, indices 0x00-0x0B)
-- Total: 12 questions

-- Question 0 (0x00): 쿠버네티스란 무엇이며, 어떤 문제를 해결하기 위해 등장했나요?
UPDATE questions SET explanation =
'**Kubernetes (K8s)란?**
컨테이너화된 애플리케이션을 자동으로 배포, 스케일링, 관리하는 오픈소스 오케스트레이션 플랫폼입니다.

**해결하는 문제**

Docker만 사용하면 컨테이너를 수동으로 관리해야 하고, 장애 시 자동 복구가 안 되며, 여러 서버에 분산된 컨테이너를 관리하기 어렵습니다.

Kubernetes는 이를 해결하여:
- 자동 복구 (Self-healing): Pod가 죽으면 자동 재시작
- 자동 스케일링: CPU 사용률 기반으로 Pod 자동 증감
- 로드 밸런싱: 여러 Pod로 트래픽 자동 분산
- 선언적 관리: 원하는 상태를 선언하면 K8s가 자동으로 유지

**예시**
```yaml
replicas: 3  # 3개 유지
# K8s가 자동으로:
# - 3개 유지, 하나 죽으면 재시작
# - 노드 장애 시 다른 노드에 재배포
```

**실무 경험**
프로덕션에서 HPA(Horizontal Pod Autoscaler)로 트래픽 급증 시 자동으로 Pod를 10개까지 확장하여 서비스 안정성을 확보했습니다.'
WHERE id = 'b0000000-0000-0000-0014-000000000000';

-- Question 1 (0x01): 쿠버네티스의 주요 구성 요소는 무엇인가요?
UPDATE questions SET explanation =
'**Kubernetes 주요 구성 요소**

**Control Plane (Master Node)**
- kube-apiserver: 모든 요청의 진입점, RESTful API 제공
- etcd: 클러스터 상태를 저장하는 분산 키-값 저장소
- kube-scheduler: Pod를 적절한 노드에 배정
- kube-controller-manager: Deployment, ReplicaSet 등 리소스 관리

**Worker Node**
- kubelet: Pod를 실행하고 상태를 apiserver에 보고
- kube-proxy: 네트워크 라우팅, Service 로드 밸런싱
- Container Runtime: Docker, containerd 등 컨테이너 실행 엔진

**동작 흐름**
```
kubectl create pod
  ↓
kube-apiserver → etcd 저장
  ↓
kube-scheduler → 노드 배정
  ↓
kubelet → 컨테이너 생성
```

**실무 경험**
프로덕션에서 Control Plane을 3개 노드로 구성하여 고가용성을 확보하고, etcd는 전용 SSD 디스크에 구성하여 성능을 최적화했습니다.'
WHERE id = 'b0000000-0000-0000-0014-000000000001';

-- Question 2 (0x02): Pod란 무엇인가요?
UPDATE questions SET explanation =
'**Pod란?**
Kubernetes에서 배포할 수 있는 가장 작은 단위로, 하나 이상의 컨테이너를 묶은 그룹입니다.

**특징**
- 같은 Pod 내 컨테이너는 동일한 IP 공유
- localhost로 서로 통신 가능
- 같은 Volume 공유 가능
- 같은 노드에 스케줄링됨

**예시**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
  - name: nginx
    image: nginx:1.21
    ports:
    - containerPort: 80
```

**일반적인 패턴**
- 1 Pod = 1 Container (가장 흔함)
- Sidecar 패턴: 메인 컨테이너 + 로그 수집기

**실무 경험**
프로덕션에서 NGINX 컨테이너와 Fluentd 사이드카를 같은 Pod에 배포하여 로그를 자동으로 수집하고, 두 컨테이너가 Volume을 공유하여 로그 파일에 접근했습니다.'
WHERE id = 'b0000000-0000-0000-0014-000000000002';

-- Question 3 (0x03): Deployment와 Service의 차이는 무엇인가요?
UPDATE questions SET explanation =
'**Deployment vs Service**

**Deployment**
- Pod를 관리하는 리소스
- 원하는 Pod 개수(replicas) 유지
- 롤링 업데이트, 롤백 지원
- "어떤 애플리케이션을 몇 개 실행할지" 정의

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  replicas: 3  # 3개 유지
  template:
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
```

**Service**
- Pod에 접근하기 위한 안정적인 엔드포인트
- Pod IP는 변경되지만 Service IP는 고정
- 여러 Pod로 트래픽 로드 밸런싱
- "어떻게 접근할지" 정의

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80
  type: LoadBalancer
```

**관계**
Deployment로 Pod 생성 → Service로 Pod에 접근

**실무 경험**
Deployment로 API 서버 3개를 유지하고, Service를 통해 단일 엔드포인트로 로드 밸런싱하여 고가용성을 확보했습니다.'
WHERE id = 'b0000000-0000-0000-0014-000000000003';

-- Question 4 (0x04): 컨테이너 오케스트레이션 도구로서 Kubernetes의 장점은 무엇인가요?
UPDATE questions SET explanation =
'**Kubernetes의 주요 장점**

**1. 자동 복구 (Self-healing)**
- Pod 장애 시 자동 재시작
- 노드 장애 시 다른 노드에 자동 재배포
- Health Check 실패 시 자동 교체

**2. 자동 스케일링**
- HPA (Horizontal Pod Autoscaler): CPU/메모리 기반 자동 확장
- VPA (Vertical Pod Autoscaler): Pod 리소스 자동 조정
- Cluster Autoscaler: 노드 자동 증감

**3. 무중단 배포**
- 롤링 업데이트: 점진적으로 새 버전 배포
- 롤백: 문제 발생 시 이전 버전으로 즉시 복구
- Blue-Green, Canary 배포 지원

**4. 멀티 클라우드 지원**
- AWS, GCP, Azure 모두 지원
- 온프레미스 환경에서도 동일하게 동작
- 벤더 종속성 최소화

**5. 풍부한 생태계**
- Helm: 패키지 관리
- Prometheus: 모니터링
- Istio: 서비스 메시

**실무 경험**
Kubernetes를 도입하여 배포 시간을 1시간에서 5분으로 단축하고, 자동 복구로 장애 대응 시간을 90% 줄였습니다.'
WHERE id = 'b0000000-0000-0000-0014-000000000004';

-- Question 5 (0x05): Kubernetes에서 Namespace는 무엇이며 왜 사용하나요?
UPDATE questions SET explanation =
'**Namespace란?**
클러스터 내에서 리소스를 논리적으로 분리하는 가상 클러스터입니다.

**사용 이유**

**1. 환경 분리**
- dev, staging, production 분리
- 각 환경별로 독립적인 리소스 관리

**2. 팀/프로젝트 분리**
- team-a, team-b로 리소스 격리
- 네임스페이스별 접근 권한 설정 (RBAC)

**3. 리소스 쿼터**
- 네임스페이스별 CPU/메모리 제한
- 무분별한 리소스 사용 방지

**예시**
```bash
# Namespace 생성
kubectl create namespace production

# Namespace에 Pod 배포
kubectl apply -f deployment.yaml -n production

# 기본 Namespace
kubectl get pods -n default
```

**리소스 쿼터**
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: prod-quota
  namespace: production
spec:
  hard:
    requests.cpu: "10"
    requests.memory: 20Gi
    pods: "50"
```

**실무 경험**
프로덕션 클러스터에서 dev, staging, prod 네임스페이스로 환경을 분리하고, ResourceQuota로 dev 환경이 과도한 리소스를 사용하지 못하도록 제한했습니다.'
WHERE id = 'b0000000-0000-0000-0014-000000000005';

-- Question 6 (0x06): 쿠버네티스에서 Pod를 재시작하거나 대체하는 메커니즘은 무엇인가요?
UPDATE questions SET explanation =
'**Pod 재시작/대체 메커니즘**

**1. Liveness Probe (생존 확인)**
- Pod가 정상 동작하는지 주기적으로 체크
- 실패 시 컨테이너 재시작

```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10
```

**2. Readiness Probe (준비 상태 확인)**
- Pod가 트래픽을 받을 준비가 되었는지 체크
- 실패 시 Service에서 제외 (재시작 안 함)

```yaml
readinessProbe:
  httpGet:
    path: /ready
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
```

**3. RestartPolicy**
- Always: 항상 재시작 (기본값, Deployment용)
- OnFailure: 실패 시에만 재시작 (Job용)
- Never: 재시작 안 함

**4. ReplicaSet/Deployment**
- 원하는 Pod 개수 유지
- Pod 삭제되면 자동으로 새로 생성

**동작 흐름**
```
Liveness Probe 실패 (3회 연속)
  ↓
kubelet이 컨테이너 재시작
  ↓
Readiness Probe 성공할 때까지 트래픽 차단
  ↓
준비 완료 후 Service에 다시 추가
```

**실무 경험**
API 서버에 Liveness Probe를 설정하여 응답 없는 Pod를 자동으로 재시작하고, Readiness Probe로 초기화 완료 전에는 트래픽을 받지 않도록 했습니다.'
WHERE id = 'b0000000-0000-0000-0014-000000000006';

-- Question 7 (0x07): ConfigMap과 Secret은 무엇이며 어떻게 활용되나요?
UPDATE questions SET explanation =
'**ConfigMap과 Secret**

**ConfigMap**
- 일반 설정 데이터를 key-value로 저장
- 환경변수, 설정 파일 등 저장
- 평문으로 저장 (암호화 안 됨)

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  DATABASE_URL: "postgres://db:5432/mydb"
  LOG_LEVEL: "info"
```

**Secret**
- 민감한 데이터를 저장 (비밀번호, API 키)
- Base64 인코딩으로 저장
- RBAC로 접근 제한 가능

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  password: cGFzc3dvcmQxMjM=  # base64 encoded
```

**Pod에서 사용**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp
spec:
  containers:
  - name: app
    image: myapp:1.0
    env:
    - name: DATABASE_URL
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: DATABASE_URL
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: password
```

**차이점**

| | ConfigMap | Secret |
|---|---|---|
| **용도** | 일반 설정 | 민감한 데이터 |
| **저장 방식** | 평문 | Base64 인코딩 |
| **사용 예시** | DB URL, 로그 레벨 | 비밀번호, API 키 |

**실무 경험**
ConfigMap으로 환경별 설정(dev/prod)을 분리하고, Secret으로 DB 비밀번호를 관리하여 코드에 하드코딩하지 않고 안전하게 배포했습니다.'
WHERE id = 'b0000000-0000-0000-0014-000000000007';

-- Question 8 (0x08): 쿠버네티스에서 모니터링은 어떻게 이루어지나요?
UPDATE questions SET explanation =
'**Kubernetes 모니터링**

**Prometheus (가장 널리 사용)**
- 시계열 데이터 수집 및 저장
- PromQL로 쿼리 및 알람 설정
- Grafana와 연동하여 시각화

**수집하는 메트릭**
- 노드: CPU, 메모리, 디스크 사용률
- Pod: 컨테이너별 리소스 사용량
- 애플리케이션: 요청 수, 응답 시간, 에러율

**구성 예시**
```yaml
# ServiceMonitor로 메트릭 수집 대상 지정
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: api-monitor
spec:
  selector:
    matchLabels:
      app: api
  endpoints:
  - port: metrics
    interval: 30s
```

**알람 설정**
```yaml
# PrometheusRule로 알람 조건 정의
alert: HighCPUUsage
expr: container_cpu_usage > 80
for: 5m
annotations:
  summary: "CPU 사용률이 80% 초과"
```

**기타 도구**
- Grafana: Prometheus 데이터 시각화
- Metrics Server: kubectl top 명령어용 (HPA에서 사용)
- ELK Stack: 로그 수집 및 분석
- Jaeger/Zipkin: 분산 추적

**실무 경험**
Prometheus + Grafana로 클러스터 전체를 모니터링하고, CPU 사용률 80% 초과 시 Slack 알람을 받도록 설정하여 장애를 사전에 방지했습니다.'
WHERE id = 'b0000000-0000-0000-0014-000000000008';

-- Question 9 (0x09): StatefulSet은 무엇이고, Deployment와 어떻게 다른가요?
UPDATE questions SET explanation =
'**StatefulSet vs Deployment**

**Deployment**
- Stateless 애플리케이션용
- Pod 이름이 랜덤 (web-7f8d9c-abc12)
- 순서 없이 생성/삭제
- 영구 스토리지 필요 없음
- 예: Web 서버, API 서버

**StatefulSet**
- Stateful 애플리케이션용 (상태 유지 필요)
- Pod 이름이 고정 (db-0, db-1, db-2)
- 순서대로 생성/삭제
- 각 Pod마다 영구 볼륨 할당
- 예: 데이터베이스, 메시지 큐

**StatefulSet 예시**
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
spec:
  serviceName: mysql
  replicas: 3
  template:
    spec:
      containers:
      - name: mysql
        image: mysql:8.0
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 10Gi
```

**주요 차이**

| | Deployment | StatefulSet |
|---|---|---|
| **Pod 이름** | 랜덤 | 고정 (순서 번호) |
| **스토리지** | 공유 가능 | Pod별 전용 볼륨 |
| **생성 순서** | 동시 | 순차 (0→1→2) |
| **네트워크 ID** | 랜덤 | 고정 DNS |

**Headless Service**
```yaml
# StatefulSet용 Headless Service
apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  clusterIP: None  # Headless
  selector:
    app: mysql
# DNS: mysql-0.mysql, mysql-1.mysql
```

**실무 경험**
MySQL을 StatefulSet으로 배포하여 각 Pod가 독립적인 영구 볼륨을 가지도록 하고, Headless Service로 Master/Slave 복제를 구성했습니다.'
WHERE id = 'b0000000-0000-0000-0014-000000000009';

-- Question 10 (0x0A): 컨테이너 스케줄링은 쿠버네티스에서 어떻게 이루어지나요?
UPDATE questions SET explanation =
'**Kubernetes 스케줄링**

kube-scheduler가 Pod를 적절한 노드에 자동 배정합니다.

**스케줄링 과정**

**1. Filtering (필터링)**
- 리소스 부족한 노드 제외
- nodeSelector 조건 미충족 노드 제외
- Taints/Tolerations 불일치 노드 제외

**2. Scoring (점수 계산)**
- 리소스가 고르게 분산되도록 점수 부여
- Affinity/Anti-affinity 규칙 적용
- 최고 점수 노드에 배정

**nodeSelector 예시**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: gpu-pod
spec:
  nodeSelector:
    gpu: "true"  # gpu=true 라벨 있는 노드에만 배정
  containers:
  - name: ml-app
    image: tensorflow:latest
```

**Taints와 Tolerations**
```bash
# 노드에 Taint 추가 (특정 Pod만 허용)
kubectl taint nodes node1 key=value:NoSchedule

# Pod에 Toleration 추가 (Taint 무시)
tolerations:
- key: "key"
  operator: "Equal"
  value: "value"
  effect: "NoSchedule"
```

**Affinity (선호도)**
- Node Affinity: 특정 노드 선호
- Pod Affinity: 특정 Pod 근처에 배치
- Pod Anti-Affinity: 특정 Pod와 멀리 배치 (고가용성)

**실무 경험**
GPU 노드에 gpu=true 라벨을 붙이고 nodeSelector로 ML 워크로드만 배정했으며, Pod Anti-Affinity로 API 서버를 서로 다른 노드에 분산 배치하여 가용성을 높였습니다.'
WHERE id = 'b0000000-0000-0000-0014-00000000000A';

-- Question 11 (0x0B): Kubernetes에서 롤링 업데이트는 어떻게 동작하나요?
UPDATE questions SET explanation =
'**롤링 업데이트 (Rolling Update)**

새 버전을 점진적으로 배포하여 무중단 업데이트를 실현합니다.

**동작 과정**
```
기존: v1 Pod 3개 [v1] [v1] [v1]
  ↓
Step 1: v2 Pod 1개 생성
[v1] [v1] [v1] [v2]
  ↓
Step 2: v1 Pod 1개 종료
[v1] [v1] [v2]
  ↓
Step 3: v2 Pod 추가, v1 Pod 종료 반복
[v1] [v2] [v2]
  ↓
최종: v2 Pod 3개
[v2] [v2] [v2]
```

**Deployment 설정**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1  # 최대 1개까지 중단 허용
      maxSurge: 1        # 최대 1개 초과 생성 허용
  template:
    spec:
      containers:
      - name: nginx
        image: nginx:1.22  # 버전 변경
```

**배포 명령어**
```bash
# 이미지 업데이트
kubectl set image deployment/web nginx=nginx:1.22

# 배포 상태 확인
kubectl rollout status deployment/web

# 롤백 (문제 발생 시)
kubectl rollout undo deployment/web
```

**전략 비교**

| 전략 | 설명 | 장점 | 단점 |
|------|------|------|------|
| **Rolling Update** | 점진적 교체 | 무중단 | 두 버전 공존 |
| **Recreate** | 전부 삭제 후 생성 | 단순 | 다운타임 발생 |
| **Blue-Green** | 새 환경 준비 후 전환 | 빠른 롤백 | 리소스 2배 |

**실무 경험**
프로덕션 배포 시 Rolling Update를 사용하여 서비스 중단 없이 업데이트하고, maxUnavailable=1로 설정하여 항상 최소 2개 Pod가 서비스하도록 보장했습니다.'
WHERE id = 'b0000000-0000-0000-0014-00000000000B';
