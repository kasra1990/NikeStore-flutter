import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike_flutter/common/color.dart';
import 'package:nike_flutter/common/size_config.dart';
import 'package:nike_flutter/data/model/ProductModel.dart';

class ProductBody extends StatefulWidget {
  final ProductModel product;
  static String selectedProductSize = "";

  const ProductBody({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductBody> createState() => _ProductBodyState();
}

class _ProductBodyState extends State<ProductBody> {
  @override
  Widget build(BuildContext context) {
    var productSizes = ["40", "41", "41.5", "42", "42.5"];

    if (ProductBody.selectedProductSize.isEmpty) {
      ProductBody.selectedProductSize = productSizes[0];
    }
    return Stack(children: [
      CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(widget.product.image1,
                  fit: BoxFit.cover, width: double.maxFinite),
            ),
            expandedHeight: MediaQuery.of(context).size.height * 0.4,
            foregroundColor: mainColor,
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset('assets/icons/heart_icon.svg'))
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2, color: Colors.black.withOpacity(0.1))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product.gender,
                      style: TextStyle(
                          fontSize: getFontSize(0.017),
                          color: Colors.black.withOpacity(0.5))),
                  SizedBox(height: getHeight(0.01)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.product.name,
                          style: TextStyle(
                              fontSize: getFontSize(0.02),
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text("\$${widget.product.price}",
                          style: TextStyle(
                              fontSize: getFontSize(0.02),
                              fontWeight: FontWeight.bold,
                              color: Colors.black))
                    ],
                  ),
                  SizedBox(height: getHeight(0.04)),
                  Text("Sizes",
                      style: TextStyle(
                          fontSize: getFontSize(0.02), color: Colors.black)),
                  SizedBox(height: getHeight(0.02)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var size in productSizes)
                        _productSizes(size, () {
                          setState(() {
                            ProductBody.selectedProductSize = size;
                          });
                        })
                    ],
                  ),
                  SizedBox(height: getHeight(0.03)),
                  Text("Description",
                      style: TextStyle(
                          fontSize: getFontSize(0.02), color: Colors.black)),
                  SizedBox(height: getHeight(0.01)),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                        height: getHeight(0.002),
                        color: Colors.black.withOpacity(0.5)),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: getHeight(0.085))
                ],
              ),
            ),
          ),
        ],
      ),
      Positioned(
        bottom: 0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: getHeight(0.081),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.white, Colors.white.withOpacity(0.7)])),
        ),
      )
    ]);
  }

  Widget _productSizes(String size, Function() onClick) {
    var selected = ProductBody.selectedProductSize == size;
    return InkWell(
      onTap: () {
        onClick();
      },
      child: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: mainColor, width: 1),
          color: selected ? mainColor : Colors.white,
        ),
        child: Text(size,
            style: TextStyle(
                fontSize: 16, color: selected ? Colors.white : mainColor)),
      ),
    );
  }
}
