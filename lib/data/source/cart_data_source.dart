import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nike_flutter/data/model/CartDataModel.dart';

abstract class ICartDataSource {
  Future<List<CartDataModel>> getCarts(String userId);

  Future<void> changeCount(String cartId, String count);
  
  Future<void> deleteProduct(String cartId);
}

class CartDataSource extends ICartDataSource {
  final Dio httpClient;

  CartDataSource(this.httpClient);

  @override
  Future<List<CartDataModel>> getCarts(String userId) async {
    final response =
        await httpClient.post('getFromCart.php', data: {"userId": userId});
    if (response.statusCode != 200) {
      throw Exception(response.statusMessage);
    }
    return CartDataModel.parseJsonArray(jsonDecode(response.data));
  }

  @override
  Future<void> changeCount(String cartId, String count) async {
    await httpClient.post('changeCountOfCart.php',
        data: {"cartId": cartId, "count": count});
  }

  @override
  Future<void> deleteProduct(String cartId) async{
   await httpClient.post('deleteProductFromCart.php',data: {
     "cartId":cartId
   });
  }
}
