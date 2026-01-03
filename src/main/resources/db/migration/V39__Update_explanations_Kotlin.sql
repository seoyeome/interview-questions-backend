-- Kotlin 면접 질문 답변 추가

UPDATE questions SET explanation =
'**Kotlin이란?**
- JetBrains에서 개발한 **정적 타입 언어**로, JVM(Java Virtual Machine), Android, JavaScript, Native 등 다양한 플랫폼을 타겟으로 합니다.
- 2011년 공개, 2017년 Google이 Android 공식 언어로 채택하면서 대중화되었습니다.

**Java와의 주요 차이점**
1. **널 안전성(Null Safety)**
   - Kotlin은 타입 시스템에서 nullable과 non-nullable을 명확히 구분합니다 (`String` vs `String?`)
   - Java는 모든 참조 타입이 null일 수 있어 NPE 위험이 큽니다

2. **간결한 문법**
   - 세미콜론 생략, 타입 추론, 데이터 클래스, 프로퍼티 등으로 보일러플레이트 감소
   - Java보다 코드량이 평균 40% 적다는 통계도 있습니다

3. **함수형 프로그래밍 지원**
   - 고차 함수, 람다, 확장 함수 등이 1급 시민(first-class)으로 지원됩니다

4. **코루틴(Coroutines)**
   - 비동기 처리를 간결하게 작성할 수 있는 경량 스레드
   - Java의 CompletableFuture보다 직관적이고 효율적입니다

5. **100% Java 호환**
   - 기존 Java 라이브러리를 그대로 사용 가능하며, Java와 Kotlin 코드를 한 프로젝트에서 혼용 가능합니다'
WHERE id = 'b0000000-0000-0000-0003-000000000001';

UPDATE questions SET explanation =
'**Nullable vs Non-nullable 타입**
- Kotlin은 타입 시스템에서 **nullable 타입**과 **non-nullable 타입**을 명확히 구분합니다

**Non-nullable (기본)**
```kotlin
var name: String = "홍길동"
name = null  // 컴파일 에러!
```

**Nullable (? 붙임)**
```kotlin
var name: String? = "홍길동"
name = null  // OK
```

**안전한 호출 연산자들**
1. **Safe Call (`?.`)**
   ```kotlin
   val length = name?.length  // name이 null이면 null 반환
   ```

2. **Elvis 연산자 (`?:`)**
   ```kotlin
   val length = name?.length ?: 0  // null이면 기본값 반환
   ```

3. **Non-null assertion (`!!`)**
   ```kotlin
   val length = name!!.length  // null이면 NPE 발생 (주의!)
   ```

4. **안전한 캐스트 (`as?`)**
   ```kotlin
   val str = obj as? String  // 캐스트 실패 시 null 반환
   ```

**실무 장점**
- 컴파일 타임에 NPE 가능성을 대부분 제거
- null 처리 로직이 명확해져 코드 가독성/안정성 향상'
WHERE id = 'b0000000-0000-0000-0003-000000000002';

UPDATE questions SET explanation =
'**Data Class란?**
- 데이터를 보관하는 목적의 클래스로, `data` 키워드를 붙이면 컴파일러가 유용한 메서드들을 자동 생성해줍니다

**자동 생성되는 메서드**
1. `equals()` / `hashCode()` - 내용 기반 비교
2. `toString()` - 보기 좋은 문자열 표현
3. `copy()` - 불변성을 유지하면서 일부 값만 변경한 복사본 생성
4. `componentN()` - 구조 분해 선언 지원

**예시**
```kotlin
data class User(
    val name: String,
    val age: Int
)

val user1 = User("김철수", 25)
val user2 = user1.copy(age = 26)  // 이름은 같고 나이만 변경

println(user1)  // User(name=김철수, age=25)
println(user1 == user2)  // false (age가 다름)

val (name, age) = user1  // 구조 분해 선언
```

**제약 사항**
- 주 생성자에 최소 1개의 파라미터 필요
- 주 생성자 파라미터는 `val` 또는 `var`로 선언되어야 함
- `abstract`, `open`, `sealed`, `inner` 불가

**실무 활용**
- DTO, VO, Entity 등 데이터 전달용 객체
- API 응답/요청 모델
- 불변 도메인 모델 설계'
WHERE id = 'b0000000-0000-0000-0003-000000000003';

UPDATE questions SET explanation =
'**Extension Function이란?**
- 기존 클래스를 수정하지 않고, **외부에서 메서드를 추가**할 수 있는 Kotlin의 강력한 기능입니다

**기본 문법**
```kotlin
fun String.isValidEmail(): Boolean {
    return this.contains("@") && this.contains(".")
}

// 사용
val email = "user@example.com"
println(email.isValidEmail())  // true
```

**특징**
1. **수신 객체 타입(Receiver Type)**
   - 확장할 클래스를 `fun` 뒤에 명시 (`String.`)

2. **this 키워드**
   - 함수 내부에서 `this`는 수신 객체를 가리킴

