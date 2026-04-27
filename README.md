# voyager-lib-flutter

Flutter용 Firebase Cloud Messaging(FCM) 통합 라이브러리입니다. FCM 토큰 관리, 푸시 알림 권한 요청, 토픽 구독, 커스텀 서버 연동을 단일 인터페이스로 제공합니다.

---

## 구조

```
lib/
├── voyager_messaging.dart          # 퍼사드 진입점 (VoyagerMessaging)
├── common/
│   ├── remote_message_listener.dart   # 메시지 수신 리스너 인터페이스
│   └── token_refresh_listener.dart    # 토큰 갱신 리스너 인터페이스
├── service/
│   ├── fcm_service.dart            # FirebaseMessaging 래퍼
│   └── voyager_service.dart        # 커스텀 서버 HTTP 클라이언트 (Dio)
├── repository/
│   └── voyager_repository.dart     # SharedPreferences 기반 로컬 저장소
└── usecase/
    ├── get_fcm_token_usecase.dart
    ├── get_apns_token_usecase.dart
    ├── get_initial_message_usecase.dart
    ├── save_fcm_token_usecase.dart
    ├── load_fcm_token_usecase.dart
    ├── request_permission_usecase.dart
    ├── set_auto_init_enabled_usecase.dart
    ├── subscribe_to_fcm_topic_usecase.dart
    ├── unsubscribe_from_fcm_topic_usecase.dart
    ├── register_target_usecase.dart
    ├── unregister_target_usecase.dart
    ├── subscribe_to_custom_topic_usecase.dart
    └── unsubscribe_from_custom_topic_usecase.dart
```

---

## 의존성

| 패키지 | 버전 | 용도 |
|---|---|---|
| `firebase_messaging` | ^16.0.1 | FCM 연동 |
| `dio` | ^5.9.0 | 커스텀 서버 HTTP 통신 |
| `shared_preferences` | ^2.5.3 | FCM 토큰 로컬 저장 |

---

## 초기화

```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:voyager/voyager_messaging.dart';

// FCM만 사용할 경우
VoyagerMessaging.initialize(FirebaseMessaging.instance);

// 커스텀 서버 연동이 필요한 경우 apiUrl 추가
VoyagerMessaging.initialize(
  FirebaseMessaging.instance,
  apiUrl: 'https://your-api.example.com',
);
```

---

## 클래스 설명

### `VoyagerMessaging`

`lib/voyager_messaging.dart`

싱글턴 퍼사드 클래스. 모든 기능의 진입점입니다.

| 메서드 | 설명 |
|---|---|
| `initialize(fm, {apiUrl})` | 라이브러리 초기화 (static) |
| `getFcmToken()` | FCM 토큰 요청 및 로컬 저장 |
| `getAPNSToken()` | APNS 토큰 요청 (iOS 전용) |
| `getInitialMessage()` | 알림 탭으로 앱 진입 시 메시지 반환 |
| `setFcmAutoInitEnabled(bool)` | FCM auto-init 설정 |
| `requestPermission({...})` | 알림 권한 요청 (iOS 전용) |
| `subscribeToFcmTopic(topic)` | FCM 토픽 구독 |
| `unsubscribeFromFcmTopic(topic)` | FCM 토픽 구독 해제 |
| `registerTarget(endpoint, targetId, token)` | 커스텀 서버에 타겟 등록 |
| `unregisterTarget(endpoint, targetId)` | 커스텀 서버에서 타겟 해제 |
| `subscribeToCustomTopic(endpoint, targetId, topic)` | 커스텀 서버 토픽 구독 |
| `unsubscribeFromCustomTopic(endpoint, targetId, topic)` | 커스텀 서버 토픽 구독 해제 |
| `onMessage(handler, errorHandler)` | Foreground 메시지 수신 핸들러 등록 |
| `onBackgroundMessage(handler)` | Background 메시지 수신 핸들러 등록 |

> `registerTarget`, `unregisterTarget`, `subscribeToCustomTopic`, `unsubscribeFromCustomTopic`는 `initialize` 시 `apiUrl`을 지정해야 사용 가능합니다.

---

### `FcmService`

`lib/service/fcm_service.dart`

`FirebaseMessaging` 인스턴스를 주입받아 FCM 기능을 래핑합니다.

| 메서드 | 설명 |
|---|---|
| `getToken()` | FCM 토큰 반환 |
| `getAPNSToken()` | APNS 토큰 반환 (iOS) |
| `requestPermission(...)` | 알림 권한 요청 |
| `getInitialMessage()` | 초기 메시지 반환 |
| `setAutoInitEnabled(bool)` | auto-init 설정 |
| `setFcmTokenRefreshListener(listener)` | 토큰 갱신 리스너 등록 |
| `subscribeToTopic(topic)` | FCM 토픽 구독 |
| `unsubscribeFromTopic(topic)` | FCM 토픽 구독 해제 |

