import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:voyager/common/token_refresh_listener.dart';

class FcmService {
  final FirebaseMessaging _fm;

  FcmService(this._fm);

  // FCM 토큰 요청.
  Future<String?> getToken() async {
    return await _fm.getToken();
  }

  // APNS 토큰 요청.
  Future<String?> getAPNSToken() async {
    return _fm.getAPNSToken();
  }

  // 수신을 위한 권한 요청.
  Future<NotificationSettings> requestPermission(
    bool alert,
    bool announcement,
    bool badge,
    bool carPlay,
    bool criticalAlert,
    bool provisional,
    bool sound,
  ) async {
    return await _fm.requestPermission(
      alert: alert,
      announcement: announcement,
      badge: badge,
      carPlay: carPlay,
      criticalAlert: criticalAlert,
      provisional: provisional,
      sound: sound,
    );
  }

  // 메시지 알림을 클릭해 앱에 진입했을 때, 메시지 정보를 전달.
  Future<RemoteMessage?> getInitialMessage() async {
    return await _fm.getInitialMessage();
  }

  // auto init 여부 설정.
  Future<bool> setAutoInitEnabled(bool enabled) async {
    try {
      await _fm.setAutoInitEnabled(enabled);
      return true;
    } catch (error) {
      return false;
    }
  }

  // FCM 토큰 갱신 이벤트 리스너 설정.
  void setFcmTokenRefreshListener(TokenRefreshListener? listener) {
    _fm.onTokenRefresh
        .listen((fcmToken) {
      listener?.listen(fcmToken);
    })
        .onError((error) {
      listener?.onError(error);
    });
  }

  // Topic 구독.
  Future<void> subscribeToTopic(String topic) async {
    await _fm.subscribeToTopic(topic);
  }

  // Topic 구독 취소.
  Future<void> unsubscribeFromTopic(String topic) async {
    await _fm.unsubscribeFromTopic(topic);
  }


}