3. **정적 디스패치(Static Dispatch)**
   - 확장 함수는 컴파일 타임에 결정됨 (오버라이드 불가)
   - 실제로는 정적 메서드로 변환됩니다

**실무 활용 예시**
```kotlin
// Context 확장
fun Context.showToast(message: String) {
    Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
}

// Collection 확장
fun <T> List<T>.second(): T? {
    return if (size >= 2) this[1] else null
}

// Nullable 타입 확장
fun String?.orDefault(default: String = "N/A"): String {
    return this ?: default
}
```

**주의사항**
- 멤버 함수와 이름이 같으면 멤버 함수가 우선
- private 멤버는 접근 불가
- 너무 남용하면 코드 추적이 어려워질 수 있음'
WHERE id = 'b0000000-0000-0000-0003-000000000004';

UPDATE questions SET explanation =
'**고차 함수(Higher-order Function)**
- 함수를 **파라미터로 받거나 반환**하는 함수입니다

**람다(Lambda)**
- 이름 없는 함수로, **중괄호 `{}`** 안에 파라미터와 본문을 작성합니다

**기본 예시**
```kotlin
// 고차 함수 정의
fun operation(a: Int, b: Int, op: (Int, Int) -> Int): Int {
    return op(a, b)
}

// 사용
val sum = operation(3, 5) { x, y -> x + y }  // 8
val multiply = operation(3, 5) { x, y -> x * y }  // 15
```

**람다 문법**
```kotlin
// 완전한 형태
val sum: (Int, Int) -> Int = { x: Int, y: Int -> x + y }

// 타입 추론
val sum = { x: Int, y: Int -> x + y }

// 파라미터가 하나면 it 사용
val double = { x: Int -> x * 2 }
list.filter { it > 5 }  // it는 각 요소

// 파라미터가 마지막이면 소괄호 밖으로
list.filter { it > 5 }  // 대신 list.filter({ it > 5 })
```

**실무 활용 예시**
```kotlin
// Collection 처리
val numbers = listOf(1, 2, 3, 4, 5)
val evenSum = numbers
    .filter { it % 2 == 0 }
    .map { it * it }
    .sum()  // 4 + 16 = 20

// 콜백 패턴
fun fetchData(onSuccess: (String) -> Unit, onError: (Exception) -> Unit) {
    try {
        val data = "결과"
        onSuccess(data)
    } catch (e: Exception) {
        onError(e)
    }
}

// DSL 스타일
fun buildString(builder: StringBuilder.() -> Unit): String {
    return StringBuilder().apply(builder).toString()
}

val html = buildString {
    append("<html>")
    append("</html>")
}
```

**장점**
- 코드 재사용성 향상
- 선언적이고 간결한 코드
- 함수형 프로그래밍 패러다임 지원'
WHERE id = 'b0000000-0000-0000-0003-000000000005';

UPDATE questions SET explanation =
'**Coroutine(코루틴)이란?**
- **경량 스레드**로, 비동기 작업을 동기 코드처럼 작성할 수 있게 해주는 Kotlin의 동시성 프레임워크입니다
- 스레드보다 훨씬 가볍고(메모리 효율적), 수만 개를 동시에 실행 가능합니다

**주요 개념**
1. **suspend 함수**: 중단 가능한 함수 (코루틴 안에서만 호출 가능)
2. **CoroutineScope**: 코루틴의 생명주기를 관리하는 범위
3. **Dispatcher**: 코루틴이 실행될 스레드를 지정
   - `Dispatchers.Main` - UI 스레드
   - `Dispatchers.IO` - I/O 작업용
   - `Dispatchers.Default` - CPU 집약적 작업용

**기본 사용법**
```kotlin
// 코루틴 시작
fun main() = runBlocking {  // 메인 스레드를 블로킹하는 코루틴
    launch {  // 새 코루틴 시작 (백그라운드)
        delay(1000L)  // 1초 대기 (스레드 블로킹 안 함!)
        println("World!")
    }
    println("Hello,")
}
// 출력: Hello, World! (1초 후)
```

**실무 예시**
```kotlin
// Android ViewModel에서
class UserViewModel : ViewModel() {
    fun fetchUser() {
        viewModelScope.launch {
            try {
                val user = withContext(Dispatchers.IO) {
                    // 네트워크 호출
                    api.getUser()
                }
                // UI 업데이트 (자동으로 Main에서 실행)
                _userState.value = user
            } catch (e: Exception) {
                _errorState.value = e.message
            }
        }
    }
}

// 여러 비동기 작업 병렬 처리
suspend fun loadData(): Result {
    return coroutineScope {
        val user = async { fetchUser() }
        val posts = async { fetchPosts() }

        Result(user.await(), posts.await())  // 둘 다 완료될 때까지 대기
    }
}
```

**Thread vs Coroutine**
- Thread: OS 레벨, 무겁고 생성 비용 높음, 블로킹 작업
- Coroutine: 언어 레벨, 가볍고 효율적, non-blocking, 구조화된 동시성

