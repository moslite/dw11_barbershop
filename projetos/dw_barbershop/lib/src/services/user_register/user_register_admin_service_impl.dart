// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../core/exceptions/repository_exception.dart';
import 'user_register_admin_service.dart';
import '../../core/exceptions/service_exception.dart';
import '../../core/functional/either.dart';
import '../../core/functional/nil.dart';
import '../../repositories/user/user_repository.dart';
import '../user_login/user_login_service.dart';

class UserRegisterAdminServiceImpl implements UserRegisterAdminService {
  final UserRepository userRepository;
  final UserLoginService userLoginService;

  UserRegisterAdminServiceImpl({
    required this.userRepository,
    required this.userLoginService,
  });

  @override
  Future<Either<ServiceException, Nil>> execute(
      ({String email, String name, String password}) userData) async {
    final registerResult = await userRepository.registerAdmin(userData);

    switch (registerResult) {
      case Success():
        return userLoginService.execute(userData.email, userData.password);
      case Failure(exception: RepositoryException(:final message)):
        return Failure(ServiceException(message: message));
    }
  }
}
