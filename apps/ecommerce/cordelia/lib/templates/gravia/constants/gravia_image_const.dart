/// Icon/image assets the `gravia` template's storefront screens use.
///
/// The files live under `assets/icons/templates/gravia/`, not the app-wide
/// `assets/icons/` — pack-scoped the same way `assets/theme/templates/`
/// already scopes each template's theme config. A pack owns its own artwork,
/// so `dailymart` can ship its own `search.svg` / `cart.svg` without
/// colliding with these.
///
/// Genuinely app-level assets (Cordelia's brand marks, the auth providers'
/// logos, the shared back arrow, the default avatar photo) stay in
/// `ImageConst` / `assets/icons/` + `assets/images/`.
abstract final class GraviaImageConst {
  static const _icons = 'assets/icons/templates/gravia';

  static const locationIcon = '$_icons/location_icon.svg';
  static const notification = '$_icons/notification.svg';
  static const search = '$_icons/search.svg';
  static const mic = '$_icons/mic.svg';
  static const navHome = '$_icons/home-minus.svg';
  static const navCategories = '$_icons/apps-circle.svg';
  static const navFavourite = '$_icons/heart.svg';
  static const favouriteFilled = '$_icons/heart-filled.svg';
  static const navOrders = '$_icons/bag.svg';
  static const navProfile = '$_icons/user-circle.svg';
  static const flash = '$_icons/flash.svg';
  static const badgePercent = '$_icons/badge-percent.svg';
  static const card = '$_icons/card.svg';
  static const bagAdd = '$_icons/bag-add.svg';
  static const cart = '$_icons/cart.svg';
  static const gift = '$_icons/gift.svg';
  static const plus = '$_icons/plus.svg';
  static const minus = '$_icons/minus.svg';
  static const undo = '$_icons/undo.svg';
  static const remove = '$_icons/remove.svg';
  static const arrowSort = '$_icons/arrow-sort.svg';
  static const filter = '$_icons/filter.svg';
  static const directionRight = '$_icons/direction-right.svg';
  static const shoppingBag = '$_icons/shopping-bag.svg';
  static const shieldCheck = '$_icons/shield-check.svg';
  static const circleCheck = '$_icons/circle_check.svg';
  static const openBox = '$_icons/open-box.svg';
  static const packageBox = '$_icons/package-box.svg';
  static const notes = '$_icons/notes.svg';
  static const editRectangle = '$_icons/edit-rectangle.svg';
  static const calling = '$_icons/calling.svg';
  static const trash = '$_icons/trash.svg';
  static const camera = '$_icons/camera.svg';
  static const folderGallery = '$_icons/folder_gallery.svg';
  static const graviaBrandIcon = '$_icons/gravia_brand_icon.svg';
  static const logout = '$_icons/logout.svg';
  static const eye = '$_icons/eye.svg';
  static const lock = '$_icons/lock.svg';
}
