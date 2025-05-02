import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weather_model.dart';
import '../providers/api_key_provider.dart';

class WeatherService {
  final Ref ref;
  WeatherService(this.ref);

  Future<WeatherData> getCurrentWeather(String location) async {
    final apiKey = ref.read(apiKeyProvider);

    if (apiKey.isEmpty) {
      throw Exception('Brak API key – uzupełnij w .env');
    }

    final url = Uri.parse(
      'http://api.weatherstack.com/current?access_key=$apiKey&query=$location',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);

      if (jsonBody['success'] == false || jsonBody['current'] == null) {
        throw Exception(jsonBody['error']?['info'] ?? 'Unknown API error');
      }

      return WeatherData.fromJson(jsonBody);
    } else {
      throw Exception('HTTP error: ${response.statusCode}');
    }
  }
}
