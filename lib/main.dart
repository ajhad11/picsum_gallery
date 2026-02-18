import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/gallery/presentation/screens/gallery_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Picsum Gallery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D31FA),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Inter', // Optional: requires font setup, fallback to system font
      ),
      home: const GalleryScreen(),
    );
  }
}
