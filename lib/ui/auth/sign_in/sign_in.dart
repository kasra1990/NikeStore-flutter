import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_flutter/common/color.dart';
import 'package:nike_flutter/common/size_config.dart';
import 'package:nike_flutter/common/utils.dart';
import 'package:nike_flutter/data/model/userDataModel.dart';
import 'package:nike_flutter/data/repo/auth_repository.dart';
import 'package:nike_flutter/ui/auth/bloc/auth_bloc.dart';
import 'package:nike_flutter/ui/auth/sign_up/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  AuthBloc? bloc;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool passVisibility = true;
  final formKey = GlobalKey<FormState>();
  String textMessage = "Please enter email and password";

  @override
  void dispose() {
    bloc!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    systemUIController();
    return BlocProvider<AuthBloc>(
      create: (context) {
        bloc = AuthBloc(authRepository);
        bloc!.stream.forEach((state) {
          if (state is SignInSuccess) {
            if (state.authDataModel.email != null) {
              _saveUser(state.authDataModel.userId!, email.text, pass.text);
              AuthRepository.authChangeNotifier.value = UserDataModel(
                  userId: state.authDataModel.userId!,
                  email: email.text,
                  password: pass.text);
              Navigator.of(context).pop();
            } else {
              setState(() {
                textMessage = state.authDataModel.message!;
              });
            }
          } else if (state is AuthNoInternet) {
            setState(() {
              textMessage = "Something wrong with your internet connection";
            });
          }
        });
        return bloc!;
      },
      child: SafeArea(
          child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: getHeight(0.17)),
            child: SizedBox(
              width: double.infinity,
              child: Form(
                key: formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/icons/nike_logo.png",
                          width: getWidth(0.25)),
                      SizedBox(height: getHeight(0.03)),
                      Text("Sing in",
                          style: TextStyle(fontSize: getFontSize(0.02))),
                      SizedBox(height: getHeight(0.02)),
                      Text(textMessage,
                          style: TextStyle(fontSize: getFontSize(0.016))),
                      SizedBox(height: getHeight(0.02)),
                      _myTextInput(inputName: "Email"),
                      _myPasswordInput(),
                      SizedBox(height: getHeight(0.02)),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return const CircularProgressIndicator(
                                color: mainColor);
                          } else {
                            return SizedBox(
                              width: getWidth(0.8),
                              height: getHeight(0.06),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        if (!states
                                            .contains(MaterialState.disabled)) {
                                          return mainColor;
                                        }
                                      }),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)))),
                                  onPressed: () {
                                    final isValidForm =
                                        formKey.currentState!.validate();
                                    if (isValidForm) {
                                      checkInternetConnection()
                                          .asStream()
                                          .listen((event) {
                                        if (event) {
                                          BlocProvider.of<AuthBloc>(context)
                                              .add(SignIn(
                                                  email.text, pass.text));
                                        } else {
                                          BlocProvider.of<AuthBloc>(context)
                                              .add(AuthNoInternetConnection());
                                        }
                                      });
                                    }
                                  },
                                  child: const Text("Login")),
                            );
                          }
                        },
                      ),
                      SizedBox(height: getHeight(0.15)),
                      TextButton(
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(mainColor),
                              overlayColor: MaterialStateProperty.all(
                                  Colors.transparent)),
                          onPressed: () {},
                          child: const Text("Forgot Password?")),
                      TextButton(
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(mainColor),
                              overlayColor: MaterialStateProperty.all(
                                  Colors.transparent)),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                          },
                          child: const Text("Sign Up")),
                    ]),
              ),
            ),
          ),
        ),
      )),
    );
  }

  Widget _myTextInput({required String inputName}) {
    return SizedBox(
        width: getWidth(0.8),
        height: getHeight(0.1),
        child: TextFormField(
            controller: email,
            cursorColor: mainColor,
            obscureText: inputName == "Email" ? false : true,
            style: const TextStyle(color: mainColor),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                label: Text(inputName),
                labelStyle: const TextStyle(color: mainColor),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: mainColor)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: inputName == "Password"
                    ? IconButton(
                        onPressed: () {}, icon: const Icon(Icons.visibility))
                    : null),
            validator: (value) {
              if (value!.isEmpty || !EmailValidator.validate(value)) {
                return "Please enter a valid email";
              } else {
                return null;
              }
            }));
  }

  Widget _myPasswordInput() {
    return SizedBox(
        width: getWidth(0.8),
        height: getHeight(0.1),
        child: TextFormField(
          controller: pass,
          cursorColor: mainColor,
          obscureText: passVisibility,
          style: const TextStyle(color: mainColor),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              label: const Text("Password"),
              labelStyle: const TextStyle(color: mainColor),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: mainColor)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      passVisibility = !passVisibility;
                    });
                  },
                  icon: passVisibility
                      ? const Icon(Icons.visibility, color: Colors.grey)
                      : const Icon(Icons.visibility_off, color: Colors.grey))),
          validator: (value) {
            if (value!.isEmpty) {
              return "Please enter your password";
            } else {
              return null;
            }
          },
        ));
  }

  _saveUser(String userId, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("userId", userId);
    await prefs.setString("email", email);
    await prefs.setString("pass", password);
  }
}
