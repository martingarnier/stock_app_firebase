import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoiteProduit extends StatelessWidget{

  final DocumentSnapshot _infoProduit;

  BoiteProduit(this._infoProduit);

  @override
  Widget build(BuildContext context) {
    return GridTile(
        header: Text(_infoProduit['nomProduit'], style: Theme.of(context).textTheme.headline2,),
        child: Padding(
            padding: EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _infoProduit['descriptionProduit'],
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _infoProduit['quantiteProduit'],
                ),
              ],
            )
        ),
        footer: Padding(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Row(
            children: <Widget>[
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _alertChangerProduit(context);
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    onPressed: () => _alertVoirProduit(context)
                ),
              )
            ],
          ),
        )
    );
  }


  void _alertVoirProduit(BuildContext context){
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _infoProduit['nomProduit'],
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Quantité en stock: ${_infoProduit['quantiteProduit']}",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                    SingleChildScrollView(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(_infoProduit['descriptionProduit']),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Annuler"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    FlatButton(
                      child: Text("Supprimer"),
                      onPressed: () {
                        Navigator.pop(context);
                        Firestore.instance.collection('produits').document(_infoProduit.documentID).delete();
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  _alertChangerProduit(BuildContext context){

    String _nouveauNom = _infoProduit['nomProduit'];
    String _nouvelleDescription = _infoProduit['descriptionProduit'];
    String _nouvelleQuantite = _infoProduit['quantiteProduit'];

    TextEditingController _controllerNom = new TextEditingController(text: _infoProduit['nomProduit']);
    TextEditingController _controllerDescription = new TextEditingController(text: _infoProduit['descriptionProduit']);
    TextEditingController _controllerQuantite = new TextEditingController(text: _infoProduit['quantiteProduit']);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            Expanded(
              flex: 10,
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(hintText: "Nom"),
                    controller: _controllerNom,
                    onChanged: (value) => _nouveauNom = value,
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Description"),
                    controller: _controllerDescription,
                    onChanged: (value) => _nouvelleDescription = value,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Quantite"),
                    controller: _controllerQuantite,
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _nouvelleQuantite = value,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text("Annuler"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      if (_nouveauNom != "" && _nouvelleDescription != "" && _nouvelleQuantite != "") {
                        _updateProduit(_nouveauNom, _nouvelleDescription, _nouvelleQuantite);
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              ),
            )
          ]),
        );
      },
    );
  }

  Future<void> _updateProduit(String nom, String description, String quantite) async {
    try{
      Firestore.instance.collection('produits').document(_infoProduit.documentID).updateData({'nomProduit': nom, 'descriptionProduit': description, 'quantiteProduit': quantite});
    }
    catch (e){
      print(e);
    }
  }
}