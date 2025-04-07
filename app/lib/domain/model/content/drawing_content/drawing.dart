
import 'package:notes/domain/model/content/drawing_content/drawing_line.dart';

class Drawing {
  final List<DrawingLine> lines;

  Drawing({required this.lines});

  // Serializa para JSON
  Map<String, dynamic> toJson() {
    return {
      'lines': lines.map((line) => line.toJson()).toList(),
    };
  }

  // Deserializa de JSON
  factory Drawing.fromJson(Map<String, dynamic> json) {
    return Drawing(
      lines: (json['lines'] as List)
          .map((line) => DrawingLine.fromJson(line))
          .toList(),
    );
  }
}