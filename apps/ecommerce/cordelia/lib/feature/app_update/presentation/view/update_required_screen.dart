import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:cordelia/constants/value_const.dart';

import '../../domain/entities/app_update_requirement_entity.dart';

/// The one screen an unsupported build ever shows. Pack-neutral on purpose:
/// it renders before any store is chosen, in the app's base theme, so the
/// core molecules are the right vocabulary rather than a template's.
class UpdateRequiredScreen extends BaseScreen {
  final AppUpdateRequirementEntity requirement;

  const UpdateRequiredScreen({super.key, required this.requirement});

  @override
  State<UpdateRequiredScreen> createState() => _UpdateRequiredScreenState();
}

class _UpdateRequiredScreenState extends BaseScreenState<UpdateRequiredScreen> {
  Future<void> _openStore() async {
    final uri = Uri.tryParse(widget.requirement.updateUrl);
    if (uri == null) return;
    var opened = false;
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // Same outcome as `false` — handled below.
    }
    // No store app and no browser (a managed device, a web preview): the
    // link on the clipboard is still a way forward.
    if (!opened && mounted) {
      copyToClipboard(
        widget.requirement.updateUrl,
        ValueConst.updateLinkCopiedMessage,
      );
    }
  }

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl2),
        child: EmptyState(
          iconData: Icons.system_update_rounded,
          title: ValueConst.updateRequiredTitle,
          subtitle: ValueConst.updateRequiredMessage,
          actions: [
            AppButton(
              label: ValueConst.updateNowButton,
              onTap: _openStore,
              variant: AppButtonVariant.primary,
            ),
          ],
        ),
      ),
    );
  }
}
