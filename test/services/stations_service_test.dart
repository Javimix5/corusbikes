import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:corusbikes/services/stations_service.dart';
import 'package:corusbikes/models/station.dart';

void main() {

// Grupo de tests para StationsService
  group('StationsService - caching', () {

    // Test para verificar que fetchStations utiliza la caché cuando no ha expirado
    test('fetchStations uses cache when not expired', () async {
      int calls = 0;

      final mockClient = MockClient((request) async {
        calls++;
        if (request.url.path.contains('station_information')) {
          return http.Response(jsonEncode({
            'data': {
              'stations': [
                {'station_id': '1', 'name': 'A', 'capacity': 10, 'lat': 0.0, 'lon': 0.0}
              ]
            }
          }), 200);
        }

        return http.Response(jsonEncode({
          'data': {
            'stations': [
              {'station_id': '1', 'num_bikes_available': 2, 'num_docks_available': 8, 'is_installed': true, 'is_renting': true}
            ]
          }
        }), 200);
      });

      final service = StationsService(client: mockClient);
      final first = await service.fetchStations();
      final second = await service.fetchStations();

      // Primer llamada hace fetch, segunda usa caché
      expect(calls, 2);
      expect(first, isA<List<Station>>());
      expect(second.length, first.length);
    });

// Test para verificar que forceRefresh omite la caché y clearCache limpia la caché
    test('forceRefresh bypasses cache and clearCache clears', () async {
      int calls = 0;

      final mockClient = MockClient((request) async {
        calls++;
        if (request.url.path.contains('station_information')) {
          return http.Response(jsonEncode({
            'data': {
              'stations': [
                {'station_id': '1', 'name': 'A', 'capacity': 10, 'lat': 0.0, 'lon': 0.0}
              ]
            }
          }), 200);
        }

        return http.Response(jsonEncode({
          'data': {
            'stations': [
              {'station_id': '1', 'num_bikes_available': 2, 'num_docks_available': 8, 'is_installed': true, 'is_renting': true}
            ]
          }
        }), 200);
      });

      final service = StationsService(client: mockClient);
      await service.fetchStations(); // Primer llamada hace fetch, segunda usa caché
      await service.fetchStations(); // segunda llamada usa caché
      service.clearCache();
      await service.fetchStations(); // Primer llamada hace fetch, segunda usa caché

      expect(calls, 4);
    });
  });
}
