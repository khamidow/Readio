import 'package:audio_pdf_book_flutter/presentation/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/register_bloc/register_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _toggle1 = true;
  bool _toggle2 = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(),
      child: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.isRegisterSuccess == true) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
              (Route<dynamic> route) => false,
            );
          } else if (state.isRegisterSuccess == false) {
            if (state.message != "") {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message.toString()),
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
                        SizedBox(height: 26),
                        Image.asset(
                          'assets/app_logo.png',
                          height: 130,
                          width: 130,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(height: 28),
                        Text(
                          "Create an Account",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Register to continue",
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
                          obscureText: _toggle1,
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
                                _toggle1
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 24,
                              ),
                              onPressed: () {
                                setState(() {
                                  _toggle1 = !_toggle1;
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
                        SizedBox(height: 20),
                        TextField(
                          obscureText: _toggle2,
                          obscuringCharacter: '*',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          controller: _confirmController,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            suffixIconColor: Colors.black45,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _toggle2
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 24,
                              ),
                              onPressed: () {
                                setState(() {
                                  _toggle2 = !_toggle2;
                                });
                              },
                            ),
                            hintText: "Retype password",
                            hintStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 36),
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              context.read<RegisterBloc>().add(
                                AuthRegisterEvent(
                                  _usernameController.text,
                                  _passwordController.text,
                                  _confirmController.text,
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
                                      "Register",
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
                            "or register using",
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
                              onTap: () {
                                context.read<RegisterBloc>().add(
                                  SignInWithGoogleEvent(),
                                );
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
                              "Already have an account? ",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Sign In",
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
