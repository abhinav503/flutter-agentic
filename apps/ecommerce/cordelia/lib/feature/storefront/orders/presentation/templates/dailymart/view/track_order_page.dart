import 'package:flutter/material.dart';

import 'package:core/core/base/base_page.dart';
import 'package:cordelia/feature/storefront/presentation/chromeless_page.dart';

import '../../../../domain/entities/order_entity.dart';
import 'track_order_screen.dart';

class TrackOrderPage extends BasePage {
  final OrderEntity order;

  const TrackOrderPage({super.key, required this.order});

  @override
  State<TrackOrderPage> createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends BasePageState<TrackOrderPage>
    with ChromelessStorefrontPage {
  @override
  Widget buildBody(BuildContext context) =>
      TrackOrderScreen(order: widget.order);
}
