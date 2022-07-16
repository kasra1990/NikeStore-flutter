
class AddToCartModel {
  final String userId;
  final String productId;
  final String shoesSize;


  AddToCartModel({required this.userId,required this.productId,required this.shoesSize});

  AddToCartModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        productId = json['productId'],
        shoesSize = json['shoesSize'];
}
