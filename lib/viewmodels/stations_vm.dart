// viewmodels/stations_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/station.dart';

class StationsViewModel extends ChangeNotifier {
  List<Station> _stations = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Station> get stations => _stations;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // URLs 
  final String _infoUrl = 'https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl/station_information';
  final String _statusUrl = 'https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl/station_status';

  Future<void> fetchStations() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Llamamos a ambas APIs en paralelo
      final responses = await Future.wait([
        http.get(Uri.parse(_infoUrl)),
        http.get(Uri.parse(_statusUrl)),
      ]);

      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        final infoData = json.decode(responses[0].body)['data']['stations'] as List;
        final statusData = json.decode(responses[1].body)['data']['stations'] as List;

        // 1. Crear mapa de estaciones base
        Map<String, Station> stationMap = {};
        for (var s in infoData) {
          var station = Station.fromInfoJson(s);
          stationMap[station.id] = station;
        }

        // 2. Actualizar con status
        for (var s in statusData) {
          if (stationMap.containsKey(s['station_id'])) {
            stationMap[s['station_id']]!.updateStatus(s);
          }
        }

        _stations = stationMap.values.toList();
        
        // Aquí podrías cargar favoritos de SharedPreferences y marcar las stations correspondientes
      } else {
        _errorMessage = "Error al cargar datos de la API";
      }
    } catch (e) {
      _errorMessage = "Error de conexión: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavorite(String stationId) {
    final index = _stations.indexWhere((s) => s.id == stationId);
    if (index != -1) {
      _stations[index].isFavorite = !_stations[index].isFavorite;
      // Aquí guardarías la lista de IDs favoritos en SharedPreferences 
      notifyListeners();
    }
  }
}