// weather.dart
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
        title: Text('Weather Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location: $name', style: TextStyle(fontSize: 24)),
            SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  child: Image.network(
                    'https:$conditionIconUrl', // Prepend 'https:'
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, size: 64);
                    },
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Temperature: ${tempC.toString()}°C', style: TextStyle(fontSize: 24)),
                    SizedBox(height: 8),
                    Text('Condition: $condition', style: TextStyle(fontSize: 24)),
                    SizedBox(height: 8),
                    Text('Wind: ${windKph.toString()} kph', style: TextStyle(fontSize: 24)),
                    SizedBox(height: 8),
                    Text('Humidity: ${humidity.toString()}%', style: TextStyle(fontSize: 24)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
