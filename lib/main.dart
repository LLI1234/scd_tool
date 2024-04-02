import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'pages/match_page.dart';
import 'pages/profile_page.dart';
import 'pages/login_page.dart';
import 'pages/login_bloc.dart';
import 'pages/saved_page.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    Provider<http.Client>(
      create: (_) => http.Client(),
    ),
    BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme(
          primary: const Color.fromARGB(255, 255, 82, 73),
          secondary: const Color.fromARGB(255, 54, 120, 244),
          surface: Colors.white,
          background: Colors.grey[200]!,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          onBackground: Colors.grey[400]!,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title; 

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final screens = [
    SavedPage(),
    MatchPage(),
    ProfilePage(),
  ];

  int selectedIndex = 1;
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          //Keeps all the children alive i.e. state is preserved
          index: selectedIndex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          selectedItemColor: Theme.of(context).colorScheme.onPrimary,
          unselectedItemColor: Theme.of(context).colorScheme.onBackground,
          selectedIconTheme: IconThemeData(size: 40),
          unselectedIconTheme: IconThemeData(size: 30),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.bookmark,
              ),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.magnifyingGlass,
              ),
              label: 'Match',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.user,
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: selectedIndex,
          onTap: (index) => onItemTapped(index),
        ));
  }
}
