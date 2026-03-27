import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ExpandableText extends StatefulWidget {
  final String htmlData;
  final int maxLines;
  final TextStyle? textStyle;

  const ExpandableText({
    super.key,
    required this.htmlData,
    this.maxLines = 3,
    this.textStyle,
  });

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;
  bool isOverflowing = false;
  final GlobalKey _htmlKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Schedule height check after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOverflow();
    });
  }

  void _checkOverflow() {
    final RenderBox? renderBox = _htmlKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && mounted) {
      final defaultStyle = widget.textStyle ??
          const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            height: 1.5,
          );
      final lineHeight = defaultStyle.height ?? 1.5;
      final fontSize = defaultStyle.fontSize ?? 14;
      final maxHeight = fontSize * lineHeight * widget.maxLines;
      final contentHeight = renderBox.size.height;
      if (contentHeight > maxHeight && !isOverflowing) {
        setState(() {
          isOverflowing = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle = widget.textStyle ??
        const TextStyle(
          fontSize: 14,
          color: Colors.grey,
          height: 1.5,
        );
    final lineHeight = defaultStyle.height ?? 1.5;
    final fontSize = defaultStyle.fontSize ?? 14;
    final maxHeight = fontSize * lineHeight * widget.maxLines;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: isExpanded ? null : BoxConstraints(maxHeight: maxHeight),
          clipBehavior: isExpanded ? Clip.none : Clip.hardEdge,
          decoration: isExpanded ? null : const BoxDecoration(),
          child: Html(
            key: _htmlKey,
            data: widget.htmlData,
            style: {
              '*': Style.fromTextStyle(defaultStyle),
              'body': Style(margin: Margins.zero),
            },

            onLinkTap: (url, _, __) {
              debugPrint('Tapped link: $url');
            },
            shrinkWrap: true,
          ),
        ),
        if (isOverflowing)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
                // Recheck overflow when collapsing to ensure accuracy
                if (!isExpanded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _checkOverflow();
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Text(
                  isExpanded ? 'Read Less' : 'Read More',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}