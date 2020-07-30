import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_app_firebase/pages/page_choix.dart';
import 'package:stock_app_firebase/pages/page_stock/page_stock.dart';

class LandingPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.active){
          FirebaseUser user = snapshot.data;
          if(user == null){
            return PageChoix();
          }
          return PageStock();
        }
        else{
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}