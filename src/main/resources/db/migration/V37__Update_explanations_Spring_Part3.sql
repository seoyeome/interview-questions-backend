-- Spring 면접 질문 답변 추가 (Part 3: 질문 29-42, 마지막)

UPDATE questions SET explanation = 'DI 컨테이너가 빈의 의존성을 해결하는 순서:

**1. 빈 정의 로드:**
- @ComponentScan으로 클래스 스캔
- @Configuration 클래스의 @Bean 메서드 탐색
- XML 설정 파싱
→ BeanDefinition 생성

**2. 빈 생성 순서 결정:**
- 의존성 그래프 분석
- 의존성이 없는 빈부터 생성
- 순환 참조 감지 (생성자 주입 시)

**3. 빈 인스턴스화:**
- 생성자 호출하여 객체 생성
- 생성자 주입 시 이 단계에서 의존성 주입

**4. 의존성 주입:**
- Setter 주입 실행
- 필드 주입 실행 (리플렉션)

**5. BeanPostProcessor.postProcessBeforeInitialization:**
- @Autowired, @Value 등 처리
- 의존성 주입 완료

**6. 초기화:**
- @PostConstruct 메서드 실행
- InitializingBean.afterPropertiesSet() 실행
- initMethod 실행

**7. BeanPostProcessor.postProcessAfterInitialization:**
- AOP 프록시 생성

**8. 빈 사용 가능:**
- 완전히 초기화된 빈을 컨테이너에 등록

**예시:**

```java
@Component
public class UserService {
    private final UserRepository repository; // 의존성
    private EmailService emailService; // 의존성

    // 1. 생성자 호출 (생성자 주입)
    @Autowired
    public UserService(UserRepository repository) {
        this.repository = repository;
        System.out.println("1. 생성자 호출");
    }

    // 2. Setter 주입
    @Autowired
    public void setEmailService(EmailService emailService) {
        this.emailService = emailService;
        System.out.println("2. Setter 주입");
    }

    // 3. 초기화
    @PostConstruct
    public void init() {
        System.out.println("3. @PostConstruct");
    }
}
```

**실행 순서:**
```
1. UserRepository 빈 생성 (의존성 없음)
2. EmailService 빈 생성 (의존성 없음)
3. UserService 생성자 호출 → repository 주입
4. UserService setter 호출 → emailService 주입
5. @PostConstruct 실행
6. UserService 빈 등록 완료
```

**순환 참조 처리:**
- 생성자 주입: 컨테이너 시작 시 예외 (BeanCurrentlyInCreationException)
- Setter/필드 주입: 프록시로 해결 (권장하지 않음)'
WHERE id = 'b0000000-0000-0000-0001-00000000001C';

UPDATE questions SET explanation = 'Spring에서 동일한 이름의 빈이 두 번 정의되면:

**기본 동작:**
- **나중에 정의된 빈이 이전 빈을 덮어씁니다** (Override)
- 경고 로그 출력

**시나리오:**

**1. 같은 이름으로 여러 번 정의:**

```java
@Configuration
public class Config1 {
    @Bean
    public MyBean myBean() {
        return new MyBean("First");
    }
}

@Configuration
public class Config2 {
    @Bean
    public MyBean myBean() {
        return new MyBean("Second"); // 이게 사용됨
    }
}
```

**2. 컴포넌트 스캔 중복:**

```java
@Component("userService")
public class UserServiceImpl implements UserService { }

@Component("userService") // 같은 이름!
public class AnotherUserService implements UserService { }
```

**Spring Boot 2.1+ 동작:**
- 기본적으로 빈 오버라이딩 **비활성화**
- `BeanDefinitionOverrideException` 발생

```properties
# application.properties
spring.main.allow-bean-definition-overriding=true # 허용하려면
```

**해결 방법:**

**1. 빈 이름 변경:**
```java
@Component("userServiceImpl")
public class UserServiceImpl { }

@Component("anotherUserService")
public class AnotherUserService { }
```

**2. @Primary 사용:**
```java
@Component
@Primary
public class UserServiceImpl implements UserService { }

@Component
public class AnotherUserService implements UserService { }

@Autowired
private UserService userService; // UserServiceImpl 주입 (Primary)
```

**3. @Qualifier 사용:**
```java
@Autowired
@Qualifier("userServiceImpl")
private UserService userService;
```

**4. 조건부 등록:**
```java
@Configuration
public class Config {
    @Bean
    @ConditionalOnMissingBean
    public MyBean myBean() {
        return new MyBean(); // 같은 타입 빈이 없을 때만 생성
    }
}
```

**주의사항:**
- 빈 오버라이딩은 예상치 못한 버그의 원인
- 명시적으로 이름을 다르게 하는 것이 Best Practice
- Spring Boot는 기본적으로 오버라이딩 금지로 안전성 향상'
WHERE id = 'b0000000-0000-0000-0001-00000000001D';

UPDATE questions SET explanation = '프로토타입(Prototype) 빈은 요청할 때마다 새로운 인스턴스를 생성하는 빈입니다.

**관리 방식:**

**1. 생성과 의존성 주입:**
- 스프링 컨테이너가 빈 생성
- 의존성 주입 수행
- 초기화 콜백 실행 (@PostConstruct 등)

**2. 빈 반환:**
- 클라이언트에게 빈 반환
- **이후 컨테이너는 관리하지 않음**

**3. 소멸:**
- **스프링이 소멸 콜백을 호출하지 않음** (@PreDestroy 실행 안 됨)
- 클라이언트가 직접 정리 책임

**특징:**

