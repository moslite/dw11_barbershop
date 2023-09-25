import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/local_storage_keys.dart';
import '../../core/providers/application_providers.dart';
import '../../models/user_model.dart';

part 'splash_view_model.g.dart';

enum SplashStateEnum {
  initial,
  login,
  admin,
  employee,
  error,
}

@riverpod
class SplashViewModel extends _$SplashViewModel {
  @override
  Future<SplashStateEnum> build() async {
    final shared = await SharedPreferences.getInstance();

    if (shared.containsKey(LocalStorageKeys.accessToken)) {
      ref.invalidate(getMeProvider);
      ref.invalidate(getMyBarbershopProvider);

      try {
        final userModel = await ref.watch(getMeProvider.future);
        return switch (userModel) {
          UserModelAdmin() => SplashStateEnum.admin,
          UserModelEmployee() => SplashStateEnum.employee,
        };
      } catch (e) {
        return SplashStateEnum.login;
      }
    }

    return SplashStateEnum.login;
  }
}
