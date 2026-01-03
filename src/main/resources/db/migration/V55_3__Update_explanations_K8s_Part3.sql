-- V55_3: Kubernetes 답변 Part 3 (Questions 23-33, 11개)

-- Question 23 (0x17): etcd의 역할
UPDATE questions SET explanation =
'**etcd란?**

Kubernetes 클러스터의 모든 데이터를 저장하는 분산 Key-Value 저장소입니다.

**역할**
- 클러스터 상태 저장: 모든 리소스 정보 (Pod, Service, ConfigMap 등)
- 설정 데이터 저장: Namespace, RBAC 정책 등
- API Server의 유일한 데이터 저장소
- 강력한 일관성 보장 (Raft 알고리즘)

**주요 특징**
```bash
# etcd에 저장되는 데이터 예시
- Pod 상태: 어느 노드에서 실행 중인지
- Service 설정: ClusterIP, 포트 정보
- Secret 데이터: base64 인코딩된 민감 정보
- ConfigMap: 애플리케이션 설정
```

**실무 경험**
프로덕션에서 etcd 장애로 클러스터 전체가 멈춘 경험이 있어, 이후 etcd를 3대로 구성하여 고가용성을 확보하고 주기적으로 백업했습니다.'
WHERE id = 'b0000000-0000-0000-0014-000000000015';

-- Question 24 (0x18): Control Plane 구성 요소
UPDATE questions SET explanation =
'**Control Plane (Master Node) 구성 요소**

Kubernetes 클러스터를 관리하는 핵심 컴포넌트들입니다.

**주요 구성 요소**

1. **kube-apiserver**
   - 모든 요청의 진입점
   - REST API 제공
   - etcd와 통신하는 유일한 컴포넌트

2. **etcd**
   - 클러스터 데이터 저장소
   - Key-Value 형태로 모든 상태 저장

3. **kube-scheduler**
   - Pod를 어느 노드에 배치할지 결정
   - 리소스, Affinity 규칙 고려

4. **kube-controller-manager**
   - 다양한 컨트롤러 실행 (Deployment, ReplicaSet, Node 등)
   - 원하는 상태 유지

**구조**
```
Control Plane
├── kube-apiserver (모든 요청 처리)
├── etcd (데이터 저장)
├── kube-scheduler (Pod 배치 결정)
└── kube-controller-manager (상태 관리)
```

**실무 경험**
프로덕션 환경에서 Control Plane을 3대로 구성하여 HA를 구현했고, API Server 앞단에 LoadBalancer를 두어 안정성을 높였습니다.'
WHERE id = 'b0000000-0000-0000-0014-000000000016';

-- Question 25 (0x19): kube-apiserver의 역할
UPDATE questions SET explanation =
'**kube-apiserver**

Kubernetes 클러스터의 모든 요청을 처리하는 REST API 서버입니다.

**주요 역할**
- 모든 컴포넌트의 통신 허브
- kubectl 명령어 처리
- 인증/인가 수행 (RBAC)
- etcd와 통신하는 유일한 컴포넌트
- Admission Controller 실행

**동작 흐름**
```bash
kubectl apply -f deployment.yaml
    ↓
kube-apiserver
    ↓ (인증/인가 확인)
    ↓ (Admission Controller)
    ↓ (etcd에 저장)
    ↓
kube-controller-manager가 변경 감지
    ↓
Deployment Controller가 ReplicaSet 생성
```

**실무 경험**
프로덕션에서 API Server 로그를 모니터링하여 비정상적인 요청이나 인증 실패를 추적하고, API Server 앞단에 Rate Limiting을 설정하여 과부하를 방지했습니다.'
WHERE id = 'b0000000-0000-0000-0014-000000000017';

-- Question 26 (0x1A): kube-scheduler의 기능
UPDATE questions SET explanation =
'**kube-scheduler**

새로 생성된 Pod를 어느 노드에 배치할지 결정하는 컴포넌트입니다.

**스케줄링 과정**
1. **Filtering (필터링)**
   - 조건에 맞지 않는 노드 제거
   - CPU/메모리 부족한 노드 제외
   - NodeSelector, Affinity 규칙 확인

2. **Scoring (점수 매기기)**
   - 남은 노드들에 점수 부여
   - 리소스 균등 분산 고려
   - 가장 높은 점수의 노드 선택

**스케줄링 요소**
```yaml
# NodeSelector: 특정 노드에만 배치
nodeSelector:
  disktype: ssd

# Affinity: 더 세밀한 제어
affinity:
  nodeAffinity:  # 노드 선호도
  podAffinity:   # 같은 노드에 배치
  podAntiAffinity:  # 다른 노드에 배치
```

**실무 경험**
GPU 노드에 ML 워크로드만 배치하기 위해 NodeSelector와 Taint/Toleration을 조합하여 리소스를 효율적으로 관리했습니다.'
WHERE id = 'b0000000-0000-0000-0014-000000000018';

