import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nike_flutter/data/model/ProductModel.dart';

abstract class ICategoryDataSource {
  Future<List<ProductModel>> gatCategory(
      String userId, String category);
}

class CategoryRemoteDataSource implements ICategoryDataSource {
  final Dio httpClient;

  CategoryRemoteDataSource(this.httpClient);

  @override
  Future<List<ProductModel>> gatCategory(
      String userId, String category) async {
    final response = await httpClient.post('getProducts.php', data: {
      "userId": userId,
      "category": category
    });
    if (response.statusCode != 200) {
      throw Exception(response.statusMessage);
    }
    return ProductModel.parseJsonArray(jsonDecode(response.data));
  }
}
