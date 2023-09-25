import 'package:flutter/material.dart';

import '../constants.dart';

class WeekdaysPanel extends StatelessWidget {
  final ValueChanged<String> onPressed;
  final List<String>? availableDays;

  const WeekdaysPanel({
    super.key,
    required this.onPressed,
    this.availableDays,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecione os dias da semana',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ButtonDay(
                  label: 'Seg',
                  onPressed: onPressed,
                  availableDays: availableDays,
                ),
                ButtonDay(
                  label: 'Ter',
                  onPressed: onPressed,
                  availableDays: availableDays,
                ),
                ButtonDay(
                  label: 'Qua',
                  onPressed: onPressed,
                  availableDays: availableDays,
                ),
                ButtonDay(
                  label: 'Qui',
                  onPressed: onPressed,
                  availableDays: availableDays,
                ),
                ButtonDay(
                  label: 'Sex',
                  onPressed: onPressed,
                  availableDays: availableDays,
                ),
                ButtonDay(
                  label: 'Sáb',
                  onPressed: onPressed,
                  availableDays: availableDays,
                ),
                ButtonDay(
                  label: 'Dom',
                  onPressed: onPressed,
                  availableDays: availableDays,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonDay extends StatefulWidget {
  final String label;
  final ValueChanged<String> onPressed;
  final List<String>? availableDays;

  const ButtonDay({
    super.key,
    required this.label,
    required this.onPressed,
    this.availableDays,
  });

  @override
  State<ButtonDay> createState() => _ButtonDayState();
}

class _ButtonDayState extends State<ButtonDay> {
  var selected = false;

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? Colors.white : ColorsConstants.brown;
    var buttonColor = selected ? ColorsConstants.brown : Colors.white;
    final buttonBorderColor = selected ? ColorsConstants.brown : Colors.grey;

    final ButtonDay(:availableDays, :label) = widget;

    final disabled = availableDays != null && !availableDays.contains(label);
    if (disabled) {
      buttonColor = Colors.grey[400]!;
    }

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: disabled
            ? null
            : () {
                setState(() {
                  selected = !selected;
                  widget.onPressed(label);
                });
              },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: buttonColor,
            border: Border.all(
              color: buttonBorderColor,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