---

### `VoyagerService`

`lib/service/voyager_service.dart`

Dio를 사용해 커스텀 푸시 서버와 통신합니다. `initialize` 시 전달한 `apiUrl`을 기반으로 동작합니다.

| 메서드 | HTTP | 설명 |
|---|---|---|
| `registerTarget(endpoint, targetId, token)` | POST | 타겟 등록 |
| `unregisterTarget(endpoint, targetId)` | DELETE | 타겟 해제 |
| `subscribeToTopic(endpoint, targetId, topic)` | POST | 토픽 구독 |
| `unsubscribeFromTopic(endpoint, targetId, topic)` | POST | 토픽 구독 해제 |

---

### `VoyagerRepository`

`lib/repository/voyager_repository.dart`

`SharedPreferences`를 통해 FCM 토큰 등 데이터를 로컬에 저장합니다.

| 메서드 | 설명 |
|---|---|
| `saveString / saveInt / saveBool` | 키-값 저장 |
| `loadString / loadInt / loadBool` | 키로 값 로드 |
| `remove(key)` | 특정 키 삭제 |
| `clear()` | 전체 삭제 |

---

### `RemoteMessageListener`

`lib/common/remote_message_listener.dart`

FCM 메시지 수신 이벤트를 처리하기 위한 인터페이스입니다.

```dart
class MyMessageListener extends RemoteMessageListener {
  @override
  void listen(RemoteMessage message) {
    // 메시지 처리
  }

  @override
  void onError(Exception error) {
    // 에러 처리
  }
}
```

---

### `TokenRefreshListener`

`lib/common/token_refresh_listener.dart`

FCM 토큰 갱신 이벤트를 처리하기 위한 인터페이스입니다.

```dart
class MyTokenListener extends TokenRefreshListener {
  @override
  void listen(String fcmToken) {
    // 갱신된 토큰 처리
  }

  @override
  void onError(Exception error) {
    // 에러 처리
  }
}
```

---

## 사용 예시

### FCM 토큰 조회

```dart
final token = await VoyagerMessaging.instance.getFcmToken();
```

### 알림 권한 요청 (iOS)

```dart
final settings = await VoyagerMessaging.instance.requestPermission(
  alert: true,
  badge: true,
  sound: true,
);
```

### Foreground 메시지 수신

```dart
VoyagerMessaging.instance.onMessage(
  (message) async {
    print('수신: ${message.notification?.title}');
  },
  (error) async {
    print('에러: $error');
  },
);
```

### Background 메시지 수신

```dart
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('백그라운드 수신: ${message.messageId}');
}

VoyagerMessaging.instance.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
```

> Background 핸들러는 익명 함수 사용 불가, 최상위 함수이어야 하며, Flutter 3.3.0 이상에서는 `@pragma('vm:entry-point')` 어노테이션이 필요합니다.

### 커스텀 서버 타겟 등록

```dart
final response = await VoyagerMessaging.instance.registerTarget(
  'push/register',   // endpoint
  'user_123',        // targetId
  fcmToken,          // FCM 토큰
);
```

---

## 로컬 참조 방법

패키지를 pub.dev에 배포하지 않고 로컬 경로로 직접 참조할 수 있습니다.

### 1. path 방식 (같은 머신에서 개발 중일 때)

사용하려는 Flutter 프로젝트의 `pubspec.yaml`에 아래와 같이 추가합니다.

```yaml
dependencies:
  voyager:
    path: ../voyager-lib-flutter/voyager_module
```

> 경로는 본인의 디렉토리 구조에 맞게 조정하세요.

이후 의존성을 갱신합니다.

```bash
flutter pub get
```

### 2. git 방식 (원격 저장소를 참조할 때)

```yaml
dependencies:
  voyager:
    git:
      url: https://github.com/your-org/voyager-lib-flutter.git
      path: voyager_module        # 저장소 내 패키지 위치
      ref: main                   # 브랜치, 태그, 또는 커밋 해시
```

특정 버전 태그를 고정하려면 `ref`에 태그명을 지정합니다.

```yaml
      ref: v0.0.1
```

### 3. import

```dart
import 'package:voyager/voyager_messaging.dart';
```

---

## Release Notes

### v0.9.0 (2026-04-28)

최초 릴리즈.

- `VoyagerMessaging` 싱글턴 퍼사드 제공
- FCM 토큰 조회 및 `SharedPreferences` 자동 저장
- APNS 토큰 조회 (iOS)
- 알림 권한 요청 (iOS)
- FCM 토픽 구독 / 구독 해제
- 커스텀 서버 타겟 등록 / 해제
- 커스텀 서버 토픽 구독 / 구독 해제
- Foreground / Background 메시지 수신 핸들러
- `RemoteMessageListener`, `TokenRefreshListener` 인터페이스

---

## 라이선스

[LICENSE](LICENSE) 참고.
