import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  final String name;
  final double tempC;
  final String condition;
  final String conditionIconUrl; // Icon URL
  final double windKph;
  final int humidity;

  const WeatherScreen({
    super.key,
    required this.name,
    required this.tempC,
    required this.condition,
    required this.conditionIconUrl,
    required this.windKph,
    required this.humidity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Air Conditions',
          style: TextStyle(
            color: Colors.white,
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
              Text(
                name,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Chance of rain: 0%',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 24),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFE45E), // Yellow color for sun icon
                ),
                child: Center(
                  child: Image.network(
                    'https:$conditionIconUrl',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, size: 64, color: Colors.white);
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                '${tempC.toInt()}°',
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 32),
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
                  Expanded(
                    child: buildDataCard(
                      'CONDITION',
                      condition,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDataCard(String title, String value) {
    return Container(
      width: 160, // Adjusted width for consistent size
      height: 120, // Adjusted height for consistent size
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
              fontSize: 14, // Adjusted text size for card title
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18, // Adjusted text size for value
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
