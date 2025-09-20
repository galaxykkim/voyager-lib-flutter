import 'package:dio/dio.dart';
import 'package:voyager/service/voyager_service.dart';

class RegisterTargetUseCase {
  final VoyagerService voyagerService;

  RegisterTargetUseCase(this.voyagerService);

  Future<Response> call(String endpoint, String targetId, String token) async {
    return await voyagerService.registerTarget(endpoint, targetId, token);
  }
}