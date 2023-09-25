import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/ui/constants.dart';
import '../../../core/ui/helpers/messages.dart';

class ScheduleCalendar extends StatefulWidget {
  final VoidCallback onCancel;
  final ValueChanged<DateTime> onConfirm;
  final List<String> availableDays;

  const ScheduleCalendar({
    super.key,
    required this.onCancel,
    required this.onConfirm,
    required this.availableDays,
  });

  @override
  State<ScheduleCalendar> createState() => _ScheduleCalendarState();
}

class _ScheduleCalendarState extends State<ScheduleCalendar> {
  DateTime? selectedDay;
  late final List<int> availableDays;

  int convertWeekday(String weekday) {
    return switch (weekday.toLowerCase()) {
      'seg' => DateTime.monday,
      'ter' => DateTime.tuesday,
      'qua' => DateTime.wednesday,
      'qui' => DateTime.thursday,
      'sex' => DateTime.friday,
      'sab' => DateTime.saturday,
      'dom' => DateTime.sunday,
      _ => 0
    };
  }

  @override
  void initState() {
    availableDays = widget.availableDays.map(convertWeekday).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFe6e2e9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          TableCalendar(
            availableGestures: AvailableGestures.none,
            headerStyle: const HeaderStyle(
              titleCentered: true,
            ),
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
              });
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: ColorsConstants.brown,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: ColorsConstants.brown.withOpacity(.6),
                shape: BoxShape.circle,
              ),
            ),
            focusedDay: DateTime.now(),
            firstDay: DateTime.utc(2010, 01, 01),
            lastDay: DateTime.now().add(const Duration(days: 365 * 10)),
            calendarFormat: CalendarFormat.month,
            locale: 'pt_BR',
            enabledDayPredicate: (day) => availableDays.contains(day.weekday),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.onCancel,
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorsConstants.brown,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (selectedDay == null) {
                    Messages.showError('Selecione uma data', context);
                    return;
                  }

                  widget.onConfirm(selectedDay!);
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ColorsConstants.brown,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