```java
@Scope("prototype")
@Component
public class PrototypeBean {

    @PostConstruct
    public void init() {
        System.out.println("초기화 - 실행됨");
    }

    @PreDestroy
    public void cleanup() {
        System.out.println("소멸 - 실행 안 됨!"); // 호출되지 않음
    }
}

// 사용
@Autowired
private ApplicationContext context;

public void test() {
    PrototypeBean bean1 = context.getBean(PrototypeBean.class);
    PrototypeBean bean2 = context.getBean(PrototypeBean.class);

    System.out.println(bean1 == bean2); // false - 다른 인스턴스
}
```

**주의사항:**

**1. Singleton 빈에 Prototype 주입:**

```java
@Component
public class SingletonBean {
    @Autowired
    private PrototypeBean prototypeBean; // 문제: 한 번만 주입됨!

    public void doSomething() {
        prototypeBean.execute(); // 항상 같은 인스턴스 사용
    }
}
```

**해결 방법:**

**a. ApplicationContext 직접 사용:**
```java
@Component
public class SingletonBean {
    @Autowired
    private ApplicationContext context;

    public void doSomething() {
        PrototypeBean bean = context.getBean(PrototypeBean.class); // 매번 새 인스턴스
        bean.execute();
    }
}
```

**b. ObjectProvider 사용 (권장):**
```java
@Component
public class SingletonBean {
    @Autowired
    private ObjectProvider<PrototypeBean> prototypeBeanProvider;

    public void doSomething() {
        PrototypeBean bean = prototypeBeanProvider.getObject(); // 매번 새 인스턴스
        bean.execute();
    }
}
```

**c. @Lookup 메서드 주입:**
```java
@Component
public abstract class SingletonBean {

    public void doSomething() {
        PrototypeBean bean = getPrototypeBean(); // 매번 새 인스턴스
        bean.execute();
    }

    @Lookup
    protected abstract PrototypeBean getPrototypeBean();
}
```

**d. 프록시 모드:**
```java
@Scope(value = "prototype", proxyMode = ScopedProxyMode.TARGET_CLASS)
@Component
public class PrototypeBean { }
```

**사용 시나리오:**
- 상태를 가지는 객체
- 스레드 안전성이 필요한 경우
- 매번 다른 설정이 필요한 경우

**Best Practice:** 가능하면 무상태로 설계하여 singleton 사용, 불가피하면 ObjectProvider 활용'
WHERE id = 'b0000000-0000-0000-0001-00000000001E';

UPDATE questions SET explanation = 'Spring Boot는 스프링 기반 애플리케이션을 빠르고 쉽게 개발할 수 있도록 하는 프레임워크입니다.

**Spring Boot의 특징:**

1. **자동 구성 (Auto-Configuration)**: 의존성 기반으로 자동 설정
2. **내장 서버**: Tomcat, Jetty 등 내장으로 별도 서버 불필요
3. **스타터 의존성**: 관련 라이브러리를 묶어서 제공
4. **설정 간소화**: XML 설정 불필요, application.properties/yml
5. **프로덕션 준비**: Actuator로 모니터링, 헬스체크 기본 제공
6. **독립 실행 가능**: JAR 파일로 패키징하여 바로 실행

**기존 Spring과의 차이:**

**기존 Spring:**
```xml
<!-- web.xml, applicationContext.xml 등 복잡한 설정 -->
<servlet>
    <servlet-name>dispatcher</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
</servlet>

<bean id="dataSource" class="...">
    <property name="driverClassName" value="com.mysql.jdbc.Driver"/>
    <property name="url" value="jdbc:mysql://localhost:3306/db"/>
</bean>

<!-- 별도 WAS(Tomcat 등)에 WAR 배포 필요 -->
```

**Spring Boot:**
```java
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

```properties
# application.properties
spring.datasource.url=jdbc:mysql://localhost:3306/db
spring.datasource.username=root
```

```bash
# JAR 실행
java -jar myapp.jar
```

**비교:**

| 항목 | Spring | Spring Boot |
|------|--------|-------------|
| 설정 | XML, Java Config | 자동 구성 |
| 의존성 관리 | 수동 | 스타터 |
| 서버 | 외부 WAS 필요 | 내장 서버 |
| 배포 | WAR | JAR (독립 실행) |
| 실행 | WAS에 배포 | java -jar |
| 설정 파일 | 복잡 | 간단 (properties/yml) |
| 개발 속도 | 느림 | 빠름 |

**Spring Boot의 철학:**
- **Convention over Configuration**: 관례를 따르면 설정 최소화
- **Opinionated**: 최선의 방법을 기본값으로 제공
- 필요시 커스터마이징 가능

**실무:** Spring Boot가 표준이 되어 대부분의 신규 프로젝트는 Spring Boot 사용'
WHERE id = 'b0000000-0000-0000-0001-00000000001F';

UPDATE questions SET explanation = 'Spring Boot의 자동 구성(Auto-Configuration)은 클래스패스에 있는 의존성을 분석하여 필요한 빈을 자동으로 설정하는 기능입니다.

**동작 원리:**

**1. @SpringBootApplication:**
```java
@SpringBootApplication
// 내부적으로:
// @SpringBootConfiguration
// @EnableAutoConfiguration  ← 핵심
// @ComponentScan
public class Application { }
```

**2. @EnableAutoConfiguration:**
- `spring.factories` 파일에서 자동 구성 클래스 로드
- 조건에 맞는 설정만 활성화

**3. 조건부 구성 (@Conditional):**

```java
@Configuration
@ConditionalOnClass(DataSource.class) // DataSource 클래스가 있으면
@ConditionalOnMissingBean(DataSource.class) // DataSource 빈이 없으면
public class DataSourceAutoConfiguration {

