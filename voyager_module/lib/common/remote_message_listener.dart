import 'package:firebase_messaging/firebase_messaging.dart';

interface class RemoteMessageListener {
  void listen(RemoteMessage message) {}
  void onError(Exception error) {}
}