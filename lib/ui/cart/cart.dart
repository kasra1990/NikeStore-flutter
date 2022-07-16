import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_flutter/common/color.dart';
import 'package:nike_flutter/common/size_config.dart';
import 'package:nike_flutter/common/utils.dart';
import 'package:nike_flutter/data/model/CartDataModel.dart';
import 'package:nike_flutter/data/repo/auth_repository.dart';
import 'package:nike_flutter/data/repo/cart_repository.dart';
import 'package:nike_flutter/ui/auth/sign_in/sign_in.dart';
import 'package:nike_flutter/ui/cart/bloc/cart_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final CartBloc? cartBloc;
  String userId = "";

  @override
  void initState() {
    AuthRepository.authChangeNotifier.addListener(getUserCartNotifierListener);
    CartRepository.autoRefreshNotifier.addListener(getUserCartNotifierListener);
    super.initState();
  }

  void getUserCartNotifierListener() {
    var userID = AuthRepository.authChangeNotifier.value?.userId ?? "";
    if (userID.isNotEmpty) {
      userId = userID;
      cartBloc?.add(CartStarted(userID));
    } else {
      cartBloc?.add(CartAuth());
    }
  }

  @override
  void dispose() {
    cartBloc?.close();
    AuthRepository.authChangeNotifier
        .removeListener(getUserCartNotifierListener);
    CartRepository.autoRefreshNotifier
        .removeListener(getUserCartNotifierListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BlocProvider<CartBloc>(
      create: (context) {
        cartBloc = CartBloc(cartRepository);
        checkInternetConnection().asStream().forEach((element) {
          if (element) {
            _getUserId().asStream().listen((userId) {
              if (userId.isNotEmpty) {
                cartBloc?.add(CartStarted(userId));
              } else {
                cartBloc?.add(CartAuth());
              }
            });
          } else {
            cartBloc?.add(CartNoInternetConnection());
          }
        });
        return cartBloc!;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Image.asset('assets/icons/nike_logo.png',
                fit: BoxFit.cover, height: getHeight(0.03)),
            centerTitle: true,
          ),
          body: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(
                    child: CircularProgressIndicator(color: mainColor));
              } else if (state is CartSuccess) {
                CartRepository.autoRefreshNotifier.value = false;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(0.05)),
                  child: Stack(
                    children: [
                      ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.carts.length + 1,
                          itemBuilder: (context, index) {
                            if (index < state.carts.length) {
                              final cart = state.carts[index];
                              return Padding(
                                  padding:
                                      EdgeInsets.only(bottom: getHeight(0.02)),
                                  child: _CartProduct(
                                    cart: cart,
                                    onDecreaseButtonClicked: () {
                                      checkInternetConnection()
                                          .asStream()
                                          .listen((event) {
                                        if (event) {
                                          cartBloc?.add(
                                              CartDecreaseCount(cart.cartId));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Something wrong with your internet connection")));
                                        }
                                      });
                                    },
                                    onIncreaseButtonClicked: () {
                                      checkInternetConnection()
                                          .asStream()
                                          .listen((event) {
                                        if (event) {
                                          cartBloc?.add(
                                              CartIncreaseCount(cart.cartId));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Something wrong with your internet connection")));
                                        }
                                      });
                                    },
                                    checkedForDelete: () {
                                      checkInternetConnection()
                                          .asStream()
                                          .listen((event) {
                                        if (event) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            duration:
                                                const Duration(seconds: 3),
                                            content: const Text(
                                                "Do you want to delte this item?"),
                                            action: SnackBarAction(
                                                label: "Yes",
                                                onPressed: () {
                                                  cartBloc?.add(
                                                      CartDeleteProducts(
                                                          cart.cartId));
                                                }),
                                          ));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Something wrong with your internet connection")));
                                        }
                                      });
                                    },
                                  ));
                            } else {
                              final totalPayment =
                                  double.parse(state.totalPayment)
                                      .toStringAsFixed(2);
                              return Column(
                                children: [
                                  SizedBox(height: getHeight(0.015)),
                                  Divider(
                                      height: 1,
                                      color: Colors.black.withOpacity(0.5)),
                                  SizedBox(height: getHeight(0.015)),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text("Total Payment",
                                              style: TextStyle(
                                                  color: mainColor,
                                                  fontSize: getFontSize(0.017),
                                                  fontWeight:
                                                      FontWeight.w700))),
                                      Text("\$ $totalPayment",
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: mainColor,
                                              fontSize: getFontSize(0.017),
                                              fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                  SizedBox(height: getHeight(0.12))
                                ],
                              );
                            }
                          }),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: getHeight(0.075),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                Colors.white,
                                Colors.white.withOpacity(0.7)
                              ])),
                        ),
                      ),
                      Positioned(
                          bottom: getHeight(0.01),
                          child: SizedBox(
                            width: getWidth(0.9),
                            height: getHeight(0.055),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(mainColor),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)))),
                              onPressed: () {
                                checkInternetConnection()
                                    .asStream()
                                    .listen((event) {
                                  if (!event) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Something wrong with your internet connection")));
                                  }
                                });
                              },
                              child: Text("Check Out",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: getFontSize(0.018))),
                            ),
                          ))
                    ],
                  ),
                );
              } else if (state is CartConnection) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("No Internet Connection",
                        textAlign: TextAlign.center),
                    SizedBox(height: getHeight(0.01)),
                    OutlinedButton(
                        style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                                Size(getWidth(0.4), getHeight(0.045))),
                            overlayColor: MaterialStateProperty.all(
                                Colors.grey.withOpacity(0.3)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            foregroundColor:
                                MaterialStateProperty.all(mainColor),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)))),
                        onPressed: () {
                          checkInternetConnection().asStream().listen((event) {
                            if (event) {
                              authRepository.autoSignIn();
                            }
                          });
                        },
                        child: const Text("Try again"))
                  ],
                ));
              } else if (state is CartNotAuthentication) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "To view the shopping cart, please login",
                        style: TextStyle(fontSize: getFontSize(0.017)),
                      ),
                      SizedBox(height: getHeight(0.01)),
                      OutlinedButton(
                          style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                  Size(getWidth(0.5), getHeight(0.045))),
                              overlayColor: MaterialStateProperty.all(
                                  Colors.grey.withOpacity(0.3)),
                              foregroundColor:
                                  MaterialStateProperty.all(mainColor),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15)))),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SignInScreen()));
                          },
                          child: Text(
                            "login",
                            style: TextStyle(
                                fontSize: getFontSize(0.016),
                                fontWeight: FontWeight.w400),
                          )),
                    ],
                  ),
                );
              } else if (state is CartEmpty) {
                return const Center(child: Text("Your shopping cart is empty"));
              } else if (state is CartError) {
                debugPrint("ERROR is: ${state.error}");
                return Container();
              } else {
                throw Exception("this state is not supported");
              }
            },
          )),
    ));
  }

  Future<String> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("userId") ?? "";
  }
}