**장점**
- 동기 코드처럼 보이지만 비동기로 동작 (가독성)
- 메모리 효율적 (스레드보다 1000배 가벼움)
- 구조화된 동시성으로 메모리 누수 방지
- Exception 처리가 자연스러움'
WHERE id = 'b0000000-0000-0000-0003-000000000006';

UPDATE questions SET explanation =
'**suspend 함수란?**
- **중단 가능한(suspendable) 함수**로, 코루틴 안에서만 호출할 수 있습니다
- `suspend` 키워드를 붙여 선언하며, 실행 도중 **일시 중단했다가 나중에 재개**할 수 있습니다

**특징**
1. 코루틴 또는 다른 suspend 함수 안에서만 호출 가능
2. 스레드를 블로킹하지 않고 실행을 중단할 수 있음
3. 컴파일러가 상태 머신으로 변환하여 효율적으로 처리

**기본 예시**
```kotlin
suspend fun fetchUser(id: Int): User {
    delay(1000)  // suspend 함수 - 1초 대기하지만 스레드는 블로킹 안 됨
    return api.getUser(id)  // 네트워크 호출
}

// 일반 함수에서는 호출 불가
fun main() {
    fetchUser(1)  // 컴파일 에러!
}

// 코루틴 안에서만 호출 가능
fun main() = runBlocking {
    val user = fetchUser(1)  // OK
    println(user)
}
```

**실무 활용**
```kotlin
// Repository 계층
class UserRepository {
    suspend fun getUser(id: Int): User {
        return withContext(Dispatchers.IO) {
            // DB나 네트워크 호출
            database.userDao().getUser(id)
        }
    }
}

// ViewModel
class UserViewModel : ViewModel() {
    fun loadUser(id: Int) {
        viewModelScope.launch {
            val user = repository.getUser(id)  // suspend 함수 호출
            _userState.value = user
        }
    }
}

// 순차 실행
suspend fun processOrder(): Order {
    val user = fetchUser()      // 완료될 때까지 대기
    val cart = fetchCart(user.id)  // 이후 실행
    return createOrder(user, cart)
}

// 병렬 실행
suspend fun loadDashboard(): Dashboard = coroutineScope {
    val userDeferred = async { fetchUser() }      // 동시 시작
    val postsDeferred = async { fetchPosts() }    // 동시 시작

    Dashboard(
        user = userDeferred.await(),  // 결과 대기
        posts = postsDeferred.await()
    )
}
```

**왜 suspend를 붙여야 하나?**
- 일반 함수와 명확히 구분하여 "이 함수는 비동기적으로 실행될 수 있다"는 것을 타입 시스템으로 표현
- 컴파일러가 continuation(재개 지점)을 자동으로 관리
- 실수로 메인 스레드에서 블로킹 호출하는 것을 방지

**주의사항**
- `suspend`를 붙인다고 자동으로 백그라운드에서 실행되는 것은 아님
- `withContext(Dispatchers.IO)`로 명시적으로 스레드 전환 필요'
WHERE id = 'b0000000-0000-0000-0003-000000000007';

UPDATE questions SET explanation =
'**Scope Function이란?**
- 객체의 컨텍스트 내에서 **코드 블록을 실행**하기 위한 함수들로, `apply`, `let`, `run`, `also`, `with` 5가지가 있습니다
- 임시 범위를 만들어 객체를 참조하고 설정하는 코드를 간결하게 작성할 수 있습니다

**주요 차이점 (2가지 기준)**
1. **this vs it**: 컨텍스트 객체를 어떻게 참조하는가
2. **반환값**: 컨텍스트 객체 vs 람다 결과

| 함수  | 참조 | 반환값       | 주 용도                          |
|-------|------|--------------|----------------------------------|
| apply | this | 객체 자신    | 객체 초기화 및 설정              |
| also  | it   | 객체 자신    | 부수 효과 (로깅, 검증 등)        |
| let   | it   | 람다 결과    | null 체크 후 변환/매핑           |
| run   | this | 람다 결과    | 객체 설정 + 결과 계산            |
| with  | this | 람다 결과    | 객체 없이 여러 메서드 호출 그룹화 |

**apply - 객체 초기화**
```kotlin
val person = Person().apply {
    name = "홍길동"    // this.name (this 생략 가능)
    age = 30
    address = "서울"
}  // person 반환
```

**also - 부수 효과**
```kotlin
val numbers = mutableListOf(1, 2, 3).also {
    println("리스트에 추가 전: $it")
    it.add(4)
}  // numbers 반환
```

**let - null 체크 & 변환**
```kotlin
val length = name?.let {
    println("이름: $it")
    it.length  // 반환값
}  // length = 문자열 길이 또는 null

// Elvis와 함께
val result = value?.let {
    it * 2
} ?: 0
```

**run - 설정 + 계산**
```kotlin
val greeting = Person().run {
    name = "김철수"
    "안녕하세요, $name님"  // 반환값
}  // greeting = "안녕하세요, 김철수님"
```

