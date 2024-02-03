import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuttle_tracker/api/shuttle_api.dart';

class TripHistoryPage extends StatefulWidget {
  const TripHistoryPage({super.key});

  @override
  _TripHistoryPageState createState() => _TripHistoryPageState();
}

class _TripHistoryPageState extends State<TripHistoryPage> {
  late String username;

  @override
  void initState() {
    super.initState();
    getUsernameFromSharedPreferences();
  }

  Future<void> getUsernameFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    if (savedUsername != null) {
      setState(() {
        username = savedUsername;
      });
    }
  }

  Future<List<Trip>> fetchTripHistoryData(String username) async {
    const baseUrl = ShuttleApi.baseUrl; // Replace with your server URL
    final endpoint = '/trip-history/$username';

    try {
      final response = await http.get(Uri.parse(baseUrl + endpoint));

      if (response.statusCode == 200) {
        final List<dynamic> tripHistoryData = json.decode(response.body);

        List<Trip> tripHistory = tripHistoryData.map((tripData) {
          return Trip(
            double.parse(tripData['distance'].toString()),
            double.parse(tripData['price'].toString()),
            tripData['action'].toString(),
          );
        }).toList();

        return tripHistory;
      } else {
        throw Exception('Failed to fetch trip history data');
      }
    } catch (error) {
      throw Exception('Network error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip History'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/background_image.jpg'), // Replace with your image asset path
                fit: BoxFit.cover,
              ),
            ),
          ),
          FutureBuilder<List<Trip>>(
            future: fetchTripHistoryData(username),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final tripHistory = snapshot.data;

                return ListView.builder(
                  itemCount: tripHistory!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text('Trip ${index + 1}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status: ${tripHistory[index].action}'),
                            Text('Distance: ${tripHistory[index].distance} km'),
                          ],
                        ),
                        trailing:
                            Text('Price: \u{20B9}${tripHistory[index].price}'),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class Trip {
  final double distance;
  final double price;
  final String action;

  Trip(this.distance, this.price, this.action);
}
