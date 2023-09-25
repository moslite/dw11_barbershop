import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ui/constants.dart';
import '../../core/ui/helpers/messages.dart';
import 'splash_view_model.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  var _scale = 10.0;
  var _animationOpacityLogo = 0.0;

  double get _logoAnimationWidth => 100.0 * _scale;
  double get _logoAnimationHeight => 120.0 * _scale;

  var animationDone = false;
  Timer? redirectTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationOpacityLogo = 1.0;
      _scale = 1.0;
    });
  }

  void _redirect(String routeName) {
    if (!animationDone) {
      redirectTimer?.cancel();
      redirectTimer =
          Timer(const Duration(milliseconds: 300), () => _redirect(routeName));
    } else {
      redirectTimer?.cancel();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(routeName, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      splashViewModelProvider,
      (_, state) {
        state.whenOrNull(
          error: (error, stackTrace) {
            const message = 'Erro ao validar login';
            log(message, error: error, stackTrace: stackTrace);
            Messages.showError(message, context);
            _redirect('/auth/login');
          },
          data: (data) {
            switch (data) {
              case SplashStateEnum.admin:
                _redirect('/home/adm');
              case SplashStateEnum.employee:
                _redirect('/home/employee');
              case _:
                _redirect('/home/login');
            }
          },
        );
      },
    );
    return Scaffold(
      backgroundColor: Colors.black12,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagesConstants.backgroundChair),
            fit: BoxFit.cover,
            opacity: .2,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            duration: const Duration(seconds: 4),
            curve: Curves.easeIn,
            opacity: _animationOpacityLogo,
            onEnd: () {
              animationDone = true;
              _redirect('/auth/login');
              // Navigator.of(context).pushAndRemoveUntil(
              //   PageRouteBuilder(
              //     settings: const RouteSettings(name: '/auth/login'),
              //     pageBuilder: (context, animation, secondaryAnimation) {
              //       return const LoginPage();
              //     },
              //     transitionsBuilder: (_, animation, __, child) {
              //       return FadeTransition(
              //         opacity: animation,
              //         child: child,
              //       );
              //     },
              //   ),
              //   (route) => false,
              // );
            },
            child: AnimatedContainer(
              duration: const Duration(seconds: 5),
              curve: Curves.linearToEaseOut,
              width: _logoAnimationWidth,
              height: _logoAnimationHeight,
              child: Image.asset(
                ImagesConstants.imageLogo,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
