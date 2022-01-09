// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:prayer_list/providers/checkmark_provider.dart';
import 'package:prayer_list/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'model/prayers.dart';

List<Prayer> prayers = [];
bool nerdyStats = false;
double borderRad = 15;

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Checkmark()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const title = "Prayer List";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: title),
      },
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    );
  }
}
