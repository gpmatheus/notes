
import 'package:flutter/material.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/ui/content_types/text_content/text_form_viewmodel.dart';
import 'package:notes/ui/core/content_container.dart';
import 'package:notes/ui/core/editing_content_frame.dart';


class TextFormDisplay extends StatefulWidget {

  const TextFormDisplay({
    super.key,

    this.initialScrollPosition,
    required this.viewModel,
  });

  final double? initialScrollPosition;
  final TextFormViewmodel viewModel;

  @override
  State<StatefulWidget> createState() => _TextFormDisplayState();
  
}

class _TextFormDisplayState extends State<TextFormDisplay> {

  final textController = TextEditingController();
  late final ScrollController _scrollController;
  // final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController(
      initialScrollOffset: widget.initialScrollPosition != null 
      ? widget.initialScrollPosition! 
      : 0.0,
    );
    textController.text = widget.viewModel.content != null ? widget.viewModel.content!.text : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.viewModel.content != null ? 'Edit' : 'Add'} text'),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.viewModel.content == null
            ? _getCreateContentWidget()
            : _getEditContentWidget()
          ); 
        }
      )
    );
  }

  Widget _getCreateContentWidget() {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      itemCount: widget.viewModel.contents.length + 1,
      itemBuilder: (context, index) {
        if (index < widget.viewModel.contents.length) {
          final content = widget.viewModel.contents[index];
          return ContentContainer(
            content: content,
            contentWidget: content.type.display(content),
          );
        }
        return _getField(context);
      }
    );
  }

  Widget _getEditContentWidget() {
    final int editingIndex = widget.viewModel.contents
      .indexOf((widget.viewModel.content!) as Content);
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      itemCount: widget.viewModel.contents.length,
      itemBuilder: (context, index) {
        if (index != editingIndex) {
          final content = widget.viewModel.contents[index];
          return ContentContainer(
            content: content,
            contentWidget: content.type.display(content),
          );
        }
        return _getField(context);
      }
    );
  }

  Widget _getField(BuildContext context) {
    return EditingContentFrame(
      content: TextField(
        controller: textController,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        maxLines: 9,
        minLines: 1,
        autofocus: true,
        // focusNode: focusNode,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      ), 
      cancel: () => Navigator.pop(context), 
      send: () async {
        Content? content = await widget.viewModel.send(textController.text);
        // ignore: use_build_context_synchronously
        if (mounted) Navigator.pop(context, content);
      },
    );  
  }
  
}