import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixelprospectors_fe/screens/map_screen/search_dialog/search_dialog_state.dart';
import 'package:pixelprospectors_fe/services/geocoder_service.dart';
import 'package:pixelprospectors_fe/screens/map_screen/map_screen.dart';


void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel Prospectors',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MapScreen(),
    );
  }
}
