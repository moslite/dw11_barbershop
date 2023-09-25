import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../core/ui/helpers/form_helper.dart';
import '../../../../core/ui/helpers/messages.dart';
import '../../../../core/ui/widgets/hours_panel.dart';
import '../../../../core/ui/widgets/weekdays_panel.dart';
import 'barbershop_register_state.dart';
import 'barbershop_register_view_model.dart';

class BarbershopRegisterPage extends ConsumerStatefulWidget {
  const BarbershopRegisterPage({super.key});

  @override
  ConsumerState<BarbershopRegisterPage> createState() =>
      _BarbershopRegisterPageState();
}

class _BarbershopRegisterPageState
    extends ConsumerState<BarbershopRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barbershopRegisterViewModel =
        ref.watch(barbershopRegisterViewModelProvider.notifier);

    ref.listen(
      barbershopRegisterViewModelProvider,
      (_, state) {
        switch (state.status) {
          case BarbershopRegisterStateStatusEnum.initial:
            break;
          case BarbershopRegisterStateStatusEnum.error:
            Messages.showError(
              'Desculpe, erro ao registrar barbearia',
              context,
            );
          case BarbershopRegisterStateStatusEnum.success:
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/home/adm',
              (route) => false,
            );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar estabelecimento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(children: [
              const SizedBox(height: 5),
              TextFormField(
                controller: _nameController,
                onTapOutside: (event) => context.unfocus(),
                decoration: const InputDecoration(
                  label: Text('Nome'),
                ),
                validator: Validatorless.required('Nome obrigatório'),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                onTapOutside: (event) => context.unfocus(),
                validator: Validatorless.multiple([
                  Validatorless.required('E-mail obrigatório'),
                  Validatorless.email('E-mail inválido'),
                ]),
                decoration: const InputDecoration(
                  label: Text('E-mail'),
                ),
              ),
              const SizedBox(height: 24),
              WeekdaysPanel(
                onPressed: (value) {
                  barbershopRegisterViewModel.addOrRemoveOpeningDays(value);
                },
              ),
              const SizedBox(height: 24),
              HoursPanel(
                startAt: 6,
                endAt: 23,
                onPressed: (value) {
                  barbershopRegisterViewModel.addOrRemoveOpeningHours(value);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                onPressed: () {
                  switch (_formKey.currentState?.validate()) {
                    case (false || null):
                      Messages.showError('Verifique o formulário', context);
                    case true:
                      final name = _nameController.text;
                      final email = _emailController.text;
                      barbershopRegisterViewModel.register(name, email);
                  }
                },
                child: const Text('Criar estabelecimento'),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
