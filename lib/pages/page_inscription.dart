import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageInscription extends StatelessWidget{

  Future<void> _inscription(BuildContext context) async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _motDePasse).then((value) {
        if(value.user != null) {
          Firestore.instance.collection('utilisateurs').document(value.user.uid).setData({'nomUtilsateur': _nom, 'prenomUtilsateur': _prenom});
          Navigator.pop(context);
        }
      });
    }
    catch (e){
      print(e);
    }
  }

  String _email = "";
  String _motDePasse = "";
  String _prenom = "";
  String _nom = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: StreamBuilder<FirebaseUser>(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.active){
              return Column(
                children: <Widget>[
                  Container(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Email"
                      ),
                      onChanged: (value) => _email = value,
                    ),
                  ),
                  Container(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Prenom"
                      ),
                      onChanged: (value) => _prenom = value,
                    ),
                  ),
                  Container(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Nom"
                      ),
                      onChanged: (value) => _motDePasse = value,
                    ),
                  ),
                  Container(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Mot de passe"
                      ),
                      onChanged: (value) => _motDePasse = value,
                    ),
                  ),
                  Container(
                      child: FlatButton(
                        child: Text("S'inscrire"),
                        onPressed: () => _inscription(context),
                      )
                  )
                ],
              );
            }
            else{
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        )
      )
    );
  }
}