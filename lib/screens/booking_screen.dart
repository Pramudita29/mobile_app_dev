import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_nepal/models/tour_model.dart';
import 'package:travel_nepal/models/booking_model.dart';
import 'package:travel_nepal/repositories/booking_repo.dart';

class BookingScreen extends StatefulWidget {
  final TourModel tour;

  const BookingScreen({Key? key, required this.tour}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final BookingRepository _bookingRepo = BookingRepository();
  String _fullName = '';
  String _email = '';
  String _phone = '';
  DateTime? _tourDate;
  int _numPersons = 1;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tourDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _tourDate) {
      setState(() {
        _tourDate = picked;
      });
    }
  }

  void _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You need to be logged in to book a tour.')));
        return;
      }

      final BookingModel booking = BookingModel(
        fullName: _fullName,
        email: _email,
        phone: _phone,
        tourDate: _tourDate!,
        tourName: widget.tour.tourName ?? "Unknown Tour", // Provide a fallback value
        numPersons: _numPersons,
        totalPrice: (widget.tour.price ?? 0) * _numPersons,
        userId: userId,
      );


      try {
        await _bookingRepo.addBooking(booking);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking successful')));
        Navigator.pop(context);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit booking')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double _price = widget.tour.price ?? 0;
    double _totalPrice = _price * _numPersons;

    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.tour.tourName}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) => value!.isEmpty ? 'Please enter your full name' : null,
                onSaved: (value) => _fullName = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email Address'),
                validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
                onSaved: (value) => _phone = value!,
              ),
              ListTile(
                title: Text(_tourDate == null ? 'Pick a Date' : 'Tour Date: ${DateFormat('yyyy-MM-dd').format(_tourDate!)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _pickDate(context),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Number of Persons'),
                keyboardType: TextInputType.number,
                initialValue: _numPersons.toString(),
                onChanged: (value) {
                  setState(() {
                    _numPersons = int.tryParse(value) ?? 1;
                  });
                },
                validator: (value) {
                  if (value == null || int.tryParse(value) == null || int.parse(value) < 1) {
                    return 'Please enter a valid number of persons';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Price:', style: TextStyle(fontSize: 18)),
                    Text('\$${_price.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Price:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('\$${_totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _submitBooking,
                child: Text('Book This Tour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
