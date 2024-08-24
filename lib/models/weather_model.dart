class Weather {
  final String cityName;
  final double temperature;
  final String weatherDescription;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.weatherDescription,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    // Safely access the weather list and other fields
    final weatherList = json['weather'] as List<dynamic>?;
    final weather = weatherList != null && weatherList.isNotEmpty
        ? weatherList[0] as Map<String, dynamic>
        : {};

    return Weather(
      cityName: json['name'] ?? '',
      temperature: json['main']?['temp']?.toDouble() ?? 0.0,
      weatherDescription: weather['description'] ?? '',
    );
  }
}
