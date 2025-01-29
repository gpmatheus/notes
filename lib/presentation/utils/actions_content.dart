
import 'package:flutter/material.dart';
import 'package:notes/domain/entities/content.dart';

class ActionsContent {
  const ActionsContent({
    required this.icon,
    required this.name,
    required this.onClick,
  });

  final Icon icon;
  final String name;
  final Function(Content content) onClick;
}