import 'package:voyager/repository/voyager_repository.dart';

class LoadFcmTokenUseCase {
  final repository = VoyagerRepository();

  Future<String?> call() async {
    return await repository.loadString(key: "FCM_TOKEN");
  }
}