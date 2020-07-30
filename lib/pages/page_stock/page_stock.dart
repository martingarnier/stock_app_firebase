import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_app_firebase/pages/page_inventaire/page_inventaire.dart';
import 'package:stock_app_firebase/pages/page_stock/liste_inventaire.dart';
import 'package:stock_app_firebase/pages/page_stock/page_profil.dart';

class PageStock extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => PageStockState();
}


class PageStockState extends State<PageStock>{

  int _pageSelectionnee = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        Navigator(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              settings: settings,
              builder: (context) {
                switch (settings.name){
                  case '/': return ListeInventaire();
                  case 'inventaire' : return PageInventaire(settings.arguments);
                }
                return Text("");
              },
            );
          },
        ),
        PageProfil()
      ][_pageSelectionnee],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              title: Text("Stock")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text("Profil")
          )
        ],
        currentIndex: _pageSelectionnee,
        onTap: (value) {
          setState(() {
            _pageSelectionnee = value;
          });
        },
        selectedItemColor: Colors.black,
      ),
    );
  }

}