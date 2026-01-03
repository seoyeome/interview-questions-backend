-- Spring 면접 질문 답변 추가 (Part 2: 질문 15-28)

UPDATE questions SET explanation = '스프링 프로필(Profiles)은 환경별로 다른 설정을 적용할 수 있는 기능입니다.

**사용 목적:**
- 개발(dev), 테스트(test), 운영(prod) 환경별 설정 분리
- 데이터베이스, API 엔드포인트 등을 환경에 따라 다르게 구성

**프로필 정의:**

```java
// 특정 프로필에서만 활성화
@Configuration
@Profile("dev")
public class DevConfig {
    @Bean
    public DataSource dataSource() {
        // 개발 DB 설정
    }
}

@Configuration
@Profile("prod")
public class ProdConfig {
    @Bean
    public DataSource dataSource() {
        // 운영 DB 설정
    }
}

// 여러 프로필
@Profile({"dev", "test"})

// 프로필 제외
@Profile("!prod")
```

**프로필 활성화:**

1. **application.properties/yml:**
```properties
spring.profiles.active=dev
```

2. **JVM 옵션:**
```bash
java -jar app.jar -Dspring.profiles.active=prod
```

3. **환경 변수:**
```bash
export SPRING_PROFILES_ACTIVE=prod
```

4. **프로그래밍 방식:**
```java
SpringApplication app = new SpringApplication(App.class);
app.setAdditionalProfiles("dev");
```

**프로필별 설정 파일:**
```
application.properties (공통)
application-dev.properties
application-prod.properties
```

**활용 예시:**
```yaml
# application-dev.yml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/dev_db

# application-prod.yml
spring:
  datasource:
    url: jdbc:mysql://prod-server:3306/prod_db
```'
WHERE id = 'b0000000-0000-0000-0001-00000000000F';

UPDATE questions SET explanation = 'RESTful 웹 서비스를 Spring으로 구현할 때 지켜야 할 원칙:

**REST 원칙:**

1. **자원(Resource) 식별**: URI로 자원 표현
   ```
   GET /users/1
   POST /users
   ```

2. **HTTP 메서드 사용**:
   - GET: 조회 (안전, 멱등성)
   - POST: 생성
   - PUT: 전체 수정 (멱등성)
   - PATCH: 부분 수정
   - DELETE: 삭제 (멱등성)

3. **상태 코드 활용**:
   - 200 OK: 성공
   - 201 Created: 생성 성공
   - 400 Bad Request: 잘못된 요청
   - 404 Not Found: 자원 없음
   - 500 Internal Server Error: 서버 오류

4. **무상태(Stateless)**: 각 요청은 독립적

**Spring 구현:**

```java
@RestController
@RequestMapping("/api/users")
public class UserController {

    @GetMapping
    public ResponseEntity<List<User>> getUsers() {
        return ResponseEntity.ok(userService.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<User> getUser(@PathVariable Long id) {
        return userService.findById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<User> createUser(@RequestBody @Valid UserDto dto) {
        User user = userService.create(dto);
        URI location = ServletUriComponentsBuilder
            .fromCurrentRequest()
            .path("/{id}")
            .buildAndExpand(user.getId())
            .toUri();
        return ResponseEntity.created(location).body(user);
    }

    @PutMapping("/{id}")
    public ResponseEntity<User> updateUser(
        @PathVariable Long id,
        @RequestBody @Valid UserDto dto
    ) {
        return ResponseEntity.ok(userService.update(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        userService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
```

**Best Practices:**
- 명사 사용 (동사 X): `/users` (O), `/getUsers` (X)
- 복수형 사용: `/users` (O), `/user` (X)
- 계층 구조: `/users/1/orders/2`
- 버전 관리: `/api/v1/users`
- HATEOAS: 응답에 링크 포함 (선택)'
WHERE id = 'b0000000-0000-0000-0001-000000000010';

UPDATE questions SET explanation = '프록시 객체는 타겟 객체를 감싸서 부가 기능을 제공하는 대리 객체입니다.

