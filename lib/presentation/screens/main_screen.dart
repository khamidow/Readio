import 'package:audio_pdf_book_flutter/presentation/screens/home_screen.dart';
import 'package:audio_pdf_book_flutter/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedItem = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedItem = index;
    });
  }

  final List<Widget> _pages = [HomeScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedItem],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 15,
        selectedIconTheme: IconThemeData(color: Colors.redAccent),
        selectedItemColor: Colors.redAccent,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedItem,
        onTap: _navigateBottomBar,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
