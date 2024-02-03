import 'package:flutter/material.dart';
import 'package:shuttle_tracker/screens/qr_scanner_screen.dart';

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigate to the QR code scanner screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QRCodeScannerScreen(
                            apiEndpoint: '/start-trip')));
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QRCodeScannerScreen(
                            apiEndpoint: '/end-trip')));
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
            // Additional payment-related content can be added here.
          ],
        ),
      ),
    );
  }
}
