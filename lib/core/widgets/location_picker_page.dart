import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final Completer<GoogleMapController> _controller = Completer();
  
  // Posición inicial por defecto (Lima, por si falla el GPS)
  static const CameraPosition _kDefaultLocation = CameraPosition(
    target: LatLng(-12.046374, -77.042793),
    zoom: 14.4746,
  );

  LatLng? _currentCenter; // Coordenada central del mapa
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // 1. Obtener ubicación actual
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _isLoading = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLoading = false);
        return;
      }
    }

    // Obtener posición
    Position position = await Geolocator.getCurrentPosition();
    
    // Mover cámara allí
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 16,
      ),
    ));
    
    setState(() {
      _currentCenter = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });
  }

  // 2. Al confirmar, obtener dirección y mostrar Modal
  void _confirmLocation() async {
    if (_currentCenter == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Geocodificación inversa (Coordenadas -> Dirección)
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentCenter!.latitude,
        _currentCenter!.longitude,
      );

      if (mounted) Navigator.pop(context); // Cerrar loading

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address = "${place.thoroughfare} ${place.subThoroughfare}, ${place.subLocality}";
        
        if (mounted) {
          _showAddressModal(address);
        }
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al obtener dirección: $e")),
      );
    }
  }

  // 3. Modal para completar datos
  void _showAddressModal(String initialAddress) {
    final addressCtrl = TextEditingController(text: initialAddress);
    final referenceCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Para que suba con el teclado
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Confirma tu ubicación", 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 15),
              
              TextField(
                controller: addressCtrl,
                decoration: const InputDecoration(
                  labelText: "Dirección",
                  prefixIcon: Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              
              TextField(
                controller: referenceCtrl,
                decoration: const InputDecoration(
                  labelText: "Referencia (Opcional)",
                  hintText: "Ej: Puerta negra, frente al parque...",
                  prefixIcon: Icon(Icons.comment_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // Retornar datos a la pantalla anterior
                    Navigator.pop(ctx); // Cierra modal
                    Navigator.pop(context, {
                      "address": addressCtrl.text,
                      "reference": referenceCtrl.text,
                    });
                  },
                  child: const Text("Guardar Dirección", style: TextStyle(fontSize: 16)),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kDefaultLocation,
            myLocationEnabled: true,
            myLocationButtonEnabled: false, // Lo haremos personalizado
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onCameraMove: (position) {
              // Actualizamos el centro mientras se mueve el mapa
              _currentCenter = position.target;
            },
          ),
          
          // PIN CENTRAL FIJO
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 30), // Ajuste visual para que la punta apunte al centro
              child: Icon(Icons.location_pin, size: 50, color: Colors.deepPurple),
            ),
          ),

          // Botón de "Mi Ubicación"
          Positioned(
            right: 20,
            bottom: 140,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location, color: Colors.black87),
              onPressed: _determinePosition,
            ),
          ),

          // Botón Confirmar
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: _confirmLocation,
              child: const Text("Confirmar Ubicación", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          
          // Botón atrás
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          )
        ],
      ),
    );
  }
}