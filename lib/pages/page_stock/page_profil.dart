import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageProfil extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: StreamBuilder<FirebaseUser>(
          stream: getUser().asStream(),
          builder: (context, snapshotUser) {
            if (snapshotUser.hasData) {
              return StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance
                    .collection('utilisateurs')
                    .document(snapshotUser.data.uid)
                    .snapshots(),
                builder: (context, snapshotDocument) {
                  if (snapshotDocument.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                                snapshotUser.data.email,
                                style: Theme.of(context).textTheme.headline2
                            ),
                            Text(
                              "${snapshotDocument.data['prenomUtilisateur']} ${snapshotDocument.data['nomUtilisateur']}",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ],
                        ),
                        FlatButton(
                          child: Text("Déconnexion"),
                          onPressed: () => _deconnexion(),
                        )
                      ],
                    );
                  }
                  return Center(
                      child: Text(
                    "Chargement...",
                    style: Theme.of(context).textTheme.headline1,
                  ));
                },
              );
            }
            return Center(
                child: Text(
              "Chargement...",
              style: Theme.of(context).textTheme.headline1,
            ));
          },
        ));
  }

  Future<FirebaseUser> getUser() async {
    return await FirebaseAuth.instance.currentUser();
  }

  Future<void> _deconnexion() async{
    try{
      await FirebaseAuth.instance.signOut();
    }
    catch (e){
      print(e);
    }
  }
}