-- Java 면접 질문 답변 추가

UPDATE questions SET explanation = 'Java는 1995년 Sun Microsystems에서 개발한 객체 지향 프로그래밍 언어입니다. "Write Once, Run Anywhere" 철학을 따라 플랫폼 독립적으로 동작하며, JVM(Java Virtual Machine)을 통해 실행됩니다. 주요 특징으로는 객체 지향, 자동 메모리 관리(GC), 멀티스레딩 지원, 풍부한 API 라이브러리, 보안성 등이 있습니다.'
WHERE id = 'b0000000-0000-0000-0004-000000000001';

UPDATE questions SET explanation = '객체 지향 프로그래밍의 4대 특징은 다음과 같습니다:

1. **캡슐화(Encapsulation)**: 데이터와 메서드를 하나로 묶고, 외부로부터 데이터를 보호합니다. private, protected 등의 접근 제어자를 사용합니다.

2. **상속(Inheritance)**: 기존 클래스의 속성과 메서드를 재사용하여 새로운 클래스를 만듭니다. extends 키워드를 사용하며, 코드 재사용성을 높입니다.

3. **다형성(Polymorphism)**: 같은 인터페이스나 부모 클래스 타입으로 다양한 객체를 다룰 수 있습니다. 오버로딩과 오버라이딩으로 구현됩니다.

4. **추상화(Abstraction)**: 복잡한 시스템에서 핵심적인 개념만 추출합니다. abstract 클래스나 interface를 통해 구현합니다.'
WHERE id = 'b0000000-0000-0000-0004-000000000002';

UPDATE questions SET explanation = '**JDK (Java Development Kit)**: Java 개발 도구 모음으로, 컴파일러(javac), 디버거, JRE를 포함합니다. 개발자가 Java 애플리케이션을 작성, 컴파일, 디버깅할 때 필요합니다.

**JRE (Java Runtime Environment)**: Java 프로그램 실행 환경으로, JVM과 Java 클래스 라이브러리를 포함합니다. 개발은 불가능하며 실행만 가능합니다.

**JVM (Java Virtual Machine)**: Java 바이트코드를 실행하는 가상 머신입니다. .class 파일을 읽어 기계어로 변환하고 실행합니다. 플랫폼 독립성의 핵심입니다.

관계: JDK ⊃ JRE ⊃ JVM'
WHERE id = 'b0000000-0000-0000-0004-000000000003';

UPDATE questions SET explanation = 'Java는 소스 코드(.java)를 바이트코드(.class)로 컴파일하며, 이 바이트코드는 플랫폼에 독립적입니다. 각 운영체제별로 제공되는 JVM이 바이트코드를 해당 플랫폼의 기계어로 변환하여 실행합니다.

즉, 개발자는 한 번만 작성하고(Write Once), 어떤 플랫폼(Windows, Linux, macOS 등)에서든 JVM만 있으면 실행(Run Anywhere)할 수 있습니다. 이것이 "플랫폼 독립적"이라고 불리는 이유입니다.'
WHERE id = 'b0000000-0000-0000-0004-000000000004';

UPDATE questions SET explanation = '**기본 자료형 (Primitive Type)**:
- 스택 메모리에 저장되며, 실제 값을 직접 저장합니다
- 8가지: byte, short, int, long, float, double, char, boolean
- null 값을 가질 수 없습니다
- 연산 속도가 빠릅니다

**참조 자료형 (Reference Type)**:
- 힙 메모리에 객체가 저장되고, 스택에는 주소값(참조)이 저장됩니다
- 클래스, 인터페이스, 배열, 열거형 등
- null 값을 가질 수 있습니다
- 메서드와 필드를 가질 수 있습니다

예: `int a = 10;` (기본형, 값 저장) vs `String str = "hello";` (참조형, 주소 저장)'
WHERE id = 'b0000000-0000-0000-0004-000000000005';

UPDATE questions SET explanation = 'String이 불변 객체인 이유는 다음과 같습니다:

1. **String Pool**: JVM은 문자열 상수 풀에서 같은 값을 가진 String을 재사용합니다. 불변이 아니면 다른 참조에 영향을 줄 수 있습니다.

2. **보안**: 데이터베이스 연결, 네트워크 통신 등에서 String이 사용되는데, 변경 가능하면 보안 위험이 있습니다.

3. **스레드 안전성**: 불변 객체는 멀티스레드 환경에서 동기화 없이 안전하게 공유할 수 있습니다.

4. **해시코드 캐싱**: HashMap 등에서 키로 사용될 때, 해시코드가 변하지 않아 효율적입니다.

String을 변경하려면 새로운 String 객체가 생성됩니다.'
WHERE id = 'b0000000-0000-0000-0004-000000000006';

UPDATE questions SET explanation = '**== 연산자**:
- 참조 타입에서는 주소값(참조)을 비교합니다
- 기본 타입에서는 실제 값을 비교합니다
- 예: `str1 == str2`는 같은 객체를 가리키는지 확인

**equals() 메서드**:
- 객체의 내용(값)을 비교합니다
- Object 클래스의 기본 equals()는 ==와 동일하지만, String, Integer 등은 오버라이딩하여 값을 비교합니다
- 예: `str1.equals(str2)`는 문자열 내용이 같은지 확인

```java
String s1 = new String("hello");
String s2 = new String("hello");
s1 == s2        // false (다른 객체)
s1.equals(s2)   // true (같은 내용)
```'
WHERE id = 'b0000000-0000-0000-0004-000000000007';

UPDATE questions SET explanation = '**Error (오류)**:
- 시스템 레벨의 심각한 문제 (OutOfMemoryError, StackOverflowError 등)
- 애플리케이션에서 복구가 불가능하거나 매우 어렵습니다
- catch하지 않는 것이 일반적입니다

**Exception (예외)**:
- 프로그램 로직에서 발생하는 문제 (NullPointerException, IOException 등)
- 적절한 예외 처리로 복구 가능합니다
- Checked Exception과 Unchecked Exception으로 나뉩니다

계층 구조: Throwable → Error / Exception → RuntimeException

애플리케이션 개발 시 Exception은 처리해야 하지만, Error는 일반적으로 처리하지 않습니다.'
WHERE id = 'b0000000-0000-0000-0004-000000000008';

UPDATE questions SET explanation = '**final**:
- 변수: 값을 변경할 수 없음 (상수)
- 메서드: 오버라이딩 불가
- 클래스: 상속 불가
- 예: `final int MAX = 100;`

**finally**:
- try-catch 블록 다음에 사용되는 블록
- 예외 발생 여부와 관계없이 항상 실행됩니다
- 주로 리소스 정리(close) 작업에 사용
- 예: `try {...} catch {...} finally { /* 항상 실행 */ }`

**finalize**:
- Object 클래스의 메서드
- 가비지 컬렉터가 객체를 수거하기 전에 호출
- Java 9부터 deprecated (사용 권장하지 않음)
- 대신 try-with-resources 사용 권장'
WHERE id = 'b0000000-0000-0000-0004-000000000009';

UPDATE questions SET explanation = '가비지 컬렉션(GC)은 JVM에서 더 이상 사용되지 않는 객체를 자동으로 메모리에서 제거하는 프로세스입니다.

**동작 방식**:
1. **Mark**: GC Root에서 시작하여 도달 가능한 객체를 마킹
2. **Sweep**: 마킹되지 않은 객체(unreachable)를 메모리에서 제거
3. **Compact** (선택적): 메모리 단편화 방지를 위해 객체를 압축

**GC Root**:
- 스택의 로컬 변수
- 메서드 영역의 static 변수
- JNI 참조

**세대별 수집 (Generational GC)**:
- Young Generation: 새로 생성된 객체 (Minor GC)
- Old Generation: 오래 살아남은 객체 (Major GC)
- Permanent/Metaspace: 클래스 메타데이터

장점: 메모리 누수 방지, 개발자의 메모리 관리 부담 감소'
WHERE id = 'b0000000-0000-0000-0004-000000000010';

UPDATE questions SET explanation = '**프로세스 (Process)**:
- 실행 중인 프로그램의 인스턴스
- 독립적인 메모리 공간을 가집니다 (Code, Data, Heap, Stack)
- 프로세스 간 통신(IPC)이 필요합니다
- 생성/종료 비용이 큽니다
- 한 프로세스의 문제가 다른 프로세스에 영향을 주지 않습니다

**스레드 (Thread)**:
- 프로세스 내에서 실행되는 작업 단위
- 같은 프로세스의 스레드들은 메모리를 공유합니다 (Code, Data, Heap은 공유, Stack은 독립)
- 빠른 문맥 전환(Context Switching)
- 생성/종료 비용이 작습니다
- 한 스레드의 문제가 전체 프로세스에 영향을 줄 수 있습니다

관계: 하나의 프로세스는 여러 스레드를 가질 수 있습니다.'
WHERE id = 'b0000000-0000-0000-0004-000000000011';

UPDATE questions SET explanation = 'Java에서 스레드를 생성하는 두 가지 방법:

**1. Thread 클래스 상속**:
```java
class MyThread extends Thread {
    @Override
    public void run() {
        // 스레드 작업
    }
}
MyThread thread = new MyThread();
thread.start();
```
- 단점: Java는 단일 상속만 지원하므로 다른 클래스를 상속받을 수 없습니다

**2. Runnable 인터페이스 구현** (권장):
```java
class MyRunnable implements Runnable {
    @Override
    public void run() {
        // 스레드 작업
    }
}
Thread thread = new Thread(new MyRunnable());
thread.start();
```
- 장점: 다른 클래스를 상속받을 수 있고, 람다식 사용 가능

**람다식 사용**:
```java
Thread thread = new Thread(() -> {
    // 스레드 작업
});
thread.start();
```

주의: `start()` 메서드를 호출해야 새로운 스레드가 생성되고, `run()`이 실행됩니다.'
WHERE id = 'b0000000-0000-0000-0004-000000000012';

UPDATE questions SET explanation = '동기화(Synchronization)는 멀티스레드 환경에서 공유 자원에 대한 동시 접근을 제어하여 데이터 일관성을 보장하는 기법입니다.

**구현 방법**:

**1. synchronized 메서드**:
```java
public synchronized void method() {
    // 동기화된 코드
}
```

