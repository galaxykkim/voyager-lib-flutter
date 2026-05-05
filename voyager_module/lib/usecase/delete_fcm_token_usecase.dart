import 'package:voyager/service/fcm_service.dart';

class DeleteFcmTokenUseCase {
  final FcmService fcmService;

  DeleteFcmTokenUseCase(this.fcmService);

  Future<void> call() async {
    await fcmService.deleteToken();
  }
}
