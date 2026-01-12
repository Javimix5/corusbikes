import 'package:flutter_test/flutter_test.dart';
import 'package:corusbikes/viewmodels/stations_vm.dart';
import 'package:corusbikes/models/station.dart';

void main() {
  //Grupo de tests para StationsViewModel
  group('StationsViewModel - search and favorites', () {

    // Test para verificar que searchQuery filtra las estaciones por nombre (case-insensitive)
    test('searchQuery filters stations by name (case-insensitive)', () {
      final vm = StationsViewModel();
      vm.setStations([
        Station(id: '1', name: 'Centro', capacity: 10, lat: 0.0, lon: 0.0),
        Station(id: '2', name: 'Periferia', capacity: 8, lat: 0.0, lon: 0.0),
      ]);

      vm.setSearchQuery('cen');
      final results = vm.stations;
      expect(results.length, 1);
      expect(results.first.name, contains('Centro'));
    });

// Test para verificar que toggleFavorite actualiza correctamente el estado de favorito y el contador
    test('toggleFavorite updates station and favoritesCount', () {
      final vm = StationsViewModel();
      final s = Station(id: '1', name: 'Centro', capacity: 10, lat: 0.0, lon: 0.0);
      vm.setStations([s]);

      expect(vm.favoritesCount, 0);
      vm.toggleFavorite('1');
      expect(vm.favoritesCount, 1);
      vm.toggleFavorite('1');
      expect(vm.favoritesCount, 0);
    });
  });
}
