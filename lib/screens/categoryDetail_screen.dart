import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_nepal/models/tour_model.dart'; // Adjust the path as needed
import 'package:travel_nepal/models/tourCategory_model.dart';
import 'package:travel_nepal/screens/tour_screen.dart'; // Adjust the path as needed

const Color primaryTextColor = Color(0xFF2c3e50);
const Color accentColor = Color(0xFFfa8072);
const Color secondaryBackgroundColor = Color(0xFFbdc3c7);
const Color additionalAccentColor = Color(0xFFf1c40f);

class CategoryDetailScreen extends StatelessWidget {
  final TourCategoryModel category;

  const CategoryDetailScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.category ?? "Category Details"),
        backgroundColor: accentColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tours')
            .where('category', isEqualTo: category.category) // Ensure this matches your data model
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: additionalAccentColor));
          }
          if (!snapshot.hasData) {
            return Center(child: Text("No tours found in this category.", style: TextStyle(color: primaryTextColor)));
          }

          final tourDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: tourDocs.length,
            itemBuilder: (context, index) {
              final tour = TourModel.fromFirebaseSnapshot(tourDocs[index] as DocumentSnapshot<Map<String, dynamic>>);

              return Card(
                child: ListTile(
                  leading: tour.imageUrl != null
                      ? Image.network(tour.imageUrl!, width: 100, height: 100, fit: BoxFit.cover)
                      : SizedBox(width: 100, height: 100),
                  title: Text(tour.tourName ?? "No Name", style: TextStyle(color: primaryTextColor)),
                  subtitle: Text("\$${tour.price?.toStringAsFixed(2) ?? 'N/A'}", style: TextStyle(color: primaryTextColor)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TourDetailsScreen(tour: tour)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}