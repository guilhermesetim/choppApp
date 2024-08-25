import 'package:flutter/material.dart';
import '../views/buy_credits_page.dart';
import '../views/consumption_history_page.dart';
import '../views/locations_page.dart';
import '../views/home_page.dart';
import '../views/list_beer.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  BottomNavBar({required this.currentIndex});

  void onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()));
        break;
      // case 1:
      //   Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(builder: (context) => EditProfilePage()));
      //   break;
      case 1:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => BuyCreditsPage()));
        break;
      case 2:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ConsumptionHistoryPage(userId: '1',)));
        break;
      case 3:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CervejasPage()));
        break;
      case 4:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LocationsPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => onTabTapped(context, index),
      selectedItemColor: Colors.blue, // Cor dos ícones selecionados
      unselectedItemColor: Colors.grey, // Cor dos ícones não selecionados
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        //BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'Créditos'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Histórico'),
        BottomNavigationBarItem(icon: Icon(Icons.local_drink), label: 'Cervejas'),
        BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Locais'),
      ],
    );
  }
}
