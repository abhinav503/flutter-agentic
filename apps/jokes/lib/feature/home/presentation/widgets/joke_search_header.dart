import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jokes/constants/value_const.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/chip.dart';
import 'package:core/core/ui/atoms/text_field.dart';
import '../bloc/search_page_bloc.dart';

class JokeSearchHeader extends StatefulWidget {
  const JokeSearchHeader({super.key});

  @override
  State<JokeSearchHeader> createState() => _JokeSearchHeaderState();
}

class _JokeSearchHeaderState extends State<JokeSearchHeader> {
  final _controller = TextEditingController();
  String? _selectedChip;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(String term) {
    final trimmed = term.trim();
    if (trimmed.isEmpty) return;
    context.read<SearchPageBloc>().add(SearchPageEvent.submitted(term: trimmed));
  }

  void _selectChip(String term) {
    setState(() => _selectedChip = term);
    _controller.text = term;
    context.read<SearchPageBloc>().add(SearchPageEvent.chipSelected(term: term));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.base,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            controller: _controller,
            hint: ValueConst.jokeSearchHint,
            textInputAction: TextInputAction.search,
            onSubmitted: _submit,
            suffix: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _submit(_controller.text),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ValueConst.jokeQuickFilters.map((term) {
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: AppChip(
                    label: term,
                    selected: _selectedChip == term,
                    onTap: () => _selectChip(term),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
      ),
    );
  }
}
