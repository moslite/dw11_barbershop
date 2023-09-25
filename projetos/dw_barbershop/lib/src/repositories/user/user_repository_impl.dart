import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/exceptions/auth_exception.dart';
import '../../core/exceptions/repository_exception.dart';
import '../../core/functional/either.dart';
import '../../core/functional/nil.dart';
import '../../core/restClient/rest_client.dart';
import '../../models/user_model.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RestClient restClient;

  UserRepositoryImpl({required this.restClient});

  @override
  Future<Either<AuthException, String>> login(
      String email, String password) async {
    try {
      final Response(:data) = await restClient.unAuth.post(
        '/auth',
        data: {
          'email': email,
          'password': password,
        },
      );

      return Success(data['access_token']);
    } on DioException catch (e, s) {
      if (e.response != null) {
        final Response(:statusCode) = e.response!;
        if (statusCode == HttpStatus.forbidden) {
          log('E-mail e/ou senha inválidos', error: e, stackTrace: s);
          return Failure(AuthUnauthorizedException());
        }
      }
      const message = 'Erro ao realizar login';
      log(message, error: e, stackTrace: s);
      return Failure(AuthError(message: message));
    }
  }

  @override
  Future<Either<RepositoryException, UserModel>> me() async {
    try {
      final Response(:data) = await restClient.auth.get('/me');
      final userModel = UserModel.fromMap(data);
      return Success(userModel);
    } on DioException catch (e, s) {
      const message = 'Erro ao buscar usuário logado';
      log(message, error: e, stackTrace: s);
      return Failure(RepositoryException(message: message));
    } on ArgumentError catch (e, s) {
      log('Invalid JSON', error: e, stackTrace: s);
      return Failure(RepositoryException(message: e.message));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerAdmin(
      ({String email, String name, String password}) userData) async {
    try {
      await restClient.unAuth.post('/users', data: {
        'name': userData.name,
        'email': userData.email,
        'password': userData.password,
        'profile': 'ADM',
      });
      return Success(nil);
    } on DioException catch (e, s) {
      const message = 'Erro ao registrar usuário admin';
      log(message, error: e, stackTrace: s);
      return Failure(RepositoryException(message: message));
    }
  }

  @override
  Future<Either<RepositoryException, List<UserModel>>> getEmployees(
      int barbershopId) async {
    try {
      final Response(:data) = await restClient.auth.get(
        '/users',
        queryParameters: {
          'barbershop_id': barbershopId,
        },
      );

      final employees = data
          .map<UserModelEmployee>(
              (employee) => UserModelEmployee.fromMap(employee))
          .toList();
      return Success(employees);
    } on DioException catch (e, s) {
      const message = 'Erro ao buscar colaboradores';
      log(message, error: e, stackTrace: s);
      return Failure(RepositoryException(message: message));
    } on ArgumentError catch (e, s) {
      const message = 'Erro ao converter JSON - Colaboradores';
      log(message, error: e, stackTrace: s);
      return Failure(RepositoryException(message: message));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerAdminEmployee(
    ({
      List<String> workDays,
      List<int> workHours,
    }) data,
  ) async {
    try {
      final userModelResult = await me();
      int userId;

      switch (userModelResult) {
        case Success(value: UserModel(:final id)):
          userId = id;
        case Failure(:final exception):
          return Failure(exception);
      }

      await restClient.auth.put(
        '/users/$userId',
        data: {
          'work_days': data.workDays,
          'work_hours': data.workHours,
        },
      );

      return Success(nil);
    } on DioException catch (e, s) {
      const message = 'Erro ao atualizar usuário';
      log(message, error: e, stackTrace: s);
      return Failure(RepositoryException(message: message));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerEmployee(
    ({
      int barbershopId,
      String email,
      String name,
      String password,
      List<String> workDays,
      List<int> workHours,
    }) data,
  ) async {
    try {
      await restClient.auth.post(
        '/users',
        data: {
          'name': data.name,
          'email': data.email,
          'password': data.password,
          'barbershop_id': data.barbershopId,
          'profile': 'EMPLOYEE',
          'work_days': data.workDays,
          'work_hours': data.workHours,
        },
      );

      return Success(nil);
    } on DioException catch (e, s) {
      const message = 'Erro ao registrar usuário';
      log(message, error: e, stackTrace: s);
      return Failure(RepositoryException(message: message));
    }
  }
}
