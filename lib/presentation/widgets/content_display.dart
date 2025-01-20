
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/domain/entities/content.dart';
import 'package:notes/domain/entities/drawing.dart';

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

class ImageContentDisplay extends StatelessWidget {

  final File imageFile;

  ImageContentDisplay({super.key, required Content content}) : 
    imageFile = (content as ImageContent).file;

  @override
  Widget build(BuildContext context) {
    return Image.file(imageFile);
  }
  
}

class _DrawingPainter extends CustomPainter {
  final Drawing drawing;

  _DrawingPainter(this.drawing);

  @override
  void paint(Canvas canvas, Size size) {
    for (var line in drawing.lines) {
      final paint = Paint()
        ..color = Colors.black // Cor da linha
        ..strokeWidth = line.strokeWidth
        ..strokeCap = StrokeCap.round; // Pontas arredondadas

      for (int i = 0; i < line.points.length - 1; i++) {
        Offset first = line.points[i];
        Offset second = line.points[i + 1];

        // multiplica pelo lado
        first = first.scale(size.width, size.height);
        second = second.scale(size.width, size.height);

        // divide x pela razão
        first = first.scale(1.0 / size.aspectRatio, 1.0);
        second = second.scale(1.0 / size.aspectRatio, 1.0);

        // divide por dois, pois a escala do desenho é de -1 a 1
        first /= 2;
        second /= 2;

        first = first.translate(size.width / 2, size.height / 2);
        second = second.translate(size.width / 2, size.height / 2);
        canvas.drawLine(first, second, paint); // Desenha a linha
      }
    }
  }

  @override
  bool shouldRepaint(_DrawingPainter oldDelegate) {
    return oldDelegate.drawing != drawing; // Re-renderiza se os pontos mudarem
  }
}

class DrawingContentDisplay extends StatelessWidget {

  final Drawing drawing;

  DrawingContentDisplay({super.key, required Content content}) : 
    drawing = (content as DrawingContent).drawing;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DrawingPainter(drawing),
      size: const Size.fromHeight(300.0),
      // size: Size.infinite
    );
  }
  
}