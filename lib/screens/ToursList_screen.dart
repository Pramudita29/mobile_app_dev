import 'package:flutter/material.dart';
import 'package:travel_nepal/models/tour_model.dart'; // Adjust the import path
import 'package:travel_nepal/repositories/tour_repo.dart';
import 'package:travel_nepal/screens/tour_screen.dart'; // Adjust the import path

class UserTourListScreen extends StatefulWidget {
  @override
  _TourListScreenState createState() => _TourListScreenState();
}

class _TourListScreenState extends State<UserTourListScreen> {
  final TourRepository _tourRepository = TourRepository();
  Future<List<TourModel>>? _toursFuture;

  @override
  void initState() {
    super.initState();
    _toursFuture = _tourRepository.getAllTours();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tours'),
      ),
      body: FutureBuilder<List<TourModel>>(
        future: _toursFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred while fetching tours'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No tours found'));
          }

          final tours = snapshot.data!;
          return ListView.builder(
            itemCount: tours.length,
            itemBuilder: (context, index) {
              final tour = tours[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: tour.imageUrl != null ? Image.network(tour.imageUrl!, width: 100, fit: BoxFit.cover) : null,
                  title: Text(tour.tourName ?? 'No Name'),
                  subtitle: Text("\$${tour.price?.toStringAsFixed(2)} - ${tour.location}"),
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
