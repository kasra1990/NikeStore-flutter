import 'package:nike_flutter/data/model/ProductModel.dart';

class CartDataModel {
  final ProductModel product;
  final String cartId;
  final String shoesSize;
  String count;

  CartDataModel.fromJson(Map<String, dynamic> json)
      : product = ProductModel.fromJson(json['product']),
        cartId = json['cartId'],
        count = json['count'],
        shoesSize = json['shoesSize'];


  static List<CartDataModel> parseJsonArray(List<dynamic> jsonArray) {
    final List<CartDataModel> carts = [];
    for (var json in jsonArray) {
      carts.add(CartDataModel.fromJson(json));
    }
    return carts;
  }
}
