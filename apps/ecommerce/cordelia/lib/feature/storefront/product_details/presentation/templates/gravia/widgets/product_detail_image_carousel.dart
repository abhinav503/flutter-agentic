import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/page_indicator.dart';

class ProductDetailImageCarousel extends StatefulWidget {
  final List<String> images;

  const ProductDetailImageCarousel({super.key, required this.images});

  @override
  State<ProductDetailImageCarousel> createState() =>
      _ProductDetailImageCarouselState();
}

class _ProductDetailImageCarouselState
    extends State<ProductDetailImageCarousel> {
  final _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shapes =
        Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(shapes.cardRadius),
          child: SizedBox(
            height: 300,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (page) => setState(() => _page = page),
              itemBuilder: (context, i) =>
                  AppNetworkImage(url: widget.images[i], fit: BoxFit.cover),
            ),
          ),
        ),
        if (widget.images.length > 1) ...[
          const SizedBox(height: AppSpacing.base),
          PageIndicator(count: widget.images.length, currentIndex: _page),
        ],
      ],
    );
  }
}
