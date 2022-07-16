import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nike_flutter/common/utils.dart';
import 'package:nike_flutter/ui/root/root.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    systemUIController();
    _goToRoute(context: context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Image.asset("assets/icons/nike_logo.png", width: 100),
        ),
      ),
    );
  }

  _goToRoute({required BuildContext context}) {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      Navigator.of(context).pop();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const RootScreen()));
    });
  }
}
