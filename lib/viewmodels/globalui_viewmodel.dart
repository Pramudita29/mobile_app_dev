import 'package:flutter/material.dart';

class GlobalUIViewModel with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  bool _isSubmittingForm = false;
  bool _isFetchingData = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isSubmittingForm => _isSubmittingForm;
  bool get isFetchingData => _isFetchingData;

  void loadState(bool state) {
    _isLoading = state;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }

  void setSuccessMessage(String? message) {
    _successMessage = message;
    notifyListeners();
  }

  void clearSuccessMessage() {
    _successMessage = null;
    notifyListeners();
  }

  void submitFormState(bool state) {
    _isSubmittingForm = state;
    notifyListeners();
  }

  void fetchDataState(bool state) {
    _isFetchingData = state;
    notifyListeners();
  }

// Additional methods for managing other global states can be added here.
}
