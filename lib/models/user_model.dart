import 'dart:convert';

class UserModel {
  UserModel({
    this.id,
    this.userId,
    this.fullname,
    this.email,
    this.preferredCategories,
    this.favoriteTours,
    this.isAdmin,
  });

  String? id;
  String? userId;
  String? fullname;
  String? email;
  List<String>? preferredCategories;
  List<String>? favoriteTours;
  bool? isAdmin;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    userId: json["userId"],
    fullname: json["fullname"],
    email: json["email"],
    preferredCategories: List<String>.from(json["preferredCategories"] ?? []),
    favoriteTours: List<String>.from(json["favoriteTours"] ?? []),
    isAdmin: json["isAdmin"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "fullname": fullname,
    "email": email,
    "preferredCategories": preferredCategories,
    "favoriteTours": favoriteTours,
    "isAdmin": isAdmin,
  };
}
