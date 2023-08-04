import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'order_customization_page.dart';

class Offer {
  final String title;
  final String description;
  final double price;
  final List<String> images;
  double rating;

  Offer({
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    this.rating = 0.0,
  });
}

class AdvertisementPage extends StatefulWidget {
  const AdvertisementPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AdvertisementPageState createState() => _AdvertisementPageState();
}

class _AdvertisementPageState extends State<AdvertisementPage> {
  final List<Offer> offers = [
    Offer(
      title: 'Coffee Special',
      description: 'Enjoy our special blend of coffee.',
      price: 4.99,
      images: [
        'assets/images/coffee1.jpg',
        'assets/images/coffee2.jpg',
        'assets/images/coffee3.jpg',
        'assets/images/coffee4.jpg',
      ],
    ),
    Offer(
      title: 'Food Delight',
      description: 'Taste our delicious food items.',
      price: 9.99,
      images: [
        'assets/images/food1.jpg',
        'assets/images/food2.jpg',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadRatings();
  }

  Future<void> _loadRatings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      for (var offer in offers) {
        offer.rating = prefs.getDouble(offer.title) ?? 0.0;
      }
    });
  }

  Future<void> _saveRating(Offer offer, double rating) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(offer.title, rating);

    setState(() {
      offer.rating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advertisements'),
      ),
      body: ListView.builder(
        itemCount: offers.length,
        itemBuilder: (context, index) {
          Offer offer = offers[index];
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  items: offer.images.map((image) {
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
                    autoPlayInterval: const Duration(seconds: 3),
                  ),
                ),
                ListTile(
                  title: Text(offer.title),
                  subtitle: Text(offer.description),
                  trailing: Text('\$${offer.price.toStringAsFixed(2)}'),
                ),
                ListTile(
                  title: Row(
                    children: [
                      const Text('Rating: '),
                      _buildRatingStars(offer),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _showRatingDialog(context, offer);
                    },
                    child: const Text('Rate'),
                  ),
                ),
                ListTile(
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderCustomizationPage(offer: offer),
                        ),
                      );
                    },
                    child: const Text('Order Now'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRatingStars(Offer offer) {
    int numStars = 5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        numStars,
        (index) {
          return GestureDetector(
            onTap: () {
              _saveRating(offer, index + 1.0);
            },
            child: Icon(
              index < offer.rating.floor() ? Icons.star : Icons.star_border,
              color: Colors.orange,
            ),
          );
        },
      ),
    );
  }

  void _showRatingDialog(BuildContext context, Offer offer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rate ${offer.title}'),
          content: _buildRatingStars(offer),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
