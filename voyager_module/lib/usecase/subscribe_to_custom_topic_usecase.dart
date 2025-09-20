import 'package:dio/dio.dart';
import 'package:voyager/service/voyager_service.dart';

class SubscribeToCustomTopicUseCase {
  final VoyagerService voyagerService;

  SubscribeToCustomTopicUseCase(this.voyagerService);

  Future<Response> call(String endpoint, String targetId, String topic) async {
    return await voyagerService.subscribeToTopic(endpoint, targetId, topic);
  }

}