class _CartProduct extends StatefulWidget {
  final CartDataModel cart;
  final GestureTapCallback onIncreaseButtonClicked;
  final GestureTapCallback onDecreaseButtonClicked;
  final GestureTapCallback checkedForDelete;

  const _CartProduct(
      {Key? key,
      required this.cart,
      required this.checkedForDelete,
      required this.onIncreaseButtonClicked,
      required this.onDecreaseButtonClicked})
      : super(key: key);

  @override
  State<_CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<_CartProduct> {
  bool? checkBoxState = false;

  @override
  Widget build(BuildContext context) {
    final price = double.parse(widget.cart.product.price) *
        double.parse(widget.cart.count);
    return Card(
      color: Colors.white.withOpacity(0.95),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          SizedBox(
            height: getHeight(0.15),
            child: Row(
              children: [
                SizedBox(
                    width: getWidth(0.3),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.only(topLeft: Radius.circular(15)),
                      child: Image.network(
                        widget.cart.product.image4,
                        fit: BoxFit.cover,
                      ),
                    )),
                SizedBox(width: getWidth(0.03)),
                SizedBox(
                  width: getWidth(0.52),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: getHeight(0.02)),
                      Expanded(
                        child: Text(widget.cart.product.name,
                            style: TextStyle(
                                color: mainColor,
                                fontWeight: FontWeight.w700,
                                fontSize: getFontSize(0.016),
                                overflow: TextOverflow.ellipsis),
                            maxLines: 1),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Text(widget.cart.product.gender,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: getFontSize(0.015))),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("Size: ${widget.cart.shoesSize}",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: getFontSize(0.015))),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Expanded(
                                child: Text("\$${price.toStringAsFixed(2)}",
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: getFontSize(0.016),
                                    ))),
                            InkWell(
                              onTap: widget.onIncreaseButtonClicked,
                              child: Icon(
                                  Icons.indeterminate_check_box_outlined,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                            SizedBox(width: getWidth(0.01)),
                            Text(widget.cart.count,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: getFontSize(0.017))),
                            SizedBox(width: getWidth(0.01)),
                            InkWell(
                              onTap: widget.onDecreaseButtonClicked,
                              child: Icon(Icons.add_box_outlined,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(height: 0),
          TextButton(
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent)),
              onPressed: widget.checkedForDelete,
              child: Text("Delete",
                  style: TextStyle(
                      color: mainColor, fontSize: getFontSize(0.016))))
        ],
      ),
    );
  }
}
