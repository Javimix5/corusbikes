import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:corusbikes/services/stations_service.dart';

void main() {

  // Test de integración bottom-up para StationsService y Station model
  test('Bottom-up integration: StationsService + Station model produce expected objects', () async {
    final mockClient = MockClient((request) async {
      if (request.url.path.contains('station_information')) {
        return http.Response(jsonEncode({
          'data': {
            'stations': [
              {'station_id': '1', 'name': 'Plaza', 'capacity': 12, 'lat': 0.0, 'lon': 0.0}
            ]
          }
        }), 200);
      }

      return http.Response(jsonEncode({
        'data': {
          'stations': [
            {'station_id': '1', 'num_bikes_available': 4, 'num_docks_available': 8, 'is_installed': true, 'is_renting': true}
          ]
        }
      }), 200);
    });

    final service = StationsService(client: mockClient);
    final stations = await service.fetchStations();

    expect(stations, isNotEmpty);
    final s = stations.firstWhere((x) => x.id == '1');
    expect(s.name, 'Plaza');
    expect(s.numBikesAvailable, 4);
    expect(s.isActive, true);
  });
}
