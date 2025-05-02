import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/weather_screen.dart';
import 'providers/api_key_provider.dart';

Future<void> main() async {
  final envFile = File('.env');
  final lines = await envFile.readAsLines();
  String apiKey = '';

  for (final line in lines) {
    if (line.startsWith('WEATHERSTACK_API_KEY=')) {
      apiKey = line.split('=')[1].trim();
      break;
    }
  }

  runApp(
    ProviderScope(
      overrides: [
        apiKeyProvider.overrideWithValue(apiKey),
      ],
      child: const WeatherApp(),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(useMaterial3: true),
      home: const WeatherScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