-- Question 27 (0x1B): kubelet의 역할
UPDATE questions SET explanation =
'**kubelet**

각 Worker Node에서 실행되는 에이전트로, Pod를 실제로 실행하고 관리합니다.

**주요 역할**
- API Server에서 PodSpec 받기
- 컨테이너 런타임에 Pod 실행 요청
- Pod/컨테이너 상태 모니터링
- Liveness/Readiness Probe 실행
- API Server에 노드/Pod 상태 보고

**동작 방식**
```bash
API Server (Pod 생성 요청)
    ↓
kubelet (PodSpec 수신)
    ↓
Container Runtime (Docker/containerd)
    ↓
컨테이너 실행
    ↓
kubelet (상태 모니터링)
    ↓
API Server (상태 보고)
```

**모니터링**
- CPU/메모리 사용률
- 컨테이너 재시작 횟수
- Probe 결과

**실무 경험**
프로덕션에서 kubelet 로그를 통해 노드의 디스크 부족 문제를 사전에 발견하고, 이미지 자동 정리 정책을 설정하여 디스크 공간을 확보했습니다.'
WHERE id = 'b0000000-0000-0000-0014-000000000019';

-- Question 28 (0x1C): kube-proxy의 역할
UPDATE questions SET explanation =
'**kube-proxy**

각 노드에서 실행되며, Service의 네트워크 규칙을 관리하고 Pod 간 통신을 지원합니다.

**주요 역할**
- Service의 ClusterIP로 들어온 트래픽을 Pod로 전달
- iptables 또는 IPVS 규칙 설정
- 로드 밸런싱 수행

**동작 방식**
```bash
# Service 생성 시
Service: my-app (ClusterIP: 10.96.1.100)
    ↓
kube-proxy가 iptables 규칙 생성
    ↓
10.96.1.100:80 → Pod1(10.244.1.5:8080)
                → Pod2(10.244.2.6:8080)
                → Pod3(10.244.3.7:8080)
```

**프록시 모드**
```yaml
# iptables 모드 (기본)
- 빠르지만 Pod 수가 많으면 느려짐

# IPVS 모드 (권장)
- 대규모 클러스터에 적합
- 더 나은 로드 밸런싱
```

**실무 경험**
5000개 이상의 Pod를 운영하는 환경에서 iptables 모드의 성능 한계로 IPVS 모드로 전환하여 네트워크 지연을 30% 개선했습니다.'
WHERE id = 'b0000000-0000-0000-0014-00000000001A';

-- Question 29 (0x1D): ConfigMap vs Secret
UPDATE questions SET explanation =
'**ConfigMap과 Secret의 차이**

둘 다 설정 데이터를 저장하지만, Secret은 민감한 정보를 위한 것입니다.

**ConfigMap**
- 일반 설정 데이터 저장
- 평문으로 저장
- 예: DB URL, 애플리케이션 설정

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
- 민감 정보 저장
- base64 인코딩 (암호화 아님!)
- etcd에서 암호화 가능 (EncryptionConfig)
- 예: 비밀번호, API 키, TLS 인증서

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  password: cGFzc3dvcmQxMjM=  # base64
```

**사용 방법**
```yaml
# 환경 변수로 주입
env:
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: db-secret
      key: password
```

**실무 경험**
프로덕션에서 Secret을 Git에 올리지 않기 위해 Sealed Secrets를 사용하고, etcd 암호화를 활성화하여 보안을 강화했습니다.'
WHERE id = 'b0000000-0000-0000-0014-00000000001B';

-- Question 30 (0x1E): Helm과 Helm 차트
UPDATE questions SET explanation =
'**Helm**

Kubernetes용 패키지 매니저로, 애플리케이션을 쉽게 배포하고 관리할 수 있게 해줍니다.

**Helm 차트**
- Kubernetes 리소스의 템플릿 모음
- values.yaml로 설정 커스터마이징
- 버전 관리 및 롤백 지원

**디렉토리 구조**
```
my-app/
├── Chart.yaml       # 차트 메타데이터
├── values.yaml      # 기본 설정 값
├── templates/       # K8s 리소스 템플릿
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
└── charts/          # 의존성 차트
```

**사용 예시**
```bash
# 차트 설치
helm install my-app ./my-app

# 값 오버라이드
helm install my-app ./my-app \
  --set replicas=3 \
  --set image.tag=v2.0.0

# 업그레이드
helm upgrade my-app ./my-app

