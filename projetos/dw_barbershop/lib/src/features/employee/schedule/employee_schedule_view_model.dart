import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/exceptions/repository_exception.dart';
import '../../../core/functional/either.dart';
import '../../../core/providers/application_providers.dart';
import '../../../models/schedule_model.dart';

part 'employee_schedule_view_model.g.dart';

@riverpod
class EmployeeScheduleViewModel extends _$EmployeeScheduleViewModel {
  Future<Either<RepositoryException, List<ScheduleModel>>> _getSchedules(
    int userId,
    DateTime date,
  ) {
    final repository = ref.read(scheduleRepositoryProvider);
    return repository.findByDate((date: date, userId: userId));
  }

  @override
  Future<List<ScheduleModel>> build(int userId, DateTime date) async {
    final schedules = await _getSchedules(userId, date);

    return switch (schedules) {
      Success(value: final schedules) => schedules,
      Failure(:final exception) => throw Exception(exception),
    };
  }

  Future<void> changeDate(int userId, DateTime date) async {
    final schedulesResult = await _getSchedules(userId, date);
    state = switch (schedulesResult) {
      Success(value: final schedules) => AsyncData(schedules),
      Failure(:final exception) => AsyncError(exception, StackTrace.current),
    };
  }
}