**2. synchronized 블록**:
```java
public void method() {
    synchronized(this) {
        // 동기화된 코드
    }
}
```

**3. static synchronized 메서드**:
```java
public static synchronized void method() {
    // 클래스 레벨 동기화
}
```

**동작 원리**:
- 모니터(Monitor) 락을 사용합니다
- 한 번에 하나의 스레드만 synchronized 영역에 진입 가능
- 다른 스레드는 락이 해제될 때까지 대기(블로킹)

**주의사항**:
- 성능 저하 가능 (최소한의 영역만 동기화)
- 데드락 발생 가능성'
WHERE id = 'b0000000-0000-0000-0004-000000000013';

UPDATE questions SET explanation = '**synchronized 키워드**:
- 암묵적 락(Intrinsic Lock) 사용
- 블록 진입 시 자동으로 락 획득, 블록 종료 시 자동 해제
- 락 획득 대기 시간 제어 불가
- 간단하고 사용하기 쉬움
- 메서드 또는 블록 단위로 동기화

**java.util.concurrent.locks.Lock**:
- 명시적 락(Explicit Lock) 사용
- `lock()`과 `unlock()`을 명시적으로 호출
- 락 획득 시도 시간 제어 가능 (`tryLock()`)
- 조건 변수(Condition) 지원
- 읽기/쓰기 락 분리 가능 (ReadWriteLock)
- 더 유연하지만 복잡함

```java
// synchronized
synchronized(obj) {
    // 작업
}

// Lock
Lock lock = new ReentrantLock();
lock.lock();
try {
    // 작업
} finally {
    lock.unlock(); // 반드시 finally에서 해제
}
```

**선택 기준**: 간단한 동기화는 synchronized, 복잡한 제어가 필요하면 Lock 사용'
WHERE id = 'b0000000-0000-0000-0004-000000000014';

UPDATE questions SET explanation = 'volatile 키워드는 변수를 메인 메모리에 저장하도록 지시하여, 멀티스레드 환경에서 변수의 가시성(Visibility)을 보장합니다.

**동작 원리**:
- CPU 캐시가 아닌 메인 메모리에서 직접 읽고 씁니다
- 한 스레드가 변경한 값을 다른 스레드가 즉시 볼 수 있습니다
- 명령어 재정렬(Reordering)을 방지합니다

**사용 시기**:
1. 한 스레드가 쓰고, 여러 스레드가 읽는 경우
2. boolean 플래그 변수 (예: 종료 플래그)
3. 단일 연산만 수행하는 경우

```java
private volatile boolean running = true;

// 스레드 1
public void stop() {
    running = false; // 메인 메모리에 즉시 반영
}

// 스레드 2
while (running) { // 메인 메모리에서 최신 값 읽음
    // 작업
}
```

**주의사항**:
- 원자성(Atomicity)을 보장하지 않습니다
- 복합 연산(i++, i = i + 1)에는 synchronized 필요
- synchronized보다 가볍지만, 기능이 제한적'
WHERE id = 'b0000000-0000-0000-0004-000000000015';

UPDATE questions SET explanation = 'JVM 메모리는 크게 Heap과 Stack으로 나뉩니다.

**힙 (Heap)**:
- 모든 객체(인스턴스)와 배열이 저장됩니다
- 모든 스레드가 공유하는 영역입니다
- 가비지 컬렉션의 대상입니다
- 크기가 크고, 접근 속도가 상대적으로 느립니다
- Young Generation, Old Generation으로 구분
- 예: `new Object()`, `new int[10]`

**스택 (Stack)**:
- 메서드 호출 시 생성되는 지역 변수, 매개변수, 리턴 값 등이 저장됩니다
- 각 스레드마다 독립적인 스택을 가집니다
- 메서드 실행이 끝나면 자동으로 제거됩니다
- LIFO(Last In First Out) 구조
- 크기가 작고, 접근 속도가 빠릅니다
- StackOverflowError: 재귀 호출이 너무 깊을 때 발생

```java
public void method() {
    int a = 10;        // Stack에 저장
    String str = new String("hello"); // str 참조는 Stack, 객체는 Heap
}
```'
WHERE id = 'b0000000-0000-0000-0004-000000000016';

UPDATE questions SET explanation = '**오토박싱 (Autoboxing)**:
- 기본 자료형(primitive)을 래퍼 클래스(Wrapper Class) 객체로 자동 변환
- 예: `int` → `Integer`

**언박싱 (Unboxing)**:
- 래퍼 클래스 객체를 기본 자료형으로 자동 변환
- 예: `Integer` → `int`

```java
// 오토박싱
Integer num = 100; // int를 Integer로 자동 변환
// 실제로는: Integer num = Integer.valueOf(100);

// 언박싱
int value = num; // Integer를 int로 자동 변환
// 실제로는: int value = num.intValue();

// 혼합 사용
List<Integer> list = new ArrayList<>();
list.add(10); // 오토박싱
int x = list.get(0); // 언박싱
```

**주의사항**:
- NullPointerException 발생 가능 (언박싱 시 null 체크 필요)
- 성능: 오토박싱/언박싱은 객체 생성을 수반하므로 반복문에서 사용 시 성능 저하 가능'
WHERE id = 'b0000000-0000-0000-0004-000000000017';

UPDATE questions SET explanation = '제네릭스(Generics)는 클래스, 인터페이스, 메서드를 정의할 때 타입을 파라미터로 사용할 수 있게 하는 기능입니다.

**사용 목적**:

1. **타입 안정성**: 컴파일 타임에 타입 체크로 런타임 오류 방지
```java
List<String> list = new ArrayList<>();
list.add("hello");
// list.add(10); // 컴파일 에러
```

2. **형변환 제거**: 명시적 캐스팅이 필요 없음
```java
// 제네릭 없이
List list = new ArrayList();
String str = (String) list.get(0); // 캐스팅 필요

// 제네릭 사용
List<String> list = new ArrayList<>();
String str = list.get(0); // 캐스팅 불필요
```

3. **코드 재사용성**: 다양한 타입에 대해 같은 코드 사용
```java
class Box<T> {
    private T item;
    public void set(T item) { this.item = item; }
    public T get() { return item; }
}

Box<String> strBox = new Box<>();
Box<Integer> intBox = new Box<>();
```

**제네릭 타입 소거 (Type Erasure)**: 컴파일 후 제네릭 타입 정보는 제거되어 하위 호환성 유지'
WHERE id = 'b0000000-0000-0000-0004-000000000018';

UPDATE questions SET explanation = '애노테이션(Annotation)은 메타데이터를 코드에 추가하는 방법으로, `@` 기호로 시작합니다.

**개념**:
- 코드에 대한 정보를 제공하는 주석과 유사하지만, 컴파일러나 런타임에 처리됩니다
- 클래스, 메서드, 변수, 매개변수 등에 적용 가능

**활용 방법**:

1. **컴파일러에게 정보 제공**:
```java
@Override // 메서드가 오버라이드되었음을 확인
@Deprecated // 더 이상 사용하지 않음을 표시
@SuppressWarnings("unchecked") // 경고 억제
```

2. **컴파일 타임/런타임 처리**:
```java
@Entity // JPA 엔티티 표시
@RestController // Spring MVC 컨트롤러
@Test // JUnit 테스트 메서드
```

3. **사용자 정의 애노테이션**:
```java
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface MyAnnotation {
    String value() default "";
}
```

**장점**: 코드의 가독성, 유지보수성 향상, 보일러플레이트 코드 감소'
WHERE id = 'b0000000-0000-0000-0004-000000000019';

UPDATE questions SET explanation = '**직렬화 (Serialization)**:
- 객체를 바이트 스트림으로 변환하는 과정
- 객체의 상태를 파일에 저장하거나 네트워크로 전송할 때 사용
- `Serializable` 인터페이스 구현 필요

**역직렬화 (Deserialization)**:
- 바이트 스트림을 다시 객체로 변환하는 과정
- 저장되거나 전송된 데이터를 원래 객체로 복원

```java
// 직렬화 대상 클래스
class Person implements Serializable {
    private static final long serialVersionUID = 1L;
    private String name;
    private int age;
    // transient 키워드로 직렬화에서 제외 가능
    private transient String password;
}

// 직렬화
ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream("person.ser"));
oos.writeObject(person);

// 역직렬화
ObjectInputStream ois = new ObjectInputStream(new FileInputStream("person.ser"));
Person person = (Person) ois.readObject();
```

**주의사항**:
- `serialVersionUID` 관리 중요 (클래스 버전 관리)
- static, transient 필드는 직렬화되지 않음
- 보안 이슈: 신뢰할 수 없는 데이터 역직렬화 주의'
WHERE id = 'b0000000-0000-0000-0004-000000000020';

UPDATE questions SET explanation = '**List**:
- 순서가 있는 데이터 집합
- 중복 요소를 허용합니다
- 인덱스로 요소에 접근 가능 (get, set)
- 구현 클래스: ArrayList, LinkedList, Vector
- 사용 예: 게시판 목록, 순서가 중요한 데이터

```java
List<String> list = new ArrayList<>();
list.add("A");
list.add("B");
list.add("A"); // 중복 허용
list.get(0); // 인덱스로 접근
```

**Set**:
- 순서가 없는 데이터 집합 (구현에 따라 순서 유지 가능)
- 중복 요소를 허용하지 않습니다
- 인덱스 개념이 없음
- 구현 클래스: HashSet (순서 없음), LinkedHashSet (삽입 순서 유지), TreeSet (정렬 순서)
- 사용 예: 중복 제거, 집합 연산

```java
Set<String> set = new HashSet<>();
set.add("A");
set.add("B");
set.add("A"); // 중복 무시, 크기는 2
// set.get(0); // 컴파일 에러 - 인덱스 접근 불가
```

**선택 기준**: 순서와 중복이 필요하면 List, 중복 제거와 빠른 검색이 필요하면 Set'
WHERE id = 'b0000000-0000-0000-0004-000000000021';

