
import 'package:flutter/material.dart';
import 'package:notes/domain/entities/content.dart';

class TextContentDisplay extends StatelessWidget {

  final String text;

  TextContentDisplay({super.key, required Content content}) : 
    text = (content as TextContent).text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text),
        )
      ),
    );
  }
  
}