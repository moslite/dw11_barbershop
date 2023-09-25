// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

enum ScheduleStateStatus {
  initial,
  success,
  error,
}

class ScheduleState {
  final ScheduleStateStatus status;
  final int? hour;
  final DateTime? date;

  ScheduleState.initial() : this(status: ScheduleStateStatus.initial);

  ScheduleState({
    required this.status,
    this.hour,
    this.date,
  });

  ScheduleState copyWith({
    ScheduleStateStatus? status,
    ValueGetter<int?>? hour,
    ValueGetter<DateTime?>? date,
  }) {
    return ScheduleState(
      status: status ?? this.status,
      hour: hour != null ? hour() : this.hour,
      date: date != null ? date() : this.date,
    );
  }
}
