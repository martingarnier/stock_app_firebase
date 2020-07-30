import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_app_firebase/pages/page_inventaire/boite_produit.dart';

class GrilleProduit extends StatelessWidget{

  final String _idInventaire;

  GrilleProduit(this._idInventaire);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('produits').snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasError) return Text("Erreur: ${snapshot.error}");
        if(snapshot.connectionState == ConnectionState.waiting) return new Text("Chargement...");
        else{
          List<DocumentSnapshot> _liste = snapshot.data.documents.where((produit) => produit['idInventaire'] == _idInventaire).toList();
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8),
            itemCount: _liste.length,
            padding: EdgeInsets.all(10),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 10,
                    ),
                  ],
                ),
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
                child: BoiteProduit(_liste[index])
              );
            },
          );
        }
      },
    );
  }
}