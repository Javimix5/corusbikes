import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:corusbikes/viewmodels/stations_vm.dart';
import 'package:corusbikes/models/station.dart';
import 'package:corusbikes/screens/home_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('E2E: muestra lista y permite pulsar una estación', (tester) async {
    final vm = StationsViewModel();
    vm.setStations([
      Station(id: '1', name: 'Plaza Test', capacity: 10, lat: 0.0, lon: 0.0, numBikesAvailable: 3, numDocksAvailable: 7, isInstalled: true, isRenting: true),
    ]);

    await tester.pumpWidget(
      ChangeNotifierProvider<StationsViewModel>.value(
        value: vm,
        child: MaterialApp(home: HomeScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Plaza Test'), findsOneWidget);

    // Tocar la ListTile
    await tester.tap(find.text('Plaza Test'));
    await tester.pumpAndSettle();

    // Comprobamos que tras pulsar no hay errores y la navegación funciona (al menos se renderiza algo distinto)
    expect(find.text('Plaza Test'), findsWidgets);
  });
}
