class ProductModel {
  final String id;
  final String name;
  final String image1;
  final String image2;
  final String image3;
  final String image4;
  final String gender;
  final String price;
  final String description;
  final String visited;
  final String dateCreated;
  final int? favorite;

  ProductModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image1 = json['image1'],
        image2 = json['image2'],
        image3 = json['image3'],
        image4 = json['image4'],
        gender = json['gender'],
        price = json['price'],
        description = json['description'],
        visited = json['visited'],
        dateCreated = json['date_create'],
        favorite = json['favorite'];

  static List<ProductModel> parseJsonArray(List<dynamic> jsonArray) {
    final List<ProductModel> products = [];
    for (var json in jsonArray) {
      products.add(ProductModel.fromJson(json));
    }
    return products;
  }
}
