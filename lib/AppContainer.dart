import 'package:flutter/material.dart';
import 'ActivitiesPage.dart';
import 'PanierPage.dart';
import 'ProfilPage.dart';
import 'BottomNavigatorBar.dart';

class AppContainer extends StatefulWidget {
  @override
  _AppContainerState createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildPage() {
    switch (_currentIndex) {
      case 0:
        return ActivitiesPage();
      case 1:
        return PanierPage();
      case 2:
        return ProfilPage();
      default:
        return ActivitiesPage();
    }
  }
}
