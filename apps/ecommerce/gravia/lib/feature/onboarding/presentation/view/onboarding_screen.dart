import 'package:core/core/base/base_screen.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/device_frame.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gravia/constants/app_routes.dart';
import 'package:gravia/constants/value_const.dart';

import 'onboarding_page.dart';

class _OnboardingItem {
  final Widget image;
  final String title;
  final String subtitle;

  const _OnboardingItem({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

class OnboardingScreen extends BaseScreen {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends BaseScreenState<OnboardingScreen> {
  static final _items = [
    _OnboardingItem(
      image: AppNetworkImage.placeholder(seed: 'gravia-onboarding-1'),
      title: ValueConst.onboardingTitle1,
      subtitle: ValueConst.onboardingSubtitle1,
    ),
    _OnboardingItem(
      image: AppNetworkImage.placeholder(seed: 'gravia-onboarding-2'),
      title: ValueConst.onboardingTitle2,
      subtitle: ValueConst.onboardingSubtitle2,
    ),
    _OnboardingItem(
      image: AppNetworkImage.placeholder(seed: 'gravia-onboarding-3'),
      title: ValueConst.onboardingTitle3,
      subtitle: ValueConst.onboardingSubtitle3,
    ),
  ];

  final _imageController = PageController();
  final _sheetKey = GlobalKey();
  int _currentPage = 0;

  // How much of the sheet stays visible when dragged down — enough to keep
  // the handle grabbable so the sheet can be pulled back up.
  static const double _peekHeight = 56;

  double _sheetDragOffset = 0;
  bool _isDraggingSheet = false;

  bool get _isLastPage => _currentPage == _items.length - 1;

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  double _maxSheetDragOffset() {
    final box = _sheetKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return 0;
    return (box.size.height - _peekHeight).clamp(0.0, double.infinity);
  }

  void _onSheetDragStart(DragStartDetails details) =>
      setState(() => _isDraggingSheet = true);

  void _onSheetDragUpdate(DragUpdateDetails details) {
    setState(() {
      _sheetDragOffset = (_sheetDragOffset + details.delta.dy)
          .clamp(0.0, _maxSheetDragOffset());
    });
  }

  void _onSheetDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final pastHalfway = _sheetDragOffset > _maxSheetDragOffset() / 2;
    final shouldPeek = velocity > 300 || (velocity > -300 && pastHalfway);
    setState(() {
      _isDraggingSheet = false;
      _sheetDragOffset = shouldPeek ? _maxSheetDragOffset() : 0;
    });
  }

  void _onCta() {
    if (_isLastPage) {
      _onFinish();
      return;
    }
    _imageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Future<void> _onFinish() async {
    await SharedPreferenceService.instance
        .setBool(kHasSeenOnboardingPrefKey, true);
    if (mounted) context.go(AppRoutes.home);
  }

  // Sheet content is driven by screen state (_currentPage) — just a Text
  // swap and a PageIndicator move, no independent paging of its own.
  @override
  Widget buildBottomSheetContent() {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final item = _items[_currentPage];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragStart: _onSheetDragStart,
          onVerticalDragUpdate: _onSheetDragUpdate,
          onVerticalDragEnd: _onSheetDragEnd,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: AppRadius.sm,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl2),
        Text(
          item.title,
          textAlign: TextAlign.center,
          style: tt.headlineSmall!.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          item.subtitle,
          textAlign: TextAlign.center,
          style: tt.bodyMedium!.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.xl3),
        PageIndicator(count: _items.length, currentIndex: _currentPage),
        const SizedBox(height: AppSpacing.xl3),
        AppButton(
          label: _isLastPage
              ? ValueConst.onboardingGetStarted
              : ValueConst.onboardingNext,
          onTap: _onCta,
          size: AppButtonSize.large,
          fullWidth: true,
        ),
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final shapes = Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;

    return ColoredBox(
      color: cs.primary,
      child: Stack(
        children: [
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.xl2,
                  right: AppSpacing.xl2,
                  top: AppSpacing.xl2,
                  bottom: AppSpacing.xl14,
                ),
                child: PageView(
                  controller: _imageController,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  children: [
                    for (final item in _items) DeviceFrame(child: item.image),
                  ],
                ),
              ),
            ),
          ),
          // Permanently docked, not a modal, so this is built inline rather
          // than via showAppBottomSheet(). Height hugs its content (no
          // forced fraction of the screen, so no dead space); dragging the
          // handle slides it down to _peekHeight to reveal the image, and
          // back up to reopen — never fully off-screen.
          AnimatedPositioned(
            duration: _isDraggingSheet
                ? Duration.zero
                : const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            left: 0,
            right: 0,
            bottom: -_sheetDragOffset,
            child: Container(
              key: _sheetKey,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl4,
                0,
                AppSpacing.xl4,
                AppSpacing.xl2,
              ),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(shapes.sheetRadius),
                ),
              ),
              child: SafeArea(
                top: false,
                child: buildBottomSheetContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
