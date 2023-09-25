// ignore_for_file: public_member_api_docs, sort_constructors_first
enum EmployeeRegisterStateStatus {
  initial,
  success,
  error,
}

class EmployeeRegisterState {
  final EmployeeRegisterStateStatus status;
  final bool isAdmin;
  final List<String> workDays;
  final List<int> workHours;

  EmployeeRegisterState.initial()
      : this(
          status: EmployeeRegisterStateStatus.initial,
          isAdmin: false,
          workDays: <String>[],
          workHours: <int>[],
        );

  EmployeeRegisterState({
    required this.status,
    required this.isAdmin,
    required this.workDays,
    required this.workHours,
  });

  EmployeeRegisterState copyWith({
    EmployeeRegisterStateStatus? status,
    bool? isAdmin,
    List<String>? workDays,
    List<int>? workHours,
  }) {
    return EmployeeRegisterState(
      status: status ?? this.status,
      isAdmin: isAdmin ?? this.isAdmin,
      workDays: workDays ?? this.workDays,
      workHours: workHours ?? this.workHours,
    );
  }
}