    @Bean
    public DataSource dataSource() {
        // 자동으로 DataSource 빈 생성
    }
}
```

**주요 조건 애노테이션:**

- `@ConditionalOnClass`: 특정 클래스가 클래스패스에 있으면
- `@ConditionalOnMissingBean`: 특정 타입의 빈이 없으면
- `@ConditionalOnProperty`: 특정 프로퍼티가 있으면
- `@ConditionalOnWebApplication`: 웹 애플리케이션이면
- `@ConditionalOnMissingClass`: 특정 클래스가 없으면

**예시:**

**의존성 추가:**
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
```

**자동 구성되는 것들:**
- JPA EntityManagerFactory
- TransactionManager
- DataSource (application.properties 설정 기반)
- HibernateJpaAutoConfiguration

**커스터마이징:**

**1. Properties로 설정:**
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/mydb
spring.jpa.hibernate.ddl-auto=update
```

**2. 직접 빈 정의 (우선순위 높음):**
```java
@Configuration
public class CustomConfig {
    @Bean
    public DataSource dataSource() {
        // 커스텀 DataSource - 자동 구성 무시됨
    }
}
```

**3. 자동 구성 제외:**
```java
@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class})
public class Application { }
```

**자동 구성 확인:**
```bash
# 디버그 모드로 실행
java -jar app.jar --debug

# 또는
logging.level.org.springframework.boot.autoconfigure=DEBUG
```

**장점:**
- 빠른 개발 시작
- 보일러플레이트 코드 제거
- Best Practice 기본 적용

**주의:**
- 자동 구성이 무엇을 하는지 이해 필요
- 필요시 명시적 설정으로 오버라이드'
WHERE id = 'b0000000-0000-0000-0001-000000000020';

UPDATE questions SET explanation = 'Spring Boot에서 내장 톰캣(Embedded Tomcat)을 사용하는 이점:

**1. 간편한 배포:**
- **외부 WAS 불필요**: 별도로 Tomcat 설치할 필요 없음
- **독립 실행 가능**: JAR 파일 하나로 애플리케이션 실행
```bash
java -jar myapp.jar
# WAS 설정 없이 바로 실행
```

**2. 버전 관리 용이:**
- 애플리케이션과 서버 버전을 함께 관리
- 프로젝트마다 다른 Tomcat 버전 사용 가능
- pom.xml/build.gradle에서 버전 명시

**3. 개발 생산성 향상:**
- IDE에서 바로 실행 가능 (main 메서드)
- WAR 패키징/배포 과정 생략
- 빠른 재시작

**4. 클라우드/컨테이너 친화적:**
- Docker 이미지로 쉽게 패키징
```dockerfile
FROM openjdk:17
COPY myapp.jar /app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
```
- 마이크로서비스 아키텍처에 적합

**5. 환경 일관성:**
- 개발/테스트/운영 환경에서 같은 서버 사용
- "내 로컬에서는 되는데?" 문제 감소

**6. 설정 간소화:**
```properties
# application.properties
server.port=8080
server.tomcat.max-threads=200
server.tomcat.connection-timeout=20000
```

**기존 방식 (외부 WAS):**
```
1. Tomcat 다운로드 및 설치
2. server.xml 등 복잡한 설정
3. WAR 파일 패키징
4. Tomcat webapps에 배포
5. Tomcat 재시작
```

**Spring Boot 방식:**
```
1. spring-boot-starter-web 의존성 추가 (자동으로 내장 Tomcat 포함)
2. java -jar myapp.jar
```

**내장 서버 변경 가능:**

```xml
<!-- Jetty로 변경 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <exclusions>
        <exclusion>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-tomcat</artifactId>
        </exclusion>
    </exclusions>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-jetty</artifactId>
</dependency>
```

**단점:**
- 매우 큰 애플리케이션에서는 외부 WAS가 더 적합할 수 있음
- WAS 레벨의 세밀한 튜닝이 제한적

**결론:** 대부분의 경우 내장 서버가 더 편리하고 현대적인 방식'
WHERE id = 'b0000000-0000-0000-0001-000000000021';

UPDATE questions SET explanation = '스타터 의존성(Starter Dependency)은 관련된 라이브러리들을 하나로 묶은 의존성 세트입니다.

**역할:**

1. **의존성 관리 간소화**: 여러 라이브러리를 개별적으로 추가할 필요 없음
2. **버전 호환성 보장**: 테스트된 라이브러리 조합 제공
3. **자동 구성 트리거**: 스타터 추가만으로 자동 구성 활성화

**예시:**

**spring-boot-starter-web:**
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

**내부적으로 포함하는 것:**
- spring-web
- spring-webmvc
- spring-boot-starter-tomcat (내장 톰캣)
- spring-boot-starter-json (Jackson)
- hibernate-validator

**spring-boot-starter-data-jpa:**
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
```

**내부적으로 포함:**
- spring-data-jpa
- hibernate-core
- spring-orm
- spring-tx

**주요 스타터:**

| 스타터 | 용도 |
|--------|------|
| spring-boot-starter-web | 웹 애플리케이션 (MVC, REST) |
| spring-boot-starter-data-jpa | JPA, Hibernate |
| spring-boot-starter-security | Spring Security |
| spring-boot-starter-test | 테스트 (JUnit, Mockito 등) |
| spring-boot-starter-thymeleaf | Thymeleaf 템플릿 엔진 |
| spring-boot-starter-validation | Bean Validation |
| spring-boot-starter-webflux | Reactive 웹 애플리케이션 |
| spring-boot-starter-actuator | 모니터링, 헬스체크 |

**스타터 없이 (기존 방식):**
```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
    <version>5.3.23</version>
</dependency>
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-web</artifactId>
    <version>5.3.23</version>
</dependency>
<dependency>
    <groupId>org.apache.tomcat.embed</groupId>
    <artifactId>tomcat-embed-core</artifactId>
    <version>9.0.65</version>
</dependency>
<!-- ... 수십 개 더 -->
```

