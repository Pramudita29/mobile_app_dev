import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> register(UserModel user, String password) async {
    try {
      final response = await _firestore.collection('users').where("email", isEqualTo: user.email).get();
      if (response.docs.isNotEmpty) {
        throw Exception("User with this email already exists");
      }
      await _firestore.collection("users").add(user.toJson());
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      // IMPORTANT: This is a placeholder. Implement your password checking mechanism securely.
      final response = await _firestore.collection('users').where("email", isEqualTo: email).get();
      if (response.docs.isEmpty) {
        return null;
      }
      UserModel user = UserModel.fromJson(response.docs.first.data() as Map<String, dynamic>);
      // Add your password comparison logic here, ensuring it's done securely.
      return user;
    } catch (err) {
      print(err.toString());
      return null;
    }
  }
}
