import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

import 'screens/entry.dart';
import 'screens/confirm.dart';
import 'screens/confirm_reset.dart';
import 'screens/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amp Awesome',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == '/confirm') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                ConfirmScreen(data: settings.arguments as LoginData),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }

        if (settings.name == '/confirm-reset') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                ConfirmResetScreen(data: settings.arguments as LoginData),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }

        if (settings.name == '/dashboard') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => DashboardScreen(),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }

        return MaterialPageRoute(builder: (_) => EntryScreen());
      },
    );
  }
}
