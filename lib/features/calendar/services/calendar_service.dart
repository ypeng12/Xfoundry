import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import '../models/calendar_event.dart';

class CalendarService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // TODO: MUST UPDATE - The user MUST put their Client ID generated from Google Cloud Console right here.
    // clientId: 'YOUR_CLIENT_ID.apps.googleusercontent.com',
    scopes: <String>[
      calendar.CalendarApi.calendarReadonlyScope, // Read-only scope for safety
    ],
  );

  GoogleSignInAccount? _currentUser;
  calendar.CalendarApi? _calendarApi;

  /// Authenticate with Google OAuth
  Future<bool> authorizeGoogle() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      if (_currentUser == null) {
        return false; // User cancelled
      }

      // Convert GoogleSignIn Authentication into an authenticated HTTP Client for googleapis
      final authClient = await _googleSignIn.authenticatedClient();
      if (authClient == null) {
        throw Exception('Failed to obtain authenticated client from Google Sign In.');
      }

      _calendarApi = calendar.CalendarApi(authClient);
      return true;
    } catch (error) {
      throw Exception('Failed to sign in and authorize: $error');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    _currentUser = null;
    _calendarApi = null;
  }

  /// Fetch up to 10 upcoming events from the primary calendar
  Future<List<CalendarEventModel>> fetchUpcomingEvents() async {
    if (_calendarApi == null) {
      throw Exception('User is not authorized. Must call authorizeGoogle() first.');
    }

    try {
      // Fetch events from "primary" default calendar starting from this moment
      final calendar.Events events = await _calendarApi!.events.list(
        'primary',
        maxResults: 10,
        singleEvents: true,
        orderBy: 'startTime',
        timeMin: DateTime.now().toUtc(),
      );

      final List<calendar.Event>? items = events.items;
      if (items == null || items.isEmpty) {
        return [];
      }

      // Map the official API Event object to our simple agent/app model
      return items.map((event) {
        return CalendarEventModel(
          id: event.id ?? '',
          summary: event.summary ?? 'No Title',
          description: event.description ?? '',
          startTime: event.start?.dateTime ?? event.start?.date,
          endTime: event.end?.dateTime ?? event.end?.date,
          location: event.location ?? '',
          hangoutLink: event.hangoutLink ?? '',
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch events from Google API: $e');
    }
  }
}
