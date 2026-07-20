import 'package:gravia/enums/recent_search_type.dart';

/// A catalog item the shopper tapped from search results — not the raw
/// query string — so the Recent Search list can deep-link straight back to
/// the product/category details page. [name] is a display snapshot taken at
/// tap time; the details page re-fetches live data by [id].
class RecentSearchEntity {
  final String id;
  final String name;
  final RecentSearchType type;

  const RecentSearchEntity({
    required this.id,
    required this.name,
    required this.type,
  });
}
