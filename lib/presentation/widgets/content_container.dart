
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/domain/entities/content.dart';
import 'package:notes/presentation/utils/actions_content.dart';

class ContentContainer extends StatelessWidget {
  ContentContainer({
    super.key, 
    required this.contentWidget, 
    // this.header, 
    this.actions, 
    required this.content,
  });

  final Widget contentWidget;
  // final String? header;
  final List<ActionsContent>? actions;
  final Content content;

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy - HH:mm');

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
              _getHeader(context),
              contentWidget,
            ],
          ),
        ),
      ),
    );
  }

  Widget _getHeader(BuildContext context) {
    return SizedBox(
      height: 42.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: content.contentsType().icon,
              ),
              Text(
                content.lastEdited == null 
                ? _dateFormat.format(content.createdAt)
                : _dateFormat.format(content.lastEdited!),
                style: const TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                color: Colors.grey[600],
                onPressed: () {
                  showModalBottomSheet(
                    context: context, 
                    builder: (context) {
                      final String info = 
                        "Content of type '${content.contentsType().name}', created at ${_dateFormat.format(content.createdAt)}${content.lastEdited == null ? '' : '''
 and last edited at ${_dateFormat.format(content.lastEdited!)}'''}";
                      return Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Text(info),
                      );
                    }
                  );
                }, 
                icon: const Icon(Icons.info_rounded),
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
                          for (ActionsContent ac in actions!)
                            ListTile(
                              leading: ac.icon,
                              title: Text(ac.name),
                              onTap: () {
                                Navigator.pop(context);
                                ac.onClick(content);
                              },
                            )
                        ],
                      ),
                    );
                  },
                ),
              }
            ],
          )
        ],
      ),
    );
  }

}