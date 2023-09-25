// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../models/schedule_model.dart';
import './schedule_repository.dart';
import '../../core/exceptions/repository_exception.dart';
import '../../core/functional/either.dart';
import '../../core/functional/nil.dart';
import '../../core/restClient/rest_client.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final RestClient restClient;

  ScheduleRepositoryImpl({
    required this.restClient,
  });

  @override
  Future<Either<RepositoryException, Nil>> schedule(
    ({
      int barbershopId,
      String clientName,
      DateTime date,
      int hour,
      int userId,
    }) data,
  ) async {
    try {
      await restClient.auth.post('/schedules', data: {
        'barbershop_id': data.barbershopId,
        'user_id': data.userId,
        'client_name': data.clientName,
        'date': data.date.toIso8601String(),
        'time': data.hour,
      });

      return Success(nil);
    } on DioException catch (e, s) {
      const message = 'Erro ao realizar agendamento';
      log(message, error: e, stackTrace: s);
      return Failure(RepositoryException(message: message));
    }
  }

  @override
  Future<Either<RepositoryException, List<ScheduleModel>>> findByDate(
    ({
      DateTime date,
      int userId,
    }) filter,
  ) async {
    try {
      final Response(:List data) = await restClient.auth.get(
        '/schedules',
        queryParameters: {
          'user_id': filter.userId,
          'date': filter.date.toIso8601String(),
        },
      );

      final schedules =
          data.map((schedule) => ScheduleModel.fromMap(schedule)).toList();
      return Success(schedules);
    } on DioException catch (e, s) {
      const message = 'Erro ao buscar agendamentos';
      log(message, error: e, stackTrace: s);
      return Failure(RepositoryException(message: message));
    } on ArgumentError catch (e, s) {
      const message = 'Informações inválidas';
      log(message, error: e, stackTrace: s);
      return Failure(RepositoryException(message: message));
    }
  }
}
