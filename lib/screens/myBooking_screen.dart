import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_nepal/models/booking_model.dart'; // Adjust the import path
import 'package:travel_nepal/repositories/booking_repo.dart'; // Adjust the import path

class MyBookingsScreen extends StatefulWidget {
  @override
  _MyBookingsScreenState createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final BookingRepository _bookingRepository = BookingRepository();
  Future<List<BookingModel>>? _bookingsFuture;

  @override
  void initState() {
    super.initState();
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      _bookingsFuture = _bookingRepository.fetchBookingsByUserId(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
      ),
      body: FutureBuilder<List<BookingModel>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred while fetching your bookings'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No bookings found'));
          }

          final bookings = snapshot.data!;
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(booking.tourName),
                  subtitle: Text("${booking.tourDate} - ${booking.numPersons} persons - Total: \$${booking.totalPrice}"),
                  onTap: () {
                    // Navigate to booking detail page if needed
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