**with - 객체 없이 그룹화**
```kotlin
val result = with(person) {
    name = "이영희"
    age = 25
    "$name님의 나이는 $age세입니다"
}
```

**실무 선택 가이드**
- **객체 초기화**: `apply`
- **null 체크 후 작업**: `let`
- **로깅/검증 추가**: `also`
- **객체로 계산 후 다른 값 반환**: `run` 또는 `let`
- **Non-null 객체의 여러 메서드 호출**: `with`

**주의사항**
- 중첩 사용 시 `this`가 혼란스러울 수 있으므로 명시적 라벨 사용 권장
- 과도한 사용은 가독성을 해칠 수 있음'
WHERE id = 'b0000000-0000-0000-0003-000000000008';

UPDATE questions SET explanation =
'**sealed 클래스란?**
- **제한된 계층 구조**를 표현하는 추상 클래스입니다
- 정해진 하위 클래스만 가질 수 있어, `when` 식에서 **모든 경우를 컴파일러가 검증**할 수 있습니다

**특징**
1. 하위 클래스는 같은 파일 내에 정의되어야 함 (Kotlin 1.5부터는 같은 패키지 내)
2. 자동으로 `abstract`이며, 직접 인스턴스화 불가
3. enum보다 유연 (각 하위 클래스가 다른 데이터/동작 가능)

**기본 예시**
```kotlin
sealed class Result {
    data class Success(val data: String) : Result()
    data class Error(val exception: Exception) : Result()
    object Loading : Result()
}

// 사용
fun handleResult(result: Result) = when (result) {
    is Result.Success -> println("데이터: ${result.data}")
    is Result.Error -> println("에러: ${result.exception.message}")
    Result.Loading -> println("로딩 중...")
    // else 불필요! 컴파일러가 모든 경우를 확인
}
```

**실무 활용 - UI State 관리**
```kotlin
sealed class UiState<out T> {
    object Idle : UiState<Nothing>()
    object Loading : UiState<Nothing>()
    data class Success<T>(val data: T) : UiState<T>()
    data class Error(val message: String) : UiState<Nothing>()
}

// ViewModel
class UserViewModel : ViewModel() {
    private val _uiState = MutableStateFlow<UiState<User>>(UiState.Idle)
    val uiState: StateFlow<UiState<User>> = _uiState

    fun loadUser() {
        _uiState.value = UiState.Loading
        viewModelScope.launch {
            try {
                val user = repository.getUser()
                _uiState.value = UiState.Success(user)
            } catch (e: Exception) {
                _uiState.value = UiState.Error(e.message ?: "Unknown error")
            }
        }
    }
}

// UI
when (val state = uiState.value) {
    UiState.Idle -> { /* 초기 상태 */ }
    UiState.Loading -> showLoadingSpinner()
    is UiState.Success -> displayUser(state.data)
    is UiState.Error -> showError(state.message)
}
```

**sealed vs enum**
```kotlin
// enum - 제한적
enum class Color { RED, GREEN, BLUE }

// sealed - 유연함
sealed class Color {
    object Red : Color()
    object Green : Color()
    data class Custom(val rgb: Int) : Color()  // 데이터를 가질 수 있음
}
```

**언제 사용하나?**
- API 응답 상태 (Success/Error/Loading)
- 네비게이션 이벤트
- 뷰 상태 관리
- ADT(Algebraic Data Type) 패턴 구현
- 타입 안전한 상태 머신

**장점**
- 컴파일 타임에 모든 케이스 검증
- 새로운 하위 타입 추가 시 `when` 식에서 컴파일 에러 발생 (놓치는 케이스 방지)
- enum보다 표현력이 높음'
WHERE id = 'b0000000-0000-0000-0003-000000000009';

UPDATE questions SET explanation =
'**Destructuring Declaration(구조 분해 선언)**
- 객체의 프로퍼티를 **여러 개의 변수로 한 번에 분해**하여 선언하는 문법입니다

**기본 사용법**
```kotlin
data class User(val name: String, val age: Int)

val user = User("홍길동", 30)
val (name, age) = user  // 구조 분해
println("$name, $age")  // 홍길동, 30
```

**동작 원리**
- `componentN()` 함수를 호출합니다
- Data class는 자동으로 `component1()`, `component2()`, ... 생성

```kotlin
// 위 코드는 실제로 이렇게 동작
val name = user.component1()
val age = user.component2()
```

**다양한 활용**

**1. List/Array**
```kotlin
val list = listOf("A", "B", "C")
val (first, second) = list  // A, B
```

**2. Map**
```kotlin
val map = mapOf("name" to "김철수", "age" to "25")
for ((key, value) in map) {
    println("$key: $value")
}
```

**3. Lambda 파라미터**
```kotlin
val users = listOf(
    User("홍길동", 30),
    User("김철수", 25)
)

users.forEach { (name, age) ->  // 구조 분해
    println("$name: $age")
}
```

