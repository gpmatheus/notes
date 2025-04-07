
import 'package:flutter/material.dart';

class EditingContentFrame extends StatelessWidget {
  const EditingContentFrame({
    super.key, 
    required this.content,
    required this.cancel,
    required this.send,
    required this.loading,
  });

  final Widget content;
  final VoidCallback cancel;
  final VoidCallback send;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        content,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: loading
          ? [const CircularProgressIndicator()]
          : [
            IconButton(
              onPressed: cancel, 
              icon: const Icon(Icons.cancel_rounded)
            ),
            IconButton(
              onPressed: send, 
              icon: const Icon(Icons.send_rounded),
            )
          ],
        )
      ],
    );
  }

}