import 'package:flutter/material.dart';
import 'package:travel_nepal/models/tourCategory_model.dart';// Adjust the import path to your TourCategoryModel
import 'package:travel_nepal/models/tour_model.dart'; // Import the TourModel
import 'package:travel_nepal/repositories/tourCategory_repo.dart';// Adjust the import path to your TourCategoryRepository
import 'package:travel_nepal/repositories/tour_repo.dart'; // Import the TourRepository

class TourCategoryViewModel with ChangeNotifier {
  final TourCategoryRepo _tourCategoryRepository = TourCategoryRepo();
  final TourRepository _tourRepository = TourRepository(); // Instantiate the TourRepository
  List<TourCategoryModel> _tourCategories = [];
  List<TourModel> _toursInSelectedCategory = []; // List to hold tours of the selected category

  List<TourCategoryModel> get tourCategories => _tourCategories;
  List<TourModel> get toursInSelectedCategory => _toursInSelectedCategory; // Getter for tours in the selected category

  Future<void> getTourCategories() async {
    _tourCategories = [];
    try {
      var response = await _tourCategoryRepository.getCategories();
      _tourCategories = response.map((doc) => doc.data()).toList();
      notifyListeners();
    } catch (e) {
      print(e);
      _tourCategories = [];
      notifyListeners();
    }
  }

  // Method to fetch tours by a selected category
  Future<void> fetchToursByCategory(String category) async {
    _toursInSelectedCategory = [];
    try {
      var tours = await _tourRepository.getToursByCategory(category);
      _toursInSelectedCategory = tours;
      notifyListeners();
    } catch (e) {
      print("Error fetching tours by category: $e");
      notifyListeners();
    }
  }
}
