import 'package:json_annotation/json_annotation.dart';

/// A custom JSON converter for [DateTime] to ensure perfect compatibility 
/// between Rust (PostgreSQL) and Flutter.
/// 
/// Handles ISO-8601 strings coming from the backend and ensures all 
/// outgoing dates are converted to UTC strings.
class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String json) {
    // Rust/Postgres typically sends ISO-8601: "2024-05-10T09:30:00Z" 
    // or "2024-05-10T09:30:00.123456Z".
    // DateTime.parse handles these formats natively.
    return DateTime.parse(json).toLocal();
  }

  @override
  String toJson(DateTime dateTime) {
    // Rule: Always send UTC to the backend.
    return dateTime.toUtc().toIso8601String();
  }
}

/// A custom JSON converter for [DateTime] that handles nullable values.
class NullableDateTimeConverter implements JsonConverter<DateTime?, String?> {
  const NullableDateTimeConverter();

  @override
  DateTime? fromJson(String? json) {
    if (json == null) return null;
    return DateTime.parse(json).toLocal();
  }

  @override
  String? toJson(DateTime? dateTime) {
    return dateTime?.toUtc().toIso8601String();
  }
}

// -----------------------------------------------------------------------------
// 🛠️ GENERATION REMINDER
// To update generated files (Freezed, JsonSerializable), run:
// fvm dart run build_runner build --delete-conflicting-outputs
// -----------------------------------------------------------------------------
