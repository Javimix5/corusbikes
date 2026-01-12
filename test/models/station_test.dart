import 'package:flutter_test/flutter_test.dart';
import 'package:corusbikes/models/station.dart';

void main() {
  //Grupo de tests para Station model
  group('Station model', () {

    // Test para verificar que updateStatus actualiza correctamente los contadores de bicicletas
    test('updateStatus parses vehicle types and sets counts', () {
      final station = Station(id: '1', name: 'A', capacity: 10, lat: 0.0, lon: 0.0);
      station.updateStatus({
        'num_bikes_available': 3,
        'num_docks_available': 7,
        'last_reported': 123,
        'is_installed': true,
        'is_renting': true,
        'vehicle_types_available': [
          {'vehicle_type_id': 'FIT', 'count': 2},
          {'vehicle_type_id': 'EFIT', 'count': 1},
        ],
      });

      expect(station.numBikesAvailable, 3);
      expect(station.numFitBikes, 2);
      expect(station.numEfitBikes, 1);
      expect(station.isVirtual, false);
      expect(station.isActive, true);
    });

    // Test para verificar que isVirtual es true cuando la estación no está instalada o no está alquilando
    test('isVirtual when not installed or not renting', () {
      final s = Station(
        id: '2', name: 'B', capacity: 5, lat: 0.0, lon: 0.0,
        isInstalled: false, isRenting: false,
      );
      expect(s.isVirtual, true);
    });
  });
}
