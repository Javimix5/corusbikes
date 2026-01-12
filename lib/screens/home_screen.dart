import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/stations_vm.dart';
import 'station_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<StationsViewModel>(context, listen: false);
      if (vm.stations.isEmpty) {
        vm.fetchStations();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StationsViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "CorusBikes",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
            ),
            SizedBox(width: 8),
            Icon(Icons.pedal_bike, color: Colors.white),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(
              viewModel.showOnlyFavorites ? Icons.star : Icons.star_border,
              color: viewModel.showOnlyFavorites ? Colors.amber : null,
            ),
            tooltip: viewModel.showOnlyFavorites 
                ? 'Mostrar todas' 
                : 'Solo favoritas (${viewModel.favoritesCount})',
            onPressed: () => viewModel.toggleFavoritesFilter(),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Refrescar datos',
            onPressed: () => viewModel.refreshStations(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar estación...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: viewModel.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          viewModel.clearSearch();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) => viewModel.setSearchQuery(value),
            ),
          ),
          Expanded(
            child: viewModel.isLoading
                ? Center(child: CircularProgressIndicator())
                : viewModel.errorMessage.isNotEmpty
                    ? Center(child: Text(viewModel.errorMessage))
                    : viewModel.stations.isEmpty
                        ? Center(
                            child: Text(
                              viewModel.showOnlyFavorites
                                  ? 'No hay estaciones favoritas'
                                  : 'No se encontraron estaciones',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: viewModel.stations.length,
                            itemBuilder: (ctx, i) {
                              final station = viewModel.stations[i];
                              final isVirtual = station.isVirtual;                              
                              Color backgroundColor;
                              Color textColor;
                              
                              if (isVirtual) {
                                backgroundColor = Colors.grey.withOpacity(0.2);
                                textColor = Colors.grey[600]!;
                              } else if (station.numBikesAvailable == 0) {
                                backgroundColor = Colors.red.withOpacity(0.2);
                                textColor = Colors.red[700]!;
                              } else if (station.numBikesAvailable < 6) {
                                backgroundColor = Colors.amber.withOpacity(0.2);
                                textColor = Colors.amber[700]!;
                              } else {
                                backgroundColor = Colors.green.withOpacity(0.2);
                                textColor = Colors.green[700]!;
                              }
                              
                              return Opacity(
                                opacity: isVirtual ? 0.5 : 1.0,
                                child: ListTile(
                                  enabled: !isVirtual,
                                  title: Text(
                                    station.name,
                                    style: TextStyle(
                                      color: isVirtual ? Colors.grey : null,
                                    ),
                                  ),
                                  subtitle: Text(
                                    isVirtual
                                        ? "Estación no disponible"
                                        : "Bicis disponibles: ${station.numBikesAvailable} | "
                                          "Puestos libres: ${station.numDocksAvailable}",
                                    style: TextStyle(
                                      color: isVirtual ? Colors.grey : null,
                                    ),
                                  ),
                                  trailing: isVirtual 
                                      ? Icon(Icons.block, size: 16, color: Colors.grey)
                                      : Icon(Icons.arrow_forward_ios, size: 16),
                                  leading: CircleAvatar(
                                    backgroundColor: backgroundColor,
                                    child: isVirtual
                                        ? Icon(Icons.close, color: textColor)
                                        : Text(
                                            '${station.numBikesAvailable}',
                                            style: TextStyle(
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                  onTap: isVirtual ? null : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => StationDetailScreen(station: station),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}