import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/loading_indicator.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:gravia/constants/value_const.dart';

import '../../domain/entities/home_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/home_bloc.dart';
import '../widgets/home_category_section.dart';
import '../widgets/home_hero_header.dart';
import '../widgets/home_popular_items_section.dart';

class HomeScreen extends BaseScreen {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen> {
  @override
  Widget body(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state case HomeError(:final message)) showSnackBar(message);
        },
        builder: (context, state) => switch (state) {
          HomeLoading() => Container(
            color: cs.primary,
            child: const SafeArea(child: Center(child: LoadingIndicator())),
          ),
          HomeError() => SafeArea(
            child: ErrorView(
              message: ValueConst.homeLoadErrorMessage,
              onRetry: () =>
                  context.read<HomeBloc>().add(const HomeEvent.started()),
            ),
          ),
          HomeLoaded(:final home) => _HomeContent(
            home: home,
            onAddToCart: (product) =>
                showSnackBar(ValueConst.addedToCartMessage(product.name)),
            onFavouriteToggle: (id) => context.read<HomeBloc>().add(
              HomeEvent.favouriteToggled(productId: id),
            ),
            onComingSoon: () => showSnackBar(ValueConst.comingSoonMessage),
          ),
        },
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  final HomeEntity home;
  final ValueChanged<ProductEntity> onAddToCart;
  final ValueChanged<String> onFavouriteToggle;
  final VoidCallback onComingSoon;

  const _HomeContent({
    required this.home,
    required this.onAddToCart,
    required this.onFavouriteToggle,
    required this.onComingSoon,
  });

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final _headerKey = GlobalKey();
  final _scrollController = ScrollController();
  double _headerHeight = 220;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeader());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _measureHeader() {
    final height = _headerKey.currentContext?.size?.height;
    if (height != null && height != _headerHeight) {
      setState(() => _headerHeight = height);
    }
  }

  double get _uncoveredHeaderHeight => _scrollController.hasClients
      ? (_headerHeight - _scrollController.offset).clamp(0, _headerHeight)
      : _headerHeight;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final shapes =
        Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;

    return SizedBox.expand(
      child: ColoredBox(
        color: cs.primary,
        child: Stack(
          children: [
            HomeHeroHeader(
              key: _headerKey,
              onNotificationTap: widget.onComingSoon,
            ),
            Positioned.fill(
              child: _PassThroughAboveOffset(
                thresholdGetter: () => _uncoveredHeaderHeight,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(child: SizedBox(height: _headerHeight)),
                    SliverToBoxAdapter(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: cs.surface,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(shapes.sheetRadius),
                            topRight: Radius.circular(shapes.sheetRadius),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.xl4,
                          ),
                          child: Column(
                            children: [
                              HomeCategorySection(
                                categories: widget.home.categories,
                                onComingSoon: widget.onComingSoon,
                              ),
                              const SizedBox(height: AppSpacing.xl4),
                              HomePopularItemsSection(
                                products: widget.home.popularProducts,
                                onAddToCart: widget.onAddToCart,
                                onFavouriteToggle: widget.onFavouriteToggle,
                                onComingSoon: widget.onComingSoon,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PassThroughAboveOffset extends SingleChildRenderObjectWidget {
  const _PassThroughAboveOffset({
    required this.thresholdGetter,
    required Widget super.child,
  });

  final double Function() thresholdGetter;

  @override
  _RenderPassThroughAboveOffset createRenderObject(BuildContext context) =>
      _RenderPassThroughAboveOffset(thresholdGetter);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderPassThroughAboveOffset renderObject,
  ) {
    renderObject.thresholdGetter = thresholdGetter;
  }
}

class _RenderPassThroughAboveOffset extends RenderProxyBox {
  _RenderPassThroughAboveOffset(this.thresholdGetter);

  double Function() thresholdGetter;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (position.dy < thresholdGetter()) return false;
    return super.hitTest(result, position: position);
  }
}
