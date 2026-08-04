import 'package:flutter/material.dart';

import 'package:core/core/base/base_page.dart';
import 'package:cordelia/feature/storefront/presentation/chromeless_page.dart';

import 'favourites_screen.dart';

/// Route host for `grofast`'s Wishlist. Unlike the other two templates, this
/// pack reaches its wishlist as a **pushed route** off Profile rather than as
/// a nav tab — the kit's own Profile does the same.
///
/// No bloc: the wishlist is the app-root `FavouritesCubit`.
class FavouritesPage extends BasePage {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends BasePageState<FavouritesPage>
    with ChromelessStorefrontPage {
  @override
  Widget buildBody(BuildContext context) => const FavouritesScreen();
}
