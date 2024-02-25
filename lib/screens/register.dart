import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart'; // Ensure this file exists for navigation

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        _showErrorDialog('Error', 'Passwords do not match.');
        return;
      }

      setState(() => _isLoading = true);

      try {
        // Create user with Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        // Add additional user details to Firestore
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'fullName': fullNameController.text,
          'email': emailController.text.trim(),
          // You can add more fields as needed
        });

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } on FirebaseAuthException catch (e) {
        _showErrorDialog('Registration Failed', e.message ?? 'An error occurred. Please try again later.');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFc9d6ff), Color(0xFFe2e2e2)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2c3e50),
                      fontFamily: 'FairPlay',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Join us and explore the beauty of Nepal!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2c3e50),
                      fontFamily: 'FairPlay',
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    hint: 'Full Name',
                    controller: fullNameController,
                    isObscure: false,
                    fontFamily: 'FairPlay',
                  ),
                  CustomTextField(
                    hint: 'Email',
                    controller: emailController,
                    isObscure: false,
                    fontFamily: 'FairPlay',
                  ),
                  CustomTextField(
                    hint: 'Password',
                    controller: passwordController,
                    isObscure: true,
                    fontFamily: 'FairPlay',
                  ),
                  CustomTextField(
                    hint: 'Confirm Password',
                    controller: confirmPasswordController,
                    isObscure: true,
                    fontFamily: 'FairPlay',
                  ),
                  SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFfa8072),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: _register,
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'FairPlay',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen())),
                    child: Text(
                      'Already have an account? Login',
                      style: TextStyle(
                        color: Color(0xFF2c3e50),
                        fontFamily: 'FairPlay',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool isObscure;
  final String fontFamily;

  CustomTextField({
    Key? key,
    required this.hint,
    required this.controller,
    required this.isObscure,
    required this.fontFamily,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        border: UnderlineInputBorder(),
      ),
    );
  }
}
