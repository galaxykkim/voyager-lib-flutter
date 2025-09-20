import 'package:dio/dio.dart';
import 'package:voyager/service/voyager_service.dart';

class UnsubscribeFromCustomTopicUseCase {
  final VoyagerService voyagerService;

  UnsubscribeFromCustomTopicUseCase(this.voyagerService);

  Future<Response> call(String endpoint, String targetId, String topic) async {
    return await voyagerService.unsubscribeFromTopic(endpoint, targetId, topic);
  }
}