# 롤백
helm rollback my-app 1
```

**장점**
- 반복 가능한 배포
- 환경별 설정 관리 (dev/staging/prod)
- 롤백 간편

**실무 경험**
마이크로서비스 20개를 Helm으로 관리하여 배포 시간을 10분에서 2분으로 단축했고, 문제 발생 시 즉시 롤백하여 장애 복구 시간을 줄였습니다.'
WHERE id = 'b0000000-0000-0000-0014-00000000001C';

-- Question 31 (0x1F): HPA 동작 방식 (중복 질문 - Question 13과 동일)
UPDATE questions SET explanation =
'**HPA (Horizontal Pod Autoscaler)**

CPU/메모리 사용률에 따라 Pod 개수를 자동으로 조정합니다.

**동작 원리**
1. Metrics Server에서 Pod CPU/메모리 사용률 수집
2. 30초마다 현재 사용률 확인
3. 목표 사용률과 비교하여 Pod 개수 계산
4. Deployment의 replicas 자동 조정

**HPA 설정**
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: web
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70  # CPU 70% 유지
```

**계산 공식**
```
필요한 Pod 수 = ceil(현재 Pod 수 × 현재 사용률 / 목표 사용률)

예: 현재 3개, CPU 90%, 목표 70%
→ ceil(3 × 90 / 70) = 4개로 증가
```

**실무 경험**
트래픽이 급증하는 이벤트 기간 동안 HPA로 Pod를 자동으로 10개까지 늘려 안정적으로 서비스했고, 이벤트 종료 후 자동으로 2개로 축소하여 비용을 절감했습니다.'
WHERE id = 'b0000000-0000-0000-0014-00000000001D';

-- Question 32 (0x20): Rolling Update vs Blue-Green 배포
UPDATE questions SET explanation =
'**Rolling Update vs Blue-Green 배포**

두 가지 모두 무중단 배포 전략이지만 접근 방식이 다릅니다.

**Rolling Update**
- 기존 Pod를 점진적으로 교체
- 리소스 효율적 (추가 리소스 최소화)
- Kubernetes 기본 방식

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1        # 추가 가능한 Pod 수
    maxUnavailable: 0  # 중단 가능한 Pod 수
# 예: 3개 → 4개(새) → 3개(새) → 4개(새) → 3개(새)
```

**Blue-Green 배포**
- 새 버전(Green)을 완전히 배포 후 트래픽 전환
- 즉시 롤백 가능
- 리소스 2배 필요

```yaml
# Blue (현재)
app: my-app
version: v1
replicas: 3

# Green (새 버전) 배포
app: my-app
version: v2
replicas: 3

# Service 라벨 변경으로 전환
selector:
  version: v2  # v1 → v2
```

**비교**

| 항목 | Rolling Update | Blue-Green |
|------|----------------|------------|
| 리소스 | 효율적 | 2배 필요 |
| 롤백 속도 | 느림 (재배포) | 즉시 |
| 전환 시간 | 점진적 | 즉시 |
| 사용 사례 | 일반 배포 | 중요 릴리스 |

**실무 경험**
일반 배포는 Rolling Update를 사용하고, 대규모 DB 마이그레이션이 포함된 배포는 Blue-Green 방식으로 진행하여 문제 발생 시 즉시 이전 버전으로 전환했습니다.'
WHERE id = 'b0000000-0000-0000-0014-00000000001E';

-- Question 33 (0x21): emptyDir Volume
UPDATE questions SET explanation =
'**emptyDir Volume**

Pod 생성 시 빈 디렉토리로 시작하며, 같은 Pod 내 컨테이너 간 데이터를 공유하는 임시 볼륨입니다.

**특징**
- Pod 생성 시 빈 디렉토리 생성
- Pod 삭제 시 데이터도 함께 삭제
- 같은 Pod 내 컨테이너들이 공유
- 노드의 디스크 또는 메모리(tmpfs) 사용

**사용 사례**
1. **사이드카 패턴**
   - 로그 수집 컨테이너
   - 메인 앱 → emptyDir에 로그 → 사이드카가 수집

2. **임시 캐시**
   - 컨테이너 재시작 시 초기화되어도 괜찮은 데이터

3. **컨테이너 간 파일 공유**

**예시**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-app
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log/nginx
  - name: log-sidecar
    image: fluentd
    volumeMounts:
    - name: shared-logs
      mountPath: /logs
  volumes:
  - name: shared-logs
    emptyDir: {}  # 임시 볼륨
```

**메모리 기반 emptyDir**
```yaml
volumes:
- name: cache
  emptyDir:
    medium: Memory  # RAM 사용 (빠름)
    sizeLimit: 1Gi
```

**주의사항**
- Pod 삭제 시 데이터 손실
- 영구 저장이 필요하면 PersistentVolume 사용

**실무 경험**
웹 서버와 로그 수집 사이드카를 emptyDir로 연결하여 로그를 실시간으로 Elasticsearch에 전송하는 구조를 구현했습니다.'
WHERE id = 'b0000000-0000-0000-0014-00000000001F';
