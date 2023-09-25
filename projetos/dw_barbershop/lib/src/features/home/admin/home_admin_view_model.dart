import 'package:asyncstate/asyncstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/functional/either.dart';
import '../../../core/providers/application_providers.dart';
import '../../../models/barbershop_model.dart';
import '../../../models/user_model.dart';
import 'home_admin_state.dart';

part 'home_admin_view_model.g.dart';

@riverpod
class HomeAdminViewModel extends _$HomeAdminViewModel {
  @override
  Future<HomeAdminState> build() async {
    final userRepository = ref.read(userRepositoryProvider);
    final BarbershopModel(id: barbershopId) =
        await ref.read(getMyBarbershopProvider.future);
    final employeesResult = await userRepository.getEmployees(barbershopId);
    final me = await ref.watch(getMeProvider.future);

    switch (employeesResult) {
      case Success(value: final employeesData):
        final employees = <UserModel>[];

        if (me case UserModelAdmin(workDays: _?, workHours: _?)) {
          employees.add(me);
        }
        employees.addAll(employeesData);

        return HomeAdminState(
          status: HomeAdminStateStatusEnum.loaded,
          employees: employees,
        );
      case Failure():
        return HomeAdminState(
          status: HomeAdminStateStatusEnum.error,
          employees: [],
        );
    }
  }

  Future<void> logout() => ref.read(logoutProvider.future).asyncLoader();
}
