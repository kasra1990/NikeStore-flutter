
class SliderModel {
  final String id;
  final String productId;
  final String image;

  SliderModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        productId = json['productId'],
        image = json['image'];

  static List<SliderModel> parseJsonArray(List<dynamic> jsonArray) {
    final List<SliderModel> sliders = [];
    for (var json in jsonArray) {
      sliders.add(SliderModel.fromJson(json));
    }
    return sliders;
  }

}