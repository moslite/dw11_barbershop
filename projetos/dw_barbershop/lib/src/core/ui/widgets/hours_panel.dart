import 'package:flutter/material.dart';

import '../constants.dart';

class HoursPanel extends StatefulWidget {
  final List<int>? availableHours;
  final int startAt;
  final int endAt;
  final ValueChanged<int> onPressed;
  final bool singleSelection;

  const HoursPanel({
    super.key,
    this.availableHours,
    required this.startAt,
    required this.endAt,
    required this.onPressed,
  }) : singleSelection = false;

  const HoursPanel.singleSelection({
    super.key,
    this.availableHours,
    required this.startAt,
    required this.endAt,
    required this.onPressed,
  }) : singleSelection = true;

  @override
  State<HoursPanel> createState() => _HoursPanelState();
}

class _HoursPanelState extends State<HoursPanel> {
  int? lastSelection;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecione os horários de atendimento',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 16,
          children: [
            for (int i = widget.startAt; i <= widget.endAt; i++)
              HourButton(
                label: '${i.toString().padLeft(2, '0')}:00',
                value: i,
                onPressed: (selectedHour) {
                  setState(() {
                    if (widget.singleSelection) {
                      if (lastSelection == selectedHour) {
                        lastSelection = null;
                      } else {
                        lastSelection = selectedHour;
                      }
                    }
                  });
                  widget.onPressed(selectedHour);
                },
                availableHours: widget.availableHours,
                selectedHour: lastSelection,
                singleSelection: widget.singleSelection,
              ),
          ],
        ),
      ],
    );
  }
}

class HourButton extends StatefulWidget {
  final String label;
  final int value;
  final ValueChanged<int> onPressed;
  final List<int>? availableHours;
  final bool singleSelection;
  final int? selectedHour;

  const HourButton({
    super.key,
    this.availableHours,
    this.selectedHour,
    required this.label,
    required this.value,
    required this.onPressed,
    required this.singleSelection,
  });

  @override
  State<HourButton> createState() => _HourButtonState();
}

class _HourButtonState extends State<HourButton> {
  var selected = false;

  @override
  Widget build(BuildContext context) {
    if (widget.singleSelection) {
      if (widget.selectedHour != null) {
        if (widget.selectedHour == widget.value) {
          selected = true;
        } else {
          selected = false;
        }
      }
    }

    final textColor = selected ? Colors.white : ColorsConstants.brown;
    var buttonColor = selected ? ColorsConstants.brown : Colors.white;
    final buttonBorderColor = selected ? ColorsConstants.brown : Colors.grey;

    final HourButton(:value, :label, :availableHours, :onPressed) = widget;

    final disabled = availableHours != null && !availableHours.contains(value);
    if (disabled) {
      buttonColor = Colors.grey[400]!;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: disabled
          ? null
          : () {
              setState(() {
                selected = !selected;
                onPressed(value);
              });
            },
      child: Container(
        width: 64,
        height: 36,
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
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
