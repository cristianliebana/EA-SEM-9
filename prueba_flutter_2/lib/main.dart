import 'package:flutter/material.dart';
import 'package:prueba_flutter_2/edit_user_page.dart';
import 'package:prueba_flutter_2/products_list_page.dart';
import 'profile_page.dart';
import 'home_page.dart';
import 'create_user_page.dart';
import 'user_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    UserListPage(),
    ProfilePage(),
    CreateUserPage(),
    ProductsListPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Color.fromARGB(255, 183, 181, 181),
          backgroundColor: Color(0xFF486D28),
          selectedItemColor: Color(0xFFFFFCEA),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
              BottomNavigationBarItem(
              icon: Icon(Icons.production_quantity_limits),
              label: 'Products',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
      routes: {
        '/create_user': (context) => CreateUserPage(),
      },
    );
  }
}
