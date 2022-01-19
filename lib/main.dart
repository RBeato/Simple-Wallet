import 'package:basic_wallet/splash_screen/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future main() async {
  await dotenv.load(fileName: ".env"); // get the private key
  runApp(ProviderScope(
      child: MyApp())); // For accessing riverpod variables globally
}

//TODO: review the contract balance deposit arithmatic
//TODO: Change Readme images

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
