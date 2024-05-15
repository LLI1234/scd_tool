import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/routes/routes.dart';
import '/models/login_data.dart';
import '/models/app_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginData()),
        ChangeNotifierProvider<AppData>(
          create: (context) => AppData(
              loginData: Provider.of<LoginData>(context, listen: false)),
        ),
      ],
      builder: (context, child) {
        final loginData = Provider.of<LoginData>(context);
        return MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme(
              primary: const Color.fromARGB(255, 255, 82, 73),
              secondary: Color.fromARGB(255, 255, 186, 183),
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
          initialRoute: loginData.getCookie() == ""
              ? RouteManager.login
              : RouteManager.main,
          onGenerateRoute: RouteManager.generateRoute,
        );
      },
    );
  }
}
