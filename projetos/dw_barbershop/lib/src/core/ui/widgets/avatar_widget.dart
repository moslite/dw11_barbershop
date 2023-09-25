import 'package:flutter/material.dart';

import '../barbershop_icons.dart';
import '../constants.dart';

class AvatarWidget extends StatelessWidget {
  final bool uploadMode;

  const AvatarWidget({
    super.key,
    this.uploadMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 102,
      height: 102,
      child: Stack(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  ImagesConstants.avatar,
                ),
              ),
            ),
          ),
          Visibility(
            visible: uploadMode,
            child: Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: ColorsConstants.brown,
                    width: 3,
                  ),
                ),
                child: const Icon(
                  BarbershopIcons.addEmployee,
                  color: ColorsConstants.brown,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
