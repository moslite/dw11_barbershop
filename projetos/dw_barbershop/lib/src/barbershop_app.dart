import 'package:asyncstate/widget/async_state_builder.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/ui/barbershop_nav_global_key.dart';
import 'core/ui/barbershop_theme.dart';
import 'core/ui/widgets/barbershop_loader.dart';
import 'features/auth/login/login_page.dart';

import 'features/auth/register/barbershop/barbershop_register_page.dart';
import 'features/auth/register/user/user_register_page.dart';
import 'features/employee/register/employee_register_page.dart';
import 'features/employee/schedule/employee_schedule_page.dart';
import 'features/home/admin/home_admin_page.dart';
import 'features/home/employee/home_employee_page.dart';
import 'features/schedule/schedule_page.dart';
import 'features/splash/splash_page.dart';
import 'package:flutter/material.dart';

class BarbershopApp extends StatelessWidget {
  const BarbershopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncStateBuilder(
      builder: (asyncNavigatorObserver) {
        return MaterialApp(
          title: 'DW Barbershop',
          theme: BarbershopTheme.themeData,
          debugShowCheckedModeBanner: false,
          navigatorObservers: [
            asyncNavigatorObserver,
          ],
          navigatorKey: BarbershopNavGlobalKey.instance.navKey,
          routes: {
            '/': (_) => const SplashPage(),
            '/auth/login': (_) => const LoginPage(),
            '/auth/register/user': (_) => const UserRegisterPage(),
            '/auth/register/barbershop': (_) => const BarbershopRegisterPage(),
            '/home/adm': (_) => const HomeAdminPage(),
            '/home/employee': (_) => const HomeEmployeePage(),
            '/employee/register': (_) => const EmployeeRegisterPage(),
            '/employee/schedule': (_) => const EmployeeSchedulePage(),
            '/schedule': (_) => const SchedulePage(),
          },
          localizationsDelegates: const [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('pt', 'BR')],
          locale: const Locale('pt', 'BR'),
        );
      },
      customLoader: const BarbershopLoader(),
    );
  }
}