**차이점:**

**실제 객체:**
- 비즈니스 로직을 실제로 수행
- 스프링 컨테이너가 직접 관리하지 않을 수도 있음

**프록시 객체:**
- 실제 객체를 참조하고 있음
- 메서드 호출을 가로채서 부가 기능 실행
- 스프링 컨테이너가 빈으로 등록

**Spring Bean 주입 시 역할:**

```java
@Service
@Transactional
public class UserService {
    public void transfer() {
        // 비즈니스 로직
    }
}

// 실제 주입되는 것
@Autowired
private UserService userService; // 프록시 객체 (CGLIB$$EnhancerBySpringCGLIB)
```

**프록시가 하는 일:**

1. **메서드 호출 가로채기**
2. **부가 기능 실행** (@Transactional → 트랜잭션 시작)
3. **실제 메서드 호출** (타겟 객체의 transfer())
4. **부가 기능 마무리** (트랜잭션 커밋/롤백)

**프록시 생성 시점:**
- AOP가 적용된 빈 (@Transactional, @Async, 커스텀 AOP 등)
- 스코프가 다른 빈 (prototype을 singleton에 주입 등)

**프록시 확인:**
```java
System.out.println(userService.getClass().getName());
// UserService$$EnhancerBySpringCGLIB$$1234abcd
```

**주의사항:**
- 같은 클래스 내부 메서드 호출은 프록시를 거치지 않음
- final 메서드/클래스는 CGLIB 프록시 불가
- private 메서드는 프록시 적용 안 됨'
WHERE id = 'b0000000-0000-0000-0001-000000000011';

UPDATE questions SET explanation = '**BeanFactory:**
- 스프링 컨테이너의 최상위 인터페이스
- 빈을 관리하는 기본 기능만 제공
- **지연 로딩(Lazy Loading)**: 빈을 실제 요청할 때 생성

```java
BeanFactory factory = new XmlBeanFactory(new ClassPathResource("beans.xml"));
MyBean bean = (MyBean) factory.getBean("myBean"); // 이때 생성
```

**ApplicationContext:**
- BeanFactory를 상속한 확장 인터페이스
- 엔터프라이즈 애플리케이션에 필요한 기능 추가
- **즉시 로딩(Eager Loading)**: 컨테이너 시작 시 모든 싱글톤 빈 생성

```java
ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
MyBean bean = context.getBean(MyBean.class); // 이미 생성되어 있음
```

**차이점:**

| 기능 | BeanFactory | ApplicationContext |
|------|-------------|-------------------|
| 빈 생성 시점 | 지연 로딩 | 즉시 로딩 (싱글톤) |
| 국제화(i18n) | X | O |
| 이벤트 발행 | X | O |
| AOP 통합 | 수동 | 자동 |
| BeanPostProcessor | 수동 등록 | 자동 감지 |
| 메시지 리소스 | X | O |

**ApplicationContext 추가 기능:**

1. **국제화(MessageSource)**:
```java
context.getMessage("greeting", null, Locale.KOREA);
```

2. **이벤트 발행(ApplicationEventPublisher)**:
```java
context.publishEvent(new UserCreatedEvent(user));
```

3. **환경 변수(Environment)**:
```java
context.getEnvironment().getProperty("app.name");
```

4. **리소스 로딩(ResourceLoader)**:
```java
context.getResource("classpath:config.xml");
```

**실무:** ApplicationContext만 사용 (Spring Boot 기본)'
WHERE id = 'b0000000-0000-0000-0001-000000000012';

UPDATE questions SET explanation = 'Model 2 아키텍처는 MVC 패턴을 웹 애플리케이션에 적용한 구조입니다.

**모델1 vs 모델2:**

**모델1 (레거시):**
- JSP가 컨트롤러와 뷰 역할을 모두 담당
- JSP 파일에 Java 코드와 HTML이 혼재
- 유지보수 어려움

**모델2 (MVC):**
- Controller, Model, View가 명확히 분리
- Spring MVC가 모델2 방식

**Spring MVC 구성 요소:**

**1. Model:**
- 비즈니스 로직과 데이터
- Service, Repository, Entity

**2. View:**
- 사용자에게 보여지는 화면
- JSP, Thymeleaf, React 등

**3. Controller:**
- 사용자 요청을 받아 Model 호출하고 View 선택
- @Controller, @RestController

**흐름:**

```
Client → DispatcherServlet → Controller → Service → Repository
                                    ↓
                                  Model
                                    ↓
                            ViewResolver → View → Client
```

**예시:**

```java
// Controller
@Controller
public class UserController {

    @Autowired
    private UserService userService; // Model

    @GetMapping("/users/{id}")
    public String getUser(@PathVariable Long id, Model model) {
        User user = userService.findById(id); // Model 호출
        model.addAttribute("user", user); // View에 데이터 전달
        return "user/detail"; // View 선택
    }
}

// Service (Model)
@Service
public class UserService {
    public User findById(Long id) {
        // 비즈니스 로직
    }
}

// View (user/detail.jsp)
<h1>${user.name}</h1>
```

**장점:**
- 관심사 분리
- 유지보수 용이
- 테스트 용이
- 재사용성 높음'
WHERE id = 'b0000000-0000-0000-0001-000000000013';

UPDATE questions SET explanation = '여러 ApplicationContext를 사용하는 시나리오:

**1. 부모-자식 컨텍스트 구조:**

Spring MVC에서 Root Context와 Servlet Context를 분리:

```
Root ApplicationContext (부모)
├── Service, Repository (공통 빈)
└── Servlet ApplicationContext (자식)
    └── Controller, ViewResolver (웹 관련 빈)
```

**이유:**
- 관심사 분리: 비즈니스 로직과 웹 계층 분리
- 재사용: 여러 DispatcherServlet이 같은 서비스 공유
- 보안: 웹 계층에서 비즈니스 계층 접근은 가능하지만 역은 불가

**설정:**
```java
// RootConfig (부모)
@Configuration
@ComponentScan(basePackages = "com.example.service")
public class RootConfig { }

// WebConfig (자식)
@Configuration
@EnableWebMvc
@ComponentScan(basePackages = "com.example.controller")
public class WebConfig { }
```

**2. 멀티 모듈 프로젝트:**

```
Parent Context
├── Module A Context
├── Module B Context
└── Module C Context
```

각 모듈이 독립적인 컨텍스트를 가지면서 공통 빈은 부모에서 공유

**3. 멀티 테넌트 시스템:**

```
각 테넌트별로 별도 ApplicationContext
├── Tenant A Context
├── Tenant B Context
└── Tenant C Context
```

테넌트별로 다른 DB, 설정 사용

**4. 플러그인 아키텍처:**

```
Core Context
├── Plugin 1 Context
├── Plugin 2 Context
└── Plugin 3 Context
```

플러그인을 동적으로 로드/언로드

**주의사항:**
- 자식 컨텍스트는 부모의 빈을 참조 가능, 역은 불가
- 빈 이름 중복 시 자식이 우선
- 복잡도 증가, 꼭 필요한 경우만 사용
- Spring Boot는 기본적으로 단일 컨텍스트 사용'
WHERE id = 'b0000000-0000-0000-0001-000000000014';

UPDATE questions SET explanation = '두 인터페이스 모두 빈 후처리기(Post Processor)이지만 처리 시점과 대상이 다릅니다.

**BeanFactoryPostProcessor:**
- **빈 정의(BeanDefinition)를 수정**하는 후처리기
- 빈 인스턴스 생성 **전**에 실행
- 빈 메타데이터를 변경 가능

```java
@Component
public class CustomBeanFactoryPostProcessor implements BeanFactoryPostProcessor {

    @Override
    public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) {
        // 빈 정의 수정
        BeanDefinition bd = beanFactory.getBeanDefinition("myBean");
        bd.setScope("prototype"); // 스코프 변경

        // 프로퍼티 값 변경
        MutablePropertyValues pvs = bd.getPropertyValues();
        pvs.add("name", "modified");
    }
}
```

**실행 시점:** 컨테이너 초기화 → BeanFactoryPostProcessor → 빈 생성

**BeanPostProcessor:**
- **빈 인스턴스를 수정**하는 후처리기
- 빈 인스턴스 생성 **후**에 실행
- 빈 객체 자체를 변경하거나 프록시 생성 가능

```java
@Component
public class CustomBeanPostProcessor implements BeanPostProcessor {

    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) {
        System.out.println("초기화 전: " + beanName);
        return bean; // 또는 수정된 빈 반환
    }

    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) {
        System.out.println("초기화 후: " + beanName);

        // 프록시 생성 예시
        if (bean instanceof MyService) {
            return Proxy.newProxyInstance(...);
        }
        return bean;
    }
}
```

**실행 시점:** 빈 생성 → postProcessBeforeInitialization → 초기화(@PostConstruct) → postProcessAfterInitialization

**비교:**

| 항목 | BeanFactoryPostProcessor | BeanPostProcessor |
|------|-------------------------|-------------------|
| 처리 대상 | 빈 정의 (메타데이터) | 빈 인스턴스 (객체) |
| 실행 시점 | 빈 생성 전 | 빈 생성 후 |
| 용도 | 빈 설정 변경 | 빈 객체 수정, 프록시 생성 |
| 예시 | PropertyPlaceholderConfigurer | AOP 프록시, @Autowired 처리 |

**실무 예시:**
- BeanFactoryPostProcessor: 환경 변수 치환, 프로필별 설정
- BeanPostProcessor: AOP, @Transactional, 의존성 주입'
WHERE id = 'b0000000-0000-0000-0001-000000000015';

UPDATE questions SET explanation = '싱글톤 Bean은 하나의 인스턴스를 여러 스레드가 공유하므로 **스레드 안전(Thread-Safe)** 설계가 필요합니다.

**문제 상황:**

```java
@Service
public class UserService {
    private int count = 0; // 멀티스레드 환경에서 위험!

    public void incrementCount() {
        count++; // 경쟁 조건(Race Condition) 발생
    }
}
```

**스레드 안전 설계 방법:**

**1. 무상태(Stateless) 설계 (권장):**
```java
@Service
public class UserService {
    // 인스턴스 변수 없음 (상태 없음)

    public User getUser(Long id) {
        // 로컬 변수만 사용
        User user = userRepository.findById(id);
        return user;
    }
}
```
- 인스턴스 변수를 사용하지 않음
- 메서드 파라미터와 로컬 변수만 사용

**2. 불변 객체 사용:**
```java
@Service
public class UserService {
    private final UserRepository repository; // final, 불변

    @Autowired
    public UserService(UserRepository repository) {
        this.repository = repository;
    }
}
```

**3. ThreadLocal 사용:**
```java
@Service
public class UserService {
    private ThreadLocal<User> currentUser = new ThreadLocal<>();

    public void setCurrentUser(User user) {
        currentUser.set(user); // 스레드별 독립 저장
    }

    public User getCurrentUser() {
        return currentUser.get();
    }
}
```
- 주의: 사용 후 `remove()` 호출 필수 (메모리 누수 방지)

**4. 동기화 (비권장 - 성능 저하):**
```java
@Service
public class UserService {
    private int count = 0;

    public synchronized void incrementCount() {
        count++;
    }
}
```

**5. Atomic 클래스 사용:**
```java
@Service
public class UserService {
    private AtomicInteger count = new AtomicInteger(0);

    public void incrementCount() {
        count.incrementAndGet(); // 원자적 연산
    }
}
```

**Best Practice:**
- 가능하면 무상태로 설계
- 의존성은 final로 불변성 보장
- 상태가 필요하면 ThreadLocal 또는 요청 스코프 빈 사용
- 동기화는 최후의 수단 (성능 저하)'
WHERE id = 'b0000000-0000-0000-0001-000000000016';

UPDATE questions SET explanation = '스프링 Bean의 초기화/소멸 메서드 지정 방법:

**초기화 메서드:**

**1. @PostConstruct (권장):**
```java
@Component
public class MyBean {
    @PostConstruct
    public void init() {
        System.out.println("빈 초기화");
        // DB 커넥션 풀 생성, 파일 로드 등
    }
}
```

**2. InitializingBean 인터페이스:**
```java
@Component
public class MyBean implements InitializingBean {
    @Override
    public void afterPropertiesSet() throws Exception {
        System.out.println("빈 초기화");
    }
}
```

**3. @Bean(initMethod):**
```java
@Configuration
public class AppConfig {
    @Bean(initMethod = "init")
    public MyBean myBean() {
        return new MyBean();
    }
}

public class MyBean {
    public void init() {
        System.out.println("빈 초기화");
    }
}
```

**소멸 메서드:**

**1. @PreDestroy (권장):**
```java
@Component
public class MyBean {
    @PreDestroy
    public void cleanup() {
        System.out.println("빈 소멸");
        // 리소스 정리, 커넥션 종료 등
    }
}
```

**2. DisposableBean 인터페이스:**
```java
@Component
public class MyBean implements DisposableBean {
    @Override
    public void destroy() throws Exception {
        System.out.println("빈 소멸");
    }
}
```

**3. @Bean(destroyMethod):**
```java
@Bean(destroyMethod = "cleanup")
public MyBean myBean() {
    return new MyBean();
}
```

**실행 순서:**
```
초기화: @PostConstruct → afterPropertiesSet() → initMethod
소멸: @PreDestroy → destroy() → destroyMethod
```

**주의사항:**
- prototype 스코프는 소멸 콜백이 호출되지 않음
- 초기화 메서드에서 예외 발생 시 빈 생성 실패
- @PostConstruct/@PreDestroy는 JSR-250 표준 (Java 11+에서는 별도 의존성 필요)

**Best Practice:** @PostConstruct와 @PreDestroy 사용'
WHERE id = 'b0000000-0000-0000-0001-000000000017';

UPDATE questions SET explanation = '@EnableAspectJAutoProxy는 스프링 AOP에서 AspectJ 스타일의 애노테이션 기반 AOP를 활성화하는 애노테이션입니다.

**역할:**

1. **@Aspect 애노테이션을 인식**하여 AOP 설정 자동 구성
2. **프록시 자동 생성**: AOP가 적용될 빈에 프록시 객체 생성
3. **Pointcut과 Advice를 자동 매칭**

**사용 방법:**

```java
@Configuration
@EnableAspectJAutoProxy
public class AppConfig {
    // AOP 설정
}

@Aspect
@Component
public class LoggingAspect {

    @Before("execution(* com.example.service.*.*(..))")
    public void logBefore(JoinPoint joinPoint) {
        System.out.println("메서드 호출: " + joinPoint.getSignature());
    }
}
```

**옵션:**

**1. proxyTargetClass:**
```java
@EnableAspectJAutoProxy(proxyTargetClass = true)
```
- `false` (기본): JDK Dynamic Proxy 사용 (인터페이스 기반)
- `true`: CGLIB Proxy 사용 (클래스 기반)

**2. exposeProxy:**
```java
@EnableAspectJAutoProxy(exposeProxy = true)
```
- 현재 프록시를 ThreadLocal에 노출
- 같은 클래스 내부 메서드 호출 시 프록시 사용 가능

```java
@Service
@Transactional
public class UserService {

    public void outer() {
        // 프록시를 통해 호출 (트랜잭션 적용됨)
        ((UserService) AopContext.currentProxy()).inner();
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void inner() {
        // 새 트랜잭션
    }
}
```

**Spring Boot:**
```java
// 자동 설정됨 (spring-boot-starter-aop 의존성 추가 시)
// 명시적으로 @EnableAspectJAutoProxy 불필요
```

**없으면:**
- @Aspect 클래스를 인식하지 못함
- AOP가 작동하지 않음
- 수동으로 ProxyFactoryBean 설정 필요'
WHERE id = 'b0000000-0000-0000-0001-000000000018';

UPDATE questions SET explanation = 'Spring에서 예외 처리 방법:

**1. @ExceptionHandler (컨트롤러 레벨):**

```java
@RestController
public class UserController {

    @GetMapping("/users/{id}")
    public User getUser(@PathVariable Long id) {
        return userService.findById(id); // 예외 발생 가능
    }

    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleUserNotFound(UserNotFoundException ex) {
        ErrorResponse error = new ErrorResponse("USER_NOT_FOUND", ex.getMessage());
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGeneral(Exception ex) {
        ErrorResponse error = new ErrorResponse("INTERNAL_ERROR", "서버 오류");
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }
}
```

**2. @ControllerAdvice (전역 예외 처리, 권장):**

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleUserNotFound(UserNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(new ErrorResponse("USER_NOT_FOUND", ex.getMessage()));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException ex) {
        String message = ex.getBindingResult().getAllErrors().get(0).getDefaultMessage();
        return ResponseEntity.badRequest()
            .body(new ErrorResponse("VALIDATION_ERROR", message));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGeneral(Exception ex) {
        log.error("Unexpected error", ex);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
            .body(new ErrorResponse("INTERNAL_ERROR", "서버 오류"));
    }
}
```

**3. @ResponseStatus:**

```java
@ResponseStatus(HttpStatus.NOT_FOUND)
public class UserNotFoundException extends RuntimeException {
    public UserNotFoundException(String message) {
        super(message);
    }
}
```

**4. ResponseEntityExceptionHandler 상속:**

```java
@RestControllerAdvice
public class GlobalExceptionHandler extends ResponseEntityExceptionHandler {

    @Override
    protected ResponseEntity<Object> handleMethodArgumentNotValid(
        MethodArgumentNotValidException ex,
        HttpHeaders headers,
        HttpStatus status,
        WebRequest request
    ) {
        // 커스텀 처리
        return ResponseEntity.badRequest().body(...);
    }
}
```

**5. ErrorController (Fallback):**

```java
@Controller
public class CustomErrorController implements ErrorController {

    @RequestMapping("/error")
    public ResponseEntity<ErrorResponse> handleError(HttpServletRequest request) {
        Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
        return ResponseEntity.status(statusCode).body(...);
    }
}
```

**Best Practice:**
- @ControllerAdvice로 전역 예외 처리
- 계층별로 커스텀 예외 정의 (UserNotFoundException 등)
- @ResponseStatus로 HTTP 상태 코드 지정
- 민감한 정보 노출 금지 (스택 트레이스 숨김)
- 로깅으로 디버깅 정보 기록'
WHERE id = 'b0000000-0000-0000-0001-000000000019';

UPDATE questions SET explanation = 'ProxyFactoryBean을 사용한 AOP 설정은 스프링 초기의 프로그래밍 방식 AOP 설정입니다.

**ProxyFactoryBean 방식 (레거시):**

```java
@Configuration
public class AopConfig {

    @Bean
    public ProxyFactoryBean userServiceProxy() {
        ProxyFactoryBean proxyFactoryBean = new ProxyFactoryBean();

        // 타겟 객체 설정
        proxyFactoryBean.setTarget(userService());

        // Advice 설정 (부가 기능)
        proxyFactoryBean.setInterceptorNames("loggingAdvice", "transactionAdvice");

        return proxyFactoryBean;
    }

    @Bean
    public UserService userService() {
        return new UserService();
    }

    @Bean
    public MethodInterceptor loggingAdvice() {
        return new MethodInterceptor() {
            @Override
            public Object invoke(MethodInvocation invocation) throws Throwable {
                System.out.println("메서드 호출 전: " + invocation.getMethod().getName());
                Object result = invocation.proceed();
                System.out.println("메서드 호출 후");
                return result;
            }
        };
    }
}
```

**Advisor 사용 (Pointcut + Advice):**

```java
@Bean
public Advisor loggingAdvisor() {
    // Pointcut 정의
    AspectJExpressionPointcut pointcut = new AspectJExpressionPointcut();
    pointcut.setExpression("execution(* com.example.service.*.*(..))");

    // Advice 정의
    MethodInterceptor advice = invocation -> {
        System.out.println("Before: " + invocation.getMethod().getName());
        Object result = invocation.proceed();
        System.out.println("After");
        return result;
    };

    // Advisor (Pointcut + Advice)
    return new DefaultPointcutAdvisor(pointcut, advice);
}

@Bean
public ProxyFactoryBean userServiceProxy() {
    ProxyFactoryBean proxyFactoryBean = new ProxyFactoryBean();
    proxyFactoryBean.setTarget(userService());
    proxyFactoryBean.addAdvisor(loggingAdvisor());
    return proxyFactoryBean;
}
```

**현대 방식 (@AspectJ, 권장):**

```java
@Aspect
@Component
public class LoggingAspect {

    @Around("execution(* com.example.service.*.*(..))")
    public Object logAround(ProceedingJoinPoint pjp) throws Throwable {
        System.out.println("Before: " + pjp.getSignature());
        Object result = pjp.proceed();
        System.out.println("After");
        return result;
    }
}

@Configuration
@EnableAspectJAutoProxy
public class AppConfig { }
```

**비교:**
- ProxyFactoryBean: 프로그래밍 방식, 복잡, 레거시
- @AspectJ: 선언적 방식, 간결, 현대적

**실무:** @AspectJ 방식 사용 (Spring Boot 자동 설정)'
WHERE id = 'b0000000-0000-0000-0001-00000000001A';

UPDATE questions SET explanation = '스프링 빈 스코프(Scope)의 종류:

**기본 스코프:**

**1. singleton (기본값):**
- 스프링 컨테이너당 하나의 인스턴스
- 모든 요청에서 동일한 객체 반환
```java
@Scope("singleton") // 또는 생략
@Component
public class MyBean { }
```

**2. prototype:**
- 요청할 때마다 새 인스턴스 생성
- 컨테이너는 생성/DI까지만 관리, 소멸은 클라이언트 책임
```java
@Scope("prototype")
@Component
public class MyBean { }
```

**웹 환경 스코프:**

**3. request:**
- HTTP 요청당 하나의 인스턴스
- 요청 종료 시 소멸
```java
@Scope(value = WebApplicationContext.SCOPE_REQUEST)
@Component
public class LoginUser { }

// 또는
@RequestScope
@Component
public class LoginUser { }
```

**4. session:**
- HTTP 세션당 하나의 인스턴스
- 세션 종료 시 소멸
```java
@Scope(value = WebApplicationContext.SCOPE_SESSION)
@Component
public class ShoppingCart { }

// 또는
@SessionScope
@Component
public class ShoppingCart { }
```

**5. application:**
- ServletContext 생명주기와 동일
- 웹 애플리케이션당 하나
```java
@Scope(value = WebApplicationContext.SCOPE_APPLICATION)
@Component
public class AppConfig { }

// 또는
@ApplicationScope
@Component
public class AppConfig { }
```

**6. websocket:**
- WebSocket 세션당 하나의 인스턴스
```java
@Scope(scopeName = "websocket")
@Component
public class WebSocketHandler { }
```

**커스텀 스코프:**
```java
@Scope("custom")
@Component
public class MyBean { }

// Scope 구현 등록
beanFactory.registerScope("custom", new MyCustomScope());
```

**프록시 모드 (스코프 프록시):**
```java
@Scope(value = "request", proxyMode = ScopedProxyMode.TARGET_CLASS)
@Component
public class LoginUser { }
```
- singleton 빈에 request/session 빈 주입 시 필요
- 프록시를 통해 실제 객체에 접근

**선택 기준:**
- 무상태: singleton
- 상태 유지: prototype, request, session'
WHERE id = 'b0000000-0000-0000-0001-00000000001B';
