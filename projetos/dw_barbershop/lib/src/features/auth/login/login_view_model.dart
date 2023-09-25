import 'package:asyncstate/asyncstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/exceptions/service_exception.dart';
import '../../../core/functional/either.dart';
import '../../../core/providers/application_providers.dart';
import '../../../models/user_model.dart';
import 'login_state.dart';

part 'login_view_model.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  LoginState build() => LoginState.initial();

  Future<void> login(String email, String password) async {
    final loaderHandler = AsyncLoaderHandler()..start();

    final loginService = ref.watch(userLoginServiceProvider);

    final result = await loginService.execute(email, password);
    switch (result) {
      case Success():
        ref.invalidate(getMeProvider);
        ref.invalidate(getMyBarbershopProvider);
        final userModel = await ref.watch(getMeProvider.future);
        switch (userModel) {
          case UserModelAdmin():
            state = state.copyWith(status: LoginStateStatusEnum.admin);
          case UserModelEmployee():
            state = state.copyWith(status: LoginStateStatusEnum.employee);
        }
        break;
      case Failure(exception: ServiceException(:final message)):
        state = state.copyWith(
          status: LoginStateStatusEnum.error,
          errorMessage: () => message,
        );
    }

    loaderHandler.close();
  }
}
