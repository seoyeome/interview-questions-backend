-- This file contains Kubernetes explanations Part 2 (Questions 12-22, indices 0x0C-0x16)
-- Total: 11 questions

-- Question 12 (0x0C): 노드가 다운되었을 때 쿠버네티스의 동작은?
UPDATE questions SET explanation =
$md$
**노드 장애 시 Kubernetes 동작**

**감지 과정**
1. kubelet이 40초간 응답 없음
2. kube-controller-manager가 노드를 NotReady 상태로 표시
3. 5분 후에도 복구 안 되면 Pod 퇴출(Eviction) 시작

**자동 복구**
- 해당 노드의 Pod를 다른 건강한 노드에 자동 재생성
- ReplicaSet/Deployment가 원하는 Pod 개수 유지
- StatefulSet은 기존 PV가 다시 연결될 때까지 대기

**타임라인**
```
T+0초:  노드 다운
T+40초: kubelet 응답 없음 감지
T+40초: 노드 상태 NotReady로 변경
T+5분:  Pod Eviction 시작
T+5분:  다른 노드에 Pod 재생성
```

**설정**
```yaml
# kube-controller-manager 플래그
--node-monitor-grace-period=40s
--pod-eviction-timeout=5m
```

**실무 경험**
프로덕션에서 노드 1대가 갑자기 다운되었을 때 5분 내에 모든 Pod가 다른 노드로 자동 이전되어 서비스 중단 없이 복구되었습니다.
$md$

WHERE id = 'b0000000-0000-0000-0014-00000000000C';

-- Question 13 (0x0D): Horizontal Pod Autoscaler(HPA)는 어떻게 작동하나요?
UPDATE questions SET explanation =
$md$
**HPA (Horizontal Pod Autoscaler)**

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

**스케일링 동작**
```
CPU 사용률 30% → 2개 (최소값 유지)
CPU 사용률 70% → 5개 (목표 유지)
CPU 사용률 90% → 7개 (자동 증가)
CPU 사용률 50% → 4개 (자동 감소)
```

**명령어**
```bash
# HPA 생성
kubectl autoscale deployment web --cpu-percent=70 --min=2 --max=10

# HPA 상태 확인
kubectl get hpa
```

**실무 경험**
트래픽이 급증하는 이벤트 기간 동안 HPA로 Pod를 자동으로 10개까지 늘려 안정적으로 서비스했고, 이벤트 종료 후 자동으로 2개로 축소하여 비용을 절감했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0014-00000000000D';

-- Question 14 (0x0E): 컨테이너 자원 제한은 Kubernetes에서 어떻게 설정하나요?
UPDATE questions SET explanation =
$md$
**컨테이너 리소스 제한**

**Requests vs Limits**

| | Requests | Limits |
|---|---|---|
| **의미** | 보장되는 최소 리소스 | 사용 가능한 최대 리소스 |
| **용도** | 스케줄링 기준 | 초과 시 제한/종료 |
| **CPU 초과** | 제한 없음 | Throttling (속도 제한) |
| **메모리 초과** | 제한 없음 | OOMKilled (강제 종료) |

**설정 예시**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app
spec:
  containers:
  - name: web
    image: nginx
    resources:
      requests:
        cpu: "250m"      # 0.25 core 보장
        memory: "512Mi"  # 512MB 보장
      limits:
        cpu: "500m"      # 최대 0.5 core
        memory: "1Gi"    # 최대 1GB
```

**CPU 단위**
- 1 = 1 CPU core
- 500m = 0.5 core
- 100m = 0.1 core (10%)

**메모리 단위**
- 512Mi = 512 Mebibytes
- 1Gi = 1 Gibibyte

**LimitRange (네임스페이스별 기본값)**
```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: default-limits
  namespace: production
spec:
  limits:
  - default:        # Limit 기본값
      cpu: "500m"
      memory: "1Gi"
    defaultRequest: # Request 기본값
      cpu: "250m"
      memory: "512Mi"
    type: Container
