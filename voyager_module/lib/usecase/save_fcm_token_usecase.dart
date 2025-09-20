import 'package:voyager/repository/voyager_repository.dart';

class SaveFcmTokenUseCase {
  final repository = VoyagerRepository();

  Future<bool> call(String token) async {
    return await repository.saveString(key: "FCM_TOKEN", value: token);
  }
}