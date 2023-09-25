import '../../core/exceptions/repository_exception.dart';
import '../../core/functional/either.dart';
import '../../core/functional/nil.dart';
import '../../models/schedule_model.dart';

abstract interface class ScheduleRepository {
  Future<Either<RepositoryException, Nil>> schedule(
      ({
        int barbershopId,
        int userId,
        String clientName,
        DateTime date,
        int hour,
      }) data);

  Future<Either<RepositoryException, List<ScheduleModel>>> findByDate(
      ({
        DateTime date,
        int userId,
      }) filter);
}