**4. 일부만 사용 (언더스코어)**
```kotlin
val (name, _) = user  // age는 무시
```

**5. Pair/Triple**
```kotlin
val pair = "name" to "홍길동"
val (key, value) = pair

fun getCoordinates() = Triple(10, 20, 30)
val (x, y, z) = getCoordinates()
```

**6. 함수 반환값**
```kotlin
fun getUserInfo(): User {
    return User("이영희", 28)
}

val (name, age) = getUserInfo()
```

**커스텀 클래스에서 사용**
```kotlin
class Point(val x: Int, val y: Int) {
    operator fun component1() = x
    operator fun component2() = y
}

val point = Point(10, 20)
val (x, y) = point
```

**주의사항**
- 순서가 중요함 (이름이 아닌 위치 기반)
- 최대 5개까지만 지원 (`component1` ~ `component5`)
- 가독성이 떨어질 수 있으므로 적절히 사용'
WHERE id = 'b0000000-0000-0000-0003-000000000010';

UPDATE questions SET explanation =
'**inline 함수란?**
- 함수 호출을 **호출 위치에 함수 본문을 복사**하여 성능을 최적화하는 기능입니다
- 특히 **람다를 파라미터로 받는 고차 함수**에서 객체 생성 오버헤드를 제거합니다

**문제 상황**
```kotlin
// 일반 함수 - 람다가 객체로 생성됨
fun normalRepeat(times: Int, action: () -> Unit) {
    for (i in 1..times) {
        action()  // 람다 객체 생성 + 호출 오버헤드
    }
}
```

**inline으로 해결**
```kotlin
inline fun inlineRepeat(times: Int, action: () -> Unit) {
    for (i in 1..times) {
        action()
    }
}

// 사용
inlineRepeat(3) {
    println("Hello")
}

// 컴파일 후 실제 코드 (인라인 됨)
for (i in 1..3) {
    println("Hello")  // 람다 본문이 직접 삽입
}
```

**장점**
1. **성능 향상**: 함수 호출 오버헤드 제거, 람다 객체 생성 X
2. **non-local return 가능**
```kotlin
inline fun <T> List<T>.forEachIndexed(action: (Int, T) -> Unit) {
    for (i in indices) {
        action(i, this[i])
    }
}

fun findUser(users: List<User>) {
    users.forEachIndexed { index, user ->
        if (user.name == "홍길동") {
            return  // findUser 함수 자체를 리턴! (inline이라 가능)
        }
    }
}
```

**noinline - 일부 람다는 인라인 안함**
```kotlin
inline fun request(
    url: String,
    noinline onSuccess: (String) -> Unit,  // 인라인 안됨
    onError: (Exception) -> Unit           // 인라인 됨
) {
    // onSuccess를 다른 함수에 전달하거나 저장할 때 필요
    saveCallback(onSuccess)
}
```

**crossinline - non-local return 방지**
```kotlin
inline fun runAsync(crossinline action: () -> Unit) {
    thread {
        action()  // 다른 컨텍스트에서 실행될 때 return 막기
    }
}
```

**reified - 타입 파라미터 실체화**
```kotlin
// inline이 없으면 불가능
inline fun <reified T> isInstance(value: Any): Boolean {
    return value is T  // 제네릭 타입 체크 가능!
}

// 사용
val result = isInstance<String>("Hello")  // true

// 실무 예시 - JSON 파싱
inline fun <reified T> String.fromJson(): T {
    return Gson().fromJson(this, T::class.java)
}

val user = jsonString.fromJson<User>()
```

**언제 사용하나?**
1. 람다를 파라미터로 받는 고차 함수
2. reified 타입 파라미터가 필요할 때
3. 자주 호출되는 작은 함수 (성능 최적화)

**주의사항**
- 함수 본문이 크면 코드 크기 증가 (바이너리 비대화)
- public inline 함수는 private 멤버에 접근 불가
- 표준 라이브러리의 컬렉션 함수들(`map`, `filter` 등)은 대부분 inline'
WHERE id = 'b0000000-0000-0000-0003-000000000011';

UPDATE questions SET explanation =
'**Kotlin DSL이란?**
- **Domain-Specific Language**의 약자로, 특정 도메인에 특화된 언어를 Kotlin 문법으로 만드는 것입니다
- Kotlin의 람다, 확장 함수, 연산자 오버로딩 등을 활용해 **가독성 높고 선언적인 API**를 설계합니다

**핵심 기법**
1. **Lambda with Receiver**: 람다 내부에서 `this`로 특정 객체 접근
2. **확장 함수**: 기존 타입에 새로운 메서드 추가
3. **중위 함수(infix)**: `a to b` 같은 자연스러운 문법

**실무 활용 사례**

**1. HTML DSL (kotlinx.html)**
```kotlin
html {
    head {
        title { +"Kotlin DSL" }
    }
    body {
        h1 { +"제목" }
        p {
            +"내용입니다."
        }
        ul {
            for (i in 1..5) {
                li { +"항목 $i" }
            }
        }
    }
}
```

