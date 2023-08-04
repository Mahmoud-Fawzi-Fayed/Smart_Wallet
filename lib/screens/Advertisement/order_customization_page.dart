// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, deprecated_member_use, library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unused_element, unused_local_variable, avoid_print, depend_on_referenced_packages
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'advertisement_page.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class OrderCustomizationPage extends StatefulWidget {
  final Offer offer;


  OrderCustomizationPage({required this.offer});

  @override
  _OrderCustomizationPageState createState() => _OrderCustomizationPageState();

}

class _OrderCustomizationPageState extends State<OrderCustomizationPage> {
  String _selectedCoffeeType = 'coffee';
  String _selectedSize = 'Small';
  bool _addMilk = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customize Your Order'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: widget.offer.images.map((image) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 300,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
              ),
            ),
            ListTile(
              title: Text(widget.offer.title),
              subtitle: Text(widget.offer.description),
              trailing: Text('\$${widget.offer.price.toStringAsFixed(2)}'),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Customization Options:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (widget.offer.title == 'Coffee Special')
              _buildCoffeeOptions(),
            // Add more customization options for other offers here
            // Example: Food options, size selection, etc.
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Place the order here with the selected customization options
                  // For this example, we'll just show a dialog with the order details and a QR code
                  _showOrderConfirmationDialog();
                },
                child: Text('Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoffeeOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Coffee Type:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCoffeeTypeOption('Coffee', 'assets/images/coffee.png', Colors.white),
            _buildCoffeeTypeOption('Latte', 'assets/images/latte.png', Colors.white),
            _buildCoffeeTypeOption('Nescafe', 'assets/images/nescafe.png', Colors.white),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Size:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSizeOption('Small', 'assets/images/small_coffee.png', Colors.white),
            _buildSizeOption('Medium', 'assets/images/medium_coffee.png', Colors.white),
            _buildSizeOption('Large', 'assets/images/large_coffee.png', Colors.white),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CheckboxListTile(
            title: Text('Add Milk'),
            value: _addMilk,
            onChanged: (value) {
              setState(() {
                _addMilk = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCoffeeTypeOption(String type, String coffee, Color white) {
    final bool isSelected = _selectedCoffeeType == coffee;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCoffeeType = coffee;
        });
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(coffee),
                fit: BoxFit.contain,
              ),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 4),
          Text(
            type,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeOption(String size, String coffee, Color white) {
    final bool isSelected = _selectedSize == size;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = size;
        });
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(coffee),
                fit: BoxFit.contain,
              ),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 4),
          Text(
            size,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

void _showOrderConfirmationDialog() async {
  // Generate the order data
  String orderData = _generateOrderData();

  // Generate the QR code
  final qrImageData = await QrPainter(
    data: orderData,
    version: QrVersions.auto,
    gapless: false,
    color: Colors.black,
    emptyColor: Colors.white,
  ).toImageData(200);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Order Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your order has been placed.'),
            SizedBox(height: 10),
            Text('Order Details:'),
            SizedBox(height: 10),
            Text(orderData), // Show order details
            SizedBox(height: 20),
            Center(
              child: Image.memory(qrImageData!.buffer.asUint8List()), // Display the QR code as an Image widget
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _saveQrCodeToGallery(qrImageData);
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

void _saveQrCodeToGallery(ByteData qrImageData) async {
  try {
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/qr_code.png';
    final buffer = qrImageData.buffer.asUint8List();

    // Save the QR code image to the gallery
    final result = await ImageGallerySaver.saveImage(buffer, name: 'qr_code');

    if (result['isSuccess']) {
      print('QR code image saved to gallery.');
    } else {
      print('Failed to save QR code image to gallery.');
    }
  } catch (e) {
    print('Error saving QR code image: $e');
  }
}

  String _generateOrderData() {
    // Customize this method to generate the order data as per your requirements
    return 'Coffee Type: $_selectedCoffeeType\nSize: $_selectedSize\nAdd Milk: $_addMilk';
  }
}

