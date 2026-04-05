import '../../../core/network/api_client.dart';

class CanvaService {
  final ApiClient apiClient;

  CanvaService(this.apiClient);

  /// Fetch all designs from Canva
  Future<List<dynamic>> fetchMyDesigns() async {
    throw UnimplementedError('Canva Fetch Not Implemented Yet');
  }

  /// Listen to Canva webhooks or realtime update channels 
  Stream<dynamic> listenToRecentChanges() {
    throw UnimplementedError('Canva Realtime Stream Not Implemented Yet');
  }
}
