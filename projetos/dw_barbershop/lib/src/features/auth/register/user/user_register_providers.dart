import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/application_providers.dart';
import '../../../../services/user_register/user_register_admin_service.dart';
import '../../../../services/user_register/user_register_admin_service_impl.dart';

part 'user_register_providers.g.dart';

@riverpod
UserRegisterAdminService userRegisterAdminService(
        UserRegisterAdminServiceRef ref) =>
    UserRegisterAdminServiceImpl(
      userRepository: ref.watch(userRepositoryProvider),
      userLoginService: ref.watch(userLoginServiceProvider),
    );
