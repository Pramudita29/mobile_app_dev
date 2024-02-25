import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_nepal/models/booking_model.dart'; // Ensure this model path is correct

class ViewBookingsScreen extends StatefulWidget {
  @override
  _ViewBookingsScreenState createState() => _ViewBookingsScreenState();
}

class _ViewBookingsScreenState extends State<ViewBookingsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<BookingModel>> _fetchBookings() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('bookings').get();
      return snapshot.docs.map((doc) => BookingModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      print("Error fetching bookings: $e");
      return [];
    }
  }

  Future<void> _deleteBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).delete();
      // Show a snackbar message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking deleted successfully')));
      // Refresh the list of bookings
      setState(() {});
    } catch (e) {
      print("Error deleting booking: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting booking')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Bookings"),
        backgroundColor: Colors.blueGrey, // Your desired color
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<BookingModel>>(
        future: _fetchBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("An error occurred!"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                BookingModel booking = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(booking.tourName),
                    subtitle: Text("Date: ${booking.tourDate.toString()}, People: ${booking.numPersons}"),
                    trailing: Wrap(
                      spacing: 12, // space between two icons
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteBooking(booking.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("No bookings found!"));
          }
        },
      ),
    );
  }
}
