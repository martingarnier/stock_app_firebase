import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_app_firebase/pages/page_connexion.dart';
import 'package:stock_app_firebase/pages/page_inscription.dart';

class PageChoix extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

        ),
        body: Center(
          child: Row(
            children: <Widget>[
             Expanded(
               child: FlatButton(
                 child: Text("S'inscrire"),
                 onPressed: () => Navigator.of(context).push(
                   MaterialPageRoute(
                       builder: (context) => PageInscription()
                   ),
                 )
               ),
             ),
              Expanded(
                child: FlatButton(
                  child: Text("Se connecter"),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => PageConnexion()
                    ),
                  )
                ),
              )
            ],
          ),
        )
    );
  }
}