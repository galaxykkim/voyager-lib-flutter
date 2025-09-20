import 'package:dio/dio.dart';

class VoyagerService {
  final dio = Dio();
  String _apiUrl = "";

  VoyagerService({required apiUrl}) {
    _apiUrl = apiUrl;
    dio.interceptors.add(LogInterceptor(
      request: false,
      requestHeader: false,
      requestBody: false,
      responseHeader: false,
      responseBody: false,
      error: true,
    ));
  }

  // Target 등록.
  Future<Response> registerTarget(
      String endpoint,
      String targetId,
      String token,
  ) async {
    return await dio.post(
      "$_apiUrl/$endpoint",
      data: { "targetId": targetId, "token": token }
    );
  }

  Future<Response> unregisterTarget(
      String endpoint,
      String targetId,
  ) async {
    return await dio.delete(
      "$_apiUrl/$endpoint",
      data: { "targetId": targetId }
    );
  }

  // Topic 구독.
  Future<Response> subscribeToTopic(
      String endpoint,
      String targetId,
      String topic
  ) async {
    return await dio.post(
      "$_apiUrl/$endpoint",
      data: { "targetId": targetId, "topic": topic }
    );
  }

  // Topic 구독 취소.
  Future<Response> unsubscribeFromTopic(
      String endpoint,
      String targetId,
      String topic,
  ) async {
    return await dio.post(
      "$_apiUrl/$endpoint",
      data: { "targetId": targetId, "topic": topic }
    );
  }


}