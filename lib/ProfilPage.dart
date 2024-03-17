import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:tp_emre/main.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Profil'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text('Aucune donnée utilisateur trouvée.'),
            );
          }

          Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Login: ${userData['Login']}'),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: passwordController..text = userData['Password'] ?? '',
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Mot de passe'),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: birthdayController..text = userData['Anniversaire'] ?? '',
                  decoration: InputDecoration(labelText: 'Anniversaire'),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: addressController..text = userData['Adresse'] ?? '',
                  decoration: InputDecoration(labelText: 'Adresse'),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: postalCodeController..text = userData['CodePostal']?.toString() ?? '',
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(labelText: 'Code Postal'),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: cityController..text = userData['Ville'] ?? '',
                  decoration: InputDecoration(labelText: 'Ville'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    saveUserProfile();
                  },
                  child: Text('Valider'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Se déconnecter et retourner à la page de login
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
                (route) => false,
              );                  },
                  child: Text('Se déconnecter'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<DocumentSnapshot> getUserProfile() async {
    return await FirebaseFirestore.instance.collection('Users_information').doc(Globals.userId).get();
  }

  void saveUserProfile() {
    FirebaseFirestore.instance.collection('Users_information').doc(Globals.userId).update({
      'Password': passwordController.text,
      'Anniversaire': birthdayController.text,
      'Adresse': addressController.text,
      'CodePostal': int.tryParse(postalCodeController.text) ?? 0,
      'Ville': cityController.text,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profil mis à jour avec succès'),
      ));
    });
  }
}
