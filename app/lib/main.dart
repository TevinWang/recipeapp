/*
Created at the FTNE Hackathon on June 5-7, 2020.
================================================
This is the main class for the Recipe app UI.
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'login_signup.dart';
import 'recipes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

final FirebaseAuth auth = FirebaseAuth.instance;


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'GO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          hintColor: Color.fromARGB(255, 0,0,0),
          primaryColor: Color.fromARGB(255,0, 0, 0),
          fontFamily: "Montserrat",
          canvasColor: Colors.transparent),
      home: new StreamBuilder(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          //if (snapshot.hasData) {
          //  return Home();
          //}
          return LoginRegister();
        },
      ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new Home(),
        '/login': (BuildContext context) => new LoginRegister(),
        '/recipes': (BuildContext context) => new Recipes(),
      },
    );
  }
}