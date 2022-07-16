import 'package:nike_flutter/common/http_client.dart';
import 'package:nike_flutter/data/model/ProductModel.dart';
import 'package:nike_flutter/data/source/category_data_source.dart';

final categoryRepository =
    CategoryRepository(CategoryRemoteDataSource(httpClient));

abstract class ICategoryRepository {
  Future<List<ProductModel>> gatCategory(
      String userId, String category);
}

class CategoryRepository implements ICategoryRepository {
  final ICategoryDataSource dataSource;

  CategoryRepository(this.dataSource);

  @override
  Future<List<ProductModel>> gatCategory(
      String userId, String category) {
    return dataSource.gatCategory(userId, category);
  }
}
