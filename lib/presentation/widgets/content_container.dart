
import 'package:flutter/material.dart';
import 'package:notes/domain/entities/content.dart';

class ContentContainer extends StatelessWidget {
  const ContentContainer({
    super.key, 
    required this.contentWidget, 
    this.header, 
    this.actions, 
    required this.content,
  });

  final Widget contentWidget;
  final String? header;
  final List<ContainerActions>? actions;
  final Content content;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Theme.of(context).secondaryHeaderColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    header == null ? '' : header!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  if (actions != null && actions!.isNotEmpty) ... {
                    IconButton(
                      icon: const Icon(Icons.more_vert_rounded),
                      color: Colors.grey[600],
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => ListView(
                            padding: const EdgeInsets.all(16.0),
                            children: [
                              for (ContainerActions ac in actions!)
                                ListTile(
                                  leading: ac.icon,
                                  title: Text(ac.name),
                                  onTap: () {
                                    Navigator.pop(context);
                                    ac.callback(content);
                                  },
                                )
                            ],
                          ),
                        );
                      },
                    ),
                  }
                ],
              ),
              contentWidget,
            ],
          ),
        ),
      ),
    );
  }

}

class ContainerActions {

  const ContainerActions({
    required this.icon,
    required this.name,
    required this.callback,
  });

  final Icon icon;
  final String name;
  final Function(Content content) callback;
}