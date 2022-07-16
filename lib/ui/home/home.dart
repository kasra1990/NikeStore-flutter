import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nike_flutter/common/color.dart';
import 'package:nike_flutter/common/size_config.dart';
import 'package:nike_flutter/common/utils.dart';
import 'package:nike_flutter/data/model/ProductModel.dart';
import 'package:nike_flutter/data/model/userDataModel.dart';
import 'package:nike_flutter/data/repo/auth_repository.dart';
import 'package:nike_flutter/data/repo/home_data_repository.dart';
import 'package:nike_flutter/ui/home/bloc/home_bloc.dart';
import 'package:nike_flutter/ui/home/component/slider.dart';
import 'package:nike_flutter/ui/product/product_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userId = "";
  HomeBloc? bloc;

  @override
  void initState() {
    _readUser().asStream().listen((event) {
      userId = event.userId;
    });
    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
    super.initState();
  }

  void authChangeNotifierListener() {
    var userID = AuthRepository.authChangeNotifier.value?.userId ?? "";
    if (userID.isNotEmpty) {
      userId = userID;
    } else {
      userId = "";
    }
    bloc?.add(HomeStarted());
  }

  @override
  void dispose() {
    AuthRepository.authChangeNotifier
        .removeListener(authChangeNotifierListener);
    bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    systemUIController();
    SizeConfig().init(context);
    return BlocProvider(
      create: (context) {
        bloc = HomeBloc(homeDataRepository);
        checkInternetConnection().asStream().listen((event) {
          if (event) {
            bloc!.add(HomeStarted());
          } else {
            bloc!.add(HomeNoInternetConnection());
          }
        });
        bloc!.stream.listen((event) {
          debugPrint("State is : $event");
        });
        return bloc!;
      },
      child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              body: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeSuccess) {
                    return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: getHeight(0.01),
                                    bottom: getHeight(0.02)),
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/icons/nike_logo.png',
                                      fit: BoxFit.cover,
                                      height: getHeight(0.03),
                                    )),
                              );
                            case 1:
                              return BannerSlider(
                                  banners: state.homeDataModel.sliders);
                            case 2:
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: getHeight(0.01),
                                    left: getWidth(0.03),
                                    right: getWidth(0.03)),
                                child: _ProductList(
                                  title: "New Arrivals",
                                  products: state.homeDataModel.newArrivals,
                                ),
                              );
                            case 3:
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: getWidth(0.03),
                                    right: getWidth(0.03)),
                                child: _ProductList(
                                  title: "Most Popular",
                                  products: state.homeDataModel.mostPopular,
                                ),
                              );
                            default:
                              return Container();
                          }
                        });
                  } else if (state is HomeLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: mainColor,
                    ));
                  } else if (state is HomeConnection) {
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
                                        borderRadius:
                                            BorderRadius.circular(15)))),
                            onPressed: () {
                              checkInternetConnection()
                                  .asStream()
                                  .listen((event) {
                                if (event) {
                                  authRepository.autoSignIn();
                                }
                              });
                            },
                            child: const Text("Try again"))
                      ],
                    ));
                  } else if (state is HomeError) {
                    return Center(
                        child: Text(state.error, textAlign: TextAlign.center));
                  } else {
                    throw Exception("State is not support : $state");
                  }
                },
              ))),
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

class _ProductList extends StatelessWidget {
  final String title;
  final List<ProductModel> products;

  const _ProductList({Key? key, required this.title, required this.products})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: getFontSize(0.016))),
            Text("View All", style: TextStyle(fontSize: getFontSize(0.016)))
          ],
        ),
        SizedBox(
          height: getHeight(0.24),
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: products.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final product = products[index];
                return _Product(index: index, product: product);
              }),
        ),
      ],
    );
  }
}

class _Product extends StatelessWidget {
  final ProductModel product;
  final int index;

  const _Product({Key? key, required this.product, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: getHeight(0.01),
          bottom: getHeight(0.01),
          left: index == 0 ? 0 : getWidth(0.03)),
      child: OpenContainer(
        closedElevation: 0,
        closedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        openShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        transitionType: ContainerTransitionType.fade,
        transitionDuration: const Duration(milliseconds: 400),
        openBuilder: (contex, _) => ProductDetailsScreen(product: product),
        closedBuilder: (context, VoidCallback openContainer) => InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: openContainer,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(product.image1,
                    alignment: Alignment.center,
                    width: getWidth(0.4),
                    height: getHeight(0.24),
                    fit: BoxFit.fill),
              ),
              Positioned(
                  top: getHeight(0.015),
                  left: getWidth(0.025),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name,
                          style: TextStyle(fontSize: getFontSize(0.012))),
                      SizedBox(height: getHeight(0.005)),
                      Text(product.gender,
                          style: TextStyle(fontSize: getFontSize(0.012))),
                    ],
                  )),
              Positioned(
                  bottom: getHeight(0.02),
                  left: getWidth(0.025),
                  child: Text(
                    "\$${product.price}",
                    style: TextStyle(fontSize: getFontSize(0.012)),
                  )),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: SvgPicture.asset('assets/icons/heart_icon.svg'),
                    onPressed: () {},
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
