import 'package:dio/dio.dart';

import 'package:core/core/network/http_service.dart';

import 'package:gravia/constants/api_constants.dart';
import 'package:gravia/services/firebase_auth_service.dart';

import '../../domain/entities/cart_item_entity.dart';
import '../models/cart_item_model.dart';
import 'cart_remote_data_source.dart';

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  const CartRemoteDataSourceImpl();

  // The server reads the shopper's uid off this verified token, not a
  // client-supplied id — a null token means signed out, so the caller
  // degrades to an empty cart rather than hitting the API.
  @override
  Future<List<CartItemModel>> getCart() async {
    final idToken = await FirebaseAuthService.instance.idToken();
    if (idToken == null) return const [];

    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.cartPath,
      options: Options(headers: {'Authorization': 'Bearer $idToken'}),
    );
    return _parseItems(response.data!);
  }

  @override
  Future<List<CartItemModel>> saveCart(List<CartItemEntity> items) async {
    final idToken = await FirebaseAuthService.instance.idToken();
    if (idToken == null) return const [];

    final response = await HttpService.instance.put<Map<String, dynamic>>(
      ApiConstants.cartPath,
      data: {
        'items': items
            .map(
              (item) => {
                'productId': item.product.id,
                'quantity': item.quantity,
              },
            )
            .toList(),
      },
      options: Options(headers: {'Authorization': 'Bearer $idToken'}),
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
