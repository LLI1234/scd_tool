import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'match_page.dart';
import 'profile_page.dart';
import 'saved_page.dart';
import 'calendar_page.dart';

import '../models/app_data.dart';
import '../models/login_data.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final screens = [
    CalendarPage(),
    SavedPage(),
    MatchPage(),
    ProfilePage(),
  ];

  int selectedIndex = 2;
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          AppData(loginData: Provider.of<LoginData>(context, listen: false)),
      builder: (context, child) {
        return Scaffold(
          body: SafeArea(child: screens[selectedIndex]),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).colorScheme.primary,
            selectedItemColor: Theme.of(context).colorScheme.onPrimary,
            unselectedItemColor: Theme.of(context).colorScheme.onBackground,
            selectedIconTheme: IconThemeData(size: 30),
            unselectedIconTheme: IconThemeData(size: 25),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.calendar,
              ),
              label: 'Symptoms',
              ),
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
          ),
        );
      },
    );
  }
}
