import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuttle_tracker/api/shuttle_api.dart';
import 'package:shuttle_tracker/models/shuttle_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Set<Marker> _markers = {};
  List<Shuttle> shuttles = [];
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;

  // Define a timer for periodic data refresh
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchShuttleData();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      fetchShuttleData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void _updateMarkers(List<Shuttle> shuttles, Uint8List markIcons) {
    setState(() {
      _markers.clear();
      for (var shuttle in shuttles) {
        final marker = Marker(
          markerId: MarkerId(shuttle.id),
          position: LatLng(shuttle.latitude, shuttle.longitude),
          infoWindow: InfoWindow(
            title: shuttle.name,
            snippet: 'Status: ${shuttle.status}',
          ),
          icon: BitmapDescriptor.fromBytes(markIcons),
        );
        _markers.add(marker);
      }
    });
  }

  void fetchShuttleData() async {
    final Uint8List markIcons = await getImages('assets/markers/icon.png', 64);
    try {
      final List<Shuttle> fetchedShuttles = await ShuttleApi.fetchShuttleData();

      setState(() {
        shuttles = fetchedShuttles;
        _updateMarkers(shuttles, markIcons);
      });
    } catch (error) {
      print('Error fetching shuttle data: $error');
    }
  }

  // Function to handle logout
  void logout(BuildContext context) async {
    // Clear the stored login state
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.setString('username', "");
    // Navigate to the login screen
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VIT Shuttle Tracker'),
      ),
      // Add a Drawer for the side panel
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(
              height: 90,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF0a0e21),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text(
                'Payment',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(
                    context, '/payment'); // Navigate to the Payment screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text(
                'Trip History',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(
                    context, '/trip'); // Navigate to the Trip History screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                logout(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          // Minimize the app when the back button is pressed
          SystemNavigator.pop();
          return false; // Prevent default back button behavior
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: GoogleMap(
                onMapCreated: (controller) {
                  setState(() {});
                },
                initialCameraPosition: const CameraPosition(
                  target: LatLng(12.975079, 79.164208),
                  zoom: 15,
                ),
                markers: _markers,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
