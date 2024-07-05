import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'weather.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  final String? lastSearchedCity;

  const MyHomePage({Key? key, this.lastSearchedCity}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = false;
  late String _lastSearchedCity;

  @override
  void initState() {
    super.initState();
    _lastSearchedCity = widget.lastSearchedCity ?? '';
    _searchController.text = _lastSearchedCity;
    _searchQuery = _lastSearchedCity;
  }

  void _cancelSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  Future<void> _performSearch() async {
    if (_searchQuery.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      final url =
          'https://api.weatherapi.com/v1/current.json?key=bfb38479a31747bfbb6123311240207&q=$_searchQuery&aqi=no';
      final response = await http.get(Uri.parse(url));

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Save the searched city to SharedPreferences
        _saveLastSearchedCity(_searchQuery);

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch weather data')),
        );
      }
    }
  }

  // Method to save last searched city to SharedPreferences
  Future<void> _saveLastSearchedCity(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('last_searched_city', city);
  }

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
            fontSize: 24.0,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: Color(0xFF0B131E),
      ),
      backgroundColor: Color(0xFF0B131E),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white10,
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
                TextButton(
                  onPressed: _cancelSearch,
                  child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            Spacer(),
            if (_searchQuery.isNotEmpty)
              ElevatedButton(
                onPressed: _performSearch,
                child: const Text('Search'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF0095FF),
                ),
              ),
            if (_isLoading)
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
