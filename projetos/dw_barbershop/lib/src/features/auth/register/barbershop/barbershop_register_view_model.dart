import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/functional/either.dart';
import '../../../../core/providers/application_providers.dart';
import 'barbershop_register_state.dart';

part 'barbershop_register_view_model.g.dart';

@riverpod
class BarbershopRegisterViewModel extends _$BarbershopRegisterViewModel {
  @override
  BarbershopRegisterState build() => BarbershopRegisterState.initial();

  void addOrRemoveOpeningDays(String day) {
    final openingDays = state.openingDays;

    if (openingDays.contains(day)) {
      openingDays.remove(day);
    } else {
      openingDays.add(day);
    }

    state = state.copyWith(openingDays: openingDays);
  }

  void addOrRemoveOpeningHours(int hour) {
    final openingHours = state.openingHours;

    if (openingHours.contains(hour)) {
      openingHours.remove(hour);
    } else {
      openingHours.add(hour);
    }

    state = state.copyWith(openingHours: openingHours);
  }

  Future<void> register(String name, String email) async {
    final repository = ref.watch(barbershopRepositoryProvider);
    final BarbershopRegisterState(:openingDays, :openingHours) = state;

    final dto = (
      name: name,
      email: email,
      openingDays: openingDays,
      openingHours: openingHours,
    );

    final result = await repository.save(dto);

    switch (result) {
      case Success():
        ref.invalidate(getMyBarbershopProvider);
        state =
            state.copyWith(status: BarbershopRegisterStateStatusEnum.success);
      case Failure():
        state = state.copyWith(status: BarbershopRegisterStateStatusEnum.error);
    }
  }
}
