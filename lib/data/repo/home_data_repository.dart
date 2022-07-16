import 'package:nike_flutter/common/http_client.dart';
import 'package:nike_flutter/data/model/HomeDataModel.dart';
import 'package:nike_flutter/data/source/home_data_source.dart';

final homeDataRepository =
    HomeDataRepository(HomeDataRemoteDataSource(httpClient));

abstract class IHomeDataRepository {
  Future<HomeDataModel> getHomeData();
}

class HomeDataRepository implements IHomeDataRepository {
  final IHomeDataSource dataSource;

  HomeDataRepository(this.dataSource);

  @override
  Future<HomeDataModel> getHomeData() {
    return dataSource.getHomeData();
  }
}
