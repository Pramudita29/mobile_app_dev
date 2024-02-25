// To parse this JSON data, do
//
//     final tourCategoryModel = tourCategoryModelFromJson(jsonString);

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

TourCategoryModel? tourCategoryModelFromJson(String str) => TourCategoryModel.fromJson(json.decode(str));

String tourCategoryModelToJson(TourCategoryModel? data) => json.encode(data!.toJson());

class TourCategoryModel {
  TourCategoryModel({
    this.category,
    this.imageUrl,
  });

  String? category;
  String? imageUrl;

  factory TourCategoryModel.fromJson(Map<String, dynamic> json) => TourCategoryModel(
    category: json["category"],
    imageUrl: json["imageUrl"],
  );

  factory TourCategoryModel.fromFirebaseSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) => TourCategoryModel(
    category: doc.data()!["category"],
    imageUrl: doc.data()!["imageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "category": category,
    "imageUrl": imageUrl,
  };
}
