import 'package:nike_flutter/common/http_client.dart';
import 'package:nike_flutter/data/model/MessageModel.dart';
import 'package:nike_flutter/data/source/product_data_source.dart';

final productRepository = ProductRepository(ProductDataSource(httpClient));

abstract class IProductRepository {
  Future<MessageModel> addToCart(
      String userId, String productId, String shoesSize);
}

class ProductRepository implements IProductRepository {
  final IProductDataSource dataSource;

  ProductRepository(this.dataSource);

  @override
  Future<MessageModel> addToCart(
          String userId, String productId, String shoesSize) =>
      dataSource.addToCart(userId, productId, shoesSize);
}
