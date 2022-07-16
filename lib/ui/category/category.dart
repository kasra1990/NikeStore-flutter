import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike_flutter/common/color.dart';
import 'package:nike_flutter/common/size_config.dart';
import 'package:nike_flutter/data/model/ProductModel.dart';
import 'package:nike_flutter/data/model/userDataModel.dart';
import 'package:nike_flutter/data/repo/category_repository.dart';
import 'package:nike_flutter/ui/category/bloc/category_bloc.dart';
import 'package:nike_flutter/ui/product/product_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/utils.dart';
import '../../data/repo/auth_repository.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  var selectedCategory = 0;
  String userId = "0";
  CategoryBloc? bloc;

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
      userId = "0";
    }
    bloc?.add(CategoryStarted(userId: userId, category: "0"));
  }

  @override
  void dispose() {
    bloc?.close();
    AuthRepository.authChangeNotifier
        .removeListener(authChangeNotifierListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> categoriesButton = [
      "All",
      "Men",
      "Women",
      "Newest",
      "Most Popular"
    ];
    return BlocProvider<CategoryBloc>(
      create: (context) {
        bloc = CategoryBloc(categoryRepository);
        checkInternetConnection().asStream().listen((event) {
          if (event) {
            print("Listening: $event");
            bloc!.add(CategoryStarted(userId: userId, category: "0"));
          } else {
            bloc!.add(CategoryNoInternetConnection());
          }
        });
        return bloc!;
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(
              top: getHeight(0.015),
              left: getWidth(0.04),
              right: getWidth(0.04)),
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) {},
                style: TextStyle(fontSize: getFontSize(0.02)),
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: getFontSize(0.02)),
                  hintText: "Search here...",
                  prefixIconConstraints:
                      BoxConstraints(maxWidth: 30, maxHeight: 30),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: const BorderSide(color: mainColor, width: 2)),
                ),
                cursorColor: mainColor,
              ),
              SizedBox(height: getHeight(0.015)),
              SizedBox(
                height: getHeight(0.045),
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: categoriesButton.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      var selected = selectedCategory == index;
                      return Padding(
                        padding: EdgeInsets.only(
                            left: index == 0 ? 0 : getWidth(0.02)),
                        child: TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    selected ? mainColor : Colors.white),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        horizontal: getWidth(0.05))),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        side:
                                            const BorderSide(color: mainColor),
                                        borderRadius:
                                            BorderRadius.circular(17))),
                                overlayColor: MaterialStateProperty.all(
                                    Colors.grey.withOpacity(0.3))),
                            onPressed: () {
                              checkInternetConnection()
                                  .asStream()
                                  .listen((event) {
                                if (event) {
                                  setState(() {
                                    selectedCategory = index;
                                  });
                                  BlocProvider.of<CategoryBloc>(context).add(
                                      CategoryStarted(
                                          userId: "0",
                                          category: index.toString()));
                                } else {
                                  BlocProvider.of<CategoryBloc>(context)
                                      .add(CategoryNoInternetConnection());
                                }
                              });
                            },
                            child: Text(categoriesButton[index],
                                style: TextStyle(
                                    fontSize: getFontSize(0.015),
                                    color:
                                        selected ? Colors.white : mainColor))),
                      );
                    }),
              ),
              SizedBox(height: getHeight(0.015)),
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategorySuccess) {
                    return Expanded(
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 20,
                                    childAspectRatio: 0.82,
                                    crossAxisCount: 2),
                            itemCount: state.products.length,
                            itemBuilder: (context, index) {
                              final product = state.products[index];
                              return _Product(
                                product: product,
                              );
                            }));
                  } else if (state is CategoryLoading) {
                    return const Expanded(
                        child: Center(
                            child: CircularProgressIndicator(
                      color: mainColor,
                    )));
                  } else if (state is CategoryConnection) {
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                      ),
                    );
                  } else if (state is CategoryError) {
                    throw Exception(state.error);
                  } else {
                    throw Exception("State is not supported");
                  }
                },
              )
            ],
          ),
        ),
      )),
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

class _Product extends StatelessWidget {
  final ProductModel product;

  const _Product({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: getHeight(0.01),
        bottom: getHeight(0.01),
      ),
      child: OpenContainer(
        closedElevation: 0,
        closedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        openShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        transitionType: ContainerTransitionType.fade,
        transitionDuration: const Duration(milliseconds: 400),
        openBuilder: (context, _) => ProductDetailsScreen(product: product),
        closedBuilder: (context, VoidCallback openContainer) => InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: openContainer,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(product.image1,
                    alignment: Alignment.center,
                    width: getWidth(0.5),
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
