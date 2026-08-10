import 'package:cordelia/enums/store_status.dart';
import 'package:cordelia/feature/home/domain/entities/store_entity.dart';

/// Discovery's segmented control over the store list.
///
/// Only rendered when the shopper actually owns a store that isn't published
/// yet — for everyone else the two tabs would show identical lists, since the
/// API only ever returns an unpublished store to its own owner.
///
/// Declaration order is the order the tabs render.
enum StoreFilter { live, all }

extension StoreFilterX on StoreFilter {
  bool matches(StoreEntity store) => switch (this) {
    StoreFilter.live => store.status == StoreStatus.published,
    StoreFilter.all => true,
  };

  Iterable<StoreEntity> apply(Iterable<StoreEntity> stores) =>
      this == StoreFilter.all ? stores : stores.where(matches);
}
