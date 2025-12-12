// screens/station_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/station.dart';
import '../viewmodels/stations_viewmodel.dart';
import '../widgets/bike_quantity_indicator.dart';

class StationDetailScreen extends StatelessWidget {
  final Station station;

  const StationDetailScreen({Key? key, required this.station}) : super(key: key);

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre [cite: 55]
            Text(station.name, style: Theme.of(context).textTheme.headlineSmall),
            
            // Última actualización [cite: 56]
            Text("Actualizado: ${lastUpdate.hour}:${lastUpdate.minute}", 
                 style: TextStyle(color: Colors.grey)),
            
            const SizedBox(height: 30),

            // Tarjeta de estado
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Indicador Bicis Mecánicas (fit)
                    BikeQuantityIndicator(
                      quantity: station.numFitBikes,
                      isElectric: false,
                    ),
                    // Indicador Bicis Eléctricas (efit)
                    BikeQuantityIndicator(
                      quantity: station.numEfitBikes,
                      isElectric: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Información adicional (Anclajes, puestos rotos, etc) [cite: 58, 60]
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
          ],
        ),
      ),
    );
  }
}