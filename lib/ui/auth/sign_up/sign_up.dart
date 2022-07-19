import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_flutter/common/color.dart';
import 'package:nike_flutter/common/size_config.dart';
import 'package:nike_flutter/common/utils.dart';
import 'package:nike_flutter/data/repo/auth_repository.dart';
import 'package:nike_flutter/ui/auth/bloc/auth_bloc.dart';
import 'package:nike_flutter/ui/auth/sign_in/sign_in.dart';

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
  final formKey = GlobalKey<FormState>();
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
                  return Form(
                    key: formKey,
                    child: Column(
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
                          _myEamilInput(),
                          _myPasswordInput(),
                          _myRePasswordInput(),
                          SizedBox(height: getHeight(0.02)),
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
                                  final isValidForm =
                                      formKey.currentState!.validate();
                                  if (isValidForm) {
                                    checkInternetConnection()
                                        .asStream()
                                        .listen((event) {
                                      if (event) {
                                        BlocProvider.of<AuthBloc>(context)
                                            .add(SignUp(email.text, pass.text));
                                      } else {
                                        BlocProvider.of<AuthBloc>(context)
                                            .add(AuthNoInternetConnection());
                                      }
                                    });
                                  }
                                },
                                child: const Text("Sign Up")),
                          ),
                          SizedBox(height: getHeight(0.12)),
                          TextButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(mainColor),
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent)),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const SignInScreen()));
                              },
                              child: const Text("Sign in")),
                        ]),
                  );
                },
              ),
            ),
          ),
        ),
      )),
    );
  }

  Widget _myEamilInput() {
    return SizedBox(
        width: getWidth(0.8),
        height: getHeight(0.1),
        child: TextFormField(
          controller: email,
          cursorColor: mainColor,
          style: const TextStyle(color: mainColor),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              label: const Text("Email"),
              labelStyle: const TextStyle(color: mainColor),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: mainColor)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              )),
          validator: (email) {
            if (email!.isEmpty || !EmailValidator.validate(email)) {
              return "Please enter valid email";
            } else {
              return null;
            }
          },
        ));
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
          validator: (password) {
            if (password!.isEmpty) {
              return "Please enter your password";
            } else {
              return null;
            }
          },
        ));
  }

  Widget _myRePasswordInput() {
    return SizedBox(
        width: getWidth(0.8),
        height: getHeight(0.1),
        child: TextFormField(
          controller: rePass,
          cursorColor: mainColor,
          obscureText: rePassVisibility,
          style: const TextStyle(color: mainColor),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              label: const Text("Re-Password"),
              labelStyle: const TextStyle(color: mainColor),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: mainColor)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      rePassVisibility = !rePassVisibility;
                    });
                  },
                  icon: rePassVisibility
                      ? const Icon(Icons.visibility, color: Colors.grey)
                      : const Icon(Icons.visibility_off, color: Colors.grey))),
          validator: (rePassword) {
            if (rePassword!.isEmpty || rePassword != pass.text) {
              return "Re-Password is not correct";
            } else {
              return null;
            }
          },
        ));
  }
}
