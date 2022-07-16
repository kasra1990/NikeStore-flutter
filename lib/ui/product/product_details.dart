import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nike_flutter/common/color.dart';
import 'package:nike_flutter/common/utils.dart';
import 'package:nike_flutter/data/model/AddToCartModel.dart';
import 'package:nike_flutter/data/model/ProductModel.dart';
import 'package:nike_flutter/data/model/userDataModel.dart';
import 'package:nike_flutter/data/repo/cart_repository.dart';
import 'package:nike_flutter/data/repo/product_repository.dart';
import 'package:nike_flutter/ui/auth/sign_in/sign_in.dart';
import 'package:nike_flutter/ui/product/bloc/product_bloc.dart';
import 'package:nike_flutter/ui/product/product_body.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repo/auth_repository.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;


  const ProductDetailsScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String _userId = " ";

  @override
  void initState() {
    _readUser().asStream().listen((event) {
      _userId = event.userId;
    });
    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
    super.initState();
  }

  void authChangeNotifierListener() {
    var userID = AuthRepository.authChangeNotifier.value?.userId ?? "";
    if (userID.isNotEmpty) {
      setState(() {
        _userId = userID;
      });
    } else {
      _userId = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider<ProductBloc>(
        create: (context) {
          final bloc = ProductBloc(productRepository);
          bloc.stream.forEach((state) {
            if (state is ProductAddedSuccess) {
              CartRepository.autoRefreshNotifier.value = true;
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.model.message)));
            }
          });
          return bloc;
        },
        child: Scaffold(
          backgroundColor: const Color(0xfff6f6f6),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
          floatingActionButton: SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.9,
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                return FloatingActionButton.extended(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    onPressed: () {
                      checkInternetConnection().asStream().listen((event) {
                        if (_userId.isNotEmpty) {
                          if (event) {
                            final model = AddToCartModel(
                                userId: _userId,
                                productId: widget.product.id,
                                shoesSize: ProductBody.selectedProductSize);
                            BlocProvider.of<ProductBloc>(context)
                                .add(ProductAddToCart(model));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text(
                                    "Something wrong with your internet connection")));
                          }
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SignInScreen()));
                        }
                      });
                    },
                    foregroundColor: Colors.white,
                    backgroundColor: mainColor,
                    icon: SvgPicture.asset("assets/icons/buy_icon.svg",
                        color: Colors.white),
                    label: const Text("Add To Cart"));
              },
            ),
          ),
          body: ProductBody(product: widget.product),
        ),
      ),
    );
  }

  Future<UserDataModel> _readUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId") ?? "";
    final email = prefs.getString("email") ?? "";
    final password = prefs.getString("pass") ?? "";
    return UserDataModel(userId: userId, email: email, password: password);
  }
}
