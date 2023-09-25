import 'package:asyncstate/asyncstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/functional/either.dart';
import '../../../../core/providers/application_providers.dart';
import 'user_register_providers.dart';

part 'user_register_view_model.g.dart';

enum UserRegisterStateStatusEnum {
  initial,
  success,
  error,
}

@riverpod
class UserRegisterViewModel extends _$UserRegisterViewModel {
  @override
  UserRegisterStateStatusEnum build() => UserRegisterStateStatusEnum.initial;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final userRegisterService = ref.watch(userRegisterAdminServiceProvider);

    final registerResult = await userRegisterService.execute((
      name: name,
      email: email,
      password: password,
    )).asyncLoader();

    switch (registerResult) {
      case Success():
        ref.invalidate(getMeProvider);
        state = UserRegisterStateStatusEnum.success;
      case Failure():
        state = UserRegisterStateStatusEnum.error;
    }
  }
}
