import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherServices {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherServices(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final url = '$BASE_URL?q=$cityName&appid=$apiKey&units=metric';
    print('Request URL: $url');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('Response data: $responseData');

      if (responseData != null) {
        return Weather.fromJson(responseData);
      } else {
        throw Exception('No data in response');
      }
    } else {
      print('Failed to load weather: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load weather');
    }
  }

  Future<String> getcurrentcity() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  Position position = await Geolocator.getCurrentPosition(
    locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    ),
  );

  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
    
  );

  String? city = placemarks.isNotEmpty ? placemarks[0].locality : null;
  return 'peshawar'; 
}

}
