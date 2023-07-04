// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, prefer_const_declarations, file_names

import 'package:flutter/material.dart';

class NfcPaymentPage extends StatefulWidget {
  const NfcPaymentPage({super.key});
  @override
  _NfcPaymentPageState createState() => _NfcPaymentPageState();
}

class _NfcPaymentPageState extends State<NfcPaymentPage> {
  bool _isPaymentProcessing = false;
  bool _isPaymentSuccessful = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC Payment Reader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.credit_card,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Place your NFC-enabled credit card near the device',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Maximum payment amount: 500 pounds',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 30),
            _isPaymentProcessing
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      // Simulate payment process with NFC data
                      _startPaymentProcess();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 180, 255, 204),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: Text(
                      'Make Payment',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight :FontWeight.bold,
                      )
                    ),
                  ),
            SizedBox(height: 20),
            _isPaymentSuccessful
                ? Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Payment Successful!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  void _startPaymentProcess() {
    if (_isPaymentProcessing) return;

    // Simulated payment amount
    final double paymentAmount = 300.0;

    if (paymentAmount > 500.0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Payment Error'),
          content: Text('Maximum payment amount exceeded (500 pounds).'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _isPaymentProcessing = true;
      _isPaymentSuccessful = false;
    });

    // Simulate payment processing delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isPaymentProcessing = false;
        _isPaymentSuccessful = true;
      });
    });
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.blue, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blueAccent),
    ),
    home: NfcPaymentPage(),
    debugShowCheckedModeBanner: false,
  ));
}
