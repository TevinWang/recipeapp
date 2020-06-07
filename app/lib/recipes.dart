/*
Created at the FTNE Hackathon on June 5-7, 2020.
================================================
This file manages the recipes shown after a specific store is clicked on. 
The recipes available for each store are retrieved from the Firebase database,
which stores recipes from Spoonacular's recipe and food API at https://spoonacular.com/food-api/.

Cards were created using the getflutter repository.
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:getflutter/getflutter.dart';

class Recipes extends StatefulWidget {
  @override
  _RecipesState createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  final databaseReference = Firestore.instance;
  final items = [];
  @override
  _RecipesState() {
    items.add(Title());

    databaseReference
        .collection("stores")
        .getDocuments()
        .then((QuerySnapshot snapshot) {snapshot.documents.forEach((f) {
            if (f.documentID == globals.store) {
              f.data['recipes'].forEach((r) {
                items.add(RecipeCard(r['image'],r['title']));
              });
            }
        setState(() => {});
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[],
        elevation: 0.0,
        title: Text("RECIPES"),
      ),
      body:
          _myListView(context),

    );
  }

  // Lists the recipes available
  Widget _myListView(BuildContext context) {
  
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

// Card displays information about each Recipe, including the name and a picture.
class RecipeCard extends StatelessWidget {
  var image;
  var logo;
  var name;
  var distance;
  RecipeCard(String image, String name) {
    this.image = image;
    this.name = name;
  }
  Widget build(BuildContext context) {
    return GFCard(
      boxFit: BoxFit.cover,
      imageOverlay: NetworkImage(image),
      elevation: 100,
      colorFilter: new ColorFilter.mode(
          Colors.black.withOpacity(0.50), BlendMode.darken),
      title: GFListTile(
        title: Text(name,
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: 'Helvetica Black')),
      ),
      buttonBar: GFButtonBar(
        spacing: 10,
        children: <Widget>[
          GFButton(
            onPressed: () {
              globals.store = name;
              Navigator.of(context).pushReplacementNamed('/test');
            },
            text: 'Details',
            size: GFSize.LARGE,
          ),
        ],
        direction: Axis.vertical,
        verticalDirection: VerticalDirection.up,
      ),
    );
  }
}

class Title extends StatelessWidget {
  final databaseReference = Firestore.instance;


  Widget build(BuildContext context) {
    //getDakta();
    return Container(
        margin: const EdgeInsets.only(top: 25.0, left: 25.0),
        child: Row(children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('Available Recipes',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'Helvetica Black')),         
              ]),
        ]));
  }
}
