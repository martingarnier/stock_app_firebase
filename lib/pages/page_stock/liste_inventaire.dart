import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListeInventaire extends StatelessWidget{

  FirebaseUser _user;

  ListeInventaire(){
    getUser();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('inventaires').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasError) return Text("Erreur: ${snapshot.error}");
          if(snapshot.connectionState == ConnectionState.waiting) return Center(child: Text("Chargement...", style: Theme.of(context).textTheme.headline1,));
          else{
            List<DocumentSnapshot> _liste = snapshot.data.documents.where((inventaire) => inventaire['idUtilisateur'] == _user.uid).toList();
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: Firestore.instance.collection('utilisateurs').document(_user.uid).snapshots(),
                    builder: (context, snapshot) {
                      String _text;
                      if(snapshot.hasData){
                        _text = "Bienvenue ${snapshot.data['prenomUtilisateur']}";
                      }
                      else{
                        _text = "Bienvenue";
                      }
                      return Text(_text, style: Theme.of(context).textTheme.headline1);
                    },
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: ListView(
                    children:_liste.map((inventaire) {
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
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: ListTile(
                          trailing: Container(
                            child: Icon(Icons.edit),
                          ),
                          title: Text(
                            inventaire['nomInventaire'],
                            style: Theme.of(context).textTheme.headline2,
                          ),
                          subtitle: Text(
                            inventaire['descriptionInventaire'],
                          ),
                          /*
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => PageInventaire(inventaire.documentID)
                            ),
                          )*/
                          onTap: () => Navigator.pushNamed(context, 'inventaire', arguments: inventaire.documentID),
                        ),
                      );
                    }).toList(),
                  ),
                )
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _alertAjouterInventaire(context)
      ),
    );
  }

  Future<void> getUser() async {
    _user = await FirebaseAuth.instance.currentUser();
  }

  void _alertAjouterInventaire(BuildContext context){

    String _nom = "";
    String _description = "";

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
                      if(_nom != "" && _description != ""){
                        _ajouterInventaire(_nom, _description);
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

  Future<void> _ajouterInventaire(String nom, String description) async {
    try{
      var user = await FirebaseAuth.instance.currentUser();
      var idInventaire = Firestore.instance.collection('inventaires').document().documentID;
      Firestore.instance.collection('inventaires').document().setData({'idInventaire': idInventaire, 'idUtilisateur':user.uid, 'nomInventaire': nom, 'descriptionInventaire': description});
    }
    catch (e){
      print(e);
    }
  }

}