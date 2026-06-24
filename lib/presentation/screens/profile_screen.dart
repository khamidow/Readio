import 'package:audio_pdf_book_flutter/data/source/local/my_pref.dart';
import 'package:audio_pdf_book_flutter/data/source/remote/auth_repository.dart';
import 'package:audio_pdf_book_flutter/presentation/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthRepository _authRepository = AuthRepository();
  bool _loading = false;
  String name = MyPref.getText("USERNAME").substring(0, MyPref
      .getText("USERNAME")
      .length - 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white70,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 52,
                left: 26,
                right: 26,
                bottom: 28,
              ),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(35),
                  bottomLeft: Radius.circular(35),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Text(
                          "Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                _loading = true;
                              });
                              await _authRepository.log_out();
                              setState(() {
                                _loading = false;
                              });
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SplashScreen(),
                                ),
                                    (Route<dynamic> route) => false,
                              );
                            },
                            child: _loading
                                ? CupertinoActivityIndicator(
                              color: Colors.white,
                            )
                                : Icon(
                              Icons.logout,
                              size: 26,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.person_2_rounded,
                      size: 98,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
              child: Row(
                children: [
                  Text(
                    "User Name",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 26),
              height: 1,
              decoration: BoxDecoration(color: Colors.black54),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
              child: Row(
                children: [
                  Text(
                    "Email",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Text(
                    MyPref.getText("USERNAME"),
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 26),
              height: 1,
              decoration: BoxDecoration(color: Colors.black54),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
              child: Row(
                children: [
                  Text(
                    "Change Password",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.navigate_next, size: 28, color: Colors.black87),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 26),
              height: 1,
              decoration: BoxDecoration(color: Colors.black54),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
              child: Row(
                children: [
                  Text(
                    "Notification",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.notifications_none,
                    size: 28,
                    color: Colors.black87,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 26),
              height: 1,
              decoration: BoxDecoration(color: Colors.black54),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
              child: Row(
                children: [
                  Text(
                    "Enable Dark Mode",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.dark_mode_outlined,
                    size: 28,
                    color: Colors.black87,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 26),
              height: 1,
              decoration: BoxDecoration(color: Colors.black54),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
              child: Row(
                children: [
                  Text(
                    "Settings",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.settings_outlined,
                    size: 28,
                    color: Colors.black87,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 26),
              height: 1,
              decoration: BoxDecoration(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
