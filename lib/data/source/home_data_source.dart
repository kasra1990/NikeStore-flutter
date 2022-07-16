import 'package:dio/dio.dart';
import 'package:nike_flutter/data/model/HomeDataModel.dart';
import 'dart:convert';

abstract class IHomeDataSource {
  Future<HomeDataModel> getHomeData();
}

class HomeDataRemoteDataSource implements IHomeDataSource {
  final Dio httpClient;

  HomeDataRemoteDataSource(this.httpClient);

  @override
  Future<HomeDataModel> getHomeData() async {
    final response = await httpClient.get('homeData.php');
    if (response.statusCode != 200) {
      throw Exception(response.statusMessage);
    }
    return HomeDataModel.fromJson(jsonDecode(response.data));
  }
}
