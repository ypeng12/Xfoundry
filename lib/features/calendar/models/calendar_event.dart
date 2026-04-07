class CalendarEventModel {
  final String id;
  final String summary;
  final String description;
  final DateTime? startTime;
  final DateTime? endTime;
  final String location;
  final String hangoutLink;

  CalendarEventModel({
    required this.id,
    required this.summary,
    required this.description,
    this.startTime,
    this.endTime,
    required this.location,
    required this.hangoutLink,
  });

  // Since we use the official Google Calendar API SDK, we map it manually from their Event object
  // Avoid using dynamically typed JSON mapping here since googleapis creates proper Dart Objects
}
