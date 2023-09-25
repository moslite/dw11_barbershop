import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toBrazilianFormat() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  String toBrazilianDateTimeFormat() {
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(this);
  }
}