**2. Gradle (Kotlin DSL)**
```kotlin
plugins {
    kotlin("jvm") version "1.9.0"
}

dependencies {
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.7.0")
    testImplementation(kotlin("test"))
}
```

**3. Ktor (웹 프레임워크)**
```kotlin
routing {
    get("/users/{id}") {
        val id = call.parameters["id"]
        call.respond(getUserById(id))
    }

    post("/users") {
        val user = call.receive<User>()
        createUser(user)
        call.respond(HttpStatusCode.Created)
    }
}
```

**4. Exposed (SQL DSL)**
```kotlin
object Users : Table() {
    val id = integer("id").autoIncrement()
    val name = varchar("name", 50)
    override val primaryKey = PrimaryKey(id)
}

// 쿼리
val users = Users.select { Users.name like "홍%" }
    .orderBy(Users.id)
    .limit(10)
```

**5. 커스텀 DSL 예시 - 빌더 패턴**
```kotlin
class Person {
    var name: String = ""
    var age: Int = 0
    val addresses = mutableListOf<Address>()

    fun address(block: Address.() -> Unit) {
        addresses.add(Address().apply(block))
    }
}

class Address {
    var city: String = ""
    var street: String = ""
}

// DSL 함수
fun person(block: Person.() -> Unit): Person {
    return Person().apply(block)
}

// 사용
val person = person {
    name = "홍길동"
    age = 30
    address {
        city = "서울"
        street = "강남대로"
    }
    address {
        city = "부산"
        street = "해운대로"
    }
}
```

**6. 테스트 DSL (Kotest)**
```kotlin
class UserTest : StringSpec({
    "사용자 이름은 비어있으면 안된다" {
        val user = User("")
        user.name.shouldBeEmpty()
    }

    "사용자 나이는 0보다 커야 한다" {
        val user = User("홍길동", -1)
        user.age shouldBeGreaterThan 0
    }
})
```

**DSL 구현 핵심 문법**
```kotlin
// Lambda with Receiver
class StringBuilder {
    fun append(str: String) { /* ... */ }
}

fun buildString(block: StringBuilder.() -> Unit): String {
    return StringBuilder().apply(block).toString()
}

// 사용
val result = buildString {
    append("Hello, ")  // this.append (this는 StringBuilder)
    append("World!")
}
```

**장점**
- 선언적이고 읽기 쉬운 코드
- 도메인 전문가도 이해 가능한 코드
- 타입 안정성 유지

**주의사항**
- 과도하게 복잡한 DSL은 오히려 가독성을 해침
- 디버깅이 어려울 수 있음
- 팀원 모두가 DSL 패턴을 이해해야 함'
WHERE id = 'b0000000-0000-0000-0003-000000000012';

UPDATE questions SET explanation =
'**Kotlin Multiplatform 개요**
- Kotlin은 JVM뿐만 아니라 **JavaScript, Native(C/C++)** 환경으로도 컴파일될 수 있습니다
- 하나의 코드베이스로 여러 플랫폼을 타겟팅하는 "Kotlin Multiplatform" 전략의 일부입니다

**Kotlin/JS**
- Kotlin 코드를 **JavaScript로 컴파일**합니다
- React, Vue 같은 프론트엔드 프레임워크와 함께 사용 가능
- Node.js 백엔드 개발도 가능

**특징**
```kotlin
// Kotlin 코드
fun greet(name: String) = "Hello, $name"

// 컴파일 후 JavaScript
function greet(name) {
    return "Hello, " + name;
}
```

**활용**
- 웹 프론트엔드 개발 (타입 안정성 + Kotlin 생산성)
- Full-stack Kotlin (서버 Kotlin/JVM + 클라이언트 Kotlin/JS)
- React Wrapper: `kotlin-react`, `kotlin-react-dom`

**Kotlin/Native**
- Kotlin 코드를 **네이티브 바이너리**로 컴파일합니다 (LLVM 사용)
- JVM 없이 실행 가능 (임베디드, iOS, Desktop 등)

**타겟 플랫폼**
- iOS (Objective-C/Swift 상호 운용)
- macOS, Linux, Windows
- 임베디드 시스템
- WebAssembly

**예시 - iOS 앱**
```kotlin
// Shared 모듈 (Android + iOS 공통)
class Greeting {
    fun greeting(): String {
        return "Hello from Kotlin Multiplatform!"
    }
}

// iOS에서 사용 (Swift)
let greeting = Greeting()
print(greeting.greeting())

// Android에서 사용 (Kotlin)
val greeting = Greeting()
println(greeting.greeting())
```

**Kotlin Multiplatform Mobile (KMM)**
- Android와 iOS 앱 개발에서 **비즈니스 로직을 공유**
- UI는 각 플랫폼 네이티브 (Android: Jetpack Compose, iOS: SwiftUI)
- 네트워킹, 데이터베이스, 로직 등을 공통 코드로 작성

