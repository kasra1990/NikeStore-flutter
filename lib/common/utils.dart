import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void systemUIController() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark));
}

Future<bool> checkInternetConnection() async {
  bool state = true;
  final result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.none) {
    state = false;
  } else {
    state = true;
  }
  debugPrint('Internet State: ${result.name}');
  return state;
}
