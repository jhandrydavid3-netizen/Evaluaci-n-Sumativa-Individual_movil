
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// Coordenadas fijas del campus UIDE Loja (referencia para el feature).
const double campusLat = -4.0079;
const double campusLng = -79.2113;

class UbicacionScreen extends StatefulWidget {
  const UbicacionScreen({super.key});

  @override
  State<UbicacionScreen> createState() => _UbicacionScreenState();
}

class _UbicacionScreenState extends State<UbicacionScreen> {
  Position? _posicionActual;
  StreamSubscription<Position>? _subscription;

  @override
  void initState() {
    super.initState();
    _iniciarSeguimiento();
  }

  Future<void> _iniciarSeguimiento() async {
    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) return;
    }

    _subscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position posicion) {
      setState(() {
        _posicionActual = posicion;
      });
      // ignore: avoid_print
      print('Posición recibida: ${posicion.latitude}, ${posicion.longitude}');
    });
  }

  @override
  void dispose() {
    // Nota del autor: fallaba porque al salir de esta pantalla el
    // StreamSubscription del GPS no se cancelaba, causando un memory leak.
    // Agregué _subscription?.cancel() para detener el stream al salir.
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi ubicación')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _posicionActual == null
                ? const Text('Obteniendo ubicación...')
                : Text(
                    'Lat: ${_posicionActual!.latitude.toStringAsFixed(5)}\n'
                    'Lng: ${_posicionActual!.longitude.toStringAsFixed(5)}',
                    style: const TextStyle(fontSize: 16),
                  ),
            const SizedBox(height: 24),
            // Nota del autor: implemento el cálculo de distancia entre la
            // posición actual y el campus UIDE usando Geolocator.distanceBetween().
            // Si es menor a 500m muestro mensaje verde, si no, muestro la distancia.
            if (_posicionActual != null)
              Builder(builder: (context) {
                final distancia = Geolocator.distanceBetween(
                  _posicionActual!.latitude,
                  _posicionActual!.longitude,
                  campusLat,
                  campusLng,
                );
                if (distancia < 500) {
                  return Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        'Estás cerca del campus UIDE (${distancia.toStringAsFixed(0)} m)',
                        style: const TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      const Icon(Icons.location_off, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        'Estás a ${(distancia / 1000).toStringAsFixed(2)} km del campus UIDE',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  );
                }
              })
            else
              const Text('Obteniendo distancia al campus...'),
          ],
        ),
      ),
    );
  }
}
