import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nike_flutter/data/model/MessageModel.dart';

abstract class IProductDataSource {
  Future<MessageModel> addToCart(String userId, String productId, String shoesSize);
}

class ProductDataSource implements IProductDataSource {
  final Dio httpClient;

  ProductDataSource(this.httpClient);

  @override
  Future<MessageModel> addToCart(
      String userId, String productId, String shoesSize) async {
    final response = await httpClient.post('addToCart.php', data: {
      "userId": userId,
      "productId": productId,
      "shoesSize": shoesSize
    });
    if(response.statusCode!=200){
      throw Exception(response.statusMessage);
    }
    return MessageModel.fromJson(jsonDecode(response.data));
  }
}
