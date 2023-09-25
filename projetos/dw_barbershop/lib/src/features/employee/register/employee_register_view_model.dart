import 'package:asyncstate/asyncstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/exceptions/repository_exception.dart';
import '../../../core/functional/either.dart';
import '../../../core/functional/nil.dart';
import '../../../core/providers/application_providers.dart';
import '../../../models/barbershop_model.dart';
import '../../../repositories/user/user_repository.dart';
import 'employee_register_state.dart';

part 'employee_register_view_model.g.dart';

@riverpod
class EmployeeRegisterViewModel extends _$EmployeeRegisterViewModel {
  @override
  EmployeeRegisterState build() => EmployeeRegisterState.initial();

  void setRegisterAdmin(bool isAdmin) {
    state = state.copyWith(isAdmin: isAdmin);
  }

  void manageWorkDay(String day) {
    final EmployeeRegisterState(:workDays) = state;

    if (workDays.contains(day)) {
      workDays.remove(day);
    } else {
      workDays.add(day);
    }

    state = state.copyWith(workDays: workDays);
  }

  void manageWorkHour(int hour) {
    final EmployeeRegisterState(:workHours) = state;

    if (workHours.contains(hour)) {
      workHours.remove(hour);
    } else {
      workHours.add(hour);
    }

    state = state.copyWith(workHours: workHours);
  }

  Future<void> register({
    String? name,
    String? email,
    String? password,
  }) async {
    final EmployeeRegisterState(:isAdmin, :workDays, :workHours) = state;
    final asyncLoaderHandler = AsyncLoaderHandler()..start();
    final UserRepository(:registerAdminEmployee, :registerEmployee) =
        ref.read(userRepositoryProvider);

    final Either<RepositoryException, Nil> result;

    if (isAdmin) {
      final dto = (
        workDays: workDays,
        workHours: workHours,
      );
      result = await registerAdminEmployee(dto);
    } else {
      final BarbershopModel(:id) =
          await ref.watch(getMyBarbershopProvider.future);
      final dto = (
        barbershopId: id,
        name: name!,
        email: email!,
        password: password!,
        workDays: workDays,
        workHours: workHours,
      );
      result = await registerEmployee(dto);
    }

    switch (result) {
      case Success():
        state = state.copyWith(status: EmployeeRegisterStateStatus.success);
      case Failure():
        state = state.copyWith(status: EmployeeRegisterStateStatus.error);
    }
    asyncLoaderHandler.close();
  }
}
