import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationsPage extends StatefulWidget {
  @override
  _LocationsPageState createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  late GoogleMapController mapController;

  // Coordenadas iniciais (ajuste conforme necessário)
  final LatLng _initialPosition = LatLng(-23.5505, -46.6333);

  // Lista de markers
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _addMarkers();
  }

  // Função para adicionar markers
  void _addMarkers() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('1'),
          position: LatLng(-23.5505, -46.6333),
          infoWindow: InfoWindow(
            title: 'Estabelecimento 1',
            snippet: 'Informações sobre o Estabelecimento 1',
            onTap: () {
              _showEstablishmentInfo(context, 'Estabelecimento 1', 'Informações detalhadas sobre o Estabelecimento 1.');
            },
          ),
        ),
      );

      _markers.add(
        Marker(
          markerId: MarkerId('2'),
          position: LatLng(-23.5515, -46.6343),
          infoWindow: InfoWindow(
            title: 'Estabelecimento 2',
            snippet: 'Informações sobre o Estabelecimento 2',
            onTap: () {
              _showEstablishmentInfo(context, 'Estabelecimento 2', 'Informações detalhadas sobre o Estabelecimento 2.');
            },
          ),
        ),
      );
    });
  }

  // Função para mostrar informações do estabelecimento
  void _showEstablishmentInfo(BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              child: Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Locais')),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 12.0,
        ),
        markers: _markers,
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 4),
    );
  }
}
