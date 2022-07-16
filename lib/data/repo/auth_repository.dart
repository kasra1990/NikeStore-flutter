import 'package:flutter/material.dart';
import 'package:nike_flutter/common/http_client.dart';
import 'package:nike_flutter/data/model/AuthDataModel.dart';
import 'package:nike_flutter/data/model/userDataModel.dart';
import 'package:nike_flutter/data/source/auth_data_source.dart';

final authRepository = AuthRepository(AuthDataSource(httpClient));

abstract class IAuthRepository {
  Future<AuthDataModel> singIn(String email, String password);

  Future<AuthDataModel> singUp(String email, String password);
  Future<void> autoSignIn();
}

class AuthRepository implements IAuthRepository {
  static final ValueNotifier<UserDataModel?> authChangeNotifier =
      ValueNotifier(null);

  final IAuthDataSource dataSource;

  AuthRepository(this.dataSource);

  @override
  Future<AuthDataModel> singIn(String email, String password) =>
      dataSource.singIn(email, password);

  @override
  Future<AuthDataModel> singUp(String email, String password) =>
      dataSource.singUp(email, password);

  @override
  Future<void> autoSignIn()=>dataSource.autoSignIn();
}
