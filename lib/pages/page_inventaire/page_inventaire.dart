import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_app_firebase/pages/page_inventaire/grille_produit.dart';

class PageInventaire extends StatelessWidget{

  final String _idInventaire;

  PageInventaire(this._idInventaire);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: StreamBuilder(
              stream: Firestore.instance.collection('inventaires').document(_idInventaire).snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasError && snapshot.hasData){
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Text(snapshot.data['nomInventaire'], style: Theme.of(context).textTheme.headline1,textAlign: TextAlign.center,),
                        Text(snapshot.data['descriptionInventaire'], textAlign: TextAlign.center,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _alertUpdateInventaire(context, snapshot.data['nomInventaire'], snapshot.data['descriptionInventaire'])
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _alertSupprimerInventaire(context)
                            )
                          ],
                        )
                      ],
                    ),
                    width: MediaQuery.of(context).size.width,
                  );
                }
                return Text("");
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 130),
            child: GrilleProduit(_idInventaire),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _alertAjouterProduit(context),
      ),
    );
  }

  void _alertUpdateInventaire(BuildContext context, String nom, String description){

    String _nouveauNom = nom;
    String _nouvelleDescription = description;

    TextEditingController _controllerNom = new TextEditingController(text: nom);
    TextEditingController _controllerDescription = new TextEditingController(text: description);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text(
                "Ajouter un inventaire",
                style: Theme.of(context).textTheme.headline2,
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: "Nom"
                ),
                controller: _controllerNom,
                onChanged: (value) => _nouveauNom = value,
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: "Description"
                ),
                controller: _controllerDescription,
                onChanged: (value) => _nouvelleDescription = value,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text("Annuler"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      if(_nouveauNom != "" && _nouvelleDescription != ""){
                        _updateInventaire(_nouveauNom, _nouvelleDescription);
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateInventaire(String nom, String description) async {
    try{
      Firestore.instance.collection('inventaires').document(_idInventaire).updateData({'nomInventaire': nom, 'descriptionInventaire': description});
    }
    catch (e){
      print(e);
    }
  }

  void _alertAjouterProduit(BuildContext context){

    String _nom = "";
    String _description = "";
    String _quantite = "";

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text(
                  "Ajouter un produit",
                style: Theme.of(context).textTheme.headline2,
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: "Nom"
                ),
                onChanged: (value) => _nom = value,
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: "Description"
                ),
                onChanged: (value) => _description = value,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: "Quantite"
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _quantite = value,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text("Annuler"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      if(_nom != "" && _description != "" && _quantite != ""){
                        _ajouterProduit(_nom, _description, _quantite);
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _ajouterProduit(String nom, String description, String quantite) async {
    try{
      var user = await FirebaseAuth.instance.currentUser();
      Firestore.instance.collection('produits').document().setData({'idInventaire': _idInventaire, 'idUtilisateur':user.uid, 'nomProduit': nom, 'descriptionProduit': description, 'quantiteProduit': quantite});
    }
    catch (e){
      print(e);
    }
  }

  void _alertSupprimerInventaire(BuildContext context){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Supprimer l'inventaire ?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Annuler"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("Oui"),
              onPressed: () async {
                Navigator.pop(context);
                Navigator.pop(context);
                await Firestore.instance.collection('inventaires').document(_idInventaire).delete();
              },
            )
          ],
        );
      },
    );
  }
}