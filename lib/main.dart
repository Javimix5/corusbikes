import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/stations_vm.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CorusBikes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ChangeNotifierProvider(
        create: (context) => StationsViewModel(),
        child: HomeScreen(),
      ),
    );
  }

}