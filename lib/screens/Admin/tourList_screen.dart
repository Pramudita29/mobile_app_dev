import 'package:flutter/material.dart';
import 'package:travel_nepal/models/tour_model.dart';
import 'package:travel_nepal/repositories/tour_repo.dart';
import 'AddEditTourScreen.dart'; // Ensure this screen exists for adding/editing tours

class AdminTourListScreen extends StatefulWidget {
  final bool isAdmin;

  AdminTourListScreen({Key? key, required this.isAdmin}) : super(key: key); // Add this line

  @override
  _TourListScreenState createState() => _TourListScreenState();
}

class _TourListScreenState extends State<AdminTourListScreen> {
  final TourRepository _tourRepository = TourRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey, // Your desired color
        foregroundColor: Colors.white,
        title: Text('Tours'),
        actions: widget.isAdmin // Check if isAdmin is true to show add button
            ? [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddEditTourScreen()),
            ).then((_) => setState(() {})), // Reload list after adding/editing a tour
          ),
        ]
            : null,
      ),
      body: FutureBuilder<List<TourModel>>(
        future: _tourRepository.getAllTours(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final tours = snapshot.data ?? [];
          return ListView.builder(
            itemCount: tours.length,
            itemBuilder: (context, index) {
              final tour = tours[index];
              return ListTile(
                title: Text(tour.tourName ?? ''),
                subtitle: Text(tour.category ?? ''),
                trailing: widget.isAdmin // Check if isAdmin is true to show delete button
                    ? IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await _tourRepository.removeTour(tour.id!);
                    setState(() {}); // Reload list after deleting a tour
                  },
                )
                    : null,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditTourScreen(tourId: tour.id),
                  ),
                ).then((_) => setState(() {})), // Reload list after editing a tour
              );
            },
          );
        },
      ),
    );
  }
}
