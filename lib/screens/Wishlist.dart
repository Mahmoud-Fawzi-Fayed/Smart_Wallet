// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wishlist App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WishlistPage(),
    );
  }
}

class WishlistPage extends StatefulWidget {
  @override
  const WishlistPage({super.key});
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<WishlistItem> wishlistItems = [];

  @override
  void initState() {
    super.initState();
    // Load the wishlist items from shared preferences
    _loadWishlistItems();
  }

  Future<void> _loadWishlistItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? items = prefs.getStringList('wishlistItems');
    if (items != null) {
      setState(() {
        wishlistItems = items.map((item) => WishlistItem.fromJson(item)).toList();
      });
    }
  }

  Future<void> _saveWishlistItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> items = wishlistItems.map((item) => item.toJson()).toList();
    await prefs.setStringList('wishlistItems', items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
      ),
      body: ListView.builder(
        itemCount: wishlistItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.image),
            title: Text(wishlistItems[index].itemName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price: \$${wishlistItems[index].price.toStringAsFixed(2)}',
                ),
                Text('Link: ${wishlistItems[index].link}'),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddItemDialog() {
    String itemName = '';
    String link = '';
    double price = 0.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Wishlist Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Item Name'),
                  onChanged: (value) {
                    itemName = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Link'),
                  onChanged: (value) {
                    link = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    price = double.tryParse(value) ?? 0.0;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  wishlistItems.add(
                    WishlistItem(
                      itemName: itemName,
                      link: link,
                      price: price,
                    ),
                  );
                });
                _saveWishlistItems(); // Save the wishlist items
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class WishlistItem {
  final String itemName;
  final String link;
  final double price;

  WishlistItem({
    required this.itemName,
    required this.link,
    required this.price,
  });

  // Convert WishlistItem to JSON format
  String toJson() {
    return '{"itemName": "$itemName", "link": "$link", "price": $price}';
  }

  // Create WishlistItem from JSON
  factory WishlistItem.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return WishlistItem(
      itemName: json['itemName'],
      link: json['link'],
      price: json['price'].toDouble(),
    );
  }
}
