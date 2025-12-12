// models/station.dart
class Station {
  final String id;
  final String name;
  final int capacity; // Puestos totales
  final double lat;
  final double lon;
  
  // Datos dinámicos (Status)
  int numBikesAvailable;
  int numDocksAvailable; // Anclajes libres
  int numEfitBikes; // Eléctricas
  int numFitBikes;  // Mecánicas
  bool isInstalled;
  bool isRenting;
  int lastReported; // Timestamp

  bool isFavorite; // Estado local

  Station({
    required this.id, required this.name, required this.capacity,
    required this.lat, required this.lon,
    this.numBikesAvailable = 0,
    this.numDocksAvailable = 0,
    this.numEfitBikes = 0,
    this.numFitBikes = 0,
    this.isInstalled = false,
    this.isRenting = false,
    this.lastReported = 0,
    this.isFavorite = false,
  });

  // Fábrica para datos estáticos (Station Information)
  factory Station.fromInfoJson(Map<String, dynamic> json) {
    return Station(
      id: json['station_id'],
      name: json['name'],
      capacity: json['capacity'] ?? 0,
      lat: json['lat'],
      lon: json['lon'],
    );
  }

  // Método para actualizar con datos dinámicos (Station Status)
  void updateStatus(Map<String, dynamic> json) {
    numBikesAvailable = json['num_bikes_available'];
    numDocksAvailable = json['num_docks_available'];
    lastReported = json['last_reported'];
    isInstalled = json['is_installed'] == 1;
    isRenting = json['is_renting'] == 1;

    // Lógica para tipos de bici (ignorar 'boost' según )
    final types = json['num_bikes_available_types'];
    if (types != null) {
      numEfitBikes = types['efit'] ?? 0; // Eléctrica
      numFitBikes = types['fit'] ?? 0;   // Mecánica
      // Boost se ignora
    }
  }
}