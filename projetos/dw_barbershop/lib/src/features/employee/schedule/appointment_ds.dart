// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../core/ui/constants.dart';
import '../../../models/schedule_model.dart';

class AppointmentDs extends CalendarDataSource {
  final List<ScheduleModel> schedules;

  AppointmentDs({
    required this.schedules,
  });

  @override
  List<dynamic>? get appointments {
    return schedules.map(
      (schedule) {
        final ScheduleModel(
          date: DateTime(:year, :month, :day),
          :hour,
          :clientName
        ) = schedule;
        final startAt = DateTime(year, month, day, hour, 0, 0);
        final endAt = DateTime(year, month, day, hour + 1, 0, 0);

        return Appointment(
          color: ColorsConstants.brown,
          startTime: startAt,
          endTime: endAt,
          subject: clientName,
        );
      },
    ).toList();
  }
}
