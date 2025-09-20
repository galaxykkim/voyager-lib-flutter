import 'package:voyager/service/fcm_service.dart';

class GetAPNSTokenUseCase {
  final FcmService fcmService;

  GetAPNSTokenUseCase(this.fcmService);

  Future<String?> call() async {
    return await fcmService.getAPNSToken();
  }
}