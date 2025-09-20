interface class TokenRefreshListener {
  void listen(String fcmToken) {}
  void onError(Exception error) {}
}