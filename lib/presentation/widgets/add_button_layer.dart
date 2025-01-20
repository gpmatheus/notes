
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:notes/domain/contents/content_types.dart';

class AddButton extends StatefulWidget {
  
  const AddButton({
    super.key,
    required this.onTypeSelected,
  });

  final Function(ContentsType contentsType) onTypeSelected;

  @override
  State<StatefulWidget> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 16.0,
        children: [
          for (ContentsType ct in ContentsType.all)
          SpeedDialChild(
            child: ct.icon,
            label: ct.name,
            shape: const CircleBorder(),
            onTap: () {
              widget.onTypeSelected(ct);
            },
          )
        ],
      ),
    );
  }
  
}