// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../../models/user_model.dart';

enum HomeAdminStateStatusEnum {
  loaded,
  error,
}

class HomeAdminState {
  final HomeAdminStateStatusEnum status;
  final List<UserModel> employees;

  HomeAdminState({
    required this.status,
    required this.employees,
  });

  HomeAdminState copyWith({
    HomeAdminStateStatusEnum? status,
    List<UserModel>? employees,
  }) {
    return HomeAdminState(
      status: status ?? this.status,
      employees: employees ?? this.employees,
    );
  }
}
