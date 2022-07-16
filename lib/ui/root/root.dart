import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nike_flutter/common/utils.dart';
import 'package:nike_flutter/ui/cart/cart.dart';
import 'package:nike_flutter/ui/category/category.dart';
import 'package:nike_flutter/ui/home/home.dart';
import 'package:nike_flutter/ui/salomon_bottom_bar.dart';
import 'package:nike_flutter/ui/user/user.dart';

const int homeIndex = 0;
const int categoryIndex = 1;
const int cartIndex = 2;
const int userIndex = 3;

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedScreenIndex = homeIndex;

  final List<String> itemsName = ["Home", "Category", "Cart", "User"];
  final List<String> iconsPath = [
    "assets/icons/home.svg",
    "assets/icons/category.svg",
    "assets/icons/cart.svg",
    "assets/icons/user.svg"
  ];

  @override
  Widget build(BuildContext context) {
    systemUIController();
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: selectedScreenIndex,
        selectedItemColor: const Color(0xFF212121),
        unselectedItemColor: const Color(0xFF212121),
        onTap: (index) {
          setState(() {
            selectedScreenIndex = index;
          });
        },
        items: [
          SalomonBottomBarItem(
              icon: SvgPicture.asset(iconsPath[0]), title: Text(itemsName[0])),
          SalomonBottomBarItem(
              icon: SvgPicture.asset(iconsPath[1]), title: Text(itemsName[1])),
          SalomonBottomBarItem(
              icon: SvgPicture.asset(iconsPath[2]), title: Text(itemsName[2])),
          SalomonBottomBarItem(
              icon: SvgPicture.asset(iconsPath[3]), title: Text(itemsName[3])),
        ],
      ),
      body: IndexedStack(
        index: selectedScreenIndex,
        children: const [
          HomeScreen(),
          CategoryScreen(),
          CartScreen(),
          UserScreen(),
        ],
      ),
    );
  }
}
