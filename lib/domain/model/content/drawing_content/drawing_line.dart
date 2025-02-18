
import 'package:flutter/material.dart';

class DrawingLine {
  final List<Offset> points; // Pontos que compõem a linha
  final Color color; // Cor da linha
  final double strokeWidth; // Espessura da linha

  DrawingLine({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });

  // Serializa para JSON
  Map<String, dynamic> toJson() {
    return {
      'points': points.map((p) => {'x': p.dx, 'y': p.dy}).toList(),
      'color': color.value,
      'strokeWidth': strokeWidth,
    };
  }

  // Deserializa de JSON
  factory DrawingLine.fromJson(Map<String, dynamic> json) {
    return DrawingLine(
      points: (json['points'] as List)
          .map((p) => Offset(p['x'], p['y']))
          .toList(),
      color: Color(json['color']),
      strokeWidth: json['strokeWidth'].toDouble(),
    );
  }
}
