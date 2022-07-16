import 'SliderModel.dart';
import 'ProductModel.dart';

class HomeDataModel {
  final List<SliderModel> sliders;
  final List<ProductModel> newArrivals;
  final List<ProductModel> mostPopular;

  HomeDataModel.fromJson(Map<String, dynamic> json)
      : sliders = SliderModel.parseJsonArray(json['slider']),
        newArrivals = ProductModel.parseJsonArray(json['newArrivals']),
        mostPopular = ProductModel.parseJsonArray(json['mostPopular']);
}
