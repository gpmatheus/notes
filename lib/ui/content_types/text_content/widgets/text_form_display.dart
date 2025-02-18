
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

class _TextFormDisplayState extends State<TextFormDisplay> with SingleTickerProviderStateMixin {

  final textController = TextEditingController();
  late final ScrollController _scrollController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final List<GlobalKey> _keys = [];

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController(
      initialScrollOffset: widget.initialScrollPosition != null 
      ? widget.initialScrollPosition! 
      : 0.0,
    );
    textController.text = widget.viewModel.content != null 
      ? widget.viewModel.content!.text 
      : '';
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(
        parent: _animationController, 
        curve: Curves.easeInOut,
      )
    );

    final int numKeys = widget.viewModel.contents.length +
    (widget.viewModel.content == null ? 1 : 0);
    for (int i = 0; i < numKeys; i++) {
      _keys.add(GlobalKey());
    }

    final int index = widget.viewModel.content != null
    ? widget.viewModel.contents.indexOf(widget.viewModel.content! as Content)
    : widget.viewModel.contents.length;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerWidget(index);
    });
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
            key: _keys[index],
            content: content,
            contentWidget: content.type.display(content),
          );
        }
        return _getField(context, _keys[index]);
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
            key: _keys[index],
            content: content,
            contentWidget: content.type.display(content),
          );
        }
        return _getField(context, _keys[index]);
      }
    );
  }

  Widget _getField(BuildContext context, Key key) {
    return EditingContentFrame(
      key: key,
      content: TextField(
        controller: textController,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        maxLines: 9,
        minLines: 1,
        autofocus: true,
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

  void _centerWidget(int index) {
    final RenderBox renderBox = _keys[index].currentContext!.findRenderObject() as RenderBox;
    final double itemHeight = renderBox.size.height;
    final double viewportHeight = MediaQuery.of(context).size.height;
    final double offset = _calculateOffset(index, itemHeight, viewportHeight);

    _animation = Tween<double>(begin: _scrollController.offset, end: offset).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward(from: 0);
    _animation.addListener(() {
      _scrollController.jumpTo(_animation.value);
    });
  }

  double _calculateOffset(int index, double itemHeight, double viewportHeight) {
    double offset = 0;
    for (int i = 0; i < index; i++) {
      final RenderBox renderBox = _keys[i].currentContext!.findRenderObject() as RenderBox;
      offset += renderBox.size.height;
    }
    return offset - (viewportHeight / 2) + itemHeight;
  }
  
}