import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:voyager/service/fcm_service.dart';

class GetInitialMessageUseCase {
  final FcmService fcmService;

  GetInitialMessageUseCase(this.fcmService);

  Future<RemoteMessage?> call() async {
    return await fcmService.getInitialMessage();
  }
}