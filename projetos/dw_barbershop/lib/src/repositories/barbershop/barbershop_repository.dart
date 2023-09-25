import '../../core/exceptions/repository_exception.dart';
import '../../core/functional/either.dart';
import '../../core/functional/nil.dart';
import '../../models/barbershop_model.dart';
import '../../models/user_model.dart';

abstract interface class BarbershopRepository {
  Future<Either<RepositoryException, BarbershopModel>> getMyBarbershop(
      UserModel userModel);
  Future<Either<RepositoryException, Nil>> save(
      ({
        String name,
        String email,
        List<String> openingDays,
        List<int> openingHours,
      }) data);
}
