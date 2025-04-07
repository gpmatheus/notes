
import 'package:flutter/material.dart';

class ContentFrame extends StatelessWidget {
  const ContentFrame({
    super.key,
    required this.content,
    required this.activated,
  });

  final Widget content;
  final bool activated;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: activated ? Theme.of(context).colorScheme.secondary : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: content,
        ),
      )
    );
  }

}