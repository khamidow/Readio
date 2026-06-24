import 'package:audio_pdf_book_flutter/presentation/screens/main_screen.dart';
import 'package:audio_pdf_book_flutter/presentation/screens/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _toggle = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.isLoginSuccess == true) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          } else if (state.isLoginSuccess == false) {
            if (state.message != "") {
              String message = state.message.toString();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("$message"),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                  width: 280.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              );
            }
          }
          if (state.goToRegister == true) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterScreen()),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 42, horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 36),
                        Image.asset(
                          'assets/app_logo.png',
                          height: 130,
                          width: 130,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(height: 28),
                        Text(
                          "Welcome Back",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Sign in to continue",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 36),
                        TextFormField(
                          controller: _usernameController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username';
                            }
                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Username';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _usernameController.text = "";
                              },
                              child: Icon(Icons.clear, size: 24),
                            ),
                            hintText: "Email Address",
                            hintStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          obscureText: _toggle,
                          obscuringCharacter: '*',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            suffixIconColor: Colors.black45,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _toggle
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 24,
                              ),
                              onPressed: () {
                                setState(() {
                                  _toggle = !_toggle;
                                });
                              },
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 42),
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              context.read<LoginBloc>().add(
                                LogInEvent(
                                  _usernameController.text,
                                  _passwordController.text,
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 64,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.redAccent,
                              ),
                              child: state.loading == true
                                  ? CupertinoActivityIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      "SIGN IN",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: 42),
                        Center(
                          child: Text(
                            "or sign in using",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Spacer(),
                            GestureDetector(
                              onTap: (){
                                context.read<LoginBloc>().add(SignInWithGoogleEvent());
                              },
                              child: Image.asset(
                                'assets/ic_google.png',
                                height: 42,
                                width: 42,
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(width: 28),
                            Image.asset(
                              'assets/ic_facebook.png',
                              height: 42,
                              width: 42,
                              fit: BoxFit.fill,
                            ),
                            Spacer(),
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Spacer(),
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.read<LoginBloc>().add(
                                  GoToRegisterEvent(),
                                );
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