**실무 채택 사례**
- Netflix: 일부 iOS 앱에 KMM 도입
- VMware: Workspace ONE SDK
- Philips: 헬스케어 앱

**장단점**

**장점**
- 코드 재사용 (비즈니스 로직 중복 제거)
- 타입 안정성, Kotlin 생산성
- 각 플랫폼의 네이티브 성능 유지

**단점**
- 아직 생태계가 성숙하지 않음 (2024년 기준)
- 디버깅/빌드 설정이 복잡할 수 있음
- 플랫폼별 고유 기능은 expect/actual로 분리 필요

**expect/actual 패턴**
```kotlin
// 공통 코드 (commonMain)
expect fun getPlatformName(): String

// Android (androidMain)
actual fun getPlatformName(): String = "Android"

// iOS (iosMain)
actual fun getPlatformName(): String = "iOS"
```

**결론**
- Kotlin/JS: 웹 개발에 Kotlin 사용 (실무 채택은 제한적)
- Kotlin/Native: iOS 앱 개발, 임베디드 등 (KMM으로 주목받는 중)
- 2024년 기준 아직 실험적이지만, Google과 JetBrains의 강력한 지원으로 성장 중'
WHERE id = 'b0000000-0000-0000-0003-000000000013';

UPDATE questions SET explanation =
'**(이 질문은 8번과 중복입니다)**

**간단 정리**
| 함수  | 참조 | 반환값    | 주 용도                     |
|-------|------|-----------|----------------------------|
| apply | this | 객체 자신 | 객체 초기화/설정            |
| let   | it   | 람다 결과 | null 체크 후 변환           |
| run   | this | 람다 결과 | 설정 + 결과 계산            |
| also  | it   | 객체 자신 | 부수 효과 (로깅 등)         |

**핵심 차이**
- **apply, also**: 객체 자신을 반환 → 체이닝에 유리
- **let, run**: 람다 결과를 반환 → 변환/계산에 유리
- **this vs it**:
  - `this`는 생략 가능 (깔끔하지만 scope 혼란 가능)
  - `it`는 명시적 (특히 중첩 시 명확함)

**실무 선택 기준**
```kotlin
// 객체 설정
val dialog = AlertDialog.Builder(context).apply {
    setTitle("제목")
    setMessage("메시지")
}.create()

// null 체크 후 변환
val length = name?.let { it.length } ?: 0

// 로깅 추가
val result = calculateSomething().also {
    log("계산 결과: $it")
}

// 결과 계산
val message = user.run {
    "$name님, ${age}세"
}
```

자세한 내용은 질문 8번 참고'
WHERE id = 'b0000000-0000-0000-0003-000000000014';

UPDATE questions SET explanation =
'**Kotlin의 예외 처리**
- Kotlin은 **모든 예외가 Unchecked Exception**입니다
- Java의 Checked Exception 개념이 없습니다

**Java vs Kotlin**
```java
// Java - Checked Exception 강제
public void readFile(String path) throws IOException {
    FileReader reader = new FileReader(path);  // IOException 선언 필수
}

// 호출하는 쪽도 처리 강제
try {
    readFile("file.txt");
} catch (IOException e) {
    // 반드시 처리해야 함
}
```

```kotlin
// Kotlin - throws 선언 불필요
fun readFile(path: String) {
    val reader = FileReader(path)  // 예외 선언 안해도 됨
}

// 호출하는 쪽도 try-catch 선택 사항
readFile("file.txt")  // 컴파일 OK
```

**기본 문법은 비슷**
```kotlin
try {
    val result = riskyOperation()
    println(result)
} catch (e: IOException) {
    println("IO 에러: ${e.message}")
} catch (e: Exception) {
    println("기타 에러: ${e.message}")
} finally {
    cleanup()  // 항상 실행
}
```

**Kotlin만의 특징**

**1. try는 표현식 (값을 반환)**
```kotlin
val result = try {
    parseInt(input)
} catch (e: NumberFormatException) {
    0  // 기본값
}

// Java는 문장이라 이렇게 못함
```

**2. Nothing 타입**
```kotlin
fun fail(message: String): Nothing {
    throw IllegalArgumentException(message)
}

val value = input ?: fail("입력 필요")  // fail은 Nothing 반환
// 컴파일러가 이 줄 이후 value는 null이 아님을 알 수 있음
```

**3. @Throws 어노테이션 (Java 상호 운용)**
```kotlin
// Java에서 호출할 때만 필요
@Throws(IOException::class)
fun writeFile(path: String) {
    // ...
}
```

**왜 Checked Exception을 없앴나?**
1. **실무에서 남용됨**: 개발자들이 무의미한 `throws Exception` 또는 빈 catch 블록 사용
2. **강제성이 코드 품질을 보장하지 못함**: 어차피 제대로 처리 안하는 경우 많음
3. **함수형 프로그래밍과 맞지 않음**: 람다, 고차 함수에서 예외 처리가 번거로움

