import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tp_emre/main.dart';

class ActivitiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activités'),
      ),
      body: Column(
        children: [
          // La liste déroulante des catégories peut être ajoutée ici si nécessaire
          // _buildActivityDropdown(),
          // Liste des activités
          Expanded(
            child: _buildActivitiesList(context),
          ),
        ],
      ),

    );
  }

  Widget _buildActivitiesList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('activités').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot document = snapshot.data!.docs[index];
            String titre = document['titre'];
            String lieu = document['lieux'];
            String image = document['image'];
            int prix = document['prix'];

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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityDetailsPage(
                      titre: titre,
                      lieu: lieu,
                      image: image,
                      prix: prix,
                      categorie: document['categorie'], // Assurez-vous que votre document Firestore a une clé 'categorie'
                      maxPlace: document['max_place'], // Assurez-vous que votre document Firestore a une clé 'max_place'
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class ActivityDetailsPage extends StatelessWidget {
  final String titre;
  final String lieu;
  final String image;
  final int prix;
  final String categorie;
  final int maxPlace;

  ActivityDetailsPage({
    required this.titre,
    required this.lieu,
    required this.image,
    required this.prix,
    required this.categorie,
    required this.maxPlace,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'activité'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(image, width: double.infinity, height: 200, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Titre: $titre', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Lieu: $lieu'),
                Text('Prix: $prix €'),
                Text('Catégorie1: $categorie'),
                Text('Max Places: $maxPlace'),
                ElevatedButton(
                  onPressed: () {
                    addPanier(context);
                  },
                  child: Text('Ajouter au panier'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addPanier(BuildContext context) {
    FirebaseFirestore.instance.collection('panier').add({
      'titre': titre,
      'lieu': lieu,
      'image': image,
      'prix': prix,
      'categorie': categorie,
      'maxPlace': maxPlace,
      'userId': Globals.userId, 
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Activité ajoutée au panier'),
      ));
    });
  }}
