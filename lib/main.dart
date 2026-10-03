import 'package:flutter/material.dart';

import 'screens/map_screen.dart';

void main() {
  runApp(const FavoritePlacesApp());
}

class FavoritePlacesApp extends StatelessWidget {
  const FavoritePlacesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Favorite Places',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MapScreen(),
    );
  }
}
