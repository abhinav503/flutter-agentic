import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/enums/order_status.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';

/// The kit's status chip (frame `122:1025`) — a tinted pill carrying the
/// order's current status.
///
/// Colour by meaning, not by decoration: an in-flight order takes the pack's
/// primary tint, a delivered one its mint container, a cancelled one the
/// error tint. Placement and delivery are both "good" outcomes here, so the
/// green pair is deliberate.
class GrofastOrderStatusPill extends StatelessWidget {
  final OrderStatus status;

  const GrofastOrderStatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final (fill, ink) = switch (status) {
      OrderStatus.pending ||
      OrderStatus.inProcess => (cs.primary.withValues(alpha: 0.12), cs.primary),
      OrderStatus.delivered => (cs.primaryContainer, cs.onPrimaryContainer),
      OrderStatus.cancelled => (cs.error.withValues(alpha: 0.12), cs.error),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.xs3,
      ),
      decoration: BoxDecoration(color: fill, borderRadius: AppRadius.full),
      child: Text(
        GrofastValueConst.orderStatusName(status),
        style: GrofastTextStyleConst.bodySmall(tt).copyWith(color: ink),
      ),
    );
  }
}