```

**실무 경험**
프로덕션에서 모든 Pod에 리소스 제한을 설정하여 한 Pod가 노드 전체 리소스를 독점하는 것을 방지하고, LimitRange로 기본값을 설정하여 실수로 리소스를 무제한 사용하는 일이 없도록 했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0014-00000000000E';

-- Question 15 (0x0F): 마이크로서비스 아키텍처에서 Kubernetes를 활용할 때 얻는 이점은?
UPDATE questions SET explanation =
$md$
**마이크로서비스 + Kubernetes 이점**

**1. 독립적인 배포**
- 각 서비스를 독립적으로 배포/업데이트
- 롤링 업데이트로 무중단 배포
- 서비스별 스케일링 가능

**2. 서비스 디스커버리**
- Kubernetes Service로 자동 로드 밸런싱
- DNS 기반 서비스 발견
- 하드코딩된 IP 불필요

**3. 자동 복구**
- Pod 장애 시 자동 재시작
- Health Check로 비정상 Pod 교체
- 노드 장애 시 다른 노드로 자동 이전

**4. 리소스 격리**
- 네임스페이스로 환경 분리 (dev/staging/prod)
- 서비스별 리소스 제한
- RBAC로 접근 권한 관리

**5. 통합 모니터링**
- Prometheus로 모든 서비스 메트릭 수집
- Grafana로 통합 대시보드
- 분산 추적 (Jaeger, Zipkin)

**예시 아키텍처**
```
Ingress (외부 진입점)
  ↓
├─ frontend-service → frontend Pods (3개)
├─ api-service → API Pods (5개)
├─ auth-service → Auth Pods (2개)
└─ db-service → DB StatefulSet (3개)
```

**실무 경험**
20개 마이크로서비스를 Kubernetes로 운영하며 각 서비스를 독립적으로 배포하고, HPA로 트래픽에 따라 자동 스케일링하여 리소스 사용률을 최적화했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0014-00000000000F';

-- Question 16 (0x10): DaemonSet은 어떤 경우에 활용되는지 설명해 주세요.
UPDATE questions SET explanation =
$md$
**DaemonSet**

모든 노드(또는 특정 노드)에 Pod를 정확히 1개씩 실행하는 리소스입니다.

**사용 사례**

**1. 로그 수집**
- Fluentd, Filebeat로 각 노드의 로그 수집

**2. 모니터링 에이전트**
- Node Exporter (Prometheus)
- 각 노드의 메트릭 수집

**3. 네트워크 플러그인**
- Calico, Flannel 등 CNI 플러그인

**4. 스토리지 데몬**
- Ceph, GlusterFS 클라이언트

**DaemonSet 예시**
```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd
spec:
  selector:
    matchLabels:
      app: fluentd
  template:
    metadata:
      labels:
        app: fluentd
    spec:
      containers:
      - name: fluentd
        image: fluent/fluentd:v1.14
        volumeMounts:
        - name: varlog
          mountPath: /var/log
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
```

**특정 노드에만 배포**
```yaml
spec:
  template:
    spec:
      nodeSelector:
        disk: ssd  # ssd 노드에만 배포
```

**Deployment vs DaemonSet**

| | Deployment | DaemonSet |
|---|---|---|
| **Pod 개수** | replicas로 지정 | 노드당 1개 |
| **배치** | 스케줄러가 자유롭게 | 모든(또는 특정) 노드 |
| **용도** | 애플리케이션 | 인프라 서비스 |

**실무 경험**
모든 노드에 Fluentd DaemonSet을 배포하여 각 노드의 로그를 자동으로 수집하고 Elasticsearch로 전송하여 중앙 집중식 로그 관리를 구현했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0014-000000000010';

-- Question 17 (0x11): Job과 CronJob은 각각 어떤 용도로 쓰이나요?
UPDATE questions SET explanation =
$md$
**Job과 CronJob**

**Job**
- 일회성 작업 실행 (배치 작업)
- 완료될 때까지 재시도
- 성공하면 종료 (재시작 안 함)

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: data-import
spec:
  completions: 1      # 1번 성공하면 완료
  parallelism: 1      # 동시에 1개 실행
  backoffLimit: 3     # 최대 3번 재시도
  template:
    spec:
      containers:
      - name: import
        image: myapp:1.0
        command: ["python", "import.py"]
      restartPolicy: Never
```

**CronJob**
- 주기적인 작업 실행 (스케줄링)
- Cron 형식으로 스케줄 지정

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: backup
spec:
  schedule: "0 2 * * *"  # 매일 새벽 2시
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup
            image: backup:1.0
            command: ["sh", "backup.sh"]
          restartPolicy: OnFailure
```

**Cron 스케줄 형식**
```
* * * * *
│ │ │ │ │
│ │ │ │ └─ 요일 (0-6)
│ │ │ └─── 월 (1-12)
│ │ └───── 일 (1-31)
│ └─────── 시 (0-23)
└───────── 분 (0-59)

