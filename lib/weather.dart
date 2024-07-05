import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherScreen extends StatelessWidget {
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
      body: SingleChildScrollView(
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
                  fontSize: 72,
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
            ],
          ),
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
