import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/station.dart';

class StationsService {
  // URLs de la API
  final String _infoUrl = 'https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl/station_information';
  final String _statusUrl = 'https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl/station_status';

  // Cache
  List<Station>? _cachedStations;
  DateTime? _lastFetch;
  final Duration _cacheDuration = Duration(minutes: 5); // Cache por 5 minutos
  
  final http.Client client;

  StationsService({http.Client? client}) : client = client ?? http.Client();

  /// Obtiene la lista completa de estaciones con información estática y dinámica
  /// Usa caché si los datos tienen menos de 5 minutos
  Future<List<Station>> fetchStations({bool forceRefresh = false}) async {
    // Verificar si hay datos en caché y no ha expirado
    if (!forceRefresh && 
        _cachedStations != null && 
        _lastFetch != null && 
        DateTime.now().difference(_lastFetch!) < _cacheDuration) {
      return _cachedStations!;
    }

    final stations = await _fetchStationsFromApi();
    
    // Guardar en caché
    _cachedStations = stations;
    _lastFetch = DateTime.now();
    
    return stations;
  }

  /// Limpia el caché forzando una nueva carga en la próxima petición
  void clearCache() {
    _cachedStations = null;
    _lastFetch = null;
  }

  Future<List<Station>> _fetchStationsFromApi() async {
    // Llamamos a ambas APIs en paralelo
    final responses = await Future.wait([
      client.get(Uri.parse(_infoUrl)),
      client.get(Uri.parse(_statusUrl)),
    ]);

    if (responses[0].statusCode != 200 || responses[1].statusCode != 200) {
      throw Exception('Error al cargar datos de la API');
    }

    final infoData = json.decode(responses[0].body)['data']['stations'] as List;
    final statusData = json.decode(responses[1].body)['data']['stations'] as List;

    // 1. Crear mapa de estaciones base con información estática
    Map<String, Station> stationMap = {};
    for (var s in infoData) {
      var station = Station.fromInfoJson(s);
      stationMap[station.id] = station;
    }

    // 2. Actualizar con status dinámico
    for (var s in statusData) {
      if (stationMap.containsKey(s['station_id'])) {
        stationMap[s['station_id']]!.updateStatus(s);
      }
    }

    return stationMap.values.toList();
  }

  /// Obtiene solo la información estática de las estaciones
  Future<List<Station>> fetchStationInformation() async {
    final response = await http.get(Uri.parse(_infoUrl));

    if (response.statusCode != 200) {
      throw Exception('Error al cargar información de estaciones');
    }

    final data = json.decode(response.body)['data']['stations'] as List;
    return data.map((s) => Station.fromInfoJson(s)).toList();
  }

  /// Obtiene solo el estado dinámico de las estaciones
  Future<List<Map<String, dynamic>>> fetchStationStatus() async {
    final response = await http.get(Uri.parse(_statusUrl));

    if (response.statusCode != 200) {
      throw Exception('Error al cargar estado de estaciones');
    }

    final data = json.decode(response.body)['data']['stations'] as List;
    return data.cast<Map<String, dynamic>>();
  }
}
