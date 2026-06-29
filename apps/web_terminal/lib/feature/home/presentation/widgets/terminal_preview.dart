import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_terminal/constants/value_const.dart';
import 'package:web_terminal/feature/apps/presentation/cubit/apps_cubit.dart';
import 'preview/preview_platform.dart';

/// Editable address bar over an embedded web view ([buildPreviewSurface] — an
/// `<iframe>` on web). Defaults to the bridge's own origin so it loads with zero
/// setup.
class TerminalPreview extends StatefulWidget {
  const TerminalPreview({super.key});

  @override
  State<TerminalPreview> createState() => _TerminalPreviewState();
}

class _TerminalPreviewState extends State<TerminalPreview> {
  late final TextEditingController _urlController;
  late String _url;

  // Bumped on reload so the surface refreshes even when the URL is unchanged.
  int _reloadToken = 0;

  @override
  void initState() {
    super.initState();
    _url = resolvePreviewUrl();
    _urlController = TextEditingController(text: _url);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _load(String raw) {
    final next = raw.trim();
    if (next.isEmpty) return;
    setState(() {
      _url = next;
      _reloadToken++;
    });
  }

  void _reload() => setState(() => _reloadToken++);

  // [force] reloads even when the URL is unchanged — the app at that port has
  // only just come up.
  void _pointAt(String url, {bool force = false}) {
    if (!force && url == _url) return;
    _urlController.text = url;
    setState(() {
      _url = url;
      _reloadToken++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BlocListener<AppsCubit, AppsState>(
      // AppEntity equality is by name, so compare name + status explicitly to
      // catch both a different app and the same app flipping to running.
      listenWhen: (a, b) =>
          a.selected?.name != b.selected?.name ||
          a.selected?.status != b.selected?.status,
      listener: (context, state) {
        final url = state.selected?.previewUrl;
        if (url != null) _pointAt(url, force: true);
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _urlController,
                      hint: ValueConst.previewAddressHint,
                      dense: true,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.go,
                      onSubmitted: _load,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  AppButton(
                    label: ValueConst.previewReloadLabel,
                    variant: AppButtonVariant.secondary,
                    onTap: _reload,
                    leadingIcon: const Icon(Icons.refresh, size: AppSpacing.lg),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xs,
                0,
                AppSpacing.xs,
                AppSpacing.xs,
              ),
              child: ClipRRect(
                borderRadius: AppRadius.md,
                child: ColoredBox(
                  color: cs.surface,
                  child: buildPreviewSurface(_url, _reloadToken),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
