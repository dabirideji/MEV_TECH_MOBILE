import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Environment {
  const Environment._();
  static const String development = 'development';
  static const String staging = 'staging';
  static const String production = 'production';
  static const String test = 'test';
}

class ScreenUtilSize {
  const ScreenUtilSize._();
  static const double width = 390;
  static const double height = 844;
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class DateTimeFormat {
  static DateFormat get dayString => DateFormat.EEEE();
  static DateFormat get monthAbbrWithDate => DateFormat.MMMMd();
  static DateFormat get hourMinutes => DateFormat.Hm();
}

enum MessageType {
  info,
  warning,
  success,
  danger,
}

String? checkNullString(dynamic value) {
  if (value != null) {
    return value as String;
  }
  return null;
}

Map<String, dynamic>? checkNullMap(dynamic value) {
  if (value != null && value is Map<String, dynamic>) {
    return value;
  }
  return null;
}

// class NullModel<T> {
//   T? checkNull(dynamic value) {
//     if (value != null) {
//       return value as T;
//     }
//     return null;
//   }
// }

String youtubeApiKey = 'AIzaSyD3eeJNbQ8fdjn3vmRWW0asUMcJdJccsr0';

class UserType {
  static const instructor = 'instructor';
  static const student = 'student';
}

class Youtube {
  static String thumbnailUrl(String videoID) =>
      'https://img.youtube.com/vi/$videoID/default.jpg';
}
