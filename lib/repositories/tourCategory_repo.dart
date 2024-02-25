import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tourCategory_model.dart'; // Ensure the model name has been correctly referenced

class TourCategoryRepo {
  CollectionReference<TourCategoryModel> categoryRef = FirebaseFirestore.instance.collection("tourCategories").withConverter<TourCategoryModel>(
    fromFirestore: (snapshot, _) => TourCategoryModel.fromFirebaseSnapshot(snapshot),
    toFirestore: (model, _) => model.toJson(),
  );

  Future<List<QueryDocumentSnapshot<TourCategoryModel>>> getCategories() async {
    try {
      final response = await categoryRef.get();
      return response.docs;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<DocumentSnapshot<TourCategoryModel>> getCategory(String categoryId) async {
    try {
      final response = await categoryRef.doc(categoryId).get();
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
