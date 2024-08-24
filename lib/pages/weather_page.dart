import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherServices('db2f8a3840031d160194edfa180206f9');
  Weather? _weather;
  String _selectedCity = 'Murree';
  Color _backgroundColor = Colors.white;

  _fetchWeather(String cityName) async {
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _backgroundColor = getWeatherAnimation(weather?.weatherDescription).color;
      });
    } catch (e) {
      print(e);
    }
  }

  WeatherAnimation getWeatherAnimation(String? description) {
    if (description == null) return WeatherAnimation('assets/sunny.json', Colors.blue);
    switch (description.toLowerCase()) {
      case 'shower rain':
        return WeatherAnimation('assets/rainthunder.json', Colors.grey);
      case 'thunderstorm':
        return WeatherAnimation('assets/thunder.json', Colors.black);
      case 'clear sky':
        return WeatherAnimation('assets/sunny.json', Colors.yellow);
      default:
        return WeatherAnimation('assets/cloudy.json', Colors.blueGrey);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather(_selectedCity); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        children: [
          SizedBox(height: 50), 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCityButton('Murree'),
              _buildCityButton('Islamabad'),
              _buildCityButton('Karachi'),
            ],
          ),
          Expanded(
            child: Center(
              child: _weather == null
                  ? CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _weather!.cityName,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(221, 177, 174, 174),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${_weather!.temperature.round()}°C',
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(221, 190, 182, 182),
                          ),
                        ),
                        SizedBox(height: 10),
                        
                        SizedBox(height: 20),
                        Lottie.asset(
                          getWeatherAnimation(_weather?.weatherDescription).animationPath,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCityButton(String cityName) {
    return TextButton(
      onPressed: () {
        setState(() {
          _selectedCity = cityName;
        });
        _fetchWeather(cityName);
      },
      child: Text(
        cityName,
        style: TextStyle(
          fontSize: 20,
          color: _selectedCity == cityName ? Colors.blue : Colors.black54,
          fontWeight: _selectedCity == cityName ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class WeatherAnimation {
  final String animationPath;
  final Color color;

  WeatherAnimation(this.animationPath, this.color);
}
