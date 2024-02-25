import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_nepal/models/booking_model.dart'; // Adjust the path as needed

class BookingRepository {
  final CollectionReference collection = FirebaseFirestore.instance.collection('bookings');

  // Add a new booking
  Future<void> addBooking(BookingModel booking) async {
    await collection.add(booking.toMap());
  }

  // Fetch bookings by user ID
  Future<List<BookingModel>> fetchBookingsByUserId(String userId) async {
    final querySnapshot = await collection.where('userId', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) => BookingModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }
  // Remove a booking by ID
  Future<void> removeBooking(String bookingId) async {
    await collection.doc(bookingId).delete();
  }

  // Update an existing booking
  Future<void> updateBooking(String bookingId, BookingModel updatedBooking) async {
    await collection.doc(bookingId).update(updatedBooking.toMap());
  }
}