**Result 타입 활용 (함수형 에러 처리)**
```kotlin
// 예외 대신 Result 반환
fun parseInt(str: String): Result<Int> {
    return try {
        Result.success(str.toInt())
    } catch (e: NumberFormatException) {
        Result.failure(e)
    }
}

// 사용
val result = parseInt("123")
result.onSuccess { println("성공: $it") }
      .onFailure { println("실패: ${it.message}") }
```

**실무 권장**
- 비즈니스 로직 에러는 `sealed class`로 모델링
- 시스템 에러는 예외 사용
- 공개 API는 예외보다 Result/Either 같은 명시적 타입 선호

```kotlin
sealed class ApiResult<out T> {
    data class Success<T>(val data: T) : ApiResult<T>()
    data class Error(val code: Int, val message: String) : ApiResult<Nothing>()
}
```'
WHERE id = 'b0000000-0000-0000-0003-000000000015';

UPDATE questions SET explanation =
'**타입 추론(Type Inference)이란?**
- 컴파일러가 코드 문맥을 보고 변수나 함수의 **타입을 자동으로 추론**하는 기능입니다
- 개발자가 명시적으로 타입을 쓰지 않아도 타입 안정성은 그대로 유지됩니다

**Kotlin의 타입 추론 수준**
Kotlin은 **강력한 타입 추론**을 지원하며, 대부분의 경우 타입을 생략할 수 있습니다

**변수 타입 추론**
```kotlin
// 명시적
val name: String = "홍길동"
val age: Int = 30

// 타입 추론 (권장)
val name = "홍길동"  // String으로 추론
val age = 30         // Int로 추론
val price = 1000L    // Long
val ratio = 0.5      // Double
val list = listOf(1, 2, 3)  // List<Int>
```

**함수 반환 타입 추론**
```kotlin
// 명시적
fun add(a: Int, b: Int): Int {
    return a + b
}

// 표현식 본문 - 타입 추론
fun add(a: Int, b: Int) = a + b  // Int로 추론

// 블록 본문은 타입 명시 필요 (Unit 제외)
fun process(x: Int) {  // Unit 반환은 추론 가능
    println(x * 2)
}

fun calculate(x: Int): Double {  // 명시 필요
    if (x > 0) return x.toDouble()
    return 0.0
}
```

**제네릭 타입 추론**
```kotlin
// 명시적
val list: List<String> = listOf<String>("A", "B")

// 타입 추론
val list = listOf("A", "B")  // List<String>으로 추론

// 빈 컬렉션은 타입 명시 필요
val empty = emptyList<Int>()  // 타입을 알 수 없음
```

**람다 타입 추론**
```kotlin
val numbers = listOf(1, 2, 3, 4, 5)

// 람다 파라미터 타입 추론
val doubled = numbers.map { it * 2 }  // it는 Int로 추론

// 명시적 (불필요)
val doubled = numbers.map { num: Int -> num * 2 }
```

**스마트 캐스트**
```kotlin
fun process(value: Any) {
    if (value is String) {
        // 이 블록 안에서 value는 자동으로 String 타입으로 추론
        println(value.length)  // 캐스팅 불필요!
    }
}

// null 체크 후에도 스마트 캐스트
fun printLength(str: String?) {
    if (str != null) {
        println(str.length)  // String으로 스마트 캐스트
    }
}
```

**타입 추론의 한계**

**1. 타입을 알 수 없는 경우**
```kotlin
val x = null  // 컴파일 에러! 타입을 추론할 수 없음
val x: String? = null  // 명시 필요
```

**2. 공개 API는 명시 권장**
```kotlin
// 라이브러리 공개 함수
fun calculate(x: Int): Double {  // 반환 타입 명시 (가독성/명확성)
    return x * 0.5
}
```

**3. 복잡한 제네릭**
```kotlin
// 추론이 애매할 때는 명시
val result: Map<String, List<Int>> = complexFunction()
```

**실무 권장 사항**
- ✅ 로컬 변수는 타입 추론 활용 (간결함)
- ✅ 공개 API 함수는 반환 타입 명시 (문서화)
- ✅ 복잡한 타입은 명시 (가독성)
- ❌ 과도한 타입 명시는 오히려 코드를 복잡하게 만듦

**Java와 비교**
```java
// Java 10+ (var)
var name = "홍길동";  // 제한적 추론 (로컬 변수만)
var list = List.of(1, 2, 3);

// Kotlin
val name = "홍길동"  // 모든 곳에서 추론
val list = listOf(1, 2, 3)
fun add(a: Int, b: Int) = a + b  // 함수도 추론
```

**결론**
- Kotlin은 **매우 강력한 타입 추론**을 지원합니다
- 대부분의 경우 타입을 생략해도 컴파일러가 정확히 추론
- 타입 안정성은 유지하면서 코드는 간결해짐'
WHERE id = 'b0000000-0000-0000-0003-000000000016';
