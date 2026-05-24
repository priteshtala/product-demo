import 'package:demo/bottom_nav_bar/bottom_nav_view.dart';
import 'package:demo/home/home_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      debugShowCheckedModeBanner: false,
      routes: route,
      initialRoute: "/",
    );
  }
}

Map<String, WidgetBuilder> route = {
  BottomNavView.routeName: (context)=> BottomNavView.builder(context),
  HomeView.routeName: (context) => HomeView.builder(context),

};
