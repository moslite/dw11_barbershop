import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

import '../../core/ui/barbershop_icons.dart';
import '../../core/ui/constants.dart';
import '../../core/ui/helpers/date_time_extension.dart';
import '../../core/ui/helpers/form_helper.dart';
import '../../core/ui/helpers/messages.dart';
import '../../core/ui/widgets/avatar_widget.dart';
import '../../core/ui/widgets/hours_panel.dart';
import '../../models/user_model.dart';
import 'schedule_state.dart';
import 'schedule_view_model.dart';
import 'widgets/schedule_calendar.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  final _formKey = GlobalKey<FormState>();
  final _clientController = TextEditingController();
  final _dateController = TextEditingController();
  var showCalendar = false;

  @override
  void dispose() {
    _clientController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = ModalRoute.of(context)!.settings.arguments as UserModel;
    final scheduleViewModel = ref.watch(scheduleViewModelProvider.notifier);

    final employeeData = switch (userModel) {
      UserModelAdmin(:final workDays, :final workHours) => (
          workDays: workDays!,
          workHours: workHours!,
        ),
      UserModelEmployee(:final workDays, :final workHours) => (
          workDays: workDays!,
          workHours: workHours!,
        ),
    };

    ref.listen(
      scheduleViewModelProvider.select((state) => state.status),
      (_, status) {
        switch (status) {
          case ScheduleStateStatus.initial:
            break;
          case ScheduleStateStatus.success:
            Messages.showSuccess('Cliente agendado com sucesso', context);
            Navigator.pop(context);
          case ScheduleStateStatus.error:
            Messages.showError('Erro ao realizar agendamento', context);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar cliente'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  const AvatarWidget(),
                  const SizedBox(height: 24),
                  Text(
                    userModel.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 37),
                  TextFormField(
                    controller: _clientController,
                    validator: Validatorless.required('Cliente obrigatório'),
                    decoration: const InputDecoration(
                      label: Text('Cliente'),
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      label: Text('Selecione uma data'),
                      hintText: 'Selecione uma data',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      suffixIcon: Icon(
                        BarbershopIcons.calendar,
                        color: ColorsConstants.brown,
                        size: 21,
                      ),
                    ),
                    validator: Validatorless.required('Selecione uma data'),
                    onTap: () {
                      setState(() {
                        showCalendar = true;
                      });
                      context.unfocus();
                    },
                  ),
                  Visibility(
                    visible: showCalendar,
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        ScheduleCalendar(
                          onCancel: () {
                            setState(() {
                              showCalendar = false;
                            });
                          },
                          onConfirm: (selectedDate) {
                            setState(() {
                              _dateController.text =
                                  selectedDate.toBrazilianFormat();
                              scheduleViewModel.selectDate(selectedDate);
                              showCalendar = false;
                            });
                          },
                          availableDays: employeeData.workDays,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  HoursPanel.singleSelection(
                    startAt: 6,
                    endAt: 23,
                    onPressed: scheduleViewModel.selectHour,
                    availableHours: employeeData.workHours,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      switch (_formKey.currentState?.validate()) {
                        case null || false:
                          Messages.showError('Verifique o formulário', context);
                        case true:
                          final selectedHour = ref.watch(
                              scheduleViewModelProvider
                                  .select((state) => state.hour != null));
                          if (selectedHour) {
                            final client = _clientController.text;
                            scheduleViewModel.register(
                              userModel: userModel,
                              clientName: client,
                            );
                          } else {
                            Messages.showError('Selecione o horário', context);
                          }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                    ),
                    child: const Text('Agendar'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
