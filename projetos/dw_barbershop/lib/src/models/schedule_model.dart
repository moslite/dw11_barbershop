// ignore_for_file: public_member_api_docs, sort_constructors_first
class ScheduleModel {
  final int id;
  final int barbershopId;
  final int userId;
  final String clientName;
  final DateTime date;
  final int hour;

  ScheduleModel({
    required this.id,
    required this.barbershopId,
    required this.userId,
    required this.clientName,
    required this.date,
    required this.hour,
  });

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    switch (map) {
      case {
          'id': int id,
          'barbershop_id': int barbershopId,
          'user_id': int userId,
          'client_name': String clientName,
          'date': String scheduleDate,
          'time': int hour,
        }:
        return ScheduleModel(
          id: id,
          barbershopId: barbershopId,
          userId: userId,
          clientName: clientName,
          date: DateTime.parse(scheduleDate),
          hour: hour,
        );
      case _:
        throw ArgumentError('Invalid json');
    }
  }
}
