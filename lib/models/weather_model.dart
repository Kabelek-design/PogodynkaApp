class WeatherData {
  final String location;
  final int temperature;
  final String description;
  final DateTime observationTime;

  WeatherData({
    required this.location,
    required this.temperature,
    required this.description,
    required this.observationTime,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final obsTimeString = json['current']['observation_time']; // np. "12:06 PM"
    final now = DateTime.now().toUtc();

    // Parsujemy "12:06 PM" jako czas UTC w dzisiejszej dacie
    final obsTimeParts = RegExp(r'(\d{1,2}):(\d{2})\s(AM|PM)').firstMatch(obsTimeString);
    int hour = int.parse(obsTimeParts!.group(1)!);
    final minute = int.parse(obsTimeParts.group(2)!);
    final period = obsTimeParts.group(3);

    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;

    final observationUtc = DateTime.utc(now.year, now.month, now.day, hour, minute);
    final observationLocal = observationUtc.toLocal(); // ⬅️ tu robimy konwersję na lokalny czas

    return WeatherData(
      location: json['location']['name'],
      temperature: json['current']['temperature'],
      description: json['current']['weather_descriptions'][0],
      observationTime: observationLocal,
    );
  }
}
