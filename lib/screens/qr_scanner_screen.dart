// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuttle_tracker/api/shuttle_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScannerScreen extends StatefulWidget {
  final String apiEndpoint;

  const QRCodeScannerScreen({super.key, required this.apiEndpoint});

  @override
  _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    bool dataSent = false;
    controller.scannedDataStream.listen((scanData) {
      if (!dataSent) {
        // Send the scanned data to the backend server
        _sendDataToBackend(scanData, widget.apiEndpoint);
        dataSent = true; // Set the flag to true to indicate data has been sent
        // Close the scanner screen
      }
    });
  }

  void _sendDataToBackend(Barcode scanData, String apiEndpoint) async {
    final scannedData = scanData.code; // Extract the QR code data

    // Fetch the username from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    // Check if the username is available
    if (username != null) {
      final dataToSend = {
        'data': scannedData,
        'username': username,
      };

      String baseurl = ShuttleApi.baseUrl;
      try {
        String apiUrl = '$baseurl$apiEndpoint';
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(dataToSend),
        );

        if (response.statusCode == 200) {
          Navigator.pop(context, response.body);
        } else {
          Navigator.pop(context, response.body);
        }
      } catch (error) {
        Navigator.pop(context, "Error");
      }
    } else {
      Navigator.pop(context, "Login Error");
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
