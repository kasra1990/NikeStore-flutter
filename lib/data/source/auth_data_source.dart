import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nike_flutter/data/model/AuthDataModel.dart';
import 'package:nike_flutter/data/repo/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/userDataModel.dart';

abstract class IAuthDataSource {
  Future<AuthDataModel> singIn(String email, String password);

  Future<AuthDataModel> singUp(String email, String password);

  Future<void> autoSignIn();
}

class AuthDataSource implements IAuthDataSource {
  final Dio httpClient;

  AuthDataSource(this.httpClient);

  @override
  Future<AuthDataModel> singIn(String email, String password) async {
    final response = await httpClient
        .post('signIn.php', data: {"email": email, "password": password});
    if (response.statusCode != 200) {
      throw Exception(response.statusMessage);
    }
    return AuthDataModel.fromJson(jsonDecode(response.data));
  }

  @override
  Future<AuthDataModel> singUp(String email, String password) async {
    final response = await httpClient
        .post('signUp.php', data: {"email": email, "password": password});
    if (response.statusCode != 200) {
      throw Exception(response.statusMessage);
    }
    return AuthDataModel.fromJson(jsonDecode(response.data));
  }

  @override
  Future<void> autoSignIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId") ?? "";
    final email = prefs.getString("email") ?? "";
    final password = prefs.getString("pass") ?? "";
    if (userId.isNotEmpty) {
      AuthRepository.authChangeNotifier.value =
          UserDataModel(userId: userId, email: email, password: password);
    }
  }
}
