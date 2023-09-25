import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/application_providers.dart';
import '../../../core/ui/constants.dart';
import '../../../core/ui/widgets/avatar_widget.dart';
import '../../../core/ui/widgets/barbershop_loader.dart';
import '../../../models/user_model.dart';
import '../widgets/home_header.dart';
import 'home_employee_provider.dart';

class HomeEmployeePage extends ConsumerWidget {
  const HomeEmployeePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModelAsync = ref.watch(getMeProvider);

    return Scaffold(
      body: userModelAsync.when(
        error: (error, stackTrace) {
          return const Center(
            child: Text('Erro ao carregar página'),
          );
        },
        loading: () => const BarbershopLoader(),
        data: (user) {
          final UserModel(name: userName, id: userId) = user;
          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: HomeHeader(
                  hideFilter: true,
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const AvatarWidget(),
                      const SizedBox(height: 24),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: MediaQuery.sizeOf(context).width * .7,
                        height: 108,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorsConstants.grey,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Consumer(
                              builder: (context, ref, child) {
                                final totalAsync = ref.watch(
                                    getTotalSchedulesTodayProvider(userId));

                                return totalAsync.when(
                                  error: (error, stackTrace) {
                                    return const Center(
                                      child: Text('Erro ao carregar total'),
                                    );
                                  },
                                  loading: () => const BarbershopLoader(),
                                  skipLoadingOnRefresh: false,
                                  data: (total) {
                                    return Text(
                                      '$total',
                                      style: const TextStyle(
                                        fontSize: 32,
                                        color: ColorsConstants.brown,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            const Text(
                              'Hoje',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                        ),
                        onPressed: () async {
                          await Navigator.of(context).pushNamed(
                            '/schedule',
                            arguments: user,
                          );
                          ref.invalidate(getTotalSchedulesTodayProvider);
                        },
                        child: const Text('Agendar'),
                      ),
                      const SizedBox(height: 15),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                        ),
                        onPressed: () => Navigator.of(context).pushNamed(
                          '/employee/schedule',
                          arguments: user,
                        ),
                        child: const Text('Ver Agenda'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
