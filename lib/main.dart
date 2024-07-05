import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';
import 'weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? lastSearchedCity = prefs.getString('last_searched_city');

  runApp(MyApp(lastSearchedCity: lastSearchedCity));
}

class MyApp extends StatelessWidget {
  final String? lastSearchedCity;

  const MyApp({Key? key, this.lastSearchedCity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: lastSearchedCity != null
          ? WeatherLoader(city: lastSearchedCity!)
          : MyHomePage(),
    );
  }
}

class WeatherLoader extends StatelessWidget {
  final String city;

  const WeatherLoader({Key? key, required this.city}) : super(key: key);

  Future<Map<String, dynamic>> fetchWeatherData(String city) async {
    final url = 'https://api.weatherapi.com/v1/current.json?key=bfb38479a31747bfbb6123311240207&q=$city&aqi=no';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchWeatherData(city),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          return WeatherScreen(
            name: data['location']['name'],
            tempC: data['current']['temp_c'],
            condition: data['current']['condition']['text'],
            conditionIconUrl: data['current']['condition']['icon'],
            windKph: data['current']['wind_kph'],
            humidity: data['current']['humidity'],
            feelslikeC: data['current']['feelslike_c'],
          );
        } else {
          return Scaffold(
            body: Center(child: Text('No data available')),
          );
        }
      },
    );
  }
}
