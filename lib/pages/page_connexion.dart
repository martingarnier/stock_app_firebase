import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageConnexion extends StatelessWidget{

  Future<void> _connexion(BuildContext context) async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _motDePasse).then((value) {
        if(value.user != null) Navigator.pop(context);
      });
    }
    catch (e){
      print(e);
    }
  }

  String _email = "";
  String _motDePasse = "";

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
                            hintText: "Mot de passe"
                        ),
                        onChanged: (value) => _motDePasse = value,
                      ),
                    ),
                    Container(
                        child: FlatButton(
                          child: Text("Se connecter"),
                          onPressed: () => _connexion(context),
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