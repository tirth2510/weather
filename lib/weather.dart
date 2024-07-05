import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherScreen extends StatefulWidget {
  final String name;
  final double tempC;
  final String condition;
  final String conditionIconUrl; // Icon URL
  final double windKph;
  final int humidity;
  final double feelslikeC;

  const WeatherScreen({
    super.key,
    required this.name,
    required this.tempC,
    required this.condition,
    required this.conditionIconUrl,
    required this.windKph,
    required this.humidity,
    required this.feelslikeC,
  });

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late String name;
  late double tempC;
  late String condition;
  late String conditionIconUrl;
  late double windKph;
  late int humidity;
  late double feelslikeC;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    name = widget.name;
    tempC = widget.tempC;
    condition = widget.condition;
    conditionIconUrl = widget.conditionIconUrl;
    windKph = widget.windKph;
    humidity = widget.humidity;
    feelslikeC = widget.feelslikeC;
  }

  Future<void> _refreshWeather() async {
    setState(() {
      _isLoading = true;
    });

    final query = name; // Use the city name to refresh weather data
    final url = 'https://api.weatherapi.com/v1/current.json?key=bfb38479a31747bfbb6123311240207&q=$query&aqi=no';
    final response = await http.get(Uri.parse(url));

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        name = data['location']['name'];
        tempC = data['current']['temp_c'];
        condition = data['current']['condition']['text'];
        conditionIconUrl = data['current']['condition']['icon'];
        windKph = data['current']['wind_kph'];
        humidity = data['current']['humidity'];
        feelslikeC = data['current']['feelslike_c'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to refresh weather data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Weather Conditions',
          style: GoogleFonts.kanit(
            fontSize: 24.0,
            color: Color(0xFFFFFFFF),
          ),
        ),
        backgroundColor: Color(0xFF0B131E),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      backgroundColor: Color(0xFF0B131E),
      body: _isLoading ? _buildLoadingScreen() : _buildWeatherScreen(),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  Widget _buildWeatherScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display the city name
            Text(
              name,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            // Display the weather condition
            Text(
              condition,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24),
            // Display the weather icon
            Container(
              width: 200,
              height: 200,
              child: Center(
                child: Image.network(
                  'https:$conditionIconUrl',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, size: 128, color: Colors.white);
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            // Display the temperature
            Text(
              '${tempC.toInt()}°',
              style: TextStyle(
                fontSize: 70,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 32),
            // Display additional weather data in a row of cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildDataCard(
                  'TEMPERATURE',
                  '${tempC.toStringAsFixed(1)}°C',
                ),
                buildDataCard(
                  'WIND',
                  '${windKph.toStringAsFixed(1)} km/h',
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildDataCard(
                  'HUMIDITY',
                  '$humidity%',
                ),
                buildDataCard(
                  'FEELS LIKE',
                  '${feelslikeC.toStringAsFixed(1)}°C',
                ),
              ],
            ),
            SizedBox(height: 32),
            // Add the refresh button
            ElevatedButton(
              onPressed: _refreshWeather,
              child: Text('Refresh'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF0095FF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build data cards
  Widget buildDataCard(String title, String value) {
    return Container(
      width: 160,
      height: 120,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFF1F242C),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