**스타터 사용:**
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <!-- 버전은 parent에서 관리 -->
</dependency>
```

**커스텀 스타터 생성:**
```java
// 자체 라이브러리를 스타터로 만들 수 있음
my-custom-spring-boot-starter
├── my-custom-spring-boot-autoconfigure (자동 구성)
└── my-custom-spring-boot-starter (의존성 묶음)
```

**장점:**
- 빠른 시작
- 의존성 충돌 최소화
- 검증된 라이브러리 조합
- 자동 구성과 연계'
WHERE id = 'b0000000-0000-0000-0001-000000000022';

UPDATE questions SET explanation = 'Spring MVC와 Spring WebFlux는 각각 서블릿 기반과 리액티브 기반의 웹 프레임워크입니다.

**Spring MVC (전통적 방식):**

**특징:**
- **서블릿 API 기반** (Servlet Container 필요)
- **동기/블로킹 I/O**: 요청당 스레드 할당
- **Thread-per-Request 모델**: 각 요청마다 스레드 사용
- 스레드가 블로킹되면 대기 (DB 쿼리, HTTP 호출 등)

```java
@RestController
public class UserController {
    @GetMapping("/users/{id}")
    public User getUser(@PathVariable Long id) {
        return userService.findById(id); // 블로킹, 결과 올 때까지 대기
    }
}
```

**Spring WebFlux (리액티브 방식):**

**특징:**
- **Reactive Streams 기반** (Non-blocking)
- **비동기/논블로킹 I/O**: 적은 스레드로 많은 요청 처리
- **Event Loop 모델**: 스레드가 블로킹되지 않고 이벤트 처리
- Netty, Undertow 등 Non-blocking 서버 사용

```java
@RestController
public class UserController {
    @GetMapping("/users/{id}")
    public Mono<User> getUser(@PathVariable Long id) {
        return userService.findById(id); // 논블로킹, 즉시 반환
    }

    @GetMapping("/users")
    public Flux<User> getUsers() {
        return userService.findAll(); // 스트림으로 반환
    }
}
```

**비교:**

| 항목 | Spring MVC | Spring WebFlux |
|------|-----------|----------------|
| 프로그래밍 모델 | 동기/블로킹 | 비동기/논블로킹 |
| 서버 | Tomcat, Jetty | Netty, Undertow |
| 반환 타입 | Object, List | Mono, Flux |
| 동시성 | 스레드 기반 | 이벤트 루프 |
| 적합한 경우 | 일반 CRUD, 블로킹 I/O | 고성능, 많은 동시 요청 |
| 학습 곡선 | 낮음 | 높음 (리액티브 개념) |

**Reactive Types:**

```java
// Mono: 0~1개 요소
Mono<User> user = userService.findById(1L);

// Flux: 0~N개 요소 (스트림)
Flux<User> users = userService.findAll();

// 체이닝
userService.findById(1L)
    .map(user -> user.getName())
    .flatMap(name -> emailService.sendEmail(name))
    .subscribe(result -> System.out.println("완료"));
```

**언제 Spring WebFlux를 사용할까?**

**사용 권장:**
- 많은 동시 요청 처리 (수천~수만 건)
- I/O 작업이 많은 경우 (외부 API 호출, 스트리밍)
- 실시간 데이터 처리
- 마이크로서비스 간 비동기 통신

**사용 비권장:**
- 일반 CRUD 애플리케이션
- 블로킹 라이브러리 사용 (JDBC 등)
- 팀의 리액티브 경험 부족

**실무 조언:**
- 대부분의 경우 Spring MVC로 충분
- 성능 문제가 확실할 때만 WebFlux 도입
- 블로킹 코드가 섞이면 WebFlux 장점 사라짐'
WHERE id = 'b0000000-0000-0000-0001-000000000023';

UPDATE questions SET explanation = 'Reactive Programming은 비동기 데이터 스트림을 선언적으로 처리하는 프로그래밍 패러다임입니다.

**핵심 개념:**

1. **비동기 (Asynchronous)**: 블로킹 없이 작업 수행
2. **논블로킹 (Non-blocking)**: 스레드가 대기하지 않음
3. **데이터 스트림**: 시간에 따라 발생하는 이벤트 시퀀스
4. **백프레셔 (Backpressure)**: 생산자와 소비자 속도 조절

**Spring WebFlux 지원:**

**1. Reactive Types:**

**Mono (0~1개 요소):**
```java
Mono<User> user = Mono.just(new User("John"));
Mono<User> empty = Mono.empty();
Mono<User> error = Mono.error(new RuntimeException("Error"));
```

**Flux (0~N개 요소):**
```java
Flux<Integer> numbers = Flux.just(1, 2, 3, 4, 5);
Flux<String> names = Flux.fromIterable(Arrays.asList("A", "B", "C"));
Flux<Long> interval = Flux.interval(Duration.ofSeconds(1));
```

**2. Operators (연산자):**

```java
// map: 변환
Flux.just(1, 2, 3)
    .map(i -> i * 2)
    .subscribe(System.out::println); // 2, 4, 6

// filter: 필터링
Flux.just(1, 2, 3, 4, 5)
    .filter(i -> i % 2 == 0)
    .subscribe(System.out::println); // 2, 4

// flatMap: 비동기 변환
Flux.just("user1", "user2")
    .flatMap(id -> userService.findById(id)) // 각각 비동기 호출
    .subscribe(user -> System.out.println(user));

// zip: 결합
Mono<User> user = userService.findById(1L);
Mono<Order> order = orderService.findById(1L);
Mono.zip(user, order)
    .map(tuple -> new UserOrder(tuple.getT1(), tuple.getT2()))
    .subscribe();
