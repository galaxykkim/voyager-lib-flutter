library voyager_messaging;

import 'package:dio/src/response.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:voyager/service/fcm_service.dart';
import 'package:voyager/service/voyager_service.dart';
import 'package:voyager/usecase/delete_fcm_token_usecase.dart';
import 'package:voyager/usecase/get_apns_token_usecase.dart';
import 'package:voyager/usecase/get_fcm_token_usecase.dart';
import 'package:voyager/usecase/get_initial_message_usecase.dart';
import 'package:voyager/usecase/register_target_usecase.dart';
import 'package:voyager/usecase/request_permission_usecase.dart';
import 'package:voyager/usecase/set_auto_init_enabled_usecase.dart';
import 'package:voyager/usecase/subscribe_to_custom_topic_usecase.dart';
import 'package:voyager/usecase/subscribe_to_fcm_topic_usecase.dart';
import 'package:voyager/usecase/unregister_target_usecase.dart';
import 'package:voyager/usecase/unsubscribe_from_custom_topic_usecase.dart';
import 'package:voyager/usecase/unsubscribe_from_fcm_topic_usecase.dart';

class VoyagerMessaging {
  static final VoyagerMessaging _instance = VoyagerMessaging._internal();
  VoyagerMessaging._internal();
  static VoyagerMessaging get instance => _instance;

  static late FcmService _fcmService;
  static VoyagerService? _voyagerService;

  /// VoyagerMessaging 초기화.
  static void initialize(FirebaseMessaging fm, {String? apiUrl}) {
    _fcmService = FcmService(fm);
    if (apiUrl != null) { _voyagerService = VoyagerService(apiUrl: apiUrl); }
  }

  /// VoyagerService 초기화 여부 체크.
  bool checkVoyagerService() {
    if (_voyagerService == null) {
      throw Exception("");
    }
    return true;
  }

  /// FCM 토큰 요청.
  Future<String?> getFcmToken() async {
    return await GetFcmTokenUseCase(_fcmService).call();
  }

  /// APNS 토큰 요청. (Only iOS)
  Future<String?> getAPNSToken() async {
    return await GetAPNSTokenUseCase(_fcmService).call();
  }

  /// 메시지 알림을 통해 앱 진입 시, 메시지 정보 전달.
  Future<RemoteMessage?> getInitialMessage() async {
    return await GetInitialMessageUseCase(_fcmService).call();
  }

  /// auto-init 사용 여부 설정.
  void setFcmAutoInitEnabled(bool enabled) async {
    await SetAutoInitEnabledUseCase(_fcmService).call(enabled);
  }

  /// 메시지 수신을 위한 권한 요청. (Only iOS)
  Future<NotificationSettings> requestPermission({
    bool alert = true,
    bool announcement = false,
    bool badge = true,
    bool carPlay = false,
    bool criticalAlert = false,
    bool provisional = false,
    bool sound = true,
  }) async {
    return await RequestPermissionUseCase(_fcmService).call(
      alert,
      announcement,
      badge,
      carPlay,
      criticalAlert,
      provisional,
      sound,
    );
  }

  /// FCM 토큰 삭제. 삭제 후 FCM은 이 기기로 메시지를 전달하지 못함.
  Future<void> deleteFcmToken() async {
    await DeleteFcmTokenUseCase(_fcmService).call();
  }

  /// FCM 토픽 구독 설정.
  Future<void> subscribeToFcmTopic(String topic) async {
    await SubscribeToFcmTopicUseCase(_fcmService).call(topic);
  }

  /// FCM 토픽 구독 해제.
  Future<void> unsubscribeFromFcmTopic(String topic) async {
    await UnsubscribeFromFcmTopicUseCase(_fcmService).call(topic);
  }

  /// 타겟 등록.
  Future<Response> registerTarget(
      String endpoint,
      String targetId,
      String token,
  ) async {
    checkVoyagerService();
    return await RegisterTargetUseCase(_voyagerService!)
        .call(endpoint, targetId, token);
  }

  /// 타겟 등록해제.
  Future<Response> unregisterTarget(
      String endpoint,
      String targetId,
  ) async {
    checkVoyagerService();
    return await UnregisterTargetUseCase(_voyagerService!)
        .call(endpoint, targetId);
  }

  /// 커스텀 토픽 구독 설정.
  Future<Response> subscribeToCustomTopic(
      String endpoint,
      String targetId,
      String topic,
  ) async {
    checkVoyagerService();
    return await SubscribeToCustomTopicUseCase(_voyagerService!)
        .call(endpoint, targetId, topic);
  }

  /// 커스텀 토픽 구독 해제.
  Future<Response> unsubscribeFromCustomTopic(
      String endpoint,
      String targetId,
      String topic,
  ) async {
    checkVoyagerService();
    return await UnsubscribeFromCustomTopicUseCase(_voyagerService!)
        .call(endpoint, targetId, topic);
  }

  /// Forground 상태에서 메시지 수신을 위한 설정.
  void onMessage(
    Future<void> Function(RemoteMessage) handlerFunc,
    Future<void> Function(Exception) errorHandlerFunc,
  ) {
    FirebaseMessaging.onMessage
      .listen((message) {
        handlerFunc(message);
      })
      .onError((error) {
        errorHandlerFunc(error);
      });
  }

  /// Background 상태에서 메시지 수신을 위한 설정.
  /// 주의! 아래 조건을 만족해야만 수신 가능.
  /// 1. 익명 함수를 사용하면 안됨.
  /// 2. 반드시 최상위 수준의 함수이어야 함.
  /// 3. Flutter 3.3.0 이상인 경우, 반드기 @pragma('vm:entry-point') 어노테이션을 추가할 것.
  void onBackgroundMessage(Future<void> Function(RemoteMessage) handlerFunc) {
    FirebaseMessaging.onBackgroundMessage(handlerFunc);
  }
  
}