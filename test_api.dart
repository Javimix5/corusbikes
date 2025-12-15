import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final response = await http.get(Uri.parse('https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl/station_status'));
  
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final stations = data['data']['stations'] as List;
    
    // Mostrar la primera estación con bicis disponibles
    for (var station in stations) {
      if (station['num_bikes_available'] > 0) {
        print('Station ID: ${station['station_id']}');
        print('Num bikes available: ${station['num_bikes_available']}');
        print('Num bikes available types: ${station['num_bikes_available_types']}');
        print('---');
        break;
      }
    }
  }
}
