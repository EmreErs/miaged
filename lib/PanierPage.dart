import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tp_emre/main.dart';

class PanierPage extends StatefulWidget {
  @override
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Panier'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: getPanierItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Votre panier est vide.'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data![index];
                    return Dismissible(
                      key: Key(document.id),
                      onDismissed: (direction) {
                        removeItemFromPanier(document.id);
                      },
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete, color: Colors.white),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20.0),
                      ),
                      child: PanierItemWidget(
                        titre: document['titre'],
                        lieu: document['lieu'],
                        image: document['image'],
                        prix: document['prix'],
                        onRemove: () {
                          removeItemFromPanier(document.id);
                        },
                      ),
                    );
                  },
                ),
              ),
              TotalGeneralWidget(items: snapshot.data!),
            ],
          );
        },
      ),
    );
  }

  Future<List<DocumentSnapshot>> getPanierItems() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('panier')
        .where('userId', isEqualTo: Globals.userId)
        .get();

    return querySnapshot.docs;
  }

  void removeItemFromPanier(String itemId) {
    FirebaseFirestore.instance.collection('panier').doc(itemId).delete();
  }
}

class PanierItemWidget extends StatelessWidget {
  final String titre;
  final String lieu;
  final String image;
  final int prix;
  final VoidCallback onRemove;

  PanierItemWidget({
    required this.titre,
    required this.lieu,
    required this.image,
    required this.prix,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(titre),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Lieu: $lieu'),
          Text('Prix: $prix €'),
        ],
      ),
      leading: Image.network(image, width: 100, height: 100, fit: BoxFit.cover),
      trailing: IconButton(
        icon: Icon(Icons.close),
        onPressed: onRemove,
      ),
    );
  }
}

class TotalGeneralWidget extends StatelessWidget {
  final List<DocumentSnapshot> items;

  TotalGeneralWidget({required this.items});

  @override
  Widget build(BuildContext context) {
    int total = items.fold(0, (sum, item) => sum + (item['prix'] as num).toInt());
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Text('Total général: $total €', style: TextStyle(fontSize: 18.0)),
    );
  }
}
