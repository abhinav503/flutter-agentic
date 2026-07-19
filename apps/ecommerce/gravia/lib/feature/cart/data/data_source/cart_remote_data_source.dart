import '../../domain/entities/cart_item_entity.dart';
import '../models/cart_item_model.dart';

abstract interface class CartRemoteDataSource {
  Future<List<CartItemModel>> getCart();

  /// Whole-doc replace, matching the backend's PUT semantics — always sends
  /// the full current cart, never a diff.
  Future<List<CartItemModel>> saveCart(List<CartItemEntity> items);
}
