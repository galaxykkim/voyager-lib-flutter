import 'package:voyager/service/fcm_service.dart';
import 'package:voyager/usecase/save_fcm_token_usecase.dart';

class GetFcmTokenUseCase {
  final FcmService fcmService;
  final saveFcmTokenUseCase = SaveFcmTokenUseCase();

  GetFcmTokenUseCase(this.fcmService);

  Future<String?> call() async {
    final token = await fcmService.getToken();
    if (token != null) {
      saveFcmTokenUseCase.call(token);
    }
    return token;
  }
}