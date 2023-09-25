import '../../core/exceptions/service_exception.dart';
import '../../core/functional/either.dart';
import '../../core/functional/nil.dart';

abstract interface class UserRegisterAdminService {
  Future<Either<ServiceException, Nil>> execute(
      ({String name, String email, String password}) userData);
}
