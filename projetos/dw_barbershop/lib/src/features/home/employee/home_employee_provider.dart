import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/functional/either.dart';
import '../../../core/providers/application_providers.dart';

part 'home_employee_provider.g.dart';

@riverpod
Future<int> getTotalSchedulesToday(
    GetTotalSchedulesTodayRef ref, int userId) async {
  final DateTime(:year, :month, :day) = DateTime.now();
  final filter = (
    date: DateTime(year, month, day, 0, 0, 0),
    userId: userId,
  );

  final repository = ref.read(scheduleRepositoryProvider);
  final schedulesResult = await repository.findByDate(filter);

  return switch (schedulesResult) {
    Success(value: List(length: final totalSchedules)) => totalSchedules,
    Failure(:final exception) => throw exception,
  };
}
