import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/local_storage_keys.dart';
import '../../core/exceptions/auth_exception.dart';
import '../../core/exceptions/service_exception.dart';
import '../../core/functional/either.dart';
import '../../core/functional/nil.dart';
import '../../repositories/user/user_repository.dart';
import 'user_login_service.dart';

class UserLoginServiceImpl implements UserLoginService {
  final UserRepository userRepository;

  UserLoginServiceImpl({required this.userRepository});

  @override
  Future<Either<ServiceException, Nil>> execute(
      String email, String password) async {
    final loginResult = await userRepository.login(email, password);

    switch (loginResult) {
      case Failure(:final exception):
        return switch (exception) {
          AuthError() =>
            Failure(ServiceException(message: 'Erro ao realizar login')),
          AuthUnauthorizedException() =>
            Failure(ServiceException(message: 'E-mail e/ou senha inválidos'))
        };
      case Success(value: final accessToken):
        final sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString(LocalStorageKeys.accessToken, accessToken);
        return Success(nil);
    }
  }
}
