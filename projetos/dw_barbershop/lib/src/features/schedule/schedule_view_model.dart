import 'package:asyncstate/asyncstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/functional/either.dart';
import '../../core/providers/application_providers.dart';
import '../../models/barbershop_model.dart';
import '../../models/user_model.dart';
import 'schedule_state.dart';

part 'schedule_view_model.g.dart';

@riverpod
class ScheduleViewModel extends _$ScheduleViewModel {
  @override
  ScheduleState build() => ScheduleState.initial();

  void selectHour(int hour) {
    if (hour == state.hour) {
      state = state.copyWith(hour: () => null);
    } else {
      state = state.copyWith(hour: () => hour);
    }
  }

  void selectDate(DateTime date) {
    state = state.copyWith(date: () => date);
  }

  Future<void> register({
    required UserModel userModel,
    required String clientName,
  }) async {
    final asyncLoaderHandler = AsyncLoaderHandler()..start();

    final scheduleRepository = ref.read(scheduleRepositoryProvider);
    final ScheduleState(:hour, :date) = state;
    final BarbershopModel(id: barbershopId) =
        await ref.read(getMyBarbershopProvider.future);

    final dto = (
      barbershopId: barbershopId,
      userId: userModel.id,
      clientName: clientName,
      date: date!,
      hour: hour!,
    );

    final result = await scheduleRepository.schedule(dto);

    switch (result) {
      case Success():
        state = state.copyWith(status: ScheduleStateStatus.success);
      case Failure():
        state = state.copyWith(status: ScheduleStateStatus.error);
    }

    asyncLoaderHandler.close();
  }
}
