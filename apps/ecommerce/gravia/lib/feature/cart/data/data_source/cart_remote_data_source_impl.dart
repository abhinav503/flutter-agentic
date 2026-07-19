import 'package:core/core/network/http_service.dart';

import 'package:gravia/constants/api_constants.dart';
import 'package:gravia/services/firebase_auth_service.dart';

import '../../domain/entities/cart_item_entity.dart';
import '../models/cart_item_model.dart';
import 'cart_remote_data_source.dart';

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  const CartRemoteDataSourceImpl();

  @override
  Future<List<CartItemModel>> getCart() async {
    final uid = FirebaseAuthService.instance.currentUser?.uid;
    if (uid == null) return const [];

    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.cartPath,
      queryParameters: {'userId': uid},
    );
    return _parseItems(response.data!);
  }

  @override
  Future<List<CartItemModel>> saveCart(List<CartItemEntity> items) async {
    final uid = FirebaseAuthService.instance.currentUser?.uid;
    if (uid == null) return const [];

    final response = await HttpService.instance.put<Map<String, dynamic>>(
      ApiConstants.cartPath,
      data: {
        'userId': uid,
        'items': items
            .map(
              (item) => {
                'productId': item.product.id,
                'quantity': item.quantity,
              },
            )
            .toList(),
      },
    );
    return _parseItems(response.data!);
  }

  List<CartItemModel> _parseItems(Map<String, dynamic> json) {
    final items = json['items'] as List<dynamic>;
    return items
        .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
