

import 'package:json_annotation/json_annotation.dart';

class DatetimeConverter implements JsonConverter<DateTime?, String?> {

  const DatetimeConverter();

  @override
  DateTime? fromJson(String? json) {
    return json == null ? null : DateTime.tryParse(json);
  }

  @override
  String? toJson(DateTime? object) {
    return object?.toIso8601String();
  }

}