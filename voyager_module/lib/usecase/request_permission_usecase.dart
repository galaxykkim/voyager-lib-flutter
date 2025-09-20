import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:voyager/service/fcm_service.dart';

class RequestPermissionUseCase {
  final FcmService fcmService;

  RequestPermissionUseCase(this.fcmService);

  Future<NotificationSettings> call(
    bool alert,
    bool announcement,
    bool badge,
    bool carPlay,
    bool criticalAlert,
    bool provisional,
    bool sound,
  ) async {
    final settings = await fcmService.requestPermission(
      alert,
      announcement,
      badge,
      carPlay,
      criticalAlert,
      provisional,
      sound,
    );
    return settings;
  }
}