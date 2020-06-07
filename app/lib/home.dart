/*
Created at the FTNE Hackathon on June 5-7, 2020.
================================================
This file creates the homepage UI of the Recipe app, which displays after login/registration, listing all nearby stores.

Cards were created using the getflutter repository.
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'main.dart';
import 'package:getflutter/getflutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final databaseReference = Firestore.instance;
  final items = [];
  @override
  _HomeState() {
    items.add(WelcomeText());
    final distances = [5.6,9.9,12.0,12.1];
    print(1);
    databaseReference
        .collection("stores")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        if (f.data['imageUrl'] != null) {
          items.add(StoreCard(
              f.data['imageUrl'], f.data['logoUrl'], f.documentID, distances[items.length-1]));
          setState(() => {});
      }
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[],
        elevation: 0.0,
        title: Text("HOME"),
      ),
      body:
          _myListView(context),

    );
  }

  // This lists out the different stores as a list.
  Widget _myListView(BuildContext context) {
    final titles = [
      'bike',
    ];

    final icons = [
      Icons.directions_bike,
    ];

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: item,
        );
      },
    );
  }
}

// Each storecard displays one stay with its information.
class StoreCard extends StatelessWidget {
  var image;
  var logo;
  var name;
  var distance;
  StoreCard(String image, String logo, String name, double distance) {
    this.image = image;
    this.logo = logo;
    this.name = name;
    this.distance = distance;
  }
  Widget build(BuildContext context) {
    return GFCard(
      boxFit: BoxFit.cover,
      imageOverlay: NetworkImage(image),
      elevation: 100,
      colorFilter: new ColorFilter.mode(
          Colors.black.withOpacity(0.50), BlendMode.darken),
      title: GFListTile(
        avatar: GFAvatar(backgroundImage: NetworkImage(logo)),
        title: Text(name,
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: 'Helvetica Black')),
        subTitle: Text(distance.toString() + ' miles away',
            style: TextStyle(color: Colors.white)),
      ),
      buttonBar: GFButtonBar(
        spacing: 10,
        children: <Widget>[
          GFButton(
            onPressed: () {
              globals.store = name;
              Navigator.of(context).pushReplacementNamed('/recipes');
            },
            text: 'See Available Recipes',
            size: GFSize.LARGE,
          ),
        ],
        direction: Axis.vertical,
        verticalDirection: VerticalDirection.up,
      ),
    );
  }
}

// The WelcomeText greets the user through "Welcome, [user]"
class WelcomeText extends StatelessWidget {
  final databaseReference = Firestore.instance;

  Widget build(BuildContext context) {
    //getDakta();
    return Container(
        margin: const EdgeInsets.only(top: 25.0, left: 25.0),
        child: Row(children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Welcome,',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'Helvetica Black')),
                Text(globals.username,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 50,
                        fontFamily: 'Helvetica Black'))
              ]),
        ]));
  }
}