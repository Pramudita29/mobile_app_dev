import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tour_model.dart'; // Ensure the model is correctly imported
import '../services/firebase_service.dart';

class TourRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reference to the tours collection
  CollectionReference get _tourRef => _firestore.collection("tours");

  // Fetch all tours
  Future<List<TourModel>> getAllTours() async {
    try {
      final QuerySnapshot snapshot = await _tourRef.get();
      return snapshot.docs.map((doc) => TourModel.fromFirebaseSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
    } catch (err) {
      print(err.toString());
      rethrow;
    }
  }

  // Fetch a single tour by ID
  Future<TourModel?> getOneTour(String tourId) async {
    try {
      final DocumentSnapshot doc = await _tourRef.doc(tourId).get();
      if (doc.exists) {
        return TourModel.fromFirebaseSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>);
      }
      return null; // Return null if the tour does not exist
    } catch (err) {
      print("Error fetching tour: $err");
      rethrow;
    }
  }

  // Fetch tours by category
  Future<List<TourModel>> getToursByCategory(String category) async {
    try {
      final QuerySnapshot snapshot = await _tourRef.where("category", isEqualTo: category).get();
      return snapshot.docs.map((doc) => TourModel.fromFirebaseSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
    } catch (err) {
      print(err.toString());
      rethrow;
    }
  }

  // Fetch tours from a list of tour IDs
  Future<List<TourModel>> getToursFromList(List<String> tourIds) async {
    try {
      final QuerySnapshot snapshot = await _tourRef.where(FieldPath.documentId, whereIn: tourIds).get();
      return snapshot.docs.map((doc) => TourModel.fromFirebaseSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
    } catch (err) {
      print(err.toString());
      rethrow;
    }
  }

  // Fetch tours created by a specific user
  Future<List<TourModel>> getMyTours(String userId) async {
    try {
      final QuerySnapshot snapshot = await _tourRef.where("userId", isEqualTo: userId).get();
      return snapshot.docs.map((doc) => TourModel.fromFirebaseSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
    } catch (err) {
      print(err.toString());
      rethrow;
    }
  }

  // Remove a tour
  Future<bool> removeTour(String tourId) async {
    try {
      await _tourRef.doc(tourId).delete();
      return true;
    } catch (err) {
      print("Error removing tour: $err");
      return false;
    }
  }

  // Add a new tour
  Future<bool> addTour(TourModel tour) async {
    try {
      await _tourRef.add(tour.toJson());
      return true;
    } catch (err) {
      print("Error adding tour: $err");
      return false;
    }
  }

  // Edit an existing tour
  Future<bool> editTour(String tourId, TourModel tour) async {
    try {
      await _tourRef.doc(tourId).update(tour.toJson());
      return true;
    } catch (err) {
      print("Error editing tour: $err");
      return false;
    }
  }
}
