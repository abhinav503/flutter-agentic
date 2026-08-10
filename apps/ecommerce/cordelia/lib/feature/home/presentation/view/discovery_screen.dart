import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/blocks/section_header.dart';
import 'package:core/core/ui/blocks/section_rail.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/constants/cordelia_color_const.dart';
import 'package:cordelia/constants/cordelia_dimen_const.dart';
import 'package:cordelia/constants/cordelia_text_style_const.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/enums/store_filter.dart';
import 'package:cordelia/enums/store_status.dart';
import 'package:cordelia/feature/storefront/active_store/domain/entities/active_store_entity.dart';
import 'package:cordelia/feature/storefront/presentation/view/storefront_page.dart';
import 'package:cordelia/feature/storefront/profile/presentation/bloc/profile_bloc.dart';
import 'package:cordelia/services/notification/firebase_messaging_service.dart';

import '../../domain/entities/store_entity.dart';
import '../bloc/discovery_bloc.dart';
import '../widgets/discovery_header.dart';
import '../widgets/recent_store_tile.dart';
import '../widgets/store_card.dart';
import '../widgets/store_filter_tabs.dart';
import '../widgets/store_list_skeleton.dart';

class DiscoveryScreen extends BaseScreen {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends BaseScreenState<DiscoveryScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Messaging starts from the first frame of the app's home screen, never
    // from main(): on iOS, querying the launch notification before the
    // navigator is mounted drops the tap that opened the app from a killed
    // state. FCM is the sole entry to the native notification stack, so this
    // one guard keeps the Flutter Web preview off every native-only plugin.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!kIsWeb) FirebaseMessagingService.instance.init();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // The header canvas runs under the status bar.
  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.lightStatusIcons;

  void _openStore(StoreEntity store) {
    // Recorded before the push, so the rail is already reordered underneath
    // by the time the shopper comes back out of the storefront.
    context.read<DiscoveryBloc>().add(
      DiscoveryEvent.storeOpened(storeId: store.id),
    );
    context.push(
      AppRoutes.storefront,
      extra: StorefrontRouteArgs(store: ActiveStoreEntity.fromStore(store)),
    );
  }

  @override
  Widget body(BuildContext context) => CollapsingHeaderSheet(
    initialHeaderHeight: CordeliaDimenConst.discoveryHeaderHeight,
    // The colour the header's gradient ends on — this is painted flat behind
    // the sheet's rounded top corners, so anything else draws a hard line
    // right under the header.
    headerColor: CordeliaColorConst.brandGradientEnd,
    header: BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) => DiscoveryHeader(
        profile: switch (state) {
          ProfileLoaded(:final profile) => profile,
          ProfileLoading() || ProfileError() => null,
        },
        searchController: _searchController,
        onQueryChanged: (query) => context.read<DiscoveryBloc>().add(
          DiscoveryEvent.queryChanged(query: query),
        ),
      ),
    ),
    body: BlocBuilder<DiscoveryBloc, DiscoveryState>(
      builder: (context, state) => Padding(
        // The sheet bleeds to the device edge, so every arm below pays its
        // own bottom inset here rather than each re-adding one.
        padding: EdgeInsets.fromLTRB(
          0,
          AppSpacing.xl2,
          0,
          AppSpacing.xl2 + MediaQuery.paddingOf(context).bottom,
        ),
        child: switch (state) {
          // No gutter here: the skeleton insets each of its own sections, so
          // its rail can bleed to the screen edge like the loaded one.
          DiscoveryLoading() => const StoreListSkeleton(),
          DiscoveryError(:final message, :final query) => _centered(
            ErrorView(
              message: message,
              onRetry: () => context.read<DiscoveryBloc>().add(
                DiscoveryEvent.queryChanged(query: query),
              ),
            ),
          ),
          DiscoveryEmpty() => _centered(
            EmptyState(
              iconData: Icons.storefront_outlined,
              title: ValueConst.discoveryEmptyTitle,
              subtitle: ValueConst.discoveryEmptySubtitle,
            ),
          ),
          DiscoveryLoaded(
            :final stores,
            :final recentStores,
            :final query,
            :final filter,
          ) =>
            _content(
              stores: stores,
              recentStores: recentStores,
              query: query,
              filter: filter,
            ),
        },
      ),
    ),
  );

  /// Error and empty are short blocks in a sheet tall enough to hold a full
  /// list — without breathing room they cling to the sheet's top edge.
  Widget _centered(Widget child) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.xl10,
      AppSpacing.lg,
      AppSpacing.xl10,
    ),
    child: child,
  );

  Widget _content({
    required List<StoreEntity> stores,
    required List<StoreEntity> recentStores,
    required String query,
    required StoreFilter filter,
  }) {
    // A search result is one flat answer to what was typed: no section
    // headers, no rail, no chips. Keyed on the query rather than on an empty
    // recents list — those two look identical from here, and conflating them
    // hid the chip row from any owner who simply hadn't opened a store yet.
    final isSearching = query.isNotEmpty;

    // The chip row earns its place only for a store owner mid-setup. The API
    // returns an unpublished store solely to whoever owns it, so for an
    // ordinary shopper "Setting up" would be a permanently empty tab — and a
    // control that can never do anything is worse than no control.
    final hasUnpublished = stores.any((s) => s.status.isUnpublished);
    final visible = filter.apply(stores).toList();
    // The rail is filtered by the same tab as the list below it. Without
    // this the screen contradicted itself: "Jump back in" offered five
    // stores while "All stores / Live" listed one, because the recents were
    // resolved before the filter and never narrowed by it.
    final visibleRecents = filter.apply(recentStores).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSearching) ...[
          if (visibleRecents.isNotEmpty) ...[
            SectionRail(
              header: const SectionHeader(
                title: ValueConst.discoveryRecentTitle,
              ),
              itemCount: visibleRecents.length,
              itemBuilder: (context, i) => RecentStoreTile(
                store: visibleRecents[i],
                onTap: () => _openStore(visibleRecents[i]),
              ),
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            const SizedBox(height: AppSpacing.xl4),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: SectionHeader(
              title: ValueConst.discoveryAllStoresTitle,
              action: hasUnpublished
                  ? StoreFilterTabs(
                      selected: filter,
                      onSelected: (next) => context.read<DiscoveryBloc>().add(
                        DiscoveryEvent.filterChanged(filter: next),
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: AppSpacing.base),
        ],
        // Filtering to a chip that matches nothing is a dead end otherwise:
        // the header and chips stay, and the space under them goes blank.
        if (visible.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xl2,
              AppSpacing.lg,
              AppSpacing.xl2,
            ),
            child: Text(
              ValueConst.discoveryFilterEmpty,
              style: CordeliaTextStyleConst.textSmRegular(
                Theme.of(context).textTheme,
              ).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        for (var i = 0; i < visible.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.base),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: StoreCard(
              store: visible[i],
              onTap: () => _openStore(visible[i]),
            ),
          ),
        ],
      ],
    );
  }
}
