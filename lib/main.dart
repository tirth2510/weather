import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';

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
      home: MyHomePage(lastSearchedCity: lastSearchedCity),
    );
  }
}