```

**3. WebFlux Controller:**

```java
@RestController
@RequestMapping("/api/users")
public class UserController {

    @GetMapping("/{id}")
    public Mono<User> getUser(@PathVariable Long id) {
        return userService.findById(id);
    }

    @GetMapping
    public Flux<User> getUsers() {
        return userService.findAll();
    }

    @PostMapping
    public Mono<User> createUser(@RequestBody User user) {
        return userService.save(user);
    }

    @GetMapping(value = "/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<User> streamUsers() {
        return userService.findAll()
            .delayElements(Duration.ofSeconds(1)); // 1초마다 전송
    }
}
```

**4. Reactive Repository (R2DBC):**

```java
public interface UserRepository extends ReactiveCrudRepository<User, Long> {
    Flux<User> findByName(String name);

    @Query("SELECT * FROM users WHERE age > :age")
    Flux<User> findOlderThan(int age);
}

// 사용
userRepository.findAll()
    .filter(user -> user.getAge() > 18)
    .map(User::getName)
    .subscribe(System.out::println);
```

**5. WebClient (Reactive HTTP Client):**

```java
WebClient client = WebClient.create("https://api.example.com");

// GET 요청
Mono<User> user = client.get()
    .uri("/users/{id}", 1)
    .retrieve()
    .bodyToMono(User.class);

// POST 요청
Mono<User> created = client.post()
    .uri("/users")
    .bodyValue(new User("John"))
    .retrieve()
    .bodyToMono(User.class);
```

**6. 에러 처리:**

```java
userService.findById(1L)
    .onErrorReturn(new User("Default")) // 에러 시 기본값
    .onErrorResume(e -> Mono.just(new User("Fallback"))) // 에러 시 다른 Mono
    .doOnError(e -> log.error("Error", e)) // 에러 로깅
    .subscribe();
```

**장점:**
- 높은 처리량 (Throughput)
- 적은 리소스로 많은 동시 요청 처리
- 백프레셔로 과부하 방지

**단점:**
- 학습 곡선 높음
- 디버깅 어려움
- 블로킹 코드와 혼용 시 성능 저하

**실무:**
- 블로킹 라이브러리(JDBC 등) 대신 리액티브 라이브러리(R2DBC 등) 사용 필수
- 전체 스택이 리액티브여야 효과적'
WHERE id = 'b0000000-0000-0000-0001-000000000024';

UPDATE questions SET explanation = 'Filter와 Interceptor는 모두 요청/응답을 가로채서 처리하지만, 동작 시점과 용도가 다릅니다.

**Filter (서블릿 필터):**

**특징:**
- **서블릿 스펙**의 일부 (Java EE)
- **DispatcherServlet 전/후**에 동작
- 스프링 컨텍스트 외부에서 동작
- web.xml 또는 @WebFilter로 등록

**동작 시점:**
```
Client → Filter → DispatcherServlet → Interceptor → Controller
```

**구현:**
```java
@Component
public class LoggingFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;

        System.out.println("Before Filter: " + req.getRequestURI());

        chain.doFilter(request, response); // 다음 필터 또는 서블릿으로

        System.out.println("After Filter");
    }
}
```

**Interceptor (스프링 인터셉터):**

**특징:**
- **Spring MVC** 기능
- **DispatcherServlet과 Controller 사이**에서 동작
- 스프링 컨텍스트 내부에서 동작
- 스프링 빈 주입 가능

**동작 시점:**
```
DispatcherServlet → preHandle → Controller → postHandle → afterCompletion
```

**구현:**
```java
@Component
public class AuthInterceptor implements HandlerInterceptor {

    @Autowired
    private AuthService authService; // 빈 주입 가능

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        System.out.println("preHandle: " + request.getRequestURI());

        String token = request.getHeader("Authorization");
        if (!authService.isValid(token)) {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            return false; // Controller로 가지 않음
        }

        return true; // Controller로 진행
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response,
                          Object handler, ModelAndView modelAndView) {
        System.out.println("postHandle");
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
                               Object handler, Exception ex) {
        System.out.println("afterCompletion");
    }
}

// 등록
@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Autowired
    private AuthInterceptor authInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(authInterceptor)
                .addPathPatterns("/api/**")
                .excludePathPatterns("/api/public/**");
    }
}
```

**비교:**

| 항목 | Filter | Interceptor |
|------|--------|-------------|
| 스펙 | Java EE (서블릿) | Spring MVC |
| 동작 위치 | DispatcherServlet 전/후 | Controller 전/후 |
| 스프링 빈 주입 | 제한적 | 가능 |
| URL 패턴 | 서블릿 패턴 | Spring Path 패턴 |
| 용도 | 인코딩, 보안, 로깅 | 인증, 권한, 로깅 |
| 예외 처리 | 제한적 | @ExceptionHandler 가능 |

**전체 흐름:**
```
Client
  ↓
Filter (인코딩)
  ↓
Filter (보안)
  ↓
DispatcherServlet
  ↓
Interceptor.preHandle (인증)
  ↓
Controller
  ↓
Interceptor.postHandle
  ↓
View 렌더링
  ↓
Interceptor.afterCompletion
  ↓
Filter
  ↓
