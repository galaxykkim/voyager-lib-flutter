import 'package:voyager/service/fcm_service.dart';

class SetAutoInitEnabledUseCase {
  final FcmService fcmService;

  SetAutoInitEnabledUseCase(this.fcmService);

  Future<void> call(bool enabled) async {
    await fcmService.setAutoInitEnabled(enabled);
  }
}