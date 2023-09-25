import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/providers/application_providers.dart';
import '../../../core/ui/helpers/messages.dart';
import '../../../core/ui/widgets/avatar_widget.dart';
import '../../../core/ui/widgets/barbershop_loader.dart';
import '../../../core/ui/widgets/hours_panel.dart';
import '../../../core/ui/widgets/weekdays_panel.dart';
import '../../../models/barbershop_model.dart';
import 'employee_register_state.dart';
import 'employee_register_view_model.dart';

class EmployeeRegisterPage extends ConsumerStatefulWidget {
  const EmployeeRegisterPage({super.key});

  @override
  ConsumerState<EmployeeRegisterPage> createState() =>
      _EmployeeRegisterPageState();
}

class _EmployeeRegisterPageState extends ConsumerState<EmployeeRegisterPage> {
  var adminUserCheck = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeeViewModel =
        ref.watch(employeeRegisterViewModelProvider.notifier);
    final barbershopAsync = ref.watch(getMyBarbershopProvider);

    ref.listen(
      employeeRegisterViewModelProvider.select((state) => state.status),
      (_, status) {
        switch (status) {
          case EmployeeRegisterStateStatus.initial:
            break;
          case EmployeeRegisterStateStatus.success:
            Messages.showSuccess('Colaborador cadastrado com sucesso', context);
            Navigator.of(context).pop();
          case EmployeeRegisterStateStatus.error:
            Messages.showError('Erro ao registrar colaborador', context);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar colaborador'),
      ),
      body: barbershopAsync.when(
        data: (barbershopModel) {
          final BarbershopModel(:openingDays, :openingHours) = barbershopModel;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    children: [
                      const AvatarWidget(uploadMode: true),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Checkbox.adaptive(
                            value: adminUserCheck,
                            onChanged: (_) {
                              setState(() {
                                adminUserCheck = !adminUserCheck;
                                employeeViewModel
                                    .setRegisterAdmin(adminUserCheck);
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'Sou administrador e quero me cadastrar como colaborador',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Offstage(
                        offstage: adminUserCheck,
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _nameController,
                              validator: adminUserCheck
                                  ? null
                                  : Validatorless.required('Nome obrigatório'),
                              decoration: const InputDecoration(
                                label: Text('Nome'),
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _emailController,
                              validator: adminUserCheck
                                  ? null
                                  : Validatorless.multiple([
                                      Validatorless.required(
                                          'E-mail obrigatório'),
                                      Validatorless.email('E-mail inválido'),
                                    ]),
                              decoration: const InputDecoration(
                                label: Text('E-mail'),
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              obscureText: true,
                              controller: _passwordController,
                              validator: adminUserCheck
                                  ? null
                                  : Validatorless.multiple(
                                      [
                                        Validatorless.required(
                                            'Senha obrigatória'),
                                        Validatorless.min(
                                          6,
                                          'Informe no mínimo 6 caracteres',
                                        ),
                                      ],
                                    ),
                              decoration: const InputDecoration(
                                label: Text('Senha'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      WeekdaysPanel(
                        onPressed: employeeViewModel.manageWorkDay,
                        availableDays: openingDays,
                      ),
                      const SizedBox(height: 24),
                      HoursPanel(
                        startAt: 6,
                        endAt: 23,
                        onPressed: employeeViewModel.manageWorkHour,
                        availableHours: openingHours,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                        ),
                        onPressed: () {
                          switch (_formKey.currentState?.validate()) {
                            case false || null:
                              Messages.showError(
                                'Verifique o formulário',
                                context,
                              );
                            case true:
                              final EmployeeRegisterState(
                                workDays: List(isEmpty: emptyWorkDays),
                                workHours: List(isEmpty: emptyWorkHours)
                              ) = ref.watch(employeeRegisterViewModelProvider);

                              if (emptyWorkDays || emptyWorkHours) {
                                Messages.showError(
                                  'Selecione os dias e horários de atendimento',
                                  context,
                                );
                                return;
                              }

                              final name = _nameController.text;
                              final email = _emailController.text;
                              final password = _passwordController.text;
                              employeeViewModel.register(
                                name: name,
                                email: email,
                                password: password,
                              );
                          }
                        },
                        child: const Text('Cadastrar colaborador'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          const message = 'Erro ao carregar página';
          log(message, error: error, stackTrace: stackTrace);
          return const Center(
            child: Text(message),
          );
        },
        loading: () => const BarbershopLoader(),
      ),
    );
  }
}
