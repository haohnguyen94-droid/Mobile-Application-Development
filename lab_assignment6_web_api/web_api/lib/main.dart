/*
Name: Hong Nguyen
Assignment: Lab Assignment 6 - Web API
Date: 06/22/2026
*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// 1. Load environment variables before the app starts.
Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

// 2. Service class that fetches weather data from OpenWeatherMap.
class WeatherService {
  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final apiKey = dotenv.env['API_KEY'];
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=imperial'));
    if (response.statusCode == 200) {
      // Decode the JSON body into a Dart Map.
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

// 3. Main application widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Wether App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>{
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _cityController = TextEditingController();

  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _getWeather() async {
    final city = _cityController.text.trim();
    if(city.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _weatherData = null;
    });

    try{
      final data = await _weatherService.fetchWeather(city);
      setState(() {
        _weatherData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _errorMessage = 'City not found.please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose(){
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
             // City input field with a search button.
             TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter city name',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _getWeather,
                ),
              ),
              onSubmitted: (_) => _getWeather(),
            ),
            const SizedBox(height: 24.0),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(){
    if(_isLoading){
      return const Center (child: CircularProgressIndicator());
    }
    if(_errorMessage != null){
      return Center(child: Text(_errorMessage!,style:const TextStyle(fontSize: 18.0)));
    }
    if(_weatherData == null){
      return const Center(child: Text('Search for a city to see the weather.'));
    }

    //pull the filed we need out of the JSON response
    final cityName = _weatherData!['name'];
    final temperature = _weatherData!['main']['temp'];
    final condition = _weatherData!['weather'][0]['main'];
    final description = _weatherData!['weather'][0]['description'];
    final iconCode = _weatherData!['weather'][0]['icon'];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            cityName,
            style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          ),
        // Weather image serverd by OpenWeatherMap based on the icon code.
        Image.network(
          'https://openweathermap.org/img/wn/$iconCode@4x.png',
          width: 150,
          height: 150,
        ),
        Text(
          '${temperature.toStringAsFixed(1)}°F',
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
        ),
        Text(condition,style: const TextStyle(fontSize: 24.0)),
        Text(
          description,
          style: const TextStyle(fontSize: 18.0)
        ),
      ],
    ),
    );
  }
}