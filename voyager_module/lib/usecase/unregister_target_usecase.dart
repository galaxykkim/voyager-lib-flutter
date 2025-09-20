import 'package:dio/dio.dart';
import 'package:voyager/service/voyager_service.dart';

class UnregisterTargetUseCase {
  final VoyagerService voyagerService;

  UnregisterTargetUseCase(this.voyagerService);

  Future<Response> call(String endpoint, String targetId) async {
    return await voyagerService.unregisterTarget(endpoint, targetId);
  }
}