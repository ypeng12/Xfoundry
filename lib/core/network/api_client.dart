abstract class ApiClient {
  Future<dynamic> get(String endpoint, {Map<String, String>? query});
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body});
}

abstract class RealtimeClient {
  void connect(String wsUrl);
  void disconnect();
  Stream<dynamic> listenToChannel(String channel);
}
