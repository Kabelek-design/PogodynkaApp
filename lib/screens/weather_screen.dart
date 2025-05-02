import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weather_model.dart';
import '../providers/weather_provider.dart';

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  Color _getBackgroundColor(String description) {
    switch (description.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return Colors.orange.shade100;

      case 'partly cloudy':
      case 'mostly sunny':
        return Colors.grey.shade200;

      case 'cloudy':
      case 'overcast':
        return Colors.grey.shade300;

      case 'light rain':
      case 'light rain shower':
      case 'moderate rain':
      case 'rain':
        return Colors.lightBlue.shade100;

      case 'snow':
      case 'light snow':
      case 'snow shower':
        return Colors.white70;

      case 'fog':
      case 'mist':
        return Colors.blueGrey.shade100;

      case 'thunderstorm':
      case 'storm':
        return Colors.deepPurple.shade100;

      default:
        return Colors.white;
    }
  }

  IconData _getWeatherIcon(String description) {
    switch (description.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return Icons.wb_sunny;
      case 'partly cloudy':
      case 'mostly sunny':
        return Icons.wb_cloudy;
      case 'cloudy':
      case 'overcast':
        return Icons.cloud;
      case 'light rain':
      case 'light rain shower':
      case 'moderate rain':
      case 'rain':
        return Icons.umbrella;
      case 'snow':
      case 'light snow':
        return Icons.ac_unit;
      case 'thunderstorm':
      case 'storm':
        return Icons.bolt;
      default:
        return Icons.wb_twilight;
    }
  }

  Color _getIconColor(String description) {
    switch (description.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return Colors.orange;
      case 'partly cloudy':
      case 'mostly sunny':
        return Colors.blueGrey;
      case 'cloudy':
      case 'overcast':
        return Colors.grey;
      case 'light rain':
      case 'rain':
      case 'moderate rain':
        return Colors.blue;
      case 'snow':
        return Colors.lightBlueAccent;
      case 'thunderstorm':
      case 'storm':
        return Colors.deepPurple;
      default:
        return Colors.black54;
    }
  }

  Widget _buildWeatherCard(BuildContext context, WeatherData weather) {
    final bgColor = _getBackgroundColor(weather.description);
    final icon = _getWeatherIcon(weather.description);
    final iconColor = _getIconColor(weather.description);

    return Card(
      color: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: iconColor),
            const SizedBox(height: 12),
            Text(
              weather.location,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(weather.description, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text(
              '${weather.temperature}°C',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 4),
            Text(
              'Obserwacja: ${TimeOfDay.fromDateTime(weather.observationTime).format(context)}',
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherListAsync = ref.watch(weatherListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pogodynka'),
        backgroundColor: Colors.teal.shade400,
        foregroundColor: Colors.white,
      ),
      body: weatherListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Błąd: $err',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            ),
        data:
            (weatherList) => ListView.builder(
              padding: const EdgeInsets.only(top: 16, bottom: 32),
              itemCount: weatherList.length,
              itemBuilder: (context, index) {
                return _buildWeatherCard(context, weatherList[index]);
              },
            ),
      ),
    );
  }
}
