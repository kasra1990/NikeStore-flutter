import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_flutter/common/color.dart';
import 'package:nike_flutter/common/size_config.dart';
import 'package:nike_flutter/common/utils.dart';
import 'package:nike_flutter/data/repo/auth_repository.dart';
import 'package:nike_flutter/ui/auth/bloc/auth_bloc.dart';
import 'package:nike_flutter/ui/auth/sign_in/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  AuthBloc? bloc;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController rePass = TextEditingController();
  String textMessage = "Please enter email and password";
  bool passVisibility = true;
  bool rePassVisibility = true;

  @override
  void dispose() {
    bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    systemUIController();
    return BlocProvider<AuthBloc>(
      create: (context) {
        bloc = AuthBloc(authRepository);
        bloc!.stream.forEach((state) {
          if (state is SignUpSuccess) {
            if (state.authDataModel.email != null) {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SignInScreen()));
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
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/icons/nike_logo.png",
                            width: getWidth(0.25)),
                        SizedBox(height: getHeight(0.03)),
                        Text("Sing up",
                            style: TextStyle(fontSize: getFontSize(0.02))),
                        SizedBox(height: getHeight(0.02)),
                        Text(textMessage,
                            style: TextStyle(fontSize: getFontSize(0.016))),
                        SizedBox(height: getHeight(0.02)),
                        _myTextInput(inputName: "Email"),
                        _myPasswordInput(name: "Password"),
                        _myPasswordInput(name: "Re-Password"),
                        SizedBox(
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
                                checkInternetConnection()
                                    .asStream()
                                    .listen((event) {
                                  if (email.text.isNotEmpty &&
                                      pass.text.isNotEmpty &&
                                      pass.text == rePass.text) {
                                    if (event) {
                                      BlocProvider.of<AuthBloc>(context)
                                          .add(SignUp(email.text, pass.text));
                                    } else {
                                      BlocProvider.of<AuthBloc>(context)
                                          .add(AuthNoInternetConnection());
                                    }
                                  } else if (email.text.isNotEmpty &&
                                      pass.text.isNotEmpty &&
                                      pass.text != rePass.text) {
                                    setState(() {
                                      textMessage =
                                          "Please check your repeated password";
                                    });
                                  }
                                });
                              },
                              child: const Text("Sign Up")),
                        ),
                        SizedBox(height: getHeight(0.14)),
                        TextButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(mainColor),
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent)),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const SignInScreen()));
                            },
                            child: const Text("Sign in")),
                      ]);
                },
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
        ));
  }

  Widget _myPasswordInput({required String name}) {
    return SizedBox(
        width: getWidth(0.8),
        height: getHeight(0.1),
        child: TextFormField(
          controller: name == "Password" ? pass : rePass,
          cursorColor: mainColor,
          obscureText: name == "Password" ? passVisibility : rePassVisibility,
          style: const TextStyle(color: mainColor),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              label: Text(name),
              labelStyle: const TextStyle(color: mainColor),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: mainColor)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: name == "Password"
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          passVisibility = !passVisibility;
                        });
                      },
                      icon: passVisibility
                          ? const Icon(Icons.visibility, color: Colors.grey)
                          : const Icon(Icons.visibility_off,
                              color: Colors.grey))
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          rePassVisibility = !rePassVisibility;
                        });
                      },
                      icon: rePassVisibility
                          ? const Icon(Icons.visibility, color: Colors.grey)
                          : const Icon(Icons.visibility_off,
                              color: Colors.grey))),
        ));
  }
}
