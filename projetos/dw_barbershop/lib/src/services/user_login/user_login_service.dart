import '../../core/exceptions/service_exception.dart';
import '../../core/functional/nil.dart';

import '../../core/functional/either.dart';

abstract interface class UserLoginService {
  Future<Either<ServiceException, Nil>> execute(String email, String password);
}