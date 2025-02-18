
import 'dart:ui';

import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {

  final Widget screen;
  final bool loading;

  const LoadingScreen({super.key, required this.screen, required this.loading});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        screen,
        loading
        ? Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: const Color.fromRGBO(0, 0, 0, 0.3),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        )
        : const SizedBox.shrink(),
      ],
    );
  }

}