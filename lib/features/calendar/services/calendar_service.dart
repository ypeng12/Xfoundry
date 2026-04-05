import '../../../core/network/api_client.dart';

class CalendarService {
  final ApiClient apiClient;

  CalendarService(this.apiClient);

  /// Authenticate with Google OAuth
  Future<void> authorizeGoogle() async {
    throw UnimplementedError('Google OAuth Not Implemented');
  }

  /// Realtime fetch or sync calendar events
  Stream<dynamic> syncEventsRealtime() {
    throw UnimplementedError('Google Calendar Realtime Sync Not Implemented');
  }
}
