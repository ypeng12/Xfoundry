import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/housing_model.dart';
import '../../../core/network/api_client.dart';

class HousingService {
  final ApiClient? apiClient;
  HousingService({this.apiClient});

  static const String baseUrl = 'http://127.0.0.1:8000/api/v1/housing';

  Future<List<HousingModel>> fetchHousingListings() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        if (jsonResponse['status'] == 'success') {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((item) => HousingModel.fromJson(item)).toList();
        } else {
          throw Exception('Backend returned error: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load listings. HTTP Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error or parsing error: $e');
    }
  }

  /// Placeholder for future WebSockets or Polls
  Stream<List<HousingModel>> streamLiveListings() {
    throw UnimplementedError("Live fetching via sockets not implemented");
  }
}
