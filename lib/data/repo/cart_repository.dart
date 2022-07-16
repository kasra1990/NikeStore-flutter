import 'package:flutter/material.dart';
import 'package:nike_flutter/common/http_client.dart';
import 'package:nike_flutter/data/model/CartDataModel.dart';
import 'package:nike_flutter/data/source/cart_data_source.dart';

final cartRepository = CartRepository(CartDataSource(httpClient));

abstract class ICartRepository {
  Future<List<CartDataModel>> getCarts(String userId);

  Future<void> changeCount(String cartId, String count);

  Future<void> deleteProduct(String cartId);
}

class CartRepository extends ICartRepository {
  static final ValueNotifier<bool> autoRefreshNotifier = ValueNotifier(false);
  final ICartDataSource dataSource;

  CartRepository(this.dataSource);

  @override
  Future<List<CartDataModel>> getCarts(String userId) =>
      dataSource.getCarts(userId);

  @override
  Future<void> changeCount(String cartId, String count) =>
      dataSource.changeCount(cartId, count);

  @override
  Future<void> deleteProduct(String cartId) => dataSource.deleteProduct(cartId);
}
