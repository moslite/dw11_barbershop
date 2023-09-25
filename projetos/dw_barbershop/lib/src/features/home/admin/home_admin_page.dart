import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/application_providers.dart';
import '../../../core/ui/barbershop_icons.dart';
import '../../../core/ui/constants.dart';
import '../../../core/ui/widgets/barbershop_loader.dart';
import '../widgets/home_header.dart';
import 'home_admin_view_model.dart';
import 'widgets/home_employee_tile.dart';

class HomeAdminPage extends ConsumerWidget {
  const HomeAdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeAdminViewModelProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: ColorsConstants.brown,
        onPressed: () async {
          await Navigator.of(context).pushNamed('/employee/register');
          ref.invalidate(getMeProvider);
          ref.invalidate(homeAdminViewModelProvider);
        },
        child: const CircleAvatar(
          backgroundColor: Colors.white,
          maxRadius: 12,
          child: Icon(
            BarbershopIcons.addEmployee,
            color: ColorsConstants.brown,
          ),
        ),
      ),
      body: homeState.when(
        data: (data) {
          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: HomeHeader(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      HomeEmployeeTile(employee: data.employees[index]),
                  childCount: data.employees.length,
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          log(
            'Erro ao carregar colaboradores',
            error: error,
            stackTrace: stackTrace,
          );
          return const Center(
            child: Text('Erro ao carregar página'),
          );
        },
        loading: () => const BarbershopLoader(),
      ),
    );
  }
}