예시:
0 2 * * *      # 매일 새벽 2시
*/15 * * * *   # 매 15분마다
0 0 * * 0      # 매주 일요일 자정
```

**사용 사례**

| Job | CronJob |
|---|---|
| 데이터 마이그레이션 | 백업 (매일) |
| 일회성 배치 작업 | 리포트 생성 (매주) |
| DB 초기화 | 로그 정리 (매월) |

**실무 경험**
CronJob으로 매일 새벽 2시에 데이터베이스 백업을 S3에 자동 업로드하고, Job으로 대량의 데이터 마이그레이션 작업을 안전하게 실행했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0014-000000000011';

-- Question 18 (0x12): 쿠버네티스에서 Service란 무엇이며, 왜 필요한가요?
UPDATE questions SET explanation =
$md$
**Kubernetes Service**

Pod에 접근하기 위한 안정적인 네트워크 엔드포인트를 제공합니다.

**왜 필요한가?**

**문제: Pod IP는 변경됨**
- Pod가 재시작되면 IP 변경
- 스케일링으로 Pod 추가/삭제 시 IP 변화
- 클라이언트가 직접 Pod IP를 추적하기 어려움

**Service가 해결**
- 고정된 IP와 DNS 이름 제공
- 여러 Pod로 자동 로드 밸런싱
- Pod가 변경되어도 Service IP는 유지

**Service 예시**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  selector:
    app: web  # app=web 라벨을 가진 Pod 선택
  ports:
  - port: 80        # Service 포트
    targetPort: 8080  # Pod 포트
  type: ClusterIP
```

**동작 원리**
```
요청: web-service:80
  ↓
Service (고정 IP: 10.96.0.1)
  ↓ (로드 밸런싱)
├─ Pod1 (IP: 10.244.1.5:8080)
├─ Pod2 (IP: 10.244.2.7:8080)
└─ Pod3 (IP: 10.244.1.9:8080)
```

**DNS 이름**
- 같은 네임스페이스: `web-service`
- 다른 네임스페이스: `web-service.production.svc.cluster.local`

**실무 경험**
마이크로서비스 아키텍처에서 각 서비스를 Service로 노출하여 다른 서비스들이 고정된 DNS 이름으로 접근하도록 했고, Pod가 수십 번 재시작되어도 서비스 간 통신에 문제가 없었습니다.
$md$

WHERE id = 'b0000000-0000-0000-0014-000000000012';

-- Question 19 (0x13): ClusterIP, NodePort, LoadBalancer 서비스의 차이는?
UPDATE questions SET explanation =
$md$
**Service 타입 비교**

**ClusterIP (기본값)**
- 클러스터 내부에서만 접근 가능
- 외부에서 직접 접근 불가
- 내부 마이크로서비스용

```yaml
type: ClusterIP
# 내부 IP만 할당: 10.96.0.1
# 다른 Pod에서 접근: curl web-service:80
```

**NodePort**
- 모든 노드의 특정 포트로 외부 접근 가능
- 포트 범위: 30000-32767
- ClusterIP 기능 포함

```yaml
type: NodePort
# ClusterIP: 10.96.0.1
# NodePort: 30080
# 외부 접근: http://<NodeIP>:30080
```

**LoadBalancer**
- 클라우드 제공자의 로드 밸런서 생성
- 외부 IP 할당
- NodePort, ClusterIP 기능 포함

```yaml
type: LoadBalancer
# ClusterIP: 10.96.0.1
# NodePort: 30080
# 외부 IP: 35.123.45.67 (AWS ELB 등)
# 외부 접근: http://35.123.45.67
```

**비교 표**

| 타입 | 외부 접근 | 사용 사례 |
|------|----------|----------|
| **ClusterIP** | ❌ | 내부 통신 (API, DB) |
| **NodePort** | ✅ (NodeIP:Port) | 개발/테스트 |
| **LoadBalancer** | ✅ (외부 IP) | 프로덕션 외부 서비스 |

**실무 경험**
프로덕션에서는 대부분의 서비스를 ClusterIP로 구성하고, Ingress Controller 1개만 LoadBalancer로 외부에 노출하여 비용을 절감하면서도 모든 서비스에 외부 접근을 제공했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0014-000000000013';

-- Question 20 (0x14): Ingress는 무엇이며, 어떻게 외부 트래픽을 처리하나요?
UPDATE questions SET explanation =
$md$
**Ingress**

HTTP/HTTPS 트래픽을 클러스터 내부 서비스로 라우팅하는 규칙입니다.

**LoadBalancer vs Ingress**

**LoadBalancer 방식 (비효율)**
```
frontend-svc: LoadBalancer (외부 IP: 35.1.1.1)
api-svc: LoadBalancer (외부 IP: 35.1.1.2)
auth-svc: LoadBalancer (외부 IP: 35.1.1.3)
# 서비스마다 외부 IP 필요 → 비용 증가
```

