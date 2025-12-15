class Station {
  final String id;
  final String name;
  final int capacity;
  final double lat;
  final double lon;
  
  int numBikesAvailable;
  int numDocksAvailable; 
  int numEfitBikes; 
  int numFitBikes; 
  bool isInstalled;
  bool isRenting;
  int lastReported;

  bool isFavorite;

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
    numBikesAvailable = json['num_bikes_available'] ?? 0;
    numDocksAvailable = json['num_docks_available'] ?? 0;
    lastReported = json['last_reported'] ?? 0;
    isInstalled = json['is_installed'] ?? false;
    isRenting = json['is_renting'] ?? false;

    numEfitBikes = 0;
    numFitBikes = 0;
    
    final vehicleTypes = json['vehicle_types_available'];
    
    if (vehicleTypes != null && vehicleTypes is List) {
      for (var typeInfo in vehicleTypes) {
        if (typeInfo is Map) {
          final typeId = (typeInfo['vehicle_type_id'] ?? '').toString().toUpperCase();
          final count = typeInfo['count'] ?? 0;
          
          if (typeId == 'FIT') {
            numFitBikes = count is int ? count : int.tryParse(count.toString()) ?? 0;
          } else if (typeId == 'EFIT') {
            numEfitBikes = count is int ? count : int.tryParse(count.toString()) ?? 0;
          }
          // BOOST se ignora ya que no hay en A Coruña
        }
      }
    } else {
      // Si no hay información de tipos, todas son mecánicas
      numFitBikes = numBikesAvailable;
      numEfitBikes = 0;
    }
  }
  
  bool get isVirtual => !isInstalled || !isRenting;
  
  bool get isActive => isInstalled && isRenting;
}