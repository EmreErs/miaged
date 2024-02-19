import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tp_emre/ActivitiesPage.dart';
import 'package:tp_emre/AppContainer.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Globals {
  static String userId = ''; // Variable globale pour stocker l'ID de l'utilisateur
}

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nom de l\'application'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: loginController,
              decoration: InputDecoration(labelText: 'Login'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _handleLogin(context);
              },
              child: Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context) async {
    try {
      // Recherchez l'utilisateur dans la collection Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users_information')
          .where('Login', isEqualTo: loginController.text)
          .where('Password', isEqualTo: passwordController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Utilisateur trouvé, stocker l'ID dans la variable globale
        Globals.userId = querySnapshot.docs[0].id;

        // Rediriger vers la page suivante
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AppContainer()),
        );
      } else {
        // Utilisateur non trouvé, afficher le message dans la console
        _showErrorSnackBar(context, 'Utilisateur non trouvé');
      }
    } catch (e) {
      // Gérer les erreurs
      print('Erreur: $e');
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
