// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dio/dio.dart';

import './barbershop_repository.dart';
import '../../core/exceptions/repository_exception.dart';
import '../../core/functional/either.dart';
import '../../core/functional/nil.dart';
import '../../core/restClient/rest_client.dart';
import '../../models/barbershop_model.dart';
import '../../models/user_model.dart';

class BarbershopRepositoryImpl implements BarbershopRepository {
  final RestClient restClient;

  BarbershopRepositoryImpl({
    required this.restClient,
  });

  @override
  Future<Either<RepositoryException, BarbershopModel>> getMyBarbershop(
      UserModel userModel) async {
    switch (userModel) {
      case UserModelAdmin():
        final Response(data: List(first: data)) = await restClient.auth.get(
          '/barbershop',
          queryParameters: {
            'user_id': '#userAuthRef',
          },
        );
        return Success(BarbershopModel.fromMap(data));
      case UserModelEmployee():
        final Response(:data) = await restClient.auth.get(
          '/barbershop/${userModel.barbershopId}',
        );
        return Success(BarbershopModel.fromMap(data));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> save(
      ({
        String name,
        String email,
        List<String> openingDays,
        List<int> openingHours,
      }) data) async {
    try {
      await restClient.auth.post(
        '/barbershop',
        data: {
          'user_id': '#userAuthRef',
          'name': data.name,
          'email': data.email,
          'opening_days': data.openingDays,
          'opening_hours': data.openingHours,
        },
      );

      return Success(nil);
    } on DioException catch (e, s) {
      const message = 'Erro ao registrar barbearia';
      log(message, error: e, stackTrace: s);
      return Failure(RepositoryException(message: message));
    }
  }
}
