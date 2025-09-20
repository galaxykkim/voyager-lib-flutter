import 'package:voyager/service/fcm_service.dart';

class SubscribeToFcmTopicUseCase {
  final FcmService fcmService;

  SubscribeToFcmTopicUseCase(this.fcmService);

  Future<void> call(String topic) async {
    await fcmService.subscribeToTopic(topic);
  }
}