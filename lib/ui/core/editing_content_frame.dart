
import 'package:flutter/material.dart';
import 'package:notes/ui/core/content_frame.dart';

class EditingContentFrame extends StatelessWidget {
  const EditingContentFrame({
    super.key, 
    required this.content,
    required this.cancel,
    required this.send,
  });

  final Widget content;
  final VoidCallback cancel;
  final VoidCallback send;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContentFrame(
          content: content,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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