Client
```

**선택 기준:**
- **Filter**: 서블릿 레벨 처리 (인코딩, CORS, 압축 등)
- **Interceptor**: 스프링 MVC 레벨 처리 (인증, 로깅, 트랜잭션 등)

**실무:** 인증/권한은 Interceptor 또는 Spring Security 사용'
WHERE id = 'b0000000-0000-0000-0001-000000000025';

UPDATE questions SET explanation = 'MVC 패턴은 Model-View-Controller의 약자로, 애플리케이션을 세 가지 역할로 분리하는 디자인 패턴입니다.

**MVC 구성 요소:**

**1. Model (모델):**
- **역할**: 비즈니스 로직과 데이터
- **구성**: Service, Repository, Entity, DTO
- 데이터 상태 관리 및 비즈니스 규칙 처리

**2. View (뷰):**
- **역할**: 사용자에게 보여지는 화면
- **구성**: JSP, Thymeleaf, React, HTML
- 모델 데이터를 시각적으로 표현

**3. Controller (컨트롤러):**
- **역할**: 사용자 요청을 받아 모델과 뷰를 연결
- **구성**: @Controller, @RestController
- 요청 처리, 모델 호출, 뷰 선택

**Spring MVC 흐름:**

```
1. Client → HTTP 요청
2. DispatcherServlet → 요청 접수
3. HandlerMapping → 적절한 Controller 찾기
4. Controller → 비즈니스 로직 처리 (Model 호출)
5. Service → 비즈니스 로직 수행
6. Repository → DB 접근
7. Controller → Model에 데이터 저장, View 이름 반환
8. ViewResolver → View 이름 → 실제 View 객체
9. View → 렌더링 (Model 데이터 사용)
10. DispatcherServlet → Client에게 응답
```

**코드 예시:**

**Model (Entity):**
```java
@Entity
public class User {
    @Id
    private Long id;
    private String name;
    private String email;
}
```

**Model (Service):**
```java
@Service
public class UserService {
    @Autowired
    private UserRepository repository;

    public User findById(Long id) {
        return repository.findById(id)
            .orElseThrow(() -> new UserNotFoundException(id));
    }

    public List<User> findAll() {
        return repository.findAll();
    }
}
```

**Controller:**
```java
@Controller
@RequestMapping("/users")
public class UserController {

    @Autowired
    private UserService userService; // Model

    @GetMapping("/{id}")
    public String getUser(@PathVariable Long id, Model model) {
        User user = userService.findById(id); // Model 호출
        model.addAttribute("user", user); // View에 데이터 전달
        return "user/detail"; // View 이름 반환
    }

    @GetMapping
    public String getUsers(Model model) {
        List<User> users = userService.findAll();
        model.addAttribute("users", users);
        return "user/list";
    }
}
```

**View (Thymeleaf):**
```html
<!-- user/detail.html -->
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title>User Detail</title>
</head>
<body>
    <h1 th:text="${user.name}">User Name</h1>
    <p th:text="${user.email}">Email</p>
</body>
</html>
```

**REST API (뷰 없이 JSON 반환):**
```java
@RestController
@RequestMapping("/api/users")
public class UserApiController {

    @Autowired
    private UserService userService;

    @GetMapping("/{id}")
    public User getUser(@PathVariable Long id) {
        return userService.findById(id); // JSON 자동 변환
    }
}
```

**MVC 장점:**
- **관심사 분리**: 각 계층이 독립적
- **유지보수 용이**: 변경 영향 최소화
- **테스트 용이**: 각 계층 독립 테스트
- **재사용성**: 같은 Model을 여러 View에서 사용

**실무:**
- 전통적 웹: Controller → Model → View (JSP, Thymeleaf)
- 모던 웹: @RestController → Model → JSON (React, Vue가 View)'
WHERE id = 'b0000000-0000-0000-0001-000000000026';

UPDATE questions SET explanation = 'ViewResolver는 컨트롤러가 반환한 **논리적 뷰 이름**을 **실제 View 객체**로 변환하는 역할을 합니다.

**동작:**

```java
@Controller
public class UserController {
    @GetMapping("/users")
    public String list() {
        return "user/list"; // 논리적 뷰 이름
    }
}
```

**ViewResolver가 하는 일:**
```
"user/list" → /WEB-INF/views/user/list.jsp (실제 파일 경로)
```

**주요 ViewResolver:**

**1. InternalResourceViewResolver (JSP):**
```java
@Configuration
public class WebConfig {
    @Bean
    public ViewResolver viewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/views/");
        resolver.setSuffix(".jsp");
        return resolver;
    }
}
```
```properties
# application.properties
spring.mvc.view.prefix=/WEB-INF/views/
spring.mvc.view.suffix=.jsp
```

**2. ThymeleafViewResolver (Thymeleaf):**
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-thymeleaf</artifactId>
</dependency>
```
```properties
spring.thymeleaf.prefix=classpath:/templates/
spring.thymeleaf.suffix=.html
```

**3. BeanNameViewResolver:**
- 뷰 이름과 같은 이름의 빈을 찾음
```java
@Bean("myView")
public View myView() {
    return new CustomView();
}

@GetMapping("/custom")
public String custom() {
    return "myView"; // BeanNameViewResolver가 처리
}
```

**4. ContentNegotiatingViewResolver:**
- 요청의 Accept 헤더에 따라 적절한 뷰 선택
- JSON, XML 등 다양한 형식 지원

**우선순위:**
ViewResolver가 여러 개일 때 우선순위에 따라 처리
```java
resolver.setOrder(1); // 낮을수록 우선
```

**Spring Boot 자동 구성:**
```
- JSP: InternalResourceViewResolver
- Thymeleaf: ThymeleafViewResolver
- FreeMarker: FreeMarkerViewResolver
```

**ViewResolver 체인:**
```
1. BeanNameViewResolver (Order: 0)
2. ThymeleafViewResolver (Order: 1)
3. InternalResourceViewResolver (Order: Integer.MAX_VALUE)
```

**예시:**
```java
@Controller
public class UserController {

    @GetMapping("/users")
    public String list(Model model) {
        model.addAttribute("users", userService.findAll());
        return "user/list"; // → /templates/user/list.html (Thymeleaf)
    }

    @GetMapping("/redirect")
    public String redirect() {
        return "redirect:/users"; // 특수 prefix: 리다이렉트
    }

    @GetMapping("/forward")
    public String forward() {
        return "forward:/users"; // 특수 prefix: 포워드
    }
}
```

**@RestController는 ViewResolver 사용 안 함:**
```java
@RestController
public class UserApiController {
    @GetMapping("/api/users")
    public List<User> getUsers() {
        return userService.findAll(); // JSON 직접 반환
    }
}
```'
WHERE id = 'b0000000-0000-0000-0001-000000000027';

UPDATE questions SET explanation = '@Controller와 @RestController의 차이:

**@Controller:**
- **전통적인 MVC** 컨트롤러
- **View 반환**: 뷰 이름(String)을 반환하여 HTML 렌더링
- @ResponseBody 없으면 ViewResolver가 뷰 찾음

```java
@Controller
@RequestMapping("/users")
public class UserController {

    @GetMapping("/{id}")
    public String getUser(@PathVariable Long id, Model model) {
        User user = userService.findById(id);
        model.addAttribute("user", user);
        return "user/detail"; // View 이름 → user/detail.html
    }

    @GetMapping("/api/{id}")
    @ResponseBody // JSON 반환하려면 명시 필요
    public User getUserApi(@PathVariable Long id) {
        return userService.findById(id); // JSON으로 변환
    }
}
```

**@RestController:**
- **RESTful API** 전용 컨트롤러
- `@Controller + @ResponseBody` 조합
- 모든 메서드가 **데이터(JSON/XML)** 반환
- View를 사용하지 않음

```java
@RestController
@RequestMapping("/api/users")
public class UserApiController {

    @GetMapping("/{id}")
    public User getUser(@PathVariable Long id) {
        return userService.findById(id); // 자동으로 JSON 변환
    }

    @GetMapping
    public List<User> getUsers() {
        return userService.findAll();
    }

    @PostMapping
    public User createUser(@RequestBody User user) {
        return userService.save(user);
    }

    @GetMapping("/response-entity/{id}")
    public ResponseEntity<User> getUserWithStatus(@PathVariable Long id) {
        return ResponseEntity.ok(userService.findById(id));
    }
}
```

**비교:**

| 항목 | @Controller | @RestController |
|------|-------------|-----------------|
| 반환 | View 이름 (String) | 데이터 (Object) |
| 용도 | HTML 페이지 | JSON/XML API |
| @ResponseBody | 메서드마다 필요 | 자동 적용 |
| ViewResolver | 사용 | 사용 안 함 |
| MessageConverter | @ResponseBody 시 사용 | 자동 사용 |

**내부 정의:**

```java
// @RestController
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Controller
@ResponseBody
public @interface RestController { }
```

**실무 사용:**

**@Controller:**
- 서버 사이드 렌더링 (SSR)
- Thymeleaf, JSP 등으로 HTML 반환
- 전통적인 웹 애플리케이션

**@RestController:**
- RESTful API 서버
- SPA(React, Vue, Angular)의 백엔드
- 모바일 앱 API
- 마이크로서비스

**혼용:**
```java
@Controller
@RequestMapping("/users")
public class UserController {

    // HTML 페이지 반환
    @GetMapping
    public String list(Model model) {
        model.addAttribute("users", userService.findAll());
        return "user/list"; // View
    }

    // JSON 데이터 반환
    @GetMapping("/api")
    @ResponseBody
    public List<User> listApi() {
        return userService.findAll(); // JSON
    }
}
```

**현대적 방식:**
- 프론트엔드(React 등)와 백엔드 분리
- 백엔드는 @RestController로 API만 제공
- 프론트엔드가 렌더링 담당'
WHERE id = 'b0000000-0000-0000-0001-000000000028';

UPDATE questions SET explanation = 'Spring Bean이 유효하지 않게 되는(예외 발생) 상황:

**1. NoSuchBeanDefinitionException:**
- 요청한 빈이 컨테이너에 등록되지 않았을 때

```java
// 등록 안 된 빈 요청
@Autowired
private NonExistentService service; // 에러!

// 해결: @Component, @Service 등으로 빈 등록
```

**2. NoUniqueBeanDefinitionException:**
- 같은 타입의 빈이 여러 개일 때 (앞에서 설명함)

**3. BeanCreationException:**
- 빈 생성 중 예외 발생

**원인:**
```java
@Component
public class MyBean {
    @PostConstruct
    public void init() {
        throw new RuntimeException("초기화 실패"); // 빈 생성 실패
    }
}

@Component
public class MyBean {
    @Autowired
    private NonExistentBean dependency; // 의존성 없음 → 생성 실패
}
```

**4. BeanCurrentlyInCreationException:**
- 순환 참조 (생성자 주입 시)

```java
@Component
public class A {
    @Autowired
    public A(B b) { } // B가 필요
}

@Component
public class B {
    @Autowired
    public B(A a) { } // A가 필요 → 순환!
}
```

**해결:** Setter 주입 또는 @Lazy 사용
```java
@Component
public class A {
    @Autowired
    public A(@Lazy B b) { }
}
```

**5. UnsatisfiedDependencyException:**
- 의존성 주입 실패

```java
@Component
public class UserService {
    @Autowired
    private UserRepository repository; // repository 빈이 없으면 실패
}
```

**6. BeanInstantiationException:**
- 빈 인스턴스화 실패 (생성자 예외 등)

```java
@Component
public class MyBean {
    public MyBean() {
        throw new IllegalStateException("생성 불가");
    }
}
```

**7. BeanNotOfRequiredTypeException:**
- 요청한 타입과 실제 빈 타입 불일치

```java
@Bean
public Object myBean() {
    return "String"; // Object 타입
}

@Autowired
private Integer myBean; // Integer 요청 → 타입 불일치!
```

**8. 조건부 빈이 조건 미충족:**

```java
@Bean
@ConditionalOnProperty(name = "feature.enabled", havingValue = "true")
public MyBean myBean() {
    return new MyBean();
}

// application.properties에 feature.enabled=false → 빈 없음
```

**9. 프로필 미스매치:**

```java
@Component
@Profile("prod")
public class ProdBean { }

// dev 프로필로 실행 시 ProdBean 없음
```

**10. 스코프 관련 문제:**

```java
@Scope("request")
@Component
public class RequestBean { }

// 웹 요청이 아닌 컨텍스트에서 접근 시 에러
```

**디버깅 팁:**

1. **로그 확인:**
```properties
logging.level.org.springframework=DEBUG
```

2. **빈 목록 출력:**
```java
@Autowired
private ApplicationContext context;

public void printBeans() {
    Arrays.stream(context.getBeanDefinitionNames())
        .forEach(System.out::println);
}
```

3. **@PostConstruct에서 의존성 확인:**
```java
@PostConstruct
public void init() {
    Objects.requireNonNull(dependency, "Dependency must not be null");
}
```

**Best Practice:**
- 생성자 주입 사용 (순환 참조 조기 발견)
- 조건부 주입 시 @ConditionalOnBean 활용
- 명확한 빈 이름 사용'
WHERE id = 'b0000000-0000-0000-0001-000000000029';

UPDATE questions SET explanation = 'Spring 애플리케이션의 메모리 누수나 성능 문제를 튜닝하는 접근 방법:

**1. 문제 증상 파악:**
- OutOfMemoryError 발생
- 응답 시간 증가
- CPU 사용률 높음
- GC 빈번 발생

**2. 프로파일링 및 모니터링:**

**도구 사용:**
```bash
# VisualVM으로 힙 덤프 분석
jvisualvm

# JProfiler로 메모리 프로파일링

# Spring Boot Actuator
management.endpoints.web.exposure.include=*
management.endpoint.metrics.enabled=true
```

**메트릭 확인:**
```java
@Autowired
private MeterRegistry meterRegistry;

@GetMapping("/metrics")
public Map<String, Object> metrics() {
    return Map.of(
        "jvm.memory.used", meterRegistry.get("jvm.memory.used").gauge().value(),
        "http.server.requests", meterRegistry.get("http.server.requests").timer().count()
    );
}
```

**3. 일반적인 문제와 해결:**

**메모리 누수:**

**a. Session 속성 미정리:**
```java
// 나쁜 예
@SessionAttributes("largeObject")
public class UserController { }

// 해결: 세션 타임아웃 설정
server.servlet.session.timeout=30m
```

**b. ThreadLocal 미정리:**
```java
// 나쁜 예
private static ThreadLocal<User> currentUser = new ThreadLocal<>();

// 해결
@PreDestroy
public void cleanup() {
    currentUser.remove();
}
```

**c. 리스너/콜백 미제거:**
```java
// 나쁜 예
eventPublisher.addListener(listener);

// 해결
@PreDestroy
public void cleanup() {
    eventPublisher.removeListener(listener);
}
```

**성능 문제:**

**a. N+1 쿼리 문제:**
```java
// 나쁜 예
List<User> users = userRepository.findAll();
users.forEach(user -> user.getOrders().size()); // N번 쿼리

// 해결: Fetch Join
@Query("SELECT u FROM User u JOIN FETCH u.orders")
List<User> findAllWithOrders();
```

**b. 트랜잭션 범위 과다:**
```java
// 나쁜 예
@Transactional
public void processLargeData() {
    // 오래 걸리는 작업 → DB 커넥션 오래 점유
}

// 해결: 트랜잭션 범위 최소화
public void processLargeData() {
    List<Data> data = fetchData();
    processData(data); // 트랜잭션 외부

    saveResults(data); // 필요한 부분만 트랜잭션
}

@Transactional
public void saveResults(List<Data> data) {
    repository.saveAll(data);
}
```

**c. 커넥션 풀 설정:**
```properties
spring.datasource.hikari.maximum-pool-size=20
spring.datasource.hikari.minimum-idle=5
spring.datasource.hikari.connection-timeout=30000
spring.datasource.hikari.idle-timeout=600000
```

**4. JVM 튜닝:**

```bash
# 힙 크기 조정
java -Xms2g -Xmx4g -jar app.jar

# GC 로깅
-Xlog:gc*:file=gc.log

# G1 GC 사용
-XX:+UseG1GC
-XX:MaxGCPauseMillis=200
```

**5. 캐싱 활용:**

```java
@Cacheable("users")
public User findById(Long id) {
    return repository.findById(id).orElse(null);
}

@CacheEvict(value = "users", allEntries = true)
public void clearCache() { }
```

**6. 비동기 처리:**

```java
@Async
public CompletableFuture<String> sendEmail(String to) {
    // 비동기로 처리하여 메인 스레드 블로킹 방지
}
```

**7. 데이터베이스 쿼리 최적화:**

```java
// Projection 사용 (필요한 컬럼만)
public interface UserSummary {
    String getName();
    String getEmail();
}

List<UserSummary> findAllProjectedBy();

// 페이징
Page<User> findAll(Pageable pageable);
```

**8. Spring Boot Actuator 활용:**

```properties
management.endpoints.web.exposure.include=health,metrics,httptrace
management.endpoint.health.show-details=always
```

**체계적 접근:**
```
1. 증상 파악 (로그, 메트릭)
2. 프로파일링 (병목 지점 찾기)
3. 가설 수립 (원인 추정)
4. 수정 적용
5. 측정 (개선 확인)
6. 반복
```'
WHERE id = 'b0000000-0000-0000-0001-00000000002A';
