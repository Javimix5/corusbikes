import 'package:flutter_test/flutter_test.dart';
import 'package:corusbikes/viewmodels/stations_vm.dart';
import 'package:corusbikes/services/stations_service.dart';
import 'package:corusbikes/models/station.dart';

class FakeStationsService extends StationsService {
  final List<Station> _stations;
  FakeStationsService(this._stations) : super();

  @override
  Future<List<Station>> fetchStations({bool forceRefresh = false}) async {
    return _stations;
  }
}

void main() {
  // Test de integración top-down para StationsViewModel y StationsService
  test('Top-down integration: ViewModel uses service and updates state', () async {
    final fakeStations = [
      Station(id: '1', name: 'Prueba', capacity: 5, lat: 0.0, lon: 0.0),
    ];

    final vm = StationsViewModel(stationsService: FakeStationsService(fakeStations));

    await vm.fetchStations();
    expect(vm.stations.length, 1);
    expect(vm.stations.first.name, 'Prueba');
  });
}
