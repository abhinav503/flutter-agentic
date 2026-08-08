import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/text_field.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/storefront/active_store/domain/entities/active_store_entity.dart';
import 'package:cordelia/feature/storefront/presentation/view/storefront_page.dart';
import 'package:cordelia/services/notification/firebase_messaging_service.dart';

import '../../domain/entities/store_entity.dart';
import '../bloc/discovery_bloc.dart';
import '../widgets/store_card.dart';
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

  void _openStore(StoreEntity store) => context.push(
    AppRoutes.storefront,
    extra: StorefrontRouteArgs(
      store: ActiveStoreEntity(
        storeId: store.id,
        storeName: store.name,
        templateId: store.templateId,
        language: store.language,
        currency: store.currency,
      ),
    ),
  );

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ValueConst.discoveryTitle,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            AppTextField(
              controller: _searchController,
              hint: ValueConst.discoverySearchHint,
              dense: true,
              prefix: const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.base),
                child: Icon(Icons.search),
              ),
              onChanged: (query) => context.read<DiscoveryBloc>().add(
                DiscoveryEvent.queryChanged(query: query),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: BlocBuilder<DiscoveryBloc, DiscoveryState>(
                builder: (context, state) => switch (state) {
                  DiscoveryLoading() => const StoreListSkeleton(),
                  DiscoveryError(:final message, :final query) => ErrorView(
                    message: message,
                    onRetry: () => context.read<DiscoveryBloc>().add(
                      DiscoveryEvent.queryChanged(query: query),
                    ),
                  ),
                  DiscoveryEmpty() => EmptyState(
                    iconData: Icons.storefront_outlined,
                    title: ValueConst.discoveryEmptyTitle,
                    subtitle: ValueConst.discoveryEmptySubtitle,
                  ),
                  DiscoveryLoaded(:final stores) => ListView.separated(
                    itemCount: stores.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.base),
                    itemBuilder: (context, i) => StoreCard(
                      store: stores[i],
                      onTap: () => _openStore(stores[i]),
                    ),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
