import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nike_flutter/common/color.dart';
import 'package:nike_flutter/common/size_config.dart';
import 'package:nike_flutter/data/model/userDataModel.dart';
import 'package:nike_flutter/data/repo/auth_repository.dart';
import 'package:nike_flutter/ui/auth/sign_in/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> buttonsName = ["Favorite", "Order", "Login", "Logout"];
    List<String> buttonsIcon = [
      "assets/icons/heart_icon.svg",
      "assets/icons/order.svg",
      "assets/icons/login.svg",
      "assets/icons/logout.svg",
    ];
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
                top: getHeight(0.05),
                left: 0,
                right: 0,
                child: ValueListenableBuilder<UserDataModel?>(
                    valueListenable: AuthRepository.authChangeNotifier,
                    builder: (context, userData, child) {
                      final isLogin = userData?.email != null;
                      return Column(
                        children: [
                          Container(
                              padding: EdgeInsets.all(getWidth(0.02)),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.3),
                                      width: 1)),
                              child: Image.asset("assets/icons/nike_logo.png",
                                  width: getWidth(0.15),
                                  height: getWidth(0.15))),
                          SizedBox(height: getHeight(0.02)),
                          Text(isLogin ? userData!.email : "Guest User",
                              style: TextStyle(
                                  color: mainColor.withOpacity(0.8),
                                  fontSize: getFontSize(0.015))),
                          SizedBox(height: getHeight(0.02)),
                          _myButton(
                              name: buttonsName[0],
                              icon: buttonsIcon[0],
                              onClick: () {}),
                          _myButton(
                              name: buttonsName[1],
                              icon: buttonsIcon[1],
                              onClick: () {}),
                          _myButton(
                              name: isLogin ? buttonsName[3] : buttonsName[2],
                              icon: isLogin ? buttonsIcon[3] : buttonsIcon[2],
                              onClick: () {
                                if (isLogin) {
                                  showModal(
                                      configuration:
                                          const FadeScaleTransitionConfiguration(
                                              transitionDuration:
                                                  Duration(milliseconds: 500),
                                              reverseTransitionDuration:
                                                  Duration(milliseconds: 300)),
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            title: const Text("Log out"),
                                            content:
                                                const Text("Are you sure?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    _removeUser();
                                                    AuthRepository
                                                        .authChangeNotifier
                                                        .value = null;
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                        color: mainColor),
                                                  )),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    "No",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ))
                                            ],
                                          ));
                                } else {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const SignInScreen()));
                                }
                              }),
                          Divider(
                              height: 0, color: Colors.grey.withOpacity(0.8)),
                        ],
                      );
                    })),
            Positioned(
                left: 0,
                right: 0,
                bottom: getHeight(0.03),
                child: Column(
                  children: [
                    Text("Version 1.0",
                        style: TextStyle(
                            color: Colors.grey, fontSize: getFontSize(0.015))),
                    SizedBox(height: getHeight(0.01)),
                    Text("Designed & Developed By KY",
                        style: TextStyle(
                            color: Colors.grey, fontSize: getFontSize(0.015)))
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget _myButton(
      {required String name,
      required String icon,
      required Function() onClick}) {
    return Column(children: [
      Divider(height: 0, color: Colors.grey.withOpacity(0.8)),
      SizedBox(
        width: double.infinity,
        height: getHeight(0.07),
        child: TextButton.icon(
            style: ButtonStyle(
                overlayColor:
                    MaterialStateProperty.all(Colors.grey.withOpacity(0.15)),
                alignment: Alignment.centerLeft,
                padding: MaterialStateProperty.all(
                    EdgeInsets.only(left: getWidth(0.05)))),
            onPressed: () {
              onClick();
            },
            icon: SvgPicture.asset(icon, color: mainColor),
            label: Text(name,
                style:
                    TextStyle(color: mainColor, fontSize: getFontSize(0.018)))),
      ),
    ]);
  }

  _removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
