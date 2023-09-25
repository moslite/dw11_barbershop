import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/ui/constants.dart';
import '../../../core/ui/helpers/form_helper.dart';
import '../../../core/ui/helpers/messages.dart';
import 'login_state.dart';
import 'login_view_model.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LoginViewModel(:login) = ref.watch(loginViewModelProvider.notifier);

    ref.listen(
      loginViewModelProvider,
      (_, state) {
        switch (state) {
          case LoginState(status: LoginStateStatusEnum.initial):
            break;
          case LoginState(
              status: LoginStateStatusEnum.error,
              :final errorMessage?
            ):
            Messages.showError(errorMessage, context);
            break;
          case LoginState(status: LoginStateStatusEnum.error):
            Messages.showError('Erro ao realizar login', context);
            break;
          case LoginState(status: LoginStateStatusEnum.admin):
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/home/adm',
              (route) => false,
            );
            break;
          case LoginState(status: LoginStateStatusEnum.employee):
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/home/employee',
              (route) => false,
            );
            break;
        }
      },
    );

    return Scaffold(
      backgroundColor: Colors.black12,
      body: Form(
        key: _formKey,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImagesConstants.backgroundChair),
              fit: BoxFit.cover,
              opacity: .2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(ImagesConstants.imageLogo),
                          const SizedBox(height: 24),
                          TextFormField(
                            onTapOutside: (event) => context.unfocus(),
                            controller: _emailController,
                            decoration: const InputDecoration(
                              label: Text('E-mail'),
                              hintText: 'E-mail',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle: TextStyle(
                                color: Colors.black,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            validator: Validatorless.multiple([
                              Validatorless.required('E-mail obrigatório'),
                              Validatorless.email('E-mail inválido'),
                            ]),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            obscureText: true,
                            onTapOutside: (event) => context.unfocus(),
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              label: Text('Senha'),
                              hintText: 'Senha',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle: TextStyle(
                                color: Colors.black,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            validator: Validatorless.multiple([
                              Validatorless.required('Senha obrigatória'),
                              Validatorless.min(
                                  6, 'Digite pelo menos 6 caracteres'),
                            ]),
                          ),
                          const SizedBox(height: 16),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Esqueceu a senha?',
                              style: TextStyle(
                                color: ColorsConstants.brown,
                                fontSize: 12,
                              ),
                            ),
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
                                    'Verifique os campos do formulário!',
                                    context,
                                  );
                                  break;
                                case true:
                                  final email = _emailController.text;
                                  final password = _passwordController.text;
                                  login(email, password);
                              }
                            },
                            child: const Text('Acessar'),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () => Navigator.of(context)
                              .pushNamed('/auth/register/user'),
                          child: const Text(
                            'Criar conta',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
