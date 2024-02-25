import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

TourModel tourModelFromJson(String str) => TourModel.fromJson(json.decode(str));
String tourModelToJson(TourModel data) => json.encode(data.toJson());

class TourModel {
  TourModel({
    this.id,
    this.category,
    this.tourName,
    this.price,
    this.description,
    this.location,
    this.imageUrl,
  });

  String? id;
  String? category;
  String? tourName;
  double? price;
  String? description;
  String? location;
  String? imageUrl;

  factory TourModel.fromJson(Map<String, dynamic> json) => TourModel(
    id: json["id"],
    category: json["category"],
    tourName: json["tourName"],
    price: json["price"]?.toDouble(),
    description: json["description"],
    location: json["location"],
    imageUrl: json["imageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category,
    "tourName": tourName,
    "price": price,
    "description": description,
    "location": location,
    "imageUrl": imageUrl,
  };

  // Adjusted to properly use the DocumentSnapshot type
  factory TourModel.fromFirebaseSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return TourModel(
      id: snapshot.id, // Document ID
      category: data["category"],
      tourName: data["tourName"],
      price: data["price"]?.toDouble(),
      description: data["description"],
      location: data["location"],
      imageUrl: data["imageUrl"],
    );
  }
}
