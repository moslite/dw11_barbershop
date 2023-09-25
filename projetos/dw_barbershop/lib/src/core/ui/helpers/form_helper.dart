import 'package:flutter/widgets.dart';

extension UnfocusExtension on BuildContext {
  void unfocus() => FocusScope.of(this).unfocus();
}
