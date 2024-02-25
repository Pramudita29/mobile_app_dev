import 'package:flutter/material.dart';
import 'package:travel_nepal/models/tour_model.dart';

import 'booking_screen.dart'; // Adjust the path as needed

const Color primaryTextColor = Color(0xFF2c3e50);
const Color accentColor = Color(0xFFfa8072);
const Color secondaryBackgroundColor = Color(0xFFbdc3c7);
const Color additionalAccentColor = Color(0xFFf1c40f);

class TourDetailsScreen extends StatelessWidget {
  final TourModel tour;

  const TourDetailsScreen({Key? key, required this.tour}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tour.tourName ?? "Tour Details"),
        backgroundColor: accentColor, // Use the accent color for the AppBar background
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    tour.tourName ?? "No Name",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Image.network(
                  tour.imageUrl ?? "https://via.placeholder.com/150", // Placeholder in case the URL is null
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Description:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    tour.description ?? "No description provided.",
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryTextColor,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.location_on, color: accentColor),
                  title: Text(tour.location ?? "No Location"),
                ),
                ListTile(
                  leading: Icon(Icons.monetization_on, color: accentColor),
                  title: Text("\$${tour.price?.toStringAsFixed(2) ?? 'N/A'}"),
                ),
                ListTile(
                  leading: Icon(Icons.category, color: accentColor),
                  title: Text(tour.category ?? "No Category"),
                ),
                SizedBox(height: 80), // Add space for the fixed button
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor, // Button color
                  foregroundColor: Colors.white, // Text color
                ),
                onPressed: () {
                  // Navigate to the BookingScreen, passing the current tour
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(tour: tour),
                    ),
                  );
                },
                child: Text('Book Tour'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
