import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/station.dart';
import '../viewmodels/stations_vm.dart';
import '../widgets/bici_indicador.dart';

class StationDetailScreen extends StatelessWidget {
  final Station station;

  const StationDetailScreen({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StationsViewModel>(context);
    final lastUpdate = DateTime.fromMillisecondsSinceEpoch(station.lastReported * 1000);

    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle de Estación"),
        actions: [
          IconButton(
            icon: Icon(
              station.isFavorite ? Icons.star : Icons.star_border,
              color: station.isFavorite ? Colors.amber : null,
            ),
            onPressed: () => viewModel.toggleFavorite(station.id), // 
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(station.name, style: Theme.of(context).textTheme.headlineSmall),
              
              Text("Actualizado: ${lastUpdate.hour}:${lastUpdate.minute.toString().padLeft(2, '0')}", 
                   style: TextStyle(color: Colors.grey)),
              
              const SizedBox(height: 20),

              // Mapa de ubicación
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(station.lat, station.lon),
                      initialZoom: 16.0,
                      interactionOptions: InteractionOptions(
                        flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.corusbikes.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(station.lat, station.lon),
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BikeQuantityIndicator(
                        quantity: station.numFitBikes,
                        isElectric: false,
                      ),
                      BikeQuantityIndicator(
                        quantity: station.numEfitBikes,
                        isElectric: true,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ListTile(
                leading: Icon(Icons.local_parking),
                title: Text("Puestos Libres"),
                trailing: Text("${station.numDocksAvailable}", 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: Icon(Icons.format_list_numbered),
                title: Text("Capacidad Total"),
                trailing: Text("${station.capacity}"),
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text("Coordenadas"),
                subtitle: Text("${station.lat.toStringAsFixed(6)}, ${station.lon.toStringAsFixed(6)}"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}