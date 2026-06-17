import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

/// Renders assistant text as markdown. Uses `gpt_markdown`, which tolerates the
/// partial/incomplete markdown that arrives while a reply is still streaming.
/// All styling comes from the theme — no hardcoded colours.
class ChatMarkdown extends StatelessWidget {
  final String data;
  final Color color;

  const ChatMarkdown({super.key, required this.data, required this.color});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    // gpt_markdown renders the whole reply as one RichText, so the gaps between
    // paragraphs/list items are blank-line spans sized by fontSize × height.
    // A small font + tight height compacts both the text and those gaps;
    // collapsing 3+ newlines trims any extra blank lines the model emits.
    final compact = data.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    return GptMarkdown(
      compact,
      style: text.bodyMedium?.copyWith(color: color, fontSize: 13, height: 1.18),
    );
  }
}
