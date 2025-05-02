import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

final weatherServiceProvider = Provider((ref) => WeatherService(ref));

final weatherProvider = FutureProvider<WeatherData>((ref) async {
  final service = ref.read(weatherServiceProvider);
  return service.getCurrentWeather('Byczyna'); // <--- miasto
}); 

final weatherListProvider = FutureProvider<List<WeatherData>>((ref) async {
  final service = ref.read(weatherServiceProvider);
  final locations = ['Opole', 'Byczyna', 'Warszawa'];

  final List<WeatherData> results = [];

  for (final city in locations) {
    try {
      // Poczekaj 1 sekundę między zapytaniami, by nie złamać limitu
      final data = await service.getCurrentWeather(city);
      results.add(data);
      await Future.delayed(const Duration(seconds: 1)); // throttle
    } catch (e) {
      // można logować, ale nie przerywamy pętli
      ('Błąd dla $city: $e');
    }
  }

  if (results.isEmpty) {
    throw Exception('Brak danych pogodowych');
  }

  return results;
});