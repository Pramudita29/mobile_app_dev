import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_nepal/models/tour_model.dart';// Adjust the import path to your TourModel
import 'package:travel_nepal/repositories/tour_repo.dart';// Adjust the import path to your TourRepository
import 'package:travel_nepal/services/firebase_service.dart';// If you have centralized Firebase services
import 'package:travel_nepal/viewmodels/globalui_viewmodel.dart';// For managing global UI states

class TourViewModel with ChangeNotifier {
  TourRepository _tourRepository = TourRepository();
  List<TourModel> _tours = [];
  List<TourModel> get tours => _tours;

  Future<void> getTours() async {
    _tours = [];
    notifyListeners();
    try {
      var response = await _tourRepository.getAllTours();
      _tours = response; // Assuming getAllTours already returns List<TourModel>
      notifyListeners();
    } catch (e) {
      print(e);
      _tours = [];
      notifyListeners();
    }
  }


  Future<void> addTour(TourModel tour) async {
    try {
      await _tourRepository.addTour(tour); // Corrected call
      await getTours();
      notifyListeners();
    } catch (e) {
      print(e);
      notifyListeners();
    }
  }

  Future<void> editTour(TourModel tour, String tourId) async {
    try {
      await _tourRepository.editTour(tourId, tour); // Corrected call
      await getTours();
      notifyListeners();
    } catch (e) {
      print(e);
      notifyListeners();
    }
  }

  Future<void> deleteTour(String tourId) async {
    try {
      bool result = await _tourRepository.removeTour(tourId); // Assuming removeTour only needs tourId
      if (!result) {
        print("Failed to delete tour.");
        return;
      }
      await getTours();
      notifyListeners();
    } catch (e) {
      print("Error deleting tour: $e");
      notifyListeners();
    }
  }



}
