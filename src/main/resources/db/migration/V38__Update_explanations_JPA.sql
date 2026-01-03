-- JPA/Hibernate 면접 질문 답변 추가 (explanation 컬럼 업데이트)
-- 전제: questions 테이블에 explanation 컬럼(TEXT/VARCHAR)이 존재한다고 가정합니다.

UPDATE questions
SET explanation =
'**개념**
- **JPA(Java Persistence API)**는 자바 ORM(Object-Relational Mapping) 표준(인터페이스/규약)입니다. 즉 “객체를 DB 테이블에 어떻게 매핑하고, CRUD를 어떤 API로 수행할지”에 대한 표준 스펙입니다.
- **Hibernate**는 JPA 스펙을 구현한 대표적인 ORM 프레임워크(구현체)입니다. Spring Data JPA를 쓰더라도 실제 동작은 보통 Hibernate가 수행합니다.

**왜 사용하나(이점)**
1) **객체 중심 개발**: SQL 중심이 아니라 엔티티(객체) 중심으로 도메인 모델을 설계/구현할 수 있습니다.
2) **반복 코드 감소**: JDBC의 커넥션/리소스 정리, 매핑(ResultSet → 객체) 같은 보일러플레이트가 크게 줄어듭니다.
3) **변경 감지(Dirty Checking)**: 트랜잭션 내에서 엔티티 값만 바꾸면, 커밋 시점에 자동으로 UPDATE SQL이 생성/실행됩니다.
4) **1차 캐시/동일성 보장**: 같은 트랜잭션/영속성 컨텍스트 안에서 동일 PK 조회는 같은 객체 인스턴스를 반환해(동일성) 로직이 단순해집니다.
5) **DB 독립성/이식성**: DB Dialect 기반으로 SQL 생성이 가능해 DB 변경 비용을 낮출 수 있습니다(완전한 무관은 아니지만 비용 감소).
6) **연관관계/지연로딩**: 객체 그래프 탐색, 지연 로딩 등으로 성능/설계를 조절할 수 있습니다.

**주의점**
- ORM은 만능이 아니며, N+1, 페치 전략, 배치 사이즈, 쿼리 튜닝 같은 성능 이슈를 이해하고 써야 합니다.'
WHERE id = 'b0000000-0000-0000-0002-000000000001';

UPDATE questions
SET explanation =
'**개념**
- JPA에서 **Entity**는 DB 테이블과 매핑되는 **영속(persistent) 객체**입니다.
- 보통 하나의 엔티티 클래스는 하나의 테이블(또는 뷰)과 매핑되고, 인스턴스는 한 행(row)과 대응됩니다.

**필수 조건/권장 규칙**
1) **@Entity** 선언 및 기본 생성자(보통 protected) 필요
2) **식별자(@Id)** 필수
3) 엔티티는 **상태와 행위를 함께** 갖는 도메인 객체로 설계하는 것이 일반적
4) equals/hashCode는 식별자 전략과 프록시/지연로딩을 고려해 신중히 구현(무분별한 Lombok @EqualsAndHashCode 주의)

**예시**
- User 엔티티 ↔ users 테이블
- userId(PK) ↔ @Id 필드'
WHERE id = 'b0000000-0000-0000-0002-000000000002';

UPDATE questions
SET explanation =
'**개념**
- **EntityManager**는 JPA의 핵심 인터페이스로, 영속성 컨텍스트를 통해 엔티티의 생명주기를 관리하고 DB 작업을 수행합니다.
- 한마디로 “엔티티를 저장/조회/수정/삭제하고, 변경을 감지하며, 쿼리를 실행하는 관리자”입니다.

**주요 역할**
1) **엔티티 생명주기 관리**
   - persist(저장 예약), find(조회), merge(병합), remove(삭제)
2) **영속성 컨텍스트(1차 캐시) 관리**
   - 같은 트랜잭션에서 동일 PK 재조회 시 DB 재조회 없이 캐시 반환
3) **쓰기 지연(Write-Behind)**
   - 트랜잭션 커밋/flush 시점에 INSERT/UPDATE/DELETE SQL을 모아서 실행
4) **플러시(Flush)**
   - 변경사항을 DB에 반영(트랜잭션 커밋 전이라도 flush 발생 가능)
5) **JPQL/Native Query 실행**
   - createQuery(JPQL), createNativeQuery(SQL)

**Spring에서의 관점**
- 보통 @Transactional 경계 안에서 스프링이 EntityManager를 트랜잭션 스코프로 관리(프록시/Thread-bound)합니다.'
WHERE id = 'b0000000-0000-0000-0002-000000000003';

UPDATE questions
SET explanation =
'**의미**
- `@Entity`는 해당 클래스가 JPA가 관리하는 **엔티티(영속 객체)**임을 선언합니다.
- 즉, 이 클래스의 인스턴스는 영속성 컨텍스트에 의해 관리될 수 있고, DB 테이블과 매핑되어 CRUD 대상이 됩니다.

**주요 포인트**
1) 반드시 **@Id**가 있는 식별자 필드가 필요합니다.
2) 기본 생성자(파라미터 없는 생성자)가 필요합니다(보통 protected).
3) 엔티티 이름은 기본적으로 클래스명, 필요 시 `@Entity(name = "...")`로 JPQL에서 사용할 엔티티 이름 지정 가능

**예시**
```java
@Entity
@Table(name = "users")
public class User {
  @Id @GeneratedValue
  private Long id;
}
```'
WHERE id = 'b0000000-0000-0000-0002-000000000004';

UPDATE questions
SET explanation =
'**개념**
- **영속성 컨텍스트(Persistence Context)**는 “엔티티를 영구 저장하는 환경”으로, JPA가 엔티티를 관리하는 **1차 캐시/관리 공간**입니다.
- 애플리케이션 코드 관점에서는 EntityManager가 들고 있는 엔티티 관리 저장소라고 보면 됩니다.

**핵심 기능**
1) **1차 캐시**
   - PK 기준으로 엔티티를 캐싱해 DB 조회를 줄입니다.
2) **동일성 보장**
   - 같은 영속성 컨텍스트에서 같은 PK를 조회하면 동일 인스턴스 반환(== 가능)
3) **트랜잭션 쓰기 지연**
   - persist 시 즉시 INSERT를 날리지 않고, flush/commit 때 모아서 실행 가능
4) **변경 감지(Dirty Checking)**
   - 엔티티 스냅샷을 저장해두고, 커밋/flush 시 변경된 필드만 UPDATE 생성
5) **지연 로딩(Lazy Loading) 지원**
   - 프록시를 통해 실제 접근 시점에 SQL 실행(단, 영속성 컨텍스트가 살아있어야 함)

**정리**
- 영속성 컨텍스트는 ORM 성능/일관성의 핵심이지만, 범위를 잘못 잡으면(예: OSIV 무분별) 의도치 않은 쿼리, 메모리 증가를 유발할 수 있습니다.'
WHERE id = 'b0000000-0000-0000-0002-000000000005';

UPDATE questions
SET explanation =
'**개념**
- 연관된 엔티티를 조회할 때, 실제 데이터를 가져오는 시점/방식을 결정하는 전략입니다.

**Lazy Loading(지연 로딩)**
- 연관 엔티티를 **프록시로 먼저** 넣어두고, 실제로 접근(get)할 때 SQL을 실행합니다.
- 장점: 필요할 때만 조회 → 불필요한 조인/조회 감소
- 단점: 영속성 컨텍스트가 닫힌 뒤 접근하면 `LazyInitializationException` 발생 가능(특히 OSIV OFF + 계층 분리 미흡 시)

**Eager Loading(즉시 로딩)**
- 엔티티를 조회하는 시점에 연관 엔티티까지 **즉시 함께 로딩**합니다(주로 조인/추가쿼리).
- 장점: 이후 접근 시 추가 쿼리 없이 사용 가능
- 단점: 불필요한 데이터까지 당겨오거나, 복잡한 연관관계에서 의도치 않은 대량 조인/카테시안/성능 저하 발생 가능

**실무 권장**
- 기본적으로 **LAZY를 우선** 선택하고,
- 필요한 화면/유스케이스 단위로 **fetch join / EntityGraph / DTO projection** 등으로 “필요한 만큼만” 최적화하는 방식이 안전합니다.'
WHERE id = 'b0000000-0000-0000-0002-000000000006';

UPDATE questions
SET explanation =
'**개념**
- **Cascade(영속성 전이)**는 부모 엔티티의 상태 변경(persist/remove/merge 등)을 자식 엔티티에도 **연쇄적으로 적용**하는 옵션입니다.
- 즉, “부모를 저장하면 자식도 자동 저장”, “부모를 삭제하면 자식도 자동 삭제” 같은 동작을 선언적으로 설정합니다.

**종류**
- `CascadeType.PERSIST` : 부모 persist 시 자식 persist
- `CascadeType.MERGE` : 부모 merge 시 자식 merge
- `CascadeType.REMOVE` : 부모 remove 시 자식 remove
- `CascadeType.REFRESH` : 부모 refresh 시 자식 refresh
- `CascadeType.DETACH` : 부모 detach 시 자식 detach
- `CascadeType.ALL` : 위 전부

**사용 기준(중요)**
- “생명주기가 완전히 함께 가는 구성(Composition)”에만 쓰는 것이 안전합니다.
  예: Order(부모) - OrderItem(자식)처럼 OrderItem이 Order 없이 의미가 없는 경우
- 반대로, 여러 곳에서 공유되는 엔티티(예: Member, Product)에 REMOVE 같은 cascade를 걸면 위험합니다(연쇄 삭제 사고).'
WHERE id = 'b0000000-0000-0000-0002-000000000007';

UPDATE questions
SET explanation =
'**핵심 주의점: 연관관계의 주인(Owner)**
- JPA에서 외래키(FK)를 실제로 관리하는 쪽이 “연관관계의 주인”입니다.
- 일반적으로 **ManyToOne 쪽(자식)**이 FK를 갖기 때문에 주인이 됩니다.
- OneToMany는 보통 `mappedBy`로 “주인이 아님(읽기 전용 관계)”을 선언합니다.

**OneToMany 단방향은 왜 주의?**
- OneToMany 단방향을 쓰면 FK가 반대 테이블에 있음에도 JPA가 관리하려고 하면서
  UPDATE가 추가로 발생하거나 비효율적인 쿼리가 나오기 쉽습니다.
- 실무에서는 보통 **ManyToOne(자식→부모) + 필요 시 양방향**을 사용합니다.

**양방향 매핑 시 주의**
1) **양쪽 값을 모두 세팅**해야 객체 그래프 일관성이 유지됩니다.
   - 편의 메서드(addChild)로 양쪽 세팅을 강제하는 패턴 권장
2) 무한 루프(직렬화) 주의
   - JSON 직렬화 시 양방향 참조로 StackOverflow가 날 수 있어 DTO 변환, @JsonManagedReference/@JsonBackReference 등을 고려
3) 컬렉션은 가급적 `List`/`Set`로 초기화하고, 엔티티 외부에서 컬렉션 자체를 교체하기보다 add/remove로 관리

**예시(편의 메서드)**
- parent.addChild(child) 내부에서
  parent.children.add(child) + child.setParent(parent)'
WHERE id = 'b0000000-0000-0000-0002-000000000008';

UPDATE questions
SET explanation =
'**정의**
- N+1 문제는 “한 번의 쿼리로 N개의 엔티티를 가져온 뒤, 각 엔티티의 연관 엔티티를 조회하느라 추가로 N번 쿼리가 더 실행되는 문제”입니다.
- 예: 회원 목록 1번 조회 + 각 회원의 주문 조회 N번 → 총 N+1

**왜 발생하나**
- 주로 **지연 로딩(LAZY)**으로 설정된 연관관계에 접근할 때
- 또는 EAGER라도 내부적으로 쿼리가 여러 번 나가면서 발생할 수 있습니다(특히 컬렉션)

**해결/완화 방법**
1) **Fetch Join(JPQL)**: 필요한 연관을 한 번에 조인해서 가져오기
   - 예: `select m from Member m join fetch m.orders`
2) **EntityGraph**: 특정 조회 메서드에서만 fetch 전략을 바꾸기
3) **DTO 프로젝션**: 필요한 필드만 select 해서 바로 DTO로 받기(조회 최적화)
4) **Batch Size 설정**: `hibernate.default_batch_fetch_size`로 IN 쿼리로 묶어 가져오기(완전 해결은 아니지만 쿼리 수 감소)
5) 조회 화면/유스케이스 단위로 “필요한 연관만” 명시적으로 가져오는 설계

**실무 팁**
- 로그에서 SQL을 항상 확인하고, 컬렉션 페치 조인은 페이징과 같이 쓸 때 제약이 있으므로(중복 row) 전략을 분리하는 편이 안전합니다.'
WHERE id = 'b0000000-0000-0000-0002-000000000009';

UPDATE questions
SET explanation =
'**1차 캐시(First-Level Cache)**
- 영속성 컨텍스트(EntityManager) 단위 캐시입니다.
- 같은 트랜잭션/요청 범위에서 동일 PK 조회 시 DB를 다시 치지 않고 캐시에서 반환합니다.
- 특징:
  - 기본으로 항상 활성화
  - 트랜잭션 종료/컨텍스트 종료 시 사라짐
  - 동일성 보장(같은 PK면 같은 인스턴스)

**2차 캐시(Second-Level Cache)**
- EntityManager를 넘어, **EntityManagerFactory(애플리케이션 전역)** 단위 캐시입니다.
- 여러 트랜잭션/세션에 걸쳐 재사용 가능한 캐시이며, 별도 설정/캐시 제공자(Ehcache, Hazelcast 등)가 필요합니다.
- 특징:
  - 기본 비활성(설정 필요)
  - 엔티티/컬렉션/쿼리 캐시 등 세분화 가능
  - 캐시 일관성(동시성/무효화) 전략을 설계해야 함

**정리**
- 1차 캐시는 “JPA 기본 기능(세션 캐시)”
- 2차 캐시는 “애플리케이션 레벨 캐시(옵션, 운영 설계 필요)”'
WHERE id = 'b0000000-0000-0000-0002-000000000010';

UPDATE questions
SET explanation =
'**JPQL(Java Persistence Query Language)**
- JPA가 제공하는 객체 지향 쿼리 언어로, **테이블이 아니라 엔티티를 대상으로** 질의합니다.
- SQL처럼 보이지만 핵심 차이는 “FROM에 테이블이 아니라 엔티티 클래스(엔티티 이름)”가 온다는 점입니다.

**특징**
1) DB 방언에 독립적(최종 SQL은 JPA 구현체가 생성)
2) 연관관계를 기반으로 join 수행 가능
3) 조회 결과는 엔티티 또는 DTO로 매핑 가능

**예시**
- 엔티티 기준:
  - `select m from Member m where m.name = :name`
- 조인:
  - `select o from Order o join o.member m where m.id = :id`

**주의**
- JPQL은 “객체 모델” 기준이므로, 엔티티 매핑(필드/연관관계)을 제대로 이해하고 써야 의도한 쿼리가 나옵니다.'
WHERE id = 'b0000000-0000-0000-0002-000000000011';

UPDATE questions
SET explanation =
'**개념**
- **Criteria API**는 JPQL을 문자열로 쓰지 않고, 자바 코드로 타입-세이프하게(컴파일 타임 검증에 가깝게) 동적 쿼리를 생성하는 API입니다.

**장점**
1) 문자열 JPQL의 오타/문법 오류를 일부 줄임
2) 조건이 동적으로 늘어나는 복잡한 검색 화면에서 조합하기 쉬움(이론상)

**단점(현업에서 잘 안 쓰는 이유)**
- 코드가 지나치게 장황하고 가독성이 떨어집니다.
- 유지보수 난이도가 높아, 실무에서는 보통 **QueryDSL**이나 **Spring Data JPA Specifications** 등을 더 선호합니다.

**언제 쓰나**
- 라이브러리/프레임워크 레벨에서 동적 쿼리를 생성해야 하는 경우
- QueryDSL을 도입하기 어려운 제약 환경 등

**대체재**
- QueryDSL(가독성/타입 안정성), JPQL + 조건 조립, Spring Data JPA Specification'
WHERE id = 'b0000000-0000-0000-0002-000000000012';

UPDATE questions
SET explanation =
'**OSIV(Open Session In View)란?**
- 웹 요청 시작부터 뷰 렌더링(컨트롤러 응답 생성)까지 **영속성 컨텍스트(세션)**를 열어두는 전략입니다.
- 이렇게 하면 컨트롤러/뷰(또는 JSON 직렬화) 단계에서 지연 로딩이 동작할 수 있습니다.

**장점**
1) 서비스 계층 밖(컨트롤러/뷰)에서도 Lazy Loading 가능 → 개발 초기 편함
2) DTO 변환을 컨트롤러에서 대충 해도 Lazy 로딩이 붙어서 동작할 수 있음(편의)

**단점(중요)**
1) **트랜잭션 범위 밖에서 쿼리 발생**: 뷰 렌더링/직렬화 중에 예상치 못한 쿼리 폭발(N+1)이 생기기 쉽습니다.
2) **계층 침범**: 프레젠테이션 계층이 영속성에 의존 → 설계가 흐려짐
3) **성능/장애 원인 추적 어려움**: 어디서 쿼리가 나갔는지 파악이 어려워집니다.
4) 요청 동안 영속성 컨텍스트가 살아 메모리 사용량 증가 가능

**실무 권장**
- 가능하면 **OSIV OFF** + 서비스 계층에서 필요한 데이터만 페치 조인/DTO로 “명확히” 준비해서 반환
- 다만 팀/프로젝트 상황에 따라 단계적으로 OFF하는 전략을 택하기도 합니다.'
WHERE id = 'b0000000-0000-0000-0002-000000000013';

UPDATE questions
SET explanation =
'**SQL Injection이란**
- 사용자 입력을 문자열로 붙여 SQL을 만들 때, 공격자가 SQL 구문을 주입하여 의도치 않은 쿼리를 실행시키는 공격입니다.

**JPA/Hibernate의 기본 방어 방식**
1) **파라미터 바인딩(PreparedStatement)**
   - JPQL/Criteria/QueryDSL에서 `:param` 바인딩을 사용하면 내부적으로 PreparedStatement 형태로 파라미터가 분리되어 전달됩니다.
   - 결과적으로 입력값이 SQL 구문으로 해석되지 않고 “값”으로만 처리됩니다.
2) **자동 이스케이프/타입 처리**
   - 문자열/숫자/날짜 등 타입에 맞게 바인딩되므로 단순 문자열 결합보다 안전합니다.

**주의(여전히 위험한 경우)**
- **Native Query를 문자열로 직접 조합**하거나,
- 정렬(order by), 컬럼명 같은 “식별자”를 사용자 입력으로 직접 넣는 경우는 위험할 수 있습니다.
  - 이 경우 화이트리스트(허용 컬럼 목록)로 제한하는 방식이 필요합니다.

**결론**
- JPA를 쓰면 기본 CRUD/JPQL에서는 SQLi 위험이 크게 줄지만,
- 네이티브 쿼리/문자열 조합을 하면 동일하게 취약해질 수 있으므로 규칙이 필요합니다.'
WHERE id = 'b0000000-0000-0000-0002-000000000014';

UPDATE questions
SET explanation =
'**Spring Data JPA란?**
- JPA를 더 편하게 쓰기 위한 스프링의 데이터 접근 추상화 프로젝트입니다.
- 핵심은 Repository 인터페이스 기반으로 **구현체를 자동 생성**해 주어, DAO 구현을 최소화하는 것입니다.

**제공하는 편의**
1) **CRUD 자동 구현**
   - `JpaRepository`만 상속하면 save/findById/findAll/delete 등 기본 메서드 제공
2) **쿼리 메서드(Query Method)**
   - 메서드 이름 규칙으로 쿼리 생성
   - 예: `findByEmailAndStatus(String email, Status status)`
3) **@Query로 JPQL/NativeQuery 선언**
4) **페이징/정렬(Pageable, Sort)**
5) **Auditing**
   - @CreatedDate, @LastModifiedDate 등 자동 기록
6) **Specification/QueryDSL 연동**
   - 복잡한 동적 조건 검색에 확장 가능

**주의**
- 쿼리 메서드는 편하지만 복잡해지면 가독성이 급격히 떨어지므로, 일정 이상 복잡해지면 QueryDSL/DTO 조회로 전환하는 것이 유지보수에 유리합니다.'
WHERE id = 'b0000000-0000-0000-0002-000000000015';

UPDATE questions
SET explanation =
'**Spring Boot에서 JPA 사용 이점**
1) **자동 설정(Auto Configuration)**
   - DataSource, EntityManagerFactory, TransactionManager 등을 설정 파일(application.yml/properties) 기반으로 자동 구성
2) **스타터 의존성**
   - `spring-boot-starter-data-jpa` 하나로 JPA/Hibernate + 트랜잭션 + 기본 설정이 묶여 제공됨
3) **프로퍼티 기반 튜닝**
   - ddl-auto, show-sql, format_sql, batch_fetch_size 같은 Hibernate 옵션을 손쉽게 설정
4) **트랜잭션 관리 통합**
   - @Transactional과 함께 일관된 트랜잭션 경계 관리
5) **개발 생산성**
   - 테스트 슬라이스(@DataJpaTest), H2 같은 인메모리 연동이 쉬움

**주의**
- 편해진 만큼 “기본값”을 그대로 쓰면 운영에서 성능 문제가 터질 수 있습니다(페치 전략, N+1, DDL auto 등). 운영 환경에서는 명시적으로 설정을 정리하는 습관이 필요합니다.'
WHERE id = 'b0000000-0000-0000-0002-000000000016';

UPDATE questions
SET explanation =
'**기본값 정리**
- `@ManyToOne` : **EAGER**
- `@OneToOne`  : **EAGER**
- `@OneToMany` : **LAZY**
- `@ManyToMany`: **LAZY**

**왜 주의해야 하나**
- 특히 `ManyToOne`이 기본 EAGER라서, 엔티티 목록 조회 시 의도치 않은 조인/추가 쿼리가 붙어 성능 문제가 생기기 쉽습니다.

**실무 권장**
- 가능한 한 연관관계는 **LAZY로 명시**하고,
- 필요한 조회 케이스에서만 fetch join/EntityGraph/DTO 조회 등으로 최적화하는 패턴이 일반적으로 안전합니다.'
WHERE id = 'b0000000-0000-0000-0002-000000000017';

UPDATE questions
SET explanation =
'**영속성 전이(Cascade)**
- 부모의 영속 상태 변화(persist/merge/remove 등)를 자식에게 “전이”시키는 기능입니다.
- 예: Order 저장 시 OrderItem도 함께 저장(CascadeType.PERSIST)

**고아 객체 제거(Orphan Removal)**
- 부모 컬렉션에서 자식을 제거했을 때, 그 자식을 DB에서도 삭제하는 기능입니다.
- 즉, “부모와의 연관이 끊긴 자식은 고아로 보고 제거”합니다.
- 설정: `orphanRemoval = true`

**차이 핵심**
- Cascade는 “부모의 상태 변화”가 트리거
- Orphan Removal은 “연관관계에서 빠짐(컬렉션에서 제거)”이 트리거

**예시**
- `order.getItems().remove(item);`
  - orphanRemoval=true면 해당 item row가 DELETE됩니다.
  - orphanRemoval=false면 FK만 null 처리되거나(설정/매핑에 따라) 아무 것도 안 될 수 있어 DB에 레코드가 남을 수 있습니다.

**주의**
- orphanRemoval은 사실상 자식의 생명주기를 부모가 완전히 소유할 때만 써야 안전합니다(Composition).'
WHERE id = 'b0000000-0000-0000-0002-000000000018';

UPDATE questions
SET explanation =
'**동일성(Identity)**
- `==` 비교로 판단되는 “같은 인스턴스인가?”입니다.
- JPA에서는 같은 영속성 컨텍스트에서 같은 PK 엔티티를 조회하면 동일 인스턴스를 반환하므로 동일성이 보장됩니다.

**동등성(Equality)**
- `equals()`로 판단되는 “내용/의미가 같은가?”입니다.
- 엔티티의 equals/hashCode 구현에 따라 결과가 달라집니다.

**JPA에서 중요한 이유**
1) 영속성 컨텍스트는 PK 기반으로 동일 엔티티를 하나의 인스턴스로 관리 → 동일성 기반 로직이 자연스럽게 동작
2) equals/hashCode를 잘못 구현하면
   - Set/Map 컬렉션에서 중복 처리/삭제가 꼬이거나
   - 프록시(지연 로딩)와의 비교가 깨질 수 있습니다.

**실무 구현 팁(요지)**
- 엔티티 equals/hashCode는 일반적으로 “변하지 않는 식별자(예: PK 또는 자연키)” 기반으로 하되,
- PK가 생성 전략이고 저장 전에는 null일 수 있으므로 설계/정책이 필요합니다.
- 무분별한 모든 필드 기반 equals/hashCode는 변경 감지/컬렉션 동작에 문제를 만들 수 있습니다.'
WHERE id = 'b0000000-0000-0000-0002-000000000019';

UPDATE questions
SET explanation =
'**1차 캐시 동작 방식**
- 1차 캐시는 영속성 컨텍스트 내부(Map 형태)에 **PK → 엔티티**로 저장됩니다.

**흐름 예시**
1) `em.find(Member.class, 1L)` 호출
2) 영속성 컨텍스트(1차 캐시)에서 PK=1L 엔티티가 있는지 확인
   - 있으면 DB 조회 없이 바로 반환
3) 없으면 DB에서 SELECT 실행
4) 조회된 엔티티를 1차 캐시에 저장하고 반환

**효과**
- 같은 트랜잭션에서 같은 PK를 여러 번 조회해도 SELECT는 1번만 나가는 경우가 많습니다.
- 동시에 동일성 보장(같은 객체 인스턴스 반환)이 됩니다.

**주의**
- 1차 캐시는 트랜잭션/컨텍스트 범위에서만 의미가 있으며, 요청이 길어지면(예: OSIV) 캐시가 커져 메모리 부담이 될 수 있습니다.'
WHERE id = 'b0000000-0000-0000-0002-000000000020';

UPDATE questions
SET explanation =
'**QueryDSL이란**
- 타입-세이프한 쿼리 생성을 위한 라이브러리입니다.
- 문자열 JPQL 대신, 생성된 Q타입을 이용해 자바 코드로 조건/조인을 구성합니다.

**JPA와 함께 쓰는 방식**
1) 빌드 시점에 엔티티 메타 모델(Q클래스)을 생성
   - 예: QMember, QOrder
2) `JPAQueryFactory`로 쿼리를 작성
3) 동적 조건 조합(BooleanBuilder, where절에 null-safe 조건 추가 등)이 쉬움

**장점**
- 컴파일 타임에 필드/타입 오류를 잡기 쉬움(오타 감소)
- 동적 검색 조건이 많은 화면에서 가독성/유지보수성이 좋음
- JPQL 문자열 지옥을 피할 수 있음

**주의**
- 설정/빌드(Annotation Processing) 구성이 필요
- 너무 복잡한 조회는 DTO 프로젝션/Native SQL로 분리하는 전략도 병행합니다.'
WHERE id = 'b0000000-0000-0000-0002-000000000021';

UPDATE questions
SET explanation =
'**엔티티 라이프사이클(상태)**
1) **Transient(비영속)**
   - 영속성 컨텍스트와 전혀 관계 없는 새 객체 상태
   - 예: `new Member()`만 한 상태

2) **Managed / Persistent(영속)**
   - 영속성 컨텍스트가 관리하는 상태
   - `em.persist(entity)` 또는 `em.find(...)`로 조회된 엔티티
   - 변경 감지/쓰기 지연/1차 캐시 혜택을 받음

3) **Detached(준영속)**
   - 한때 영속이었지만, 컨텍스트에서 분리된 상태
   - `em.detach(entity)`, `em.clear()`, `em.close()` 또는 트랜잭션 종료 후 세션 종료 등
   - 변경 감지 대상이 아니므로 값 변경해도 자동 UPDATE 안 됨

4) **Removed(삭제)**
   - `em.remove(entity)`로 삭제 예약된 상태
   - flush/commit 시 DELETE SQL 실행

**merge의 의미(주의 포인트)**
- `merge()`는 준영속 엔티티를 다시 영속 상태로 “복사해서” 붙이는 동작에 가깝습니다.
- merge 결과로 반환된 객체가 영속 엔티티이고, 원래 전달한 객체는 여전히 준영속일 수 있어 혼동 주의가 필요합니다.'
WHERE id = 'b0000000-0000-0000-0002-000000000022';
