import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Add intl package to your pubspec.yaml for DateFormat

class BookingModel {
  String? id;
  final String fullName;
  final String email;
  final String phone;
  final DateTime tourDate;
  final String tourName;
  final int numPersons;
  final double totalPrice;
  final String userId;

  BookingModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.tourDate,
    required this.tourName,
    required this.numPersons,
    required this.totalPrice,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'tourDate': tourDate,
      'tourName': tourName,
      'numPersons': numPersons,
      'totalPrice': totalPrice,
      'userId': userId,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map, String documentId) {
    return BookingModel(
      id: documentId,
      fullName: map['fullName'],
      email: map['email'],
      phone: map['phone'],
      tourDate: (map['tourDate'] as Timestamp).toDate(),
      tourName: map['tourName'],
      numPersons: map['numPersons'],
      totalPrice: map['totalPrice'].toDouble(),
      userId: map['userId'],
    );
  }

  // Method to get formatted date string without time
  String get formattedTourDate {
    return DateFormat('yyyy-MM-dd').format(tourDate);
  }
}
