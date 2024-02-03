import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shuttle_tracker/screens/qr_scanner_screen.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String response = ''; // Store the response from QRCodeScannerScreen
  bool isResponseVisible = false;

  void showResponsePopup(String message) {
    setState(() {
      response = message;
      isResponseVisible = true;
    });

    // Auto-hide the response popup after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      hideResponsePopup();
    });
  }

  void hideResponsePopup() {
    setState(() {
      isResponseVisible = false;
    });
  }

  void showPriceDialog(String price, String dist) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(top: 40, left: 35),
          contentPadding: const EdgeInsets.only(left: 60, right: 60),
          title: const Text(
            'Trip Ended',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Price: \u{20B9}$price \nDistance: $dist KM',
            style: const TextStyle(fontSize: 22),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    // Navigate to the QR code scanner screen
                    final result = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const QRCodeScannerScreen(
                          apiEndpoint: '/start-trip');
                    }));
                    Map<String, dynamic> jsonMap = json.decode(result);
                    final msg = jsonMap['message'];
                    showResponsePopup(msg);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF0a0e21)),
                    elevation: MaterialStateProperty.all(8.0),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(300, 60)),
                  ),
                  child: const Text(
                    'Start Trip',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the QR code scanner screen
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const QRCodeScannerScreen(
                          apiEndpoint: '/end-trip');
                    })).then((value) {
                      if (value != null) {
                        if (value.toString().contains("Trip ended")) {
                          // Show a dialog with the price
                          Map<String, dynamic> jsonMap = json.decode(value);
                          final price = jsonMap['price'];
                          final distance = jsonMap['distance'];
                          showPriceDialog(
                              price.toString(), distance.toString());
                        } else {
                          Map<String, dynamic> jsonMap = json.decode(value);
                          final msg = jsonMap['message'];
                          showResponsePopup(msg);
                        }
                      }
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF0a0e21)),
                    elevation: MaterialStateProperty.all(8.0),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(300, 60)),
                  ),
                  child: const Text(
                    'End Trip',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 30),
                // Small popup at the bottom to display responses
                if (isResponseVisible)
                  BottomSheet(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    onClosing: hideResponsePopup,
                    backgroundColor: Colors.grey,
                    builder: (BuildContext context) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          response,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
