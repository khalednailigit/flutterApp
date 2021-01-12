import 'package:flutter/material.dart';
import 'package:flutterapp/ui/singin/signin_provider.dart';
import 'package:flutterapp/ui/singin/signin_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider(
        create: (_) => SignInProvider(),
        child: SignInScreen(),
      ),
    );
  }
}
