// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/dart.dart';
import 'package:re_highlight/styles/base16/dracula.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/meeting/presentation/widgets/find.dart';
import 'package:waterbus/features/meeting/presentation/widgets/menu.dart';

class CodeEditorPad extends StatefulWidget {
  const CodeEditorPad({super.key});

  @override
  State<StatefulWidget> createState() => _CodeEditorPadState();
}

class _CodeEditorPadState extends State<CodeEditorPad> {
  final CodeLineEditingController _controller = CodeLineEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureWrapper(
      onTap: () {
        _focusNode.requestFocus();
      },
      child: CodeAutocomplete(
        viewBuilder: (context, notifier, onSelected) {
          return _DefaultCodeAutocompleteListView(
            notifier: notifier,
            onSelected: onSelected,
          );
        },
        promptsBuilder: DefaultCodeAutocompletePromptsBuilder(
          language: langDart,
        ),
        child: CodeEditor(
          focusNode: _focusNode,
          chunkAnalyzer: const DefaultCodeChunkAnalyzer(),
          style: CodeEditorStyle(
            fontSize: 12.sp,
            cursorColor: Colors.green,
            codeTheme: CodeHighlightTheme(
              languages: {'dart': CodeHighlightThemeMode(mode: langDart)},
              theme: draculaTheme,
            ),
          ),
          controller: _controller,
          wordWrap: true,
          indicatorBuilder:
              (context, editingController, chunkController, notifier) {
            return Row(
              children: [
                DefaultCodeLineNumber(
                  controller: editingController,
                  notifier: notifier,
                ),
                DefaultCodeChunkIndicator(
                  width: 20,
                  controller: chunkController,
                  notifier: notifier,
                ),
              ],
            );
          },
          findBuilder: (context, controller, readOnly) => CodeFindPanelView(
            controller: controller,
            readOnly: readOnly,
          ),
          toolbarController: const ContextMenuControllerImpl(),
          sperator: Container(width: 0.5, color: Colors.greenAccent),
        ),
      ),
    );
  }
}

class _DefaultCodeAutocompleteListView extends StatefulWidget
    implements PreferredSizeWidget {
  static const double kItemHeight = 26;

  final ValueNotifier<CodeAutocompleteEditingValue> notifier;
  final ValueChanged<CodeAutocompleteResult> onSelected;

  const _DefaultCodeAutocompleteListView({
    required this.notifier,
    required this.onSelected,
  });

  @override
  Size get preferredSize => Size(
        250,
        // 2 is border size
        min(kItemHeight * notifier.value.prompts.length, 200) + 2,
      );

  @override
  State<StatefulWidget> createState() =>
      _DefaultCodeAutocompleteListViewState();
}

class _DefaultCodeAutocompleteListViewState
    extends State<_DefaultCodeAutocompleteListView> {
  @override
  void initState() {
    widget.notifier.addListener(_onValueChanged);
    super.initState();
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_onValueChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.loose(widget.preferredSize),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListView.builder(
        itemCount: widget.notifier.value.prompts.length,
        itemBuilder: (context, index) {
          final CodePrompt prompt = widget.notifier.value.prompts[index];
          final BorderRadius radius = BorderRadius.only(
            topLeft: index == 0 ? const Radius.circular(5) : Radius.zero,
            topRight: index == 0 ? const Radius.circular(5) : Radius.zero,
            bottomLeft: index == widget.notifier.value.prompts.length - 1
                ? const Radius.circular(5)
                : Radius.zero,
            bottomRight: index == widget.notifier.value.prompts.length - 1
                ? const Radius.circular(5)
                : Radius.zero,
          );
          return InkWell(
            borderRadius: radius,
            onTap: () {
              widget.onSelected(
                widget.notifier.value.copyWith(index: index).autocomplete,
              );
            },
            child: Container(
              width: double.infinity,
              height: _DefaultCodeAutocompleteListView.kItemHeight,
              padding: const EdgeInsets.only(left: 5, right: 5),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: index == widget.notifier.value.index
                    ? Colors.black54
                    : null,
                borderRadius: radius,
              ),
              child: RichText(
                text: prompt.createSpan(context, widget.notifier.value.input),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          );
        },
      ),
    );
  }

  void _onValueChanged() {
    setState(() {});
  }
}

extension _CodePromptExtension on CodePrompt {
  InlineSpan createSpan(BuildContext context, String input) {
    const TextStyle style = TextStyle();
    final InlineSpan span = style.createSpan(
      value: word,
      anchor: input,
      color: Colors.blue,
      fontWeight: FontWeight.bold,
    );
    final CodePrompt prompt = this;
    if (prompt is CodeFieldPrompt) {
      return TextSpan(
        children: [
          span,
          TextSpan(
            text: ' ${prompt.type}',
            style: style.copyWith(color: Colors.cyan),
          ),
        ],
      );
    }
    if (prompt is CodeFunctionPrompt) {
      return TextSpan(
        children: [
          span,
          TextSpan(
            text: '(...) -> ${prompt.type}',
            style: style.copyWith(color: Colors.cyan),
          ),
        ],
      );
    }
    return span;
  }
}

extension _TextStyleExtension on TextStyle {
  InlineSpan createSpan({
    required String value,
    required String anchor,
    required Color color,
    FontWeight? fontWeight,
    bool casesensitive = false,
  }) {
    if (anchor.isEmpty) {
      return TextSpan(
        text: value,
        style: this,
      );
    }
    final int index;
    if (casesensitive) {
      index = value.indexOf(anchor);
    } else {
      index = value.toLowerCase().indexOf(anchor.toLowerCase());
    }
    if (index < 0) {
      return TextSpan(
        text: value,
        style: this,
      );
    }
    return TextSpan(
      children: [
        TextSpan(text: value.substring(0, index), style: this),
        TextSpan(
          text: value.substring(index, index + anchor.length),
          style: copyWith(
            color: color,
            fontWeight: fontWeight,
          ),
        ),
        TextSpan(text: value.substring(index + anchor.length), style: this),
      ],
    );
  }
}
