import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/application_providers.dart';
import '../../../core/ui/barbershop_icons.dart';
import '../../../core/ui/constants.dart';
import '../../../core/ui/widgets/barbershop_loader.dart';
import '../admin/home_admin_view_model.dart';

class HomeHeader extends ConsumerWidget {
  final bool hideFilter;

  const HomeHeader({
    super.key,
    this.hideFilter = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barbershopModel = ref.watch(getMyBarbershopProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 16),
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: AssetImage(
            ImagesConstants.backgroundChair,
          ),
          fit: BoxFit.cover,
          opacity: .5,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          barbershopModel.maybeWhen(
            data: (barbershop) {
              return Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFBDBDBD),
                    child: SizedBox.shrink(),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    flex: 3,
                    child: Text(
                      barbershop.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'editar',
                      style: TextStyle(
                        color: ColorsConstants.brown,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () =>
                        ref.read(homeAdminViewModelProvider.notifier).logout(),
                    icon: const Icon(
                      BarbershopIcons.exit,
                      color: ColorsConstants.brown,
                      size: 28,
                    ),
                  )
                ],
              );
            },
            orElse: () {
              return const Center(
                child: BarbershopLoader(),
              );
            },
          ),
          const SizedBox(height: 18),
          const Text(
            'Bem-Vindo',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Agende um Cliente',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 40,
            ),
          ),
          Offstage(
            offstage: hideFilter,
            child: const SizedBox(height: 18),
          ),
          Offstage(
            offstage: hideFilter,
            child: TextFormField(
              decoration: const InputDecoration(
                label: Text('Buscar Colaborador'),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 18),
                  child: Icon(
                    BarbershopIcons.search,
                    color: ColorsConstants.brown,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
