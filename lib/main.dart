import 'package:flutter/material.dart';
import 'home_page.dart';
import 'game_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(primaryColor: Colors.white),
      initialRoute: '/',
      routes: <String,WidgetBuilder>{
        '/':(context)=>homePage(),
        '/singleplayer':(context)=>gamePage(withComputer: true,),
        '/multiplayer':(context)=>gamePage(withComputer: false,),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}