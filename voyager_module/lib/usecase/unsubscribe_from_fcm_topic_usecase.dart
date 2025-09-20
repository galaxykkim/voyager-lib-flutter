import 'package:voyager/service/fcm_service.dart';

class UnsubscribeFromFcmTopicUseCase {
  final FcmService fcmService;

  UnsubscribeFromFcmTopicUseCase(this.fcmService);

  Future<void> call(String topic) async {
    await fcmService.unsubscribeFromTopic(topic);
  }
}