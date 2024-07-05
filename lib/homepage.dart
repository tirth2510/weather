import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'weather.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // TextEditingController to handle the search input field
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Method to clear the search query and reset the search bar
  void _cancelSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  // Method to perform the weather search using the WeatherAPI
  Future<void> _performSearch() async {
    if (_searchQuery.isNotEmpty) {
      final url = 'https://api.weatherapi.com/v1/current.json?key=bfb38479a31747bfbb6123311240207&q=$_searchQuery&aqi=no';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WeatherScreen(
              name: data['location']['name'],
              tempC: data['current']['temp_c'],
              condition: data['current']['condition']['text'],
              conditionIconUrl: data['current']['condition']['icon'],
              windKph: data['current']['wind_kph'],
              humidity: data['current']['humidity'],
              feelslikeC: data['current']['feelslike_c'],
            ),
          ),
        );
      } else {
        // Show a snackbar if the API call fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch weather data')),
        );
      }
    }
  }

  // Dispose the TextEditingController when the widget is removed from the widget tree
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Weather App',
          style: GoogleFonts.kanit(
            fontSize: 24.0, // Change font size here
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: Color(0xFF0B131E), // Set AppBar background color
      ),
      backgroundColor: Color(0xFF0B131E), // Set background color
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                // Expanded widget to make the search bar take up the available space
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: Colors.white), // Text color
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.white54), // Hint text color
                      filled: true,
                      fillColor: Colors.white10, // Search bar fill color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.white54),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                // Button to clear the search input
                TextButton(
                  onPressed: _cancelSearch,
                  child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            Spacer(),
            // Search button appears only when there is a search query
            if (_searchQuery.isNotEmpty)
              ElevatedButton(
                onPressed: _performSearch,
                child: const Text('Search'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF0095FF), // Button text color
                ),
              ),
          ],
        ),
      ),
    );
  }
}
