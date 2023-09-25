// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';

enum LoginStateStatusEnum {
  initial,
  error,
  admin,
  employee,
}

class LoginState {
  final LoginStateStatusEnum status;
  final String? errorMessage;

  LoginState.initial() : this(status: LoginStateStatusEnum.initial);

  LoginState({
    required this.status,
    this.errorMessage,
  });

  LoginState copyWith({
    LoginStateStatusEnum? status,
    ValueGetter<String?>? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
