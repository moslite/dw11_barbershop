import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../core/ui/helpers/form_helper.dart';
import '../../../../core/ui/helpers/messages.dart';
import 'user_register_view_model.dart';

class UserRegisterPage extends ConsumerStatefulWidget {
  const UserRegisterPage({super.key});

  @override
  ConsumerState<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends ConsumerState<UserRegisterPage> {
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
    final userRegisterViewModel =
        ref.watch(userRegisterViewModelProvider.notifier);

    ref.listen(
      userRegisterViewModelProvider,
      (_, state) {
        switch (state) {
          case UserRegisterStateStatusEnum.initial:
            break;
          case UserRegisterStateStatusEnum.success:
            Navigator.of(context).pushNamed('/auth/register/barbershop');
            break;
          case UserRegisterStateStatusEnum.error:
            Messages.showError('Erro ao registrar usuário admin', context);
            break;
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar conta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  onTapOutside: (_) => context.unfocus(),
                  decoration: const InputDecoration(
                    label: Text('Nome'),
                  ),
                  validator: Validatorless.required('Nome obrigatório'),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  onTapOutside: (_) => context.unfocus(),
                  decoration: const InputDecoration(
                    label: Text('E-mail'),
                  ),
                  validator: Validatorless.multiple([
                    Validatorless.required('E-mail obrigatório'),
                    Validatorless.email('E-mail inválido'),
                  ]),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _passwordController,
                  onTapOutside: (_) => context.unfocus(),
                  decoration: const InputDecoration(
                    label: Text('Senha'),
                  ),
                  validator: Validatorless.multiple([
                    Validatorless.required('Senha obrigatória'),
                    Validatorless.min(6, 'Informe pelo menos 6 caracteres'),
                  ]),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Confirmar Senha'),
                  ),
                  obscureText: true,
                  onTapOutside: (_) => context.unfocus(),
                  validator: Validatorless.multiple([
                    Validatorless.required('Confirma Senha obrigatória'),
                    Validatorless.compare(
                      _passwordController,
                      'Senha e Confirma Senha não conferem',
                    ),
                  ]),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                  onPressed: () {
                    switch (_formKey.currentState?.validate()) {
                      case (false || null):
                        Messages.showError(
                          'Verifique os campos do formulário',
                          context,
                        );
                        break;
                      case true:
                        final name = _nameController.text;
                        final email = _emailController.text;
                        final password = _passwordController.text;
                        userRegisterViewModel.register(
                          name: name,
                          email: email,
                          password: password,
                        );
                        break;
                    }
                  },
                  child: const Text('Criar conta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
