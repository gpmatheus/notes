
import 'package:flutter/widgets.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'nts .',
      style: TextStyle(
        fontFamily: 'LeagueSpartan',
        fontSize: 40,
        fontWeight: FontWeight.w800,
        letterSpacing: -2.0
      ),
    );
  }

}