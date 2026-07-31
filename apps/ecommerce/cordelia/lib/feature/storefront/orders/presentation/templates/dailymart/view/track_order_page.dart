import 'package:flutter/material.dart';

import 'package:core/core/base/base_page.dart';

import '../../../../domain/entities/order_entity.dart';
import 'track_order_screen.dart';

class TrackOrderPage extends BasePage {
  final OrderEntity order;

  const TrackOrderPage({super.key, required this.order});

  @override
  State<TrackOrderPage> createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends BasePageState<TrackOrderPage> {
  /// No app bar anywhere in this pack — the screen renders its own header
  /// row as the first item of its scroll view (spec sheet §8). No DI or
  /// BlocProvider either: the order arrives whole from My Orders and this
  /// screen only displays it (see `TrackOrderScreen`).
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Color? backgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  @override
  Widget buildBody(BuildContext context) =>
      TrackOrderScreen(order: widget.order);
}