UPDATE questions SET explanation = '**ArrayList**:
- 내부적으로 배열(Array)을 사용하여 구현
- 인덱스 기반으로 빠른 조회 (O(1))
- 중간 삽입/삭제가 느림 (O(n)) - 요소 이동 필요
- 메모리 연속적으로 할당
- 크기 변경 시 새 배열 생성 및 복사 필요
- 사용 예: 조회가 많고, 삽입/삭제가 적은 경우

```java
List<String> arrayList = new ArrayList<>();
arrayList.get(100); // 빠름
arrayList.add(50, "value"); // 느림 (요소 이동)
```

**LinkedList**:
- 노드(Node)들이 링크로 연결된 구조
- 순차 접근으로 조회가 느림 (O(n))
- 중간 삽입/삭제가 빠름 (O(1)) - 링크만 변경
- 메모리가 불연속적으로 할당
- 각 노드가 다음 노드의 주소를 저장하므로 메모리 오버헤드
- 사용 예: 삽입/삭제가 많고, 조회가 적은 경우

```java
List<String> linkedList = new LinkedList<>();
linkedList.get(100); // 느림 (순차 탐색)
linkedList.add(50, "value"); // 빠름 (링크만 변경)
```

**성능 비교**:
- 조회: ArrayList > LinkedList
- 삽입/삭제: LinkedList > ArrayList (중간 위치일 때)
- 끝에 추가: 비슷함'
WHERE id = 'b0000000-0000-0000-0004-000000000022';

UPDATE questions SET explanation = '**HashMap**:
- Java 1.2부터 도입된 비동기화된 Map
- null 키와 null 값을 허용합니다
- 동기화되지 않아 멀티스레드 환경에서 안전하지 않음
- 성능이 빠름 (동기화 오버헤드 없음)
- 대부분의 경우 권장됩니다

**Hashtable**:
- Java 1.0부터 존재한 레거시 클래스
- null 키와 null 값을 허용하지 않습니다
- 모든 메서드가 synchronized로 동기화됨
- 멀티스레드 환경에서 안전하지만 성능이 느림
- 현재는 거의 사용되지 않음 (ConcurrentHashMap 권장)

```java
// HashMap
Map<String, String> hashMap = new HashMap<>();
hashMap.put(null, "value"); // OK
hashMap.put("key", null); // OK

// Hashtable
Map<String, String> hashtable = new Hashtable<>();
hashtable.put(null, "value"); // NullPointerException
hashtable.put("key", null); // NullPointerException
```

**선택 기준**:
- 단일 스레드: HashMap
- 멀티스레드: ConcurrentHashMap (Hashtable 대신)
- 레거시 코드: Hashtable'
WHERE id = 'b0000000-0000-0000-0004-000000000023';

UPDATE questions SET explanation = 'HashMap의 동시성 문제를 해결하기 위한 클래스들:

**1. ConcurrentHashMap** (권장):
- Java 5부터 도입
- 내부적으로 여러 세그먼트로 나누어 락을 분산 (Segment Locking)
- 읽기는 락 없이, 쓰기는 세그먼트 단위로 락
- Hashtable보다 훨씬 빠르고 효율적
- null 키와 null 값을 허용하지 않음

```java
Map<String, String> map = new ConcurrentHashMap<>();
```

**2. Collections.synchronizedMap()**:
- 기존 Map을 동기화된 Map으로 래핑
- 모든 메서드에 synchronized 적용
- Hashtable과 유사한 성능 (모든 작업이 블로킹)
- null 허용 여부는 원본 Map에 따름

```java
Map<String, String> map = Collections.synchronizedMap(new HashMap<>());
```

**3. Hashtable**:
- 레거시 클래스로 현재는 권장하지 않음

**성능 비교**: ConcurrentHashMap > synchronizedMap ≈ Hashtable

**실무 권장**: 멀티스레드 환경에서는 **ConcurrentHashMap** 사용'
WHERE id = 'b0000000-0000-0000-0004-000000000024';

UPDATE questions SET explanation = '**StringBuilder**:
- Java 1.5부터 도입
- 동기화되지 않음 (Thread-unsafe)
- 단일 스레드 환경에서 빠름
- 대부분의 경우 권장됩니다

**StringBuffer**:
- Java 1.0부터 존재
- 모든 메서드가 synchronized로 동기화됨 (Thread-safe)
- 멀티스레드 환경에서 안전하지만 느림
- 동기화 오버헤드로 인한 성능 저하

**공통점**:
- 둘 다 가변(mutable) 문자열을 다룸
- String과 달리 새 객체를 생성하지 않고 기존 객체를 수정
- 동일한 API 제공 (append, insert, delete 등)

```java
// StringBuilder (단일 스레드)
StringBuilder sb = new StringBuilder();
sb.append("Hello").append(" World");

// StringBuffer (멀티 스레드)
StringBuffer sbf = new StringBuffer();
sbf.append("Hello").append(" World");
```

**성능 비교**: StringBuilder > StringBuffer > String (연결 작업 시)

**선택 기준**:
- 단일 스레드: StringBuilder
- 멀티 스레드: StringBuffer
- 불변 문자열: String'
WHERE id = 'b0000000-0000-0000-0004-000000000025';

UPDATE questions SET explanation = 'Java 8의 주요 추가 기능:

**1. 람다 표현식 (Lambda Expressions)**:
- 함수형 프로그래밍 지원
- 익명 함수를 간결하게 표현
```java
list.forEach(item -> System.out.println(item));
```

**2. 스트림 API (Stream API)**:
- 컬렉션 데이터를 선언적으로 처리
- filter, map, reduce 등의 연산 지원
```java
list.stream().filter(x -> x > 10).collect(Collectors.toList());
```

**3. 함수형 인터페이스 (Functional Interface)**:
- 단일 추상 메서드를 가진 인터페이스 (@FunctionalInterface)
- Predicate, Function, Consumer, Supplier 등

**4. 메서드 참조 (Method Reference)**:
- 메서드를 직접 참조하는 축약 표현 (::)
```java
list.forEach(System.out::println);
```

**5. Optional**:
- null 처리를 위한 컨테이너 클래스
- NullPointerException 방지

**6. 디폴트 메서드 (Default Method)**:
- 인터페이스에 구현 메서드 추가 가능

**7. 새로운 날짜/시간 API**:
- java.time 패키지 (LocalDate, LocalDateTime 등)

**8. Nashorn JavaScript 엔진**

이러한 기능들은 코드의 간결성, 가독성, 성능을 크게 향상시켰습니다.'
WHERE id = 'b0000000-0000-0000-0004-000000000026';

UPDATE questions SET explanation = '람다식(Lambda Expression)은 익명 함수를 간결하게 표현하는 방법으로, Java 8부터 도입되었습니다.

**문법**:
```
(매개변수) -> { 실행 코드 }
```

**사용 예시**:

```java
// 기존 방식 (익명 클래스)
Runnable runnable = new Runnable() {
    @Override
    public void run() {
        System.out.println("Hello");
    }
};

// 람다식
Runnable runnable = () -> System.out.println("Hello");

// 매개변수가 있는 경우
List<Integer> list = Arrays.asList(1, 2, 3, 4, 5);
list.forEach(item -> System.out.println(item));

// 여러 줄인 경우
list.sort((a, b) -> {
    if (a > b) return 1;
    else if (a < b) return -1;
    else return 0;
});
```

**특징**:
- 함수형 인터페이스에만 사용 가능 (단일 추상 메서드)
- 타입 추론 지원 (매개변수 타입 생략 가능)
- 클로저(Closure) 지원 (외부 변수 참조 가능, 단 final 또는 effectively final)

**장점**:
- 코드 간결성
- 가독성 향상
- 함수형 프로그래밍 가능'
WHERE id = 'b0000000-0000-0000-0004-000000000027';

UPDATE questions SET explanation = '스트림 API(Stream API)는 컬렉션 데이터를 선언적으로 처리하는 기능으로, Java 8부터 도입되었습니다.

**특징**:

1. **선언적 프로그래밍**: 어떻게(How)가 아닌 무엇을(What) 할지 기술
2. **파이프라인**: 여러 연산을 체이닝하여 연결
3. **내부 반복**: 외부에서 반복문을 작성하지 않음
4. **지연 연산**: 최종 연산이 호출될 때까지 중간 연산이 실행되지 않음
5. **병렬 처리**: parallelStream()으로 멀티코어 활용

**주요 연산**:

**중간 연산** (Lazy):
- `filter()`: 조건에 맞는 요소만 필터링
- `map()`: 요소를 변환
- `sorted()`: 정렬
- `distinct()`: 중복 제거

**최종 연산** (Eager):
- `collect()`: 결과를 컬렉션으로 수집
- `forEach()`: 각 요소에 대해 작업 수행
- `reduce()`: 요소를 하나로 결합
- `count()`, `findFirst()`, `anyMatch()` 등

**사용 예**:
```java
List<String> result = list.stream()
    .filter(x -> x.length() > 5)
    .map(String::toUpperCase)
    .sorted()
    .collect(Collectors.toList());
```

**장점**: 코드 가독성, 병렬 처리 용이, 함수형 프로그래밍'
WHERE id = 'b0000000-0000-0000-0004-000000000028';

UPDATE questions SET explanation = '**Checked Exception (검사 예외)**:
- 컴파일 시점에 체크되는 예외
- 반드시 처리해야 함 (try-catch 또는 throws 선언)
- RuntimeException을 상속하지 않는 Exception의 서브클래스
- 복구 가능한 예외 상황에 사용
- 예: IOException, SQLException, ClassNotFoundException

```java
// 반드시 처리 필요
public void readFile() throws IOException { // 또는 try-catch
    FileReader file = new FileReader("file.txt");
}
```

**Unchecked Exception (비검사 예외)**:
- 컴파일 시점에 체크되지 않는 예외
- 처리를 강제하지 않음 (선택적)
- RuntimeException을 상속하는 예외
- 프로그래밍 오류에 사용
- 예: NullPointerException, IllegalArgumentException, ArrayIndexOutOfBoundsException

```java
// 처리 선택적
public void divide(int a, int b) {
    return a / b; // ArithmeticException 발생 가능
}
```

**선택 기준**:
- 복구 가능한 외부 상황: Checked Exception
- 프로그래머의 실수, 복구 불가: Unchecked Exception