**Ingress 방식 (효율적)**
```
Ingress Controller: LoadBalancer (외부 IP: 35.1.1.1)
  ↓
example.com → frontend-svc (ClusterIP)
api.example.com → api-svc (ClusterIP)
example.com/auth → auth-svc (ClusterIP)
# 외부 IP 1개로 모든 서비스 접근
```

**Ingress 예시**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-svc
            port:
              number: 80
  - host: api.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-svc
            port:
              number: 80
```

**TLS/HTTPS**
```yaml
spec:
  tls:
  - hosts:
    - example.com
    secretName: tls-secret
```

**Ingress Controller**
- NGINX Ingress Controller (가장 인기)
- Traefik
- HAProxy

**실무 경험**
NGINX Ingress Controller로 20개 마이크로서비스를 단일 진입점으로 관리하고, Let's Encrypt로 TLS 인증서를 자동 갱신하여 모든 서비스에 HTTPS를 적용했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0014-000000000014';

-- Question 21 (0x15): 쿠버네티스의 etcd는 어떤 역할을 하나요?
UPDATE questions SET explanation =
$md$
**etcd**

Kubernetes 클러스터의 모든 상태를 저장하는 분산 키-값 저장소입니다.

**저장되는 데이터**
- Pod, Service, ConfigMap, Secret 등 모든 리소스
- 노드 상태
- 네트워크 정책
- RBAC 권한

**특징**
- Raft 알고리즘으로 데이터 일관성 보장
- 홀수 개 노드로 구성 (3, 5, 7개)
- Watch 메커니즘으로 변경사항 실시간 알림
- kube-apiserver만 직접 통신

**동작 예시**
```
kubectl create pod nginx
  ↓
kube-apiserver → etcd에 저장
  ↓
kube-scheduler가 etcd watch → 새 Pod 감지
  ↓
노드 배정 정보를 etcd에 업데이트
  ↓
kubelet이 etcd watch → Pod 생성
```

**고가용성 구성**
```
3노드 etcd 클러스터:
[etcd1] [etcd2] [etcd3]  ✅ 정상 (3/3)
[etcd1] [❌]    [etcd3]  ✅ 정상 (2/3, Quorum 유지)
[etcd1] [❌]    [❌]     ❌ 장애 (1/3, 읽기만 가능)
```

**백업**
```bash
# 스냅샷 백업
etcdctl snapshot save backup.db
```

**실무 경험**
프로덕션에서 etcd를 5노드 클러스터로 구성하여 최대 2개 노드 장애까지 허용하도록 했고, 매일 자동으로 스냅샷을 S3에 백업하여 장애 시 복구 가능하도록 준비했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0014-000000000015';

-- Question 22 (0x16): Control Plane 구성 요소에는 무엇이 있나요?
UPDATE questions SET explanation =
$md$
**Control Plane (Master Node) 구성 요소**

**4가지 핵심 컴포넌트**

**1. kube-apiserver**
- 모든 요청의 진입점
- RESTful API 제공
- 인증/인가 처리
- etcd와 유일하게 통신

**2. etcd**
- 클러스터 상태 저장소
- 분산 키-값 저장소
- 모든 리소스 정보 저장

**3. kube-scheduler**
- Pod를 적절한 노드에 배정
- 리소스, affinity, taints 고려
- 최적의 노드 선택

**4. kube-controller-manager**
- 여러 컨트롤러 실행
- Node Controller: 노드 상태 모니터링
- Replication Controller: Pod 개수 유지
- Endpoints Controller: Service-Pod 연결

**동작 흐름**
```
kubectl create deployment web --replicas=3
  ↓
kube-apiserver: 인증 → 인가 → 검증
  ↓
etcd: Deployment 정보 저장
  ↓
kube-controller-manager: ReplicaSet 생성 → Pod 3개 생성 요청
  ↓
kube-scheduler: Pod를 노드에 배정
  ↓
kubelet (Worker Node): 컨테이너 생성
```

**고가용성 구성**
```
Master1, Master2, Master3:
- kube-apiserver: 3개 모두 active (로드 밸런서로 분산)
- etcd: 3노드 클러스터
- scheduler/controller-manager: Leader Election (1개만 active)
```

**실무 경험**
프로덕션에서 Control Plane을 3개 노드로 구성하여 1개 노드 장애 시에도 정상 운영이 가능하도록 했고, HAProxy로 kube-apiserver 3개로 트래픽을 분산시켜 부하를 분산했습니다.
$md$

WHERE id = 'b0000000-0000-0000-0014-000000000016';
