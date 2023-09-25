import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../core/ui/constants.dart';
import '../../../core/ui/helpers/date_time_extension.dart';
import '../../../core/ui/widgets/barbershop_loader.dart';
import '../../../models/user_model.dart';
import 'appointment_ds.dart';
import 'employee_schedule_view_model.dart';

class EmployeeSchedulePage extends ConsumerStatefulWidget {
  const EmployeeSchedulePage({super.key});

  @override
  ConsumerState<EmployeeSchedulePage> createState() =>
      _EmployeeSchedulePageState();
}

class _EmployeeSchedulePageState extends ConsumerState<EmployeeSchedulePage> {
  late DateTime selectedDate;
  var ignoreFirstLoad = true;

  @override
  void initState() {
    final DateTime(:year, :month, :day) = DateTime.now();
    selectedDate = DateTime(year, month, day, 0, 0, 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel(id: userId, :name) =
        ModalRoute.of(context)?.settings.arguments as UserModel;
    final scheduleAsync =
        ref.watch(EmployeeScheduleViewModelProvider(userId, selectedDate));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
      ),
      body: Column(
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 44),
          scheduleAsync.when(
            loading: () => const BarbershopLoader(),
            error: (error, stackTrace) {
              const message = 'Erro ao carregar agendamentos';
              log(message, error: error, stackTrace: stackTrace);
              return const Center(
                child: Text(message),
              );
            },
            data: (schedules) {
              return Expanded(
                child: SfCalendar(
                  allowViewNavigation: false,
                  view: CalendarView.day,
                  showNavigationArrow: true,
                  todayHighlightColor: ColorsConstants.brown,
                  showDatePickerButton: true,
                  showTodayButton: true,
                  onViewChanged: (viewChangedDetails) {
                    if (ignoreFirstLoad) {
                      ignoreFirstLoad = false;
                      return;
                    }
                    ref
                        .read(employeeScheduleViewModelProvider(
                                userId, selectedDate)
                            .notifier)
                        .changeDate(
                          userId,
                          viewChangedDetails.visibleDates.first,
                        );
                  },
                  onTap: (calendarTapDetails) {
                    if (calendarTapDetails.appointments != null &&
                        calendarTapDetails.appointments!.isNotEmpty) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 200,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Cliente: ${calendarTapDetails.appointments?.first.subject}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                                  Text(
                                    'Horário: ${calendarTapDetails.date?.toBrazilianDateTimeFormat()}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  dataSource: AppointmentDs(schedules: schedules),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
