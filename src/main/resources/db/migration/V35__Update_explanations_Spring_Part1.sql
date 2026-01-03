-- Spring 면접 질문 답변 추가 (Part 1: 질문 1-14)

UPDATE questions SET explanation = '스프링 프레임워크는 Java 기반의 엔터프라이즈 애플리케이션 개발을 위한 경량 프레임워크입니다.

**주요 기능:**

1. **IoC/DI (제어의 역전/의존성 주입)**: 객체 생성과 의존성 관리를 프레임워크가 담당
2. **AOP (관점 지향 프로그래밍)**: 횡단 관심사(로깅, 트랜잭션 등)를 분리하여 모듈화
3. **트랜잭션 관리**: 선언적 트랜잭션 지원으로 간편한 데이터베이스 처리
4. **MVC 프레임워크**: 웹 애플리케이션 개발을 위한 Model-View-Controller 패턴 지원
5. **데이터 접근 추상화**: JDBC, JPA, Hibernate 등 다양한 데이터 액세스 기술 통합
6. **테스트 지원**: 단위 테스트와 통합 테스트를 쉽게 작성할 수 있는 기능 제공

**장점:** 경량, 모듈화, 확장성, POJO 기반 개발'
WHERE id = 'b0000000-0000-0000-0001-000000000001';

UPDATE questions SET explanation = '**IoC (Inversion of Control, 제어의 역전):**
- 객체의 생성, 생명주기 관리를 개발자가 아닌 프레임워크(스프링 컨테이너)가 제어합니다
- 전통적인 방식: 개발자가 직접 `new` 키워드로 객체 생성
- IoC: 스프링 컨테이너가 객체를 생성하고 관리

**DI (Dependency Injection, 의존성 주입):**
- IoC를 구현하는 구체적인 방법 중 하나
- 객체 간의 의존 관계를 외부에서 주입합니다
- 결합도를 낮추고 테스트 용이성을 높입니다

```java
// DI 없이 (강한 결합)
public class UserService {
    private UserRepository repository = new UserRepository(); // 직접 생성
}

// DI 사용 (느슨한 결합)
@Service
public class UserService {
    private final UserRepository repository;

    @Autowired
    public UserService(UserRepository repository) {
        this.repository = repository; // 외부에서 주입
    }
}
```

**장점:** 결합도 감소, 테스트 용이, 코드 재사용성 향상'
WHERE id = 'b0000000-0000-0000-0001-000000000002';

UPDATE questions SET explanation = 'Spring Bean은 스프링 IoC 컨테이너가 관리하는 객체입니다.

**특징:**
- 스프링 컨테이너에 의해 생성, 관리, 소멸됩니다
- 기본적으로 싱글톤 스코프로 생성됩니다
- `@Component`, `@Service`, `@Repository`, `@Controller` 등의 애노테이션으로 등록

**Bean 등록 방법:**

1. **컴포넌트 스캔**:
```java
@Component
public class MyBean { }
```

2. **Java Config**:
```java
@Configuration
public class AppConfig {
    @Bean
    public MyBean myBean() {
        return new MyBean();
    }
}
```

3. **XML 설정** (레거시):
```xml
<bean id="myBean" class="com.example.MyBean"/>
```

**스프링이 관리하는 이점:** 생명주기 관리, DI, AOP 적용, 싱글톤 보장'
WHERE id = 'b0000000-0000-0000-0001-000000000003';

UPDATE questions SET explanation = '빈 스코프는 빈이 생성되고 존재하는 범위를 정의합니다.

**주요 스코프:**

1. **singleton (기본값)**:
   - 스프링 컨테이너당 하나의 인스턴스만 생성
   - 모든 요청에서 같은 객체 반환
   ```java
   @Scope("singleton") // 또는 생략
   @Component
   public class MySingleton { }
   ```

2. **prototype**:
   - 요청할 때마다 새로운 인스턴스 생성
   - 컨테이너는 생성까지만 관리, 이후는 클라이언트 책임
   ```java
   @Scope("prototype")
   @Component
   public class MyPrototype { }
   ```

3. **request** (웹 환경):
   - HTTP 요청당 하나의 인스턴스 생성
   - 요청 완료 시 소멸

4. **session** (웹 환경):
   - HTTP 세션당 하나의 인스턴스 생성
   - 세션 종료 시 소멸

5. **application** (웹 환경):
   - ServletContext 생명주기와 동일

6. **websocket** (웹 환경):
   - WebSocket 세션당 하나의 인스턴스

**선택 기준:** 상태를 가지지 않으면 singleton, 상태를 가지면 prototype 또는 request'
WHERE id = 'b0000000-0000-0000-0001-000000000004';

UPDATE questions SET explanation = '프록시 패턴은 스프링 AOP의 핵심 메커니즘으로, 타겟 객체를 감싸서 부가 기능을 제공합니다.

**동작 원리:**

1. **프록시 객체 생성**: 스프링이 원본 객체 대신 프록시 객체를 빈으로 등록
2. **메서드 호출 가로채기**: 클라이언트가 메서드 호출 시 프록시가 먼저 실행
3. **부가 기능 실행**: Advice(로깅, 트랜잭션 등) 실행
4. **원본 메서드 호출**: 타겟 객체의 실제 메서드 실행

**프록시 생성 방식:**

1. **JDK Dynamic Proxy** (인터페이스 기반):
   - 타겟이 인터페이스를 구현한 경우
   - Java의 리플렉션 사용
   ```java
   public interface UserService { }

   @Service
   public class UserServiceImpl implements UserService { } // JDK Proxy
   ```

2. **CGLIB Proxy** (클래스 기반):
   - 타겟이 인터페이스를 구현하지 않은 경우
   - 바이트코드를 조작하여 서브클래스 생성
   ```java
   @Service
   public class UserService { } // CGLIB Proxy
   ```

**AOP 적용 예시:**
```java
@Aspect
@Component
public class LoggingAspect {
    @Around("execution(* com.example.service.*.*(..))")
    public Object logExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
        long start = System.currentTimeMillis();
        Object result = joinPoint.proceed(); // 실제 메서드 호출
        long end = System.currentTimeMillis();
        System.out.println("실행 시간: " + (end - start) + "ms");
        return result;
    }
}
```

**주의:** 같은 클래스 내부 메서드 호출은 프록시를 거치지 않아 AOP가 적용되지 않습니다.'
WHERE id = 'b0000000-0000-0000-0001-000000000005';

UPDATE questions SET explanation = '**Advice (어드바이스):**
- 실제로 실행되는 부가 기능 코드 (언제, 무엇을)
- 횡단 관심사(로깅, 트랜잭션 등)의 구현체

**종류:**
1. **@Before**: 메서드 실행 전
2. **@After**: 메서드 실행 후 (예외 발생 여부 무관)
3. **@AfterReturning**: 메서드 정상 종료 후
4. **@AfterThrowing**: 메서드 예외 발생 후
5. **@Around**: 메서드 실행 전후 (가장 강력)

**Pointcut (포인트컷):**
- Advice가 적용될 위치(조인 포인트)를 지정하는 표현식 (어디에)
- 어떤 메서드에 AOP를 적용할지 정의

**예시:**
```java
@Aspect
@Component
public class LoggingAspect {

    // Pointcut: execution으로 적용 대상 지정
    @Pointcut("execution(* com.example.service.*.*(..))")
    private void serviceLayer() { }

    // Advice: Before 타입, serviceLayer() 포인트컷 참조
    @Before("serviceLayer()")
    public void logBefore(JoinPoint joinPoint) {
        System.out.println("메서드 호출: " + joinPoint.getSignature());
    }

    // Advice: Around 타입
    @Around("execution(* com.example.controller.*.*(..))")
    public Object logExecutionTime(ProceedingJoinPoint pjp) throws Throwable {
        long start = System.currentTimeMillis();
        Object result = pjp.proceed();
        System.out.println("실행 시간: " + (System.currentTimeMillis() - start));
        return result;
    }
}
```

**Pointcut 표현식:**
- `execution(* com.example.*.*(..))`: 모든 메서드
- `within(com.example.service.*)`: 특정 패키지
- `@annotation(Transactional)`: 특정 애노테이션

**관계:** Pointcut이 "어디에" 적용할지 정의하면, Advice가 "무엇을" 할지 정의합니다.'
WHERE id = 'b0000000-0000-0000-0001-000000000006';

UPDATE questions SET explanation = '스프링에서 의존성을 주입하는 방법은 크게 3가지입니다.

**1. 생성자 주입 (권장)**:
```java
@Service
public class UserService {
    private final UserRepository repository;

    @Autowired // 생성자가 하나면 생략 가능
    public UserService(UserRepository repository) {
        this.repository = repository;
    }
}
```
**장점:**
- final 키워드로 불변성 보장
- 순환 참조 방지 (컴파일 시점 감지)
- 테스트 용이 (Mock 객체 주입 쉬움)
- NPE 방지 (필수 의존성 보장)

**2. Setter 주입**:
```java
@Service
public class UserService {
    private UserRepository repository;

    @Autowired
    public void setRepository(UserRepository repository) {
        this.repository = repository;
    }
}
```
**단점:**
- 불변성 보장 안 됨
- 선택적 의존성에만 사용 권장

**3. 필드 주입 (비권장)**:
```java
@Service
public class UserService {
    @Autowired
    private UserRepository repository;
}
```
**단점:**
- final 사용 불가
- 테스트 어려움 (리플렉션 필요)
- 순환 참조 런타임 감지
- 의존성이 숨겨져 있어 파악 어려움

**Spring 공식 권장:** 생성자 주입 사용'
WHERE id = 'b0000000-0000-0000-0001-000000000007';

UPDATE questions SET explanation = '스프링은 **선언적 트랜잭션**을 지원하여 `@Transactional` 애노테이션으로 간편하게 트랜잭션을 관리합니다.

**트랜잭션 관리 방식:**

1. **선언적 트랜잭션** (권장):
```java
@Transactional
public void transfer(Long fromId, Long toId, int amount) {
    accountRepository.withdraw(fromId, amount);
    accountRepository.deposit(toId, amount);
    // 예외 발생 시 자동 롤백
}
```

2. **프로그래밍 방식** (세밀한 제어 필요 시):
```java
TransactionTemplate transactionTemplate;

transactionTemplate.execute(status -> {
    // 트랜잭션 코드
    return result;
});
```

**전파(Propagation) 옵션:**

1. **REQUIRED (기본값)**: 기존 트랜잭션이 있으면 참여, 없으면 새로 생성
2. **REQUIRES_NEW**: 항상 새 트랜잭션 생성 (기존 것은 보류)
3. **SUPPORTS**: 기존 트랜잭션 있으면 참여, 없으면 트랜잭션 없이 실행
4. **MANDATORY**: 기존 트랜잭션 필수 (없으면 예외)
5. **NOT_SUPPORTED**: 트랜잭션 없이 실행 (기존 것은 보류)
6. **NEVER**: 트랜잭션 없이 실행 (기존 것 있으면 예외)
7. **NESTED**: 중첩 트랜잭션 (부모 영향받지만 독립 롤백 가능)

```java
@Transactional(propagation = Propagation.REQUIRES_NEW)
public void createLog() {
    // 별도 트랜잭션으로 실행
}
```

**격리 수준(Isolation):**
- READ_UNCOMMITTED, READ_COMMITTED, REPEATABLE_READ, SERIALIZABLE

**동작 원리:** AOP 프록시를 통해 메서드 실행 전후로 트랜잭션 시작/커밋/롤백'
WHERE id = 'b0000000-0000-0000-0001-000000000008';

UPDATE questions SET explanation = '@Transactional 사용 시 주의할 점:

**1. private 메서드에는 적용 안 됨:**
```java
@Transactional
private void method() { } // AOP 프록시가 private 메서드 호출 불가
```

**2. 같은 클래스 내부 메서드 호출 시 적용 안 됨:**
```java
@Service
public class UserService {
    public void outer() {
        inner(); // 프록시를 거치지 않아 @Transactional 무효
    }

    @Transactional
    public void inner() { }
}
```
**해결:** 다른 Bean으로 분리하거나 self-injection

**3. 체크 예외는 기본적으로 롤백 안 됨:**
```java
@Transactional
public void method() throws Exception {
    throw new Exception(); // 롤백 안 됨
}

// 해결: rollbackFor 명시
@Transactional(rollbackFor = Exception.class)
public void method() throws Exception { }
```

**4. 프록시 모드 vs AspectJ 모드:**
- 기본 프록시 모드는 외부 호출만 가로챔
- AspectJ 모드는 모든 호출 가로챔 (설정 복잡)

**5. 트랜잭션 범위 최소화:**
- 긴 트랜잭션은 DB 락 증가, 성능 저하
- 필요한 부분만 트랜잭션 적용

**6. readOnly 옵션 활용:**
```java
@Transactional(readOnly = true)
public User findUser(Long id) {
    // 읽기 전용 최적화
}
```

**7. 격리 수준과 전파 옵션 이해:**
- 기본값이 적합한지 확인
- 동시성과 일관성 트레이드오프 고려'
WHERE id = 'b0000000-0000-0000-0001-000000000009';

UPDATE questions SET explanation = 'DispatcherServlet은 Spring MVC의 **프론트 컨트롤러(Front Controller)**로, 모든 HTTP 요청을 중앙에서 처리합니다.

**역할:**

1. **요청 접수**: 모든 클라이언트 요청을 받습니다
2. **핸들러 매핑**: 요청 URL에 맞는 컨트롤러 찾기
3. **핸들러 어댑터**: 컨트롤러 메서드 실행
4. **뷰 리졸버**: 논리적 뷰 이름을 실제 뷰로 변환
5. **뷰 렌더링**: 모델 데이터를 뷰에 전달하여 응답 생성

**요청 처리 흐름:**

```
1. 클라이언트 → DispatcherServlet (HTTP 요청)
2. DispatcherServlet → HandlerMapping (어느 컨트롤러?)
3. HandlerMapping → DispatcherServlet (Controller 정보 반환)
4. DispatcherServlet → HandlerAdapter (컨트롤러 실행)
5. HandlerAdapter → Controller (비즈니스 로직)
6. Controller → HandlerAdapter (ModelAndView 반환)
7. DispatcherServlet → ViewResolver (뷰 이름 → 실제 뷰)
8. ViewResolver → DispatcherServlet (View 객체 반환)
9. DispatcherServlet → View (모델 데이터 전달, 렌더링)
10. View → 클라이언트 (HTML 응답)
```

**설정 (Spring Boot):**
```java
// 자동 설정됨, web.xml 불필요
// application.properties에서 커스터마이징
spring.mvc.view.prefix=/WEB-INF/views/
spring.mvc.view.suffix=.jsp
```

**장점:** 공통 처리(인터셉터, 예외 처리 등)를 중앙 집중화'
WHERE id = 'b0000000-0000-0000-0001-00000000000A';

UPDATE questions SET explanation = 'Spring Bean의 생명주기는 다음과 같습니다:

**생성 → 의존성 주입 → 초기화 → 사용 → 소멸**

**상세 단계:**

1. **스프링 컨테이너 생성**
2. **빈 객체 생성** (생성자 호출)
3. **의존성 주입** (DI)
4. **초기화 콜백**:
   - `@PostConstruct` 메서드 실행
   - `InitializingBean.afterPropertiesSet()` 실행
   - `@Bean(initMethod="init")` 실행
5. **빈 사용**
6. **소멸 콜백** (컨테이너 종료 시):
   - `@PreDestroy` 메서드 실행
   - `DisposableBean.destroy()` 실행
   - `@Bean(destroyMethod="cleanup")` 실행
7. **스프링 컨테이너 종료**

**초기화/소멸 메서드 지정 방법:**

```java
// 1. @PostConstruct, @PreDestroy (권장)
@Component
public class MyBean {
    @PostConstruct
    public void init() {
        System.out.println("초기화");
    }

    @PreDestroy
    public void cleanup() {
        System.out.println("소멸");
    }
}

// 2. InitializingBean, DisposableBean 인터페이스
public class MyBean implements InitializingBean, DisposableBean {
    @Override
    public void afterPropertiesSet() { }

    @Override
    public void destroy() { }
}

// 3. @Bean 속성
@Configuration
public class AppConfig {
    @Bean(initMethod = "init", destroyMethod = "cleanup")
    public MyBean myBean() {
        return new MyBean();
    }
}
```

**주의:**
- prototype 스코프 빈은 소멸 콜백이 호출되지 않습니다
- 초기화 메서드에서 예외 발생 시 빈 생성 실패'
WHERE id = 'b0000000-0000-0000-0001-00000000000B';

UPDATE questions SET explanation = '**@Autowired:**
타입(Type)을 기준으로 의존성을 자동 주입하는 애노테이션입니다.

```java
@Service
public class UserService {
    @Autowired
    private UserRepository userRepository; // UserRepository 타입의 빈 자동 주입
}
```

**문제 상황:**
같은 타입의 빈이 여러 개 있으면 `NoUniqueBeanDefinitionException` 발생

```java
public interface MessageService { }

@Component
public class EmailService implements MessageService { }

@Component
public class SmsService implements MessageService { }

@Autowired
private MessageService messageService; // 어느 것을 주입? 에러!
```

**@Qualifier:**
같은 타입의 빈이 여러 개일 때 빈 이름으로 구분하여 주입합니다.

```java
@Autowired
@Qualifier("emailService")
private MessageService messageService; // EmailService 주입

// 또는 생성자 주입
@Autowired
public UserService(@Qualifier("smsService") MessageService messageService) {
    this.messageService = messageService;
}
```

**대안:**

1. **@Primary**: 기본 빈 지정
```java
@Component
@Primary
public class EmailService implements MessageService { }

@Autowired
private MessageService messageService; // EmailService 주입 (Primary)
```

2. **빈 이름으로 주입**: 필드명을 빈 이름과 일치
```java
@Autowired
private MessageService emailService; // 이름으로 매칭
```

3. **List로 모두 주입**:
```java
@Autowired
private List<MessageService> messageServices; // 모든 구현체 주입
```

**Best Practice:** 가능하면 타입 충돌이 없도록 설계, 불가피하면 @Primary 사용'
WHERE id = 'b0000000-0000-0000-0001-00000000000C';

UPDATE questions SET explanation = '**XML 기반 설정:**

```xml
<!-- applicationContext.xml -->
<beans>
    <bean id="userService" class="com.example.UserService">
        <property name="userRepository" ref="userRepository"/>
    </bean>

    <bean id="userRepository" class="com.example.UserRepository"/>

    <context:component-scan base-package="com.example"/>
</beans>
```

**특징:**
- 외부 설정 파일로 분리
- 코드 재컴파일 불필요
- 타입 안정성 낮음 (문자열로 지정)
- 가독성 떨어짐
- 레거시 프로젝트에서 사용

**자바 기반 설정 (Java Configuration):**

```java
@Configuration
public class AppConfig {

    @Bean
    public UserService userService() {
        return new UserService(userRepository());
    }

    @Bean
    public UserRepository userRepository() {
        return new UserRepository();
    }
}
```

**특징:**
- 타입 안정성 (컴파일 타임 체크)
- IDE 자동 완성 지원
- 리팩토링 용이
- 디버깅 쉬움
- Spring Boot 기본 방식

**비교:**

| 항목 | XML | Java Config |
|------|-----|-------------|
| 타입 안정성 | 낮음 | 높음 |
| IDE 지원 | 제한적 | 완벽 |
| 가독성 | 낮음 | 높음 |
| 재컴파일 | 불필요 | 필요 |
| 현대적 | 레거시 | 권장 |

**Spring Boot 방식:** Java Config + 애노테이션 기반 설정 (@Component, @Service 등)'
WHERE id = 'b0000000-0000-0000-0001-00000000000D';

UPDATE questions SET explanation = '빈 초기화 방법은 여러 가지가 있으며, 실행 순서가 정해져 있습니다.

**초기화 방법:**

**1. @PostConstruct (권장):**
```java
@Component
public class MyBean {
    @PostConstruct
    public void init() {
        System.out.println("@PostConstruct 실행");
        // 초기화 로직
    }
}
```
- JSR-250 표준 (Java 표준)
- 가장 권장되는 방식

**2. InitializingBean 인터페이스:**
```java
@Component
public class MyBean implements InitializingBean {
    @Override
    public void afterPropertiesSet() throws Exception {
        System.out.println("afterPropertiesSet 실행");
    }
}
```
- 스프링에 종속적
- 비권장 (인터페이스 결합)

**3. @Bean(initMethod):**
```java
@Configuration
public class AppConfig {
    @Bean(initMethod = "initialize")
    public MyBean myBean() {
        return new MyBean();
    }
}

public class MyBean {
    public void initialize() {
        System.out.println("initMethod 실행");
    }
}
```
- 외부 라이브러리 빈 초기화에 유용

**4. 생성자 주입 직후:**
```java
@Component
public class MyBean {
    private final Dependency dependency;

    @Autowired
    public MyBean(Dependency dependency) {
        this.dependency = dependency;
        init(); // 의존성 주입 직후 초기화
    }

    private void init() { }
}
```

**실행 순서:**
```
1. 생성자
2. 의존성 주입
3. @PostConstruct
4. afterPropertiesSet()
5. initMethod
```

**Best Practice:** @PostConstruct 사용 (표준이며 명확함)'
WHERE id = 'b0000000-0000-0000-0001-00000000000E';
