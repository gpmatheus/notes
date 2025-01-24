
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/domain/entities/content.dart';
import 'package:notes/presentation/widgets/content_container.dart';

class TextFormDisplay extends StatefulWidget {

  const TextFormDisplay({
    super.key,
    this.content, 
    required this.contentsList,
    required this.scrollController,
  });

  final Content? content;
  final List<Content> contentsList;
  final ScrollController? scrollController;

  @override
  State<StatefulWidget> createState() => _TextFormDisplayState();
  
}

class _TextFormDisplayState extends State<TextFormDisplay> {

  final textController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy - HH:mm');

  @override
  void initState() {
    super.initState();

    textController.text = widget.content != null ? (widget.content! as TextContent).text : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: widget.contentsList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    controller: ScrollController(
                      initialScrollOffset: widget.scrollController != null ? widget.scrollController!.offset : 0.0
                    ),
                    shrinkWrap: true,
                    itemCount: widget.contentsList.length,
                    itemBuilder: (context, index) {
                      final content = widget.contentsList[index];
                      return ContentContainer(
                        content: content,
                        contentWidget: content.contentsType().displayer(widget.key, content),
                        header: content.lastEdited == null 
                          ? 'Criado em ${_dateFormat.format(content.createdAt)}'
                          : 'Editado em ${_dateFormat.format(content.lastEdited!)}'
                      );
                    }
                  ),
                )
              : const Center(
                  child: Text('No content'),
                )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: 5,
                    minLines: 2,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Digite algo aqui...',
                    ),
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.cancel_rounded)
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: IconButton(
                        onPressed: () { 
                          Navigator.pop(
                            context, 
                            textController.text.isEmpty 
                            ? null 
                            : TextContent(text: textController.text.trim())
                          );
                        }, 
                        icon: const Icon(Icons.send_rounded)
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  
}