**계층 구조**: Throwable → Exception → RuntimeException (Unchecked) / IOException 등 (Checked)'
WHERE id = 'b0000000-0000-0000-0004-000000000029';

UPDATE questions SET explanation = '**사용자 정의 예외 만드는 방법**:

Exception 또는 RuntimeException을 상속받아 생성합니다.

```java
// Checked Exception
public class InvalidUserException extends Exception {
    public InvalidUserException(String message) {
        super(message);
    }

    public InvalidUserException(String message, Throwable cause) {
        super(message, cause);
    }
}

// Unchecked Exception (권장)
public class InsufficientBalanceException extends RuntimeException {
    private final long currentBalance;
    private final long requiredAmount;

    public InsufficientBalanceException(long currentBalance, long requiredAmount) {
        super("잔액 부족: 현재 " + currentBalance + ", 필요 " + requiredAmount);
        this.currentBalance = currentBalance;
        this.requiredAmount = requiredAmount;
    }

    public long getCurrentBalance() { return currentBalance; }
    public long getRequiredAmount() { return requiredAmount; }
}
```

**활용 사례**:

1. **도메인 비즈니스 로직 예외**:
```java
if (balance < amount) {
    throw new InsufficientBalanceException(balance, amount);
}
```

2. **유효성 검증 예외**:
```java
if (age < 0) {
    throw new InvalidAgeException("나이는 0 이상이어야 합니다");
}
```

3. **API 에러 응답 매핑**:
```java
@ExceptionHandler(InsufficientBalanceException.class)
public ResponseEntity<?> handleInsufficientBalance(InsufficientBalanceException e) {
    return ResponseEntity.badRequest().body(e.getMessage());
}
```

**장점**: 명확한 예외 의미 전달, 추가 정보 포함 가능, 예외별 처리 가능'
WHERE id = 'b0000000-0000-0000-0004-000000000030';

UPDATE questions SET explanation = 'JVM 메모리는 여러 영역으로 나뉘며, 스택과 힙은 가장 중요한 두 영역입니다.

**스택 영역 (Stack Area)**:
- **저장 내용**: 메서드 호출 정보, 지역 변수, 매개변수, 리턴 값
- **생명주기**: 메서드 실행 시 생성, 종료 시 자동 제거
- **스레드**: 각 스레드마다 독립적인 스택
- **크기**: 작음 (일반적으로 1MB)
- **접근 속도**: 빠름 (CPU 캐시 활용)
- **관리**: 컴파일 타임에 크기 결정, 자동 관리
- **에러**: StackOverflowError (재귀 호출 과다 등)

**힙 영역 (Heap Area)**:
- **저장 내용**: 모든 객체 인스턴스와 배열
- **생명주기**: 객체 생성 시 할당, GC에 의해 제거
- **스레드**: 모든 스레드가 공유
- **크기**: 큼 (수 GB까지 가능)
- **접근 속도**: 느림 (메인 메모리)
- **관리**: 런타임에 동적 할당, GC가 관리
- **에러**: OutOfMemoryError (메모리 부족)

**관계**:
```java
public void method() {
    int a = 10;              // Stack: 지역 변수 a
    String str = new String("hello"); // Stack: 참조 변수 str
                                     // Heap: String 객체
}
```

**비교 표**:
| 항목 | Stack | Heap |
|------|-------|------|
| 저장 대상 | 지역 변수, 메서드 정보 | 객체, 배열 |
| 공유 여부 | 스레드별 독립 | 모든 스레드 공유 |
| 크기 | 작음 | 큼 |
| 속도 | 빠름 | 느림 |
| 관리 | 자동 (컴파일러) | GC |'
WHERE id = 'b0000000-0000-0000-0004-000000000031';

UPDATE questions SET explanation = 'JVM의 가비지 컬렉터는 여러 알고리즘을 사용하며, 대표적인 알고리즘을 소개합니다.

**Serial GC**:
- 단일 스레드로 GC 수행
- Mark-Sweep-Compact 알고리즘 사용
- 작은 힙 메모리와 단일 CPU 환경에 적합
- Stop-The-World 시간이 길어질 수 있음

**Parallel GC (Throughput GC)**:
- 여러 스레드로 병렬 GC 수행
- Java 8의 기본 GC
- Young Generation을 병렬로 수집
- 처리량(Throughput) 최적화

**CMS GC (Concurrent Mark Sweep)**:
- 대부분의 작업을 애플리케이션 스레드와 동시에 수행
- Stop-The-World 시간 최소화 (응답 시간 중요 시)
- CPU 리소스를 더 많이 사용
- 메모리 단편화 발생 가능

**G1 GC (Garbage First)**:
- Java 9부터 기본 GC
- 힙을 여러 리전(Region)으로 나누어 관리
- 예측 가능한 Stop-The-World 시간
- 큰 힙 메모리에 적합 (4GB 이상)
- 가비지가 많은 리전을 우선 수집

**알고리즘 동작 (G1 GC 예시)**:
1. **Young GC**: Eden과 Survivor 리전에서 살아남은 객체를 다른 리전으로 이동
2. **Mixed GC**: Young + Old Generation 일부를 함께 수집
3. **Full GC**: 전체 힙 수집 (최대한 회피)

**선택 기준**:
- 단순 애플리케이션: Serial GC
- 처리량 중요: Parallel GC
- 응답 시간 중요: CMS GC 또는 G1 GC
- 큰 힙, 예측 가능한 지연: G1 GC'
WHERE id = 'b0000000-0000-0000-0004-000000000032';

UPDATE questions SET explanation = '**데드락(Deadlock)**:
두 개 이상의 스레드가 서로가 가진 락을 기다리며 무한 대기 상태에 빠지는 현상입니다.

**발생 조건 (4가지 모두 충족 시)**:
1. **상호 배제**: 자원을 동시에 사용할 수 없음
2. **점유와 대기**: 자원을 가진 상태에서 다른 자원을 기다림
3. **비선점**: 다른 스레드의 자원을 강제로 빼앗을 수 없음
4. **순환 대기**: 스레드들이 순환 형태로 자원을 기다림

**발생 예시**:
```java
// Thread 1
synchronized(lockA) {
    synchronized(lockB) { ... }
}

// Thread 2
synchronized(lockB) {
    synchronized(lockA) { ... } // 데드락!
}
```

**예방 방법**:

1. **락 순서 정하기**: 모든 스레드가 같은 순서로 락 획득
```java
// 항상 lockA → lockB 순서로
synchronized(lockA) {
    synchronized(lockB) { ... }
}
```

2. **타임아웃 설정**: Lock.tryLock(timeout) 사용
```java
if (lock.tryLock(10, TimeUnit.SECONDS)) {
    try { ... } finally { lock.unlock(); }
}
```

3. **락 최소화**: 필요한 부분만 동기화
4. **데드락 감지**: JConsole, VisualVM 등으로 스레드 덤프 분석
5. **락 없는 자료구조**: Atomic 클래스, ConcurrentHashMap 등 사용

**디버깅**:
- jstack으로 스레드 덤프 분석
- "Found one Java-level deadlock" 메시지 확인'
WHERE id = 'b0000000-0000-0000-0004-000000000033';

UPDATE questions SET explanation = '**스레드 풀(Thread Pool)**:
미리 생성된 스레드들을 풀에 보관하고 재사용하는 기법입니다.

**장점**:

1. **성능 향상**: 스레드 생성/삭제 오버헤드 감소
2. **자원 관리**: 동시 실행 스레드 수 제한으로 시스템 안정성 향상
3. **응답 시간 개선**: 스레드가 이미 생성되어 있어 작업 즉시 시작
4. **관리 편의성**: 스레드 생명주기를 풀이 관리

**동작 방식**:

1. 미리 정해진 수의 스레드를 생성하여 풀에 대기
2. 작업(Task)이 들어오면 유휴 스레드에 할당
3. 스레드가 작업 완료 후 풀로 반환
4. 모든 스레드가 사용 중이면 작업은 큐에서 대기

```java
// ExecutorService 사용
ExecutorService executor = Executors.newFixedThreadPool(10);

// 작업 제출
executor.submit(() -> {
    // 작업 내용
});

// 종료
executor.shutdown();
```

**주요 스레드 풀 타입**:

- **FixedThreadPool**: 고정된 수의 스레드
- **CachedThreadPool**: 필요에 따라 스레드 생성/제거
- **ScheduledThreadPool**: 지연/주기적 작업 실행
- **SingleThreadExecutor**: 단일 스레드로 순차 실행

**설정 고려사항**:
- CPU 집약적 작업: CPU 코어 수 + 1
- I/O 집약적 작업: CPU 코어 수 * 2 이상
- 큐 크기, 거부 정책(Rejection Policy) 설정'
WHERE id = 'b0000000-0000-0000-0004-000000000034';

UPDATE questions SET explanation = '**Executor Framework**:
Java 5부터 도입된 고수준의 동시성 프레임워크로, 스레드 관리를 추상화합니다.

**주요 구성 요소**:

1. **Executor 인터페이스**: 작업 실행을 추상화
```java
public interface Executor {
    void execute(Runnable command);
}
```

2. **ExecutorService**: Executor를 확장하여 생명주기 관리 추가
```java
ExecutorService executor = Executors.newFixedThreadPool(10);
Future<String> future = executor.submit(() -> "result");
executor.shutdown();
```

3. **ScheduledExecutorService**: 지연/주기적 작업 스케줄링
```java
ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
scheduler.schedule(() -> System.out.println("5초 후 실행"), 5, TimeUnit.SECONDS);
scheduler.scheduleAtFixedRate(() -> System.out.println("주기 실행"), 0, 1, TimeUnit.SECONDS);
```

4. **Future**: 비동기 작업의 결과를 나타냄
```java
Future<Integer> future = executor.submit(() -> {
    Thread.sleep(1000);
    return 42;
});
Integer result = future.get(); // 블로킹, 결과 대기
```

5. **Callable**: 결과를 반환하고 예외를 던질 수 있는 작업
```java
Callable<String> task = () -> {
    return "result";
};
```

**장점**:
- Thread 클래스 직접 사용보다 추상화 수준이 높음
- 스레드 풀 관리 자동화
- 작업 제출과 실행을 분리
- Future를 통한 비동기 결과 처리

**실무 활용**:
- 비동기 API 호출
- 배치 작업 처리
- 웹 요청 병렬 처리
- 스케줄링 작업'
WHERE id = 'b0000000-0000-0000-0004-000000000035';

UPDATE questions SET explanation = '**불변 객체(Immutable Object)**:
생성 후 상태를 변경할 수 없는 객체입니다.

**특징**:
- 모든 필드가 final이거나 private으로 보호됨
- setter 메서드가 없음
- 변경이 필요하면 새 객체를 생성하여 반환

**구현 방법**:
```java
public final class ImmutablePerson {
    private final String name;
    private final int age;

    public ImmutablePerson(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public String getName() { return name; }
    public int getAge() { return age; }

    // setter 없음
    // 변경이 필요하면 새 객체 반환
    public ImmutablePerson withAge(int newAge) {
        return new ImmutablePerson(this.name, newAge);
    }
}
```

**장점**:

1. **스레드 안전성**: 여러 스레드가 동시에 접근해도 안전 (동기화 불필요)
2. **캐싱 가능**: 동일한 값은 재사용 가능 (String pool처럼)
3. **HashMap 키로 안전**: 해시코드가 변하지 않음
4. **실패 원자성**: 예외 발생 시에도 객체 상태가 일관성 유지
5. **Side Effect 없음**: 메서드 호출이 객체 상태를 변경하지 않아 예측 가능

**대표적인 불변 객체**:
- String
- Integer, Long 등 Wrapper 클래스
- LocalDate, LocalDateTime (Java 8)
- BigInteger, BigDecimal

**주의사항**:
- 객체를 많이 생성하면 메모리/성능 오버헤드
- 가변 필드(배열, List 등)는 방어적 복사 필요
```java
private final List<String> items;

public ImmutableClass(List<String> items) {
    this.items = new ArrayList<>(items); // 방어적 복사
}

public List<String> getItems() {
    return new ArrayList<>(items); // 방어적 복사
}
```'
WHERE id = 'b0000000-0000-0000-0004-000000000036';

UPDATE questions SET explanation = '**serialVersionUID**:
직렬화된 객체의 버전을 식별하는 고유한 ID입니다.

**필요한 이유**:

1. **버전 호환성**: 클래스가 변경되었을 때 직렬화/역직렬화 호환성을 관리
2. **InvalidClassException 방지**: 클래스 구조가 다르면 역직렬화 시 예외 발생

**동작 원리**:
- 직렬화 시 serialVersionUID가 포함됨
- 역직렬화 시 저장된 UID와 현재 클래스의 UID를 비교
- 일치하지 않으면 InvalidClassException 발생

**사용 방법**:

```java
public class Person implements Serializable {
    // 명시적으로 선언 (권장)
    private static final long serialVersionUID = 1L;

    private String name;
    private int age;
}
```

**명시하지 않으면**:
- JVM이 자동으로 생성 (클래스 구조 기반 해시)
- 클래스가 조금만 변경되어도 UID가 달라짐
- 역직렬화 실패 가능성 높음

**버전 관리 전략**:

1. **호환되는 변경** (UID 유지):
   - 필드 추가 (기본값으로 초기화)
   - 메서드 추가/변경

2. **호환되지 않는 변경** (UID 증가):
   - 필드 타입 변경
   - 필드 삭제
   - 클래스 계층 구조 변경

```java
// 버전 1
private static final long serialVersionUID = 1L;
private String name;

// 버전 2 (필드 추가, UID 유지)
private static final long serialVersionUID = 1L;
private String name;
private int age; // 역직렬화 시 기본값 0

// 버전 3 (타입 변경, UID 변경)
private static final long serialVersionUID = 2L;
private String name;
private long age; // int → long (호환 불가)
```

**Best Practice**: 항상 명시적으로 serialVersionUID를 선언하고 관리'
WHERE id = 'b0000000-0000-0000-0004-000000000037';

UPDATE questions SET explanation = '**와일드카드 타입**:
제네릭 타입에서 유연성을 위해 사용하는 특수 타입 매개변수입니다.

**`List<? extends Number>`** (Upper Bounded Wildcard):
- **의미**: Number 또는 Number의 하위 타입 (Integer, Double 등)
- **읽기**: 안전 (Number 타입으로 읽기 가능)
- **쓰기**: 불가능 (어떤 하위 타입인지 알 수 없음)
- **사용 시기**: Producer (데이터를 제공, 읽기 전용)

```java
List<? extends Number> list = new ArrayList<Integer>();
Number num = list.get(0); // OK - Number로 읽기
// list.add(10); // 컴파일 에러 - 쓰기 불가
// list.add(new Integer(10)); // 컴파일 에러
```

**`List<? super Number>`** (Lower Bounded Wildcard):
- **의미**: Number 또는 Number의 상위 타입 (Object 등)
- **읽기**: 제한적 (Object로만 읽기 가능)
- **쓰기**: 안전 (Number 또는 하위 타입 추가 가능)
- **사용 시기**: Consumer (데이터를 소비, 쓰기 전용)

```java
List<? super Number> list = new ArrayList<Object>();
list.add(10); // OK - Integer는 Number의 하위 타입
list.add(3.14); // OK - Double도 Number의 하위 타입
// Number num = list.get(0); // 컴파일 에러
Object obj = list.get(0); // OK - Object로만 읽기 가능
```

**PECS 원칙** (Producer-Extends, Consumer-Super):
- **Producer**: 데이터를 제공 → `<? extends T>` 사용
- **Consumer**: 데이터를 소비 → `<? super T>` 사용

```java
// 복사 메서드 예시
public static <T> void copy(
    List<? extends T> src,  // Producer
    List<? super T> dest    // Consumer
) {
    for (T item : src) {
        dest.add(item);
    }
}

List<Integer> integers = Arrays.asList(1, 2, 3);
List<Number> numbers = new ArrayList<>();
copy(integers, numbers); // OK
```

**비교 표**:
| 항목 | extends | super |
|------|---------|-------|
| 의미 | 상한 제한 | 하한 제한 |
| 읽기 | 안전 (상위 타입으로) | 제한적 (Object로만) |
| 쓰기 | 불가 | 안전 (하위 타입으로) |
| 용도 | Producer (제공자) | Consumer (소비자) |'
WHERE id = 'b0000000-0000-0000-0004-000000000038';

UPDATE questions SET explanation = '**리플렉션(Reflection)**:
런타임에 클래스, 메서드, 필드 등의 정보를 검사하고 조작할 수 있는 기능입니다.

**주요 기능**:

1. **클래스 정보 조회**:
```java
Class<?> clazz = Class.forName("com.example.Person");
String className = clazz.getName();
Method[] methods = clazz.getDeclaredMethods();
Field[] fields = clazz.getDeclaredFields();
```

2. **객체 생성**:
```java
Class<?> clazz = Person.class;
Person person = (Person) clazz.getDeclaredConstructor().newInstance();
```

3. **메서드 호출**:
```java
Method method = clazz.getMethod("getName");
Object result = method.invoke(person);
```

4. **필드 접근** (private도 가능):
```java
Field field = clazz.getDeclaredField("name");
field.setAccessible(true); // private 필드 접근
field.set(person, "John");
```

**활용 사례**:
- Spring Framework (DI, AOP)
- JPA/Hibernate (엔티티 매핑)
- JUnit (테스트 실행)
- JSON 라이브러리 (Jackson, Gson)
- 플러그인 시스템

**주의할 점**:

1. **성능**: 일반 메서드 호출보다 느림 (최적화 불가)
2. **보안**: 캡슐화 깨짐 (private 접근 가능)
3. **컴파일 타임 체크 불가**: 런타임 오류 발생 가능
4. **코드 가독성**: 복잡하고 이해하기 어려움
5. **보안 관리자**: SecurityManager가 있으면 제한될 수 있음

**Best Practice**:
- 꼭 필요한 경우에만 사용
- 프레임워크/라이브러리 개발에 주로 사용
- 일반 애플리케이션 코드에서는 지양
- 캐싱으로 성능 개선 (Class, Method 객체 재사용)'
WHERE id = 'b0000000-0000-0000-0004-000000000039';

UPDATE questions SET explanation = '**네이티브 메서드(Native Method)**:
Java 코드에서 C/C++ 등 다른 언어로 작성된 코드를 호출하는 메서드입니다.

**정의**:
```java
public class Example {
    // native 키워드 사용, 구현은 C/C++에서
    public native void nativeMethod();

    static {
        System.loadLibrary("native-lib"); // 네이티브 라이브러리 로드
    }
}
```

**JNI (Java Native Interface)**:
- Java와 네이티브 코드를 연결하는 인터페이스
- `.h` 헤더 파일 생성 → C/C++로 구현 → 공유 라이브러리(.so, .dll) 컴파일

**사용하는 경우**:

1. **성능이 중요한 작업**: C/C++가 Java보다 빠른 경우
2. **하드웨어 직접 제어**: 운영체제 API, 디바이스 드라이버
3. **기존 라이브러리 활용**: C/C++ 라이브러리를 Java에서 사용
4. **플랫폼 특화 기능**: Windows API, Linux 시스템 콜 등

**Java 내부 예시**:
```java
// Object.class의 hashCode()
public native int hashCode();

// System.class의 arraycopy()
public static native void arraycopy(...);

// Thread.class의 start0()
private native void start0();
```

**단점**:
- 플랫폼 독립성 상실 (OS별로 다른 라이브러리 필요)
- 보안 위험 (JVM 보호 벗어남)
- 디버깅 어려움
- JVM 크래시 가능성 (네이티브 코드 오류 시)
- 복잡한 개발 과정

**대안**:
- JNA (Java Native Access): JNI보다 쉬운 사용
- Java 9+의 성능 개선으로 필요성 감소
- 웬만하면 순수 Java로 구현 권장'
WHERE id = 'b0000000-0000-0000-0004-000000000040';

UPDATE questions SET explanation = '**JIT 컴파일러 (Just-In-Time Compiler)**:
Java 바이트코드를 런타임에 네이티브 기계어로 컴파일하여 실행 성능을 향상시키는 컴파일러입니다.

**동작 방식**:

1. **초기 실행**: 바이트코드를 인터프리터로 실행
2. **핫스팟 감지**: 자주 실행되는 코드(Hot Spot) 식별
3. **네이티브 컴파일**: 핫스팟을 기계어로 컴파일
4. **캐싱**: 컴파일된 코드를 메모리에 저장
5. **재실행**: 이후 같은 코드는 컴파일된 기계어로 실행

**JVM 실행 흐름**:
```
.java 파일
   ↓ (javac)
.class 파일 (바이트코드)
   ↓ (JVM 로드)
인터프리터 실행 (느림)
   ↓ (JIT 컴파일러)
네이티브 기계어 (빠름)
```

**장점**:

1. **성능 향상**: 반복 실행되는 코드를 네이티브로 최적화
2. **적응적 최적화**: 런타임 정보를 활용하여 최적화 (정적 컴파일러보다 유리)
3. **메서드 인라이닝**: 자주 호출되는 메서드를 호출 위치에 직접 삽입
4. **데드 코드 제거**: 실행되지 않는 코드 제거
5. **분기 예측**: 자주 가는 경로 최적화

**JIT 컴파일러 종류 (HotSpot JVM)**:

- **C1 (Client Compiler)**: 빠른 시작, 기본 최적화
- **C2 (Server Compiler)**: 느린 시작, 강력한 최적화
- **Tiered Compilation**: C1 + C2 조합 (Java 8+ 기본)

**프로파일링 기반 최적화**:
- 메서드 호출 빈도
- 분기 경로 통계
- 타입 정보 등을 수집하여 최적화

**단점**:
- 컴파일 시간으로 인한 초기 성능 저하 (Warm-up 필요)
- 메모리 사용량 증가 (컴파일된 코드 저장)

**실무 팁**: 성능 벤치마크 시 충분한 워밍업 후 측정'
WHERE id = 'b0000000-0000-0000-0004-000000000041';

UPDATE questions SET explanation = '**동적 로딩(Dynamic Class Loading)**:
프로그램 실행 중에 필요한 클래스를 런타임에 로드하는 기법입니다.

**특징**:
- 컴파일 타임이 아닌 런타임에 클래스 로드
- 메모리 효율적 (필요할 때만 로드)
- 유연한 아키텍처 (플러그인, 확장 가능)

**클래스 로딩 과정**:

1. **Loading**: 클래스 파일을 읽어 메모리에 로드
2. **Linking**:
   - Verification: 바이트코드 검증
   - Preparation: static 변수 메모리 할당
   - Resolution: 심볼릭 참조를 실제 참조로 변환
3. **Initialization**: static 초기화 블록 실행

**동적 로딩 방법**:

1. **Class.forName()**:
```java
// 클래스 로드 및 초기화
Class<?> clazz = Class.forName("com.example.MyClass");
Object obj = clazz.getDeclaredConstructor().newInstance();
```

2. **ClassLoader.loadClass()**:
```java
// 클래스 로드만 (초기화 안함)
ClassLoader classLoader = ClassLoader.getSystemClassLoader();
Class<?> clazz = classLoader.loadClass("com.example.MyClass");
```

**활용 사례**:

1. **JDBC 드라이버 로딩**:
```java
Class.forName("com.mysql.cj.jdbc.Driver");
// 이제는 자동으로 로드되어 불필요
```

2. **플러그인 시스템**:
```java
File pluginDir = new File("plugins");
URL[] urls = {pluginDir.toURI().toURL()};
URLClassLoader loader = new URLClassLoader(urls);
Class<?> pluginClass = loader.loadClass("com.example.Plugin");
```

3. **의존성 주입 프레임워크**: Spring, Guice 등

**ClassLoader 계층**:
- Bootstrap ClassLoader (최상위, JDK 클래스)
- Extension ClassLoader (확장 라이브러리)
- Application ClassLoader (애플리케이션 클래스)
- Custom ClassLoader (사용자 정의)

**장점**: 유연성, 메모리 효율, 모듈화
**단점**: 성능 오버헤드, 복잡성, ClassNotFoundException 처리 필요'
WHERE id = 'b0000000-0000-0000-0004-000000000042';

UPDATE questions SET explanation = '**메소드 오버로딩 (Overloading)**:
같은 이름의 메서드를 매개변수를 다르게 하여 여러 개 정의하는 것입니다.

**특징**:
- **같은 클래스** 내에서 정의
- **컴파일 타임**에 결정 (정적 바인딩)
- 메서드 이름은 같지만, **매개변수 타입, 개수, 순서**가 달라야 함
- 리턴 타입만 다른 것은 오버로딩 아님
- 접근 제어자는 관계없음

```java
public class Calculator {
    public int add(int a, int b) {
        return a + b;
    }

    public double add(double a, double b) { // 타입 다름
        return a + b;
    }

    public int add(int a, int b, int c) { // 개수 다름
        return a + b + c;
    }
}
```

**메소드 오버라이딩 (Overriding)**:
부모 클래스의 메서드를 자식 클래스에서 재정의하는 것입니다.

**특징**:
- **상속 관계**에서만 가능
- **런타임**에 결정 (동적 바인딩)
- 메서드 **시그니처가 동일**해야 함 (이름, 매개변수)
- 리턴 타입은 같거나 하위 타입 (공변 반환 타입)
- 접근 제어자는 같거나 더 넓어야 함
- `@Override` 애노테이션 사용 권장

```java
public class Animal {
    public void makeSound() {
        System.out.println("동물 소리");
    }
}

public class Dog extends Animal {
    @Override
    public void makeSound() { // 재정의
        System.out.println("멍멍");
    }
}
```

**비교 표**:
| 항목 | Overloading | Overriding |
|------|-------------|------------|
| 위치 | 같은 클래스 | 상속 관계 |
| 메서드 이름 | 같음 | 같음 |
| 매개변수 | 달라야 함 | 같아야 함 |
| 리턴 타입 | 관계없음 | 같거나 하위 타입 |
| 바인딩 | 컴파일 타임 (정적) | 런타임 (동적) |
| 목적 | 같은 기능, 다른 입력 | 부모 기능 재정의 |'
WHERE id = 'b0000000-0000-0000-0004-000000000043';

UPDATE questions SET explanation = '접근 제어자는 클래스, 메서드, 변수의 접근 범위를 제어합니다.

**public**:
- 모든 곳에서 접근 가능
- 다른 패키지에서도 접근 가능
- 주로 API, 인터페이스에 사용

```java
public class PublicClass {
    public int publicField;
    public void publicMethod() { }
}
```

**protected**:
- 같은 패키지 내에서 접근 가능
- **다른 패키지의 자식 클래스**에서도 접근 가능
- 상속을 통한 확장을 위해 사용

```java
public class Parent {
    protected int protectedField;
    protected void protectedMethod() { }
}

// 다른 패키지
public class Child extends Parent {
    public void test() {
        this.protectedField = 10; // OK - 상속받았으므로
    }
}
```

**default (package-private)**:
- 접근 제어자를 명시하지 않은 경우
- **같은 패키지 내에서만** 접근 가능
- 패키지 내부 구현에 사용

```java
class DefaultClass { // default
    int defaultField; // default
    void defaultMethod() { } // default
}
```

**private**:
- **같은 클래스 내에서만** 접근 가능
- 가장 강한 제한
- 캡슐화를 위해 사용

```java
public class Example {
    private int privateField;
    private void privateMethod() { }

    public int getPrivateField() { // getter로 접근 제공
        return privateField;
    }
}
```

**접근 범위 (넓은 순서)**:
```
public > protected > default > private
```

**비교 표**:
| 접근 제어자 | 같은 클래스 | 같은 패키지 | 자식 클래스 | 전체 |
|------------|-----------|-----------|-----------|------|
| public | O | O | O | O |
| protected | O | O | O | X |
| default | O | O | X | X |
| private | O | X | X | X |

**설계 원칙**:
- 최소 권한 원칙: 가능한 가장 제한적인 접근 제어자 사용
- 필드는 private, 메서드로 접근 (Getter/Setter)
- 상속을 고려한 확장 포인트는 protected'
WHERE id = 'b0000000-0000-0000-0004-000000000044';

UPDATE questions SET explanation = '**추상 클래스 (Abstract Class)**:
```java
public abstract class Animal {
    private String name; // 필드 가능

    public Animal(String name) { // 생성자 가능
        this.name = name;
    }

    public abstract void makeSound(); // 추상 메서드

    public void sleep() { // 구현 메서드 가능
        System.out.println("잠을 잔다");
    }
}

public class Dog extends Animal { // extends
    public Dog() {
        super("강아지");
    }

    @Override
    public void makeSound() {
        System.out.println("멍멍");
    }
}
```

**특징**:
- `abstract` 키워드 사용
- 추상 메서드와 구현 메서드를 모두 가질 수 있음
- 필드, 생성자, static 메서드 가능
- **단일 상속**만 가능 (extends 하나만)
- 객체 생성 불가

**인터페이스 (Interface)**:
```java
public interface Flyable {
    // 모든 필드는 public static final
    int MAX_HEIGHT = 1000;

    // 추상 메서드 (public abstract 생략 가능)
    void fly();

    // Java 8+: 디폴트 메서드
    default void land() {
        System.out.println("착륙한다");
    }

    // Java 8+: static 메서드
    static void checkWeather() {
        System.out.println("날씨 확인");
    }
}

public class Bird implements Flyable { // implements
    @Override
    public void fly() {
        System.out.println("날아간다");
    }
}
```

**특징**:
- `interface` 키워드 사용
- 모든 메서드는 기본적으로 public abstract (Java 8+ 예외)
- 모든 필드는 public static final (상수만 가능)
- 생성자 없음
- **다중 구현** 가능 (implements 여러 개)
- Java 8+: default 메서드, static 메서드 가능
- Java 9+: private 메서드 가능

**비교 표**:
| 항목 | Abstract Class | Interface |
|------|---------------|-----------|
| 키워드 | abstract | interface |
| 상속/구현 | extends (단일) | implements (다중) |
| 필드 | 일반 필드 가능 | public static final만 |
| 생성자 | 가능 | 불가능 |
| 메서드 | 추상 + 구현 모두 | 추상 (+ default, static) |
| 접근 제어자 | 다양 | 기본 public |

**선택 기준**:
- **추상 클래스**: "is-a" 관계, 공통 구현 공유, 상태(필드) 필요
- **인터페이스**: "can-do" 관계, 다중 구현, 계약(Contract) 정의

**실무 예시**:
```java
// 추상 클래스: 공통 구현
abstract class Vehicle {
    protected int speed;
    public void accelerate() { speed += 10; }
    public abstract void brake();
}

// 인터페이스: 능력 정의
interface Flyable { void fly(); }
interface Swimmable { void swim(); }

// 다중 구현
class Duck extends Animal implements Flyable, Swimmable {
    public void fly() { }
    public void swim() { }
}
```'
WHERE id = 'b0000000-0000-0000-0004-000000000045';

UPDATE questions SET explanation = '**함수형 인터페이스 (Functional Interface)**:
단 하나의 추상 메서드만 가지는 인터페이스입니다. Java 8의 람다식과 함께 사용됩니다.

**정의**:
```java
@FunctionalInterface // 선택적이지만 권장
public interface MyFunction {
    int apply(int x, int y); // 단일 추상 메서드 (SAM)

    // default, static 메서드는 있어도 됨
    default void printResult(int result) {
        System.out.println(result);
    }

    static void staticMethod() { }
}
```

**@FunctionalInterface 애노테이션**:
- 컴파일러가 함수형 인터페이스 규칙 검증
- 두 개 이상의 추상 메서드가 있으면 컴파일 에러

**사용 방법**:

```java
// 1. 익명 클래스 (기존 방식)
MyFunction func1 = new MyFunction() {
    @Override
    public int apply(int x, int y) {
        return x + y;
    }
};

// 2. 람다식 (간결)
MyFunction func2 = (x, y) -> x + y;

// 3. 메서드 참조
MyFunction func3 = Math::max;

// 사용
int result = func2.apply(3, 5); // 8
```

**Java 기본 제공 함수형 인터페이스** (java.util.function):

**1. Predicate<T>**: 조건 검사
```java
Predicate<Integer> isPositive = x -> x > 0;
boolean result = isPositive.test(10); // true
```

**2. Function<T, R>**: 변환
```java
Function<String, Integer> strLength = s -> s.length();
int length = strLength.apply("hello"); // 5
```

**3. Consumer<T>**: 소비 (리턴 없음)
```java
Consumer<String> printer = s -> System.out.println(s);
printer.accept("hello");
```

**4. Supplier<T>**: 공급 (파라미터 없음)
```java
Supplier<Double> randomValue = () -> Math.random();
double value = randomValue.get();
```

**5. UnaryOperator<T>**: 단항 연산 (입력/출력 타입 같음)
```java
UnaryOperator<Integer> square = x -> x * x;
int result = square.apply(5); // 25
```

**6. BinaryOperator<T>**: 이항 연산 (입력/출력 타입 같음)
```java
BinaryOperator<Integer> add = (x, y) -> x + y;
int result = add.apply(3, 5); // 8
```

**장점**:
- 람다식 사용 가능
- 코드 간결성
- 함수형 프로그래밍 지원
- Stream API와 완벽한 호환

**실무 활용**:
```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);

// Predicate
numbers.stream().filter(x -> x > 3).collect(Collectors.toList());

// Function
numbers.stream().map(x -> x * 2).collect(Collectors.toList());

// Consumer
numbers.forEach(x -> System.out.println(x));
```'
WHERE id = 'b0000000-0000-0000-0004-000000000046';

UPDATE questions SET explanation = '**JDBC (Java Database Connectivity)**:
Java에서 데이터베이스에 접속하고 SQL을 실행하기 위한 표준 API입니다.

**주요 기능**:

1. **데이터베이스 연결**: DriverManager, Connection
2. **SQL 실행**: Statement, PreparedStatement, CallableStatement
3. **결과 처리**: ResultSet
4. **트랜잭션 관리**: commit, rollback
5. **메타데이터 조회**: DatabaseMetaData, ResultSetMetaData

**사용 흐름**:

```java
// 1. 드라이버 로드 (Java 6+ 자동 로드)
Class.forName("com.mysql.cj.jdbc.Driver");

// 2. 연결 생성
Connection conn = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/mydb",
    "username",
    "password"
);

// 3. Statement 생성
PreparedStatement pstmt = conn.prepareStatement(
    "SELECT * FROM users WHERE id = ?"
);
pstmt.setInt(1, 1);

// 4. SQL 실행
ResultSet rs = pstmt.executeQuery();

// 5. 결과 처리
while (rs.next()) {
    int id = rs.getInt("id");
    String name = rs.getString("name");
    System.out.println(id + ": " + name);
}

// 6. 자원 정리
rs.close();
pstmt.close();
conn.close();
```

**Try-with-resources 사용 (권장)**:
```java
try (Connection conn = DriverManager.getConnection(url, user, password);
     PreparedStatement pstmt = conn.prepareStatement(sql);
     ResultSet rs = pstmt.executeQuery()) {

    while (rs.next()) {
        // 결과 처리
    }
} // 자동으로 close() 호출
```

**Statement 종류**:

1. **Statement**: 정적 SQL
```java
Statement stmt = conn.createStatement();
ResultSet rs = stmt.executeQuery("SELECT * FROM users");
```

2. **PreparedStatement**: 파라미터화된 SQL (권장)
```java
PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
pstmt.setInt(1, 1);
// SQL Injection 방지, 성능 향상
```

3. **CallableStatement**: 저장 프로시저 호출
```java
CallableStatement cstmt = conn.prepareCall("{call getUserById(?)}");
cstmt.setInt(1, 1);
```

**트랜잭션 관리**:
```java
conn.setAutoCommit(false);
try {
    // 여러 SQL 실행
    stmt1.executeUpdate(...);
    stmt2.executeUpdate(...);
    conn.commit(); // 성공 시 커밋
} catch (Exception e) {
    conn.rollback(); // 실패 시 롤백
}
```

**장점**: 데이터베이스 독립성, 표준 API
**단점**: 반복적인 코드, Low-level API (현재는 JPA, MyBatis 등 사용)'
WHERE id = 'b0000000-0000-0000-0004-000000000047';

UPDATE questions SET explanation = '**JMS (Java Message Service)**:
Java에서 메시지 기반 통신을 위한 표준 API로, 비동기 메시징을 지원합니다.

**주요 개념**:

1. **메시지 모델**:
   - **Point-to-Point (Queue)**: 1:1 통신, 하나의 Consumer만 메시지 수신
   - **Publish-Subscribe (Topic)**: 1:N 통신, 여러 Subscriber가 메시지 수신

2. **주요 구성 요소**:
   - **ConnectionFactory**: JMS 연결 생성
   - **Connection**: JMS 서버와의 연결
   - **Session**: 메시지 송수신 세션
   - **Destination**: Queue 또는 Topic
   - **MessageProducer**: 메시지 발송자
   - **MessageConsumer**: 메시지 수신자
   - **Message**: 전송되는 메시지

**사용 예시**:

**Producer (발송자)**:
```java
// 1. ConnectionFactory 조회 (JNDI)
ConnectionFactory factory = (ConnectionFactory) ctx.lookup("ConnectionFactory");
Queue queue = (Queue) ctx.lookup("MyQueue");

// 2. Connection 생성
Connection connection = factory.createConnection();
connection.start();

// 3. Session 생성
Session session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);

// 4. MessageProducer 생성
MessageProducer producer = session.createProducer(queue);

// 5. 메시지 생성 및 발송
TextMessage message = session.createTextMessage("Hello JMS");
producer.send(message);

// 6. 자원 정리
producer.close();
session.close();
connection.close();
```

**Consumer (수신자)**:
```java
// 동기 수신
MessageConsumer consumer = session.createConsumer(queue);
Message message = consumer.receive(); // 블로킹

// 비동기 수신 (MessageListener)
consumer.setMessageListener(new MessageListener() {
    public void onMessage(Message message) {
        TextMessage textMsg = (TextMessage) message;
        System.out.println(textMsg.getText());
    }
});
```

**메시지 타입**:
- **TextMessage**: 문자열
- **ObjectMessage**: 직렬화된 객체
- **BytesMessage**: 바이트 배열
- **MapMessage**: Key-Value 맵
- **StreamMessage**: 스트림 데이터

**사용 사례**:

1. **비동기 작업 처리**:
   - 이메일 발송, 알림 전송
   - 시간이 오래 걸리는 작업을 백그라운드로

2. **시스템 간 통합**:
   - 마이크로서비스 간 통신
   - 레거시 시스템과 연동

3. **부하 분산**:
   - 여러 Consumer가 Queue에서 메시지를 나눠서 처리

4. **이벤트 드리븐 아키텍처**:
   - 주문 완료 → 재고 감소, 배송 시작 등의 이벤트 처리

**구현체 (Message Broker)**:
- ActiveMQ
- RabbitMQ
- IBM MQ
- Apache Kafka (JMS 호환)

**현대적 대안**:
- Spring AMQP (RabbitMQ)
- Spring Kafka
- AWS SQS, Google Pub/Sub'
WHERE id = 'b0000000-0000-0000-0004-000000000048';

UPDATE questions SET explanation = '**단위 테스트 프레임워크**:
개별 코드 단위(메서드, 클래스)를 자동으로 테스트하는 도구입니다.

**JUnit 역할**:

1. **테스트 자동화**: 반복 실행 가능한 테스트
2. **회귀 테스트**: 코드 변경 시 기존 기능 검증
3. **문서화**: 테스트 코드가 사용 예시 역할
4. **설계 개선**: 테스트하기 쉬운 코드 = 좋은 설계
5. **빠른 피드백**: 버그를 조기에 발견

**JUnit 5 사용 예시**:

```java
import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

class CalculatorTest {

    private Calculator calculator;

    @BeforeEach // 각 테스트 전에 실행
    void setUp() {
        calculator = new Calculator();
    }

    @Test // 테스트 메서드
    @DisplayName("두 수의 덧셈 테스트")
    void testAdd() {
        // Given (준비)
        int a = 5;
        int b = 3;

        // When (실행)
        int result = calculator.add(a, b);

        // Then (검증)
        assertEquals(8, result);
    }

    @Test
    void testDivideByZero() {
        // 예외 발생 검증
        assertThrows(ArithmeticException.class, () -> {
            calculator.divide(10, 0);
        });
    }

    @ParameterizedTest
    @ValueSource(ints = {1, 2, 3, 4, 5})
    void testIsPositive(int number) {
        assertTrue(calculator.isPositive(number));
    }

    @AfterEach // 각 테스트 후에 실행
    void tearDown() {
        calculator = null;
    }
}
```

**주요 애노테이션**:

- `@Test`: 테스트 메서드
- `@BeforeEach` / `@AfterEach`: 각 테스트 전후 실행
- `@BeforeAll` / `@AfterAll`: 전체 테스트 전후 실행 (static)
- `@DisplayName`: 테스트 이름 설정
- `@Disabled`: 테스트 비활성화
- `@ParameterizedTest`: 여러 파라미터로 반복 테스트

**주요 Assertion 메서드**:

```java
assertEquals(expected, actual); // 같은지
assertNotEquals(expected, actual); // 다른지
assertTrue(condition); // true인지
assertFalse(condition); // false인지
assertNull(object); // null인지
assertNotNull(object); // null이 아닌지
assertThrows(Exception.class, () -> {}); // 예외 발생하는지
assertAll( // 여러 검증을 한 번에
    () -> assertEquals(2, 1 + 1),
    () -> assertTrue(true)
);
```

**테스트 주도 개발 (TDD)**:
1. **Red**: 실패하는 테스트 작성
2. **Green**: 테스트를 통과하는 최소한의 코드 작성
3. **Refactor**: 코드 개선 (테스트는 통과 유지)

**Mock 프레임워크 (Mockito)**:
```java
@Mock
private UserRepository userRepository;

@Test
void testFindUser() {
    // Mock 동작 정의
    when(userRepository.findById(1L))
        .thenReturn(Optional.of(new User("John")));

    // 테스트 실행
    User user = userService.getUser(1L);

    // 검증
    assertEquals("John", user.getName());
    verify(userRepository).findById(1L); // 호출 확인
}
```

**장점**:
- 버그 조기 발견
- 리팩토링 안전성
- 코드 품질 향상
- 개발 속도 향상 (장기적)

**Best Practices**:
- 테스트는 독립적이어야 함
- 빠르게 실행되어야 함
- 반복 가능해야 함
- 명확한 이름 사용
- Given-When-Then 패턴 사용'
WHERE id = 'b0000000-0000-0000-0004-000000000049';

UPDATE questions SET explanation = '**JVM 튜닝 (성능 최적화)**:
애플리케이션의 요구사항에 맞게 JVM 설정을 조정하여 성능을 향상시키는 작업입니다.

**고려 요소**:

**1. 힙 메모리 크기 설정**:
```bash
# 초기 힙 크기
-Xms2g

# 최대 힙 크기
-Xmx4g

# Young Generation 크기
-Xmn1g

# Best Practice: Xms와 Xmx를 같게 설정 (메모리 재할당 방지)
-Xms4g -Xmx4g
```

**2. GC (Garbage Collector) 선택**:
```bash
# G1 GC (Java 9+ 기본, 대부분 권장)
-XX:+UseG1GC

# Parallel GC (처리량 중요 시)
-XX:+UseParallelGC

# ZGC (매우 낮은 지연시간 필요 시, Java 11+)
-XX:+UseZGC

# Shenandoah GC (낮은 지연시간, Java 12+)
-XX:+UseShenandoahGC
```

**3. GC 로깅 및 모니터링**:
```bash
# GC 로그 활성화 (Java 9+)
-Xlog:gc*:file=gc.log:time,uptime,level,tags

# GC 로그 (Java 8)
-XX:+PrintGCDetails
-XX:+PrintGCDateStamps
-Xloggc:gc.log

# GC 일시 정지 시간 목표 (G1 GC)
-XX:MaxGCPauseMillis=200
```

**4. 스레드 스택 크기**:
```bash
# 스레드 스택 크기 (기본 1MB)
-Xss512k # 스레드가 많으면 줄임
```

**5. 메타스페이스 (Java 8+)**:
```bash
# 초기 크기
-XX:MetaspaceSize=256m

# 최대 크기
-XX:MaxMetaspaceSize=512m
```

**6. JIT 컴파일러 최적화**:
```bash
# Tiered Compilation (기본 활성화)
-XX:+TieredCompilation

# 컴파일 임계값 조정
-XX:CompileThreshold=10000
```

**7. 대용량 페이지 사용**:
```bash
# 성능 향상 (OS 지원 필요)
-XX:+UseLargePages
```

**성능 분석 도구**:

1. **JConsole**: JVM 모니터링 (힙, 스레드, 클래스)
2. **VisualVM**: 프로파일링, 힙 덤프 분석
3. **JProfiler / YourKit**: 상용 프로파일러
4. **Java Flight Recorder (JFR)**: 프로덕션 환경 모니터링
5. **GC 로그 분석**: GCViewer, GCEasy

**튜닝 프로세스**:

1. **현재 상태 측정**:
   - GC 빈도와 시간
   - 힙 사용량
   - 응답 시간
   - 처리량

2. **병목 지점 식별**:
   - GC 로그 분석
   - 프로파일링
   - 힙 덤프 분석

3. **설정 변경**:
   - 힙 크기 조정
   - GC 알고리즘 변경
   - 기타 JVM 옵션 튜닝

4. **테스트 및 검증**:
   - 부하 테스트
   - 성능 메트릭 비교

5. **반복**: 목표 달성까지 반복

**실무 예시 (Spring Boot 애플리케이션)**:
```bash
java -Xms4g -Xmx4g \
     -XX:+UseG1GC \
     -XX:MaxGCPauseMillis=200 \
     -XX:MetaspaceSize=256m \
     -XX:MaxMetaspaceSize=512m \
     -Xlog:gc*:file=gc.log \
     -jar application.jar
```

**최적화 목표에 따른 선택**:
- **응답 시간 중요**: G1 GC, ZGC
- **처리량 중요**: Parallel GC
- **메모리 적음**: Serial GC
- **예측 가능한 지연**: G1 GC with MaxGCPauseMillis'
WHERE id = 'b0000000-0000-0000-0004-000000000050';

UPDATE questions SET explanation = '**메모리 누수(Memory Leak)**:
더 이상 사용되지 않는 객체가 GC에 의해 수거되지 못하고 메모리에 계속 남아있는 현상입니다.

**주요 원인**:

1. **Static 컬렉션에 객체 계속 추가**:
```java
// 나쁜 예
public class Cache {
    private static Map<String, Object> cache = new HashMap<>();

    public void add(String key, Object value) {
        cache.put(key, value); // 계속 쌓임, 제거되지 않음
    }
}
```

2. **리스너/콜백 등록 후 해제하지 않음**:
```java
button.addActionListener(listener);
// 사용 후 button.removeActionListener(listener); 호출 안 함
```

3. **ThreadLocal 사용 후 제거 안 함**:
```java
ThreadLocal<User> userContext = new ThreadLocal<>();
userContext.set(user);
// 사용 후 userContext.remove(); 호출 안 함
```

4. **스트림/커넥션 닫지 않음**:
```java
Connection conn = getConnection();
// 사용 후 conn.close(); 호출 안 함
```

5. **내부 클래스의 외부 참조**:
```java
public class Outer {
    class Inner { } // 자동으로 Outer 참조 보유
}
```

**진단 방법**:

**1. 증상 확인**:
- OutOfMemoryError 발생
- 힙 메모리 사용량이 계속 증가
- GC가 빈번하게 발생하지만 메모리 회수 안 됨
- 애플리케이션 점점 느려짐

**2. 힙 덤프 생성**:
```bash
# 수동 덤프
jmap -dump:format=b,file=heap.bin <pid>

# OOM 시 자동 덤프
-XX:+HeapDumpOnOutOfMemoryError
-XX:HeapDumpPath=/path/to/dumps
```

**3. 힙 덤프 분석 도구**:
- **Eclipse MAT (Memory Analyzer Tool)**: 강력한 분석 기능
- **VisualVM**: 실시간 모니터링 및 분석
- **JProfiler / YourKit**: 상용 프로파일러

**4. MAT 분석 단계**:
```
1. Leak Suspects Report 실행
2. Dominator Tree 확인 (메모리 많이 차지하는 객체)
3. Path to GC Roots 추적 (왜 수거 안 되는지)
4. Thread Overview로 ThreadLocal 누수 확인
```

**해결 방법**:

**1. WeakHashMap 사용**:
```java
// 캐시에 WeakHashMap 사용
private Map<String, Object> cache = new WeakHashMap<>();
// 키가 더 이상 참조되지 않으면 자동 제거
```

**2. 명시적 제거**:
```java
public void cleanup() {
    listener.remove();
    threadLocal.remove();
    connection.close();
}
```

**3. Try-with-resources 사용**:
```java
try (Connection conn = getConnection();
     PreparedStatement ps = conn.prepareStatement(sql)) {
    // 자동으로 close() 호출
}
```

**4. Static 컬렉션 크기 제한**:
```java
// LRU 캐시 사용
Map<String, Object> cache = Collections.synchronizedMap(
    new LinkedHashMap<>(16, 0.75f, true) {
        protected boolean removeEldestEntry(Map.Entry eldest) {
            return size() > MAX_SIZE;
        }
    }
);
```

**5. Guava Cache 사용**:
```java
LoadingCache<String, Object> cache = CacheBuilder.newBuilder()
    .maximumSize(1000)
    .expireAfterWrite(10, TimeUnit.MINUTES)
    .build(...);
```

**예방 Best Practices**:
- 리소스는 항상 finally 또는 try-with-resources로 정리
- Static 컬렉션 사용 최소화
- 리스너 등록 후 반드시 해제
- ThreadLocal 사용 후 remove() 호출
- 주기적인 힙 덤프 분석
- 프로파일링 도구로 모니터링

**실무 팁**:
```java
// 좋은 예: 명시적 정리
@PreDestroy
public void cleanup() {
    cache.clear();
    threadLocal.remove();
}
```'
WHERE id = 'b0000000-0000-0000-0004-000000000051';
