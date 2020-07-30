import 'package:flutter/material.dart';
import 'package:stock_app_firebase/pages/landing_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,

        primaryColor: const Color(0xfff70c36), // These are the color of the ISATI
        primarySwatch: Colors.grey,
        accentColor: const Color(0xfff70c36),
        cardColor: Colors.white,

        appBarTheme: const AppBarTheme(
          color:  Colors.white,
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.black87),
          elevation: 0,
        ),

        // fontFamily: "Futura Light",
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 48.0, fontWeight: FontWeight.w800, fontFamily: "Futura Light", color: Colors.black87),
          headline2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300, fontFamily: "Futura Light", color: Colors.black87),
          // subtitle1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800, color: Colors.black87),
          // bodyText1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.black87),
          // bodyText2: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black87),
          // button: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700,)
        ),

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LandingPage(),
    );
  }
}