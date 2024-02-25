import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Admin/adminDashboard.dart';
import 'home_screen.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '', _password = '';
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);

    // Hardcoded admin credentials
    const String adminEmail = "admin@gmail.com";
    const String adminPassword = "admin123";

    if (_email.trim() == adminEmail && _password == adminPassword) {
      // Navigate to Admin Dashboard if the hardcoded admin credentials are used
      _navigateTo(AdminDashboardScreen());
    } else {
      // Continue with Firebase Authentication for other users
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email.trim(),
          password: _password,
        );

        // Optionally check Firestore for additional user details
        // For example, checking if a user is an admin stored in Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();
        bool isAdmin = userDoc['isAdmin'] ?? false;  // This assumes you have an isAdmin field in Firestore for other admin users
        _navigateTo(isAdmin ? AdminDashboardScreen() : HomeScreen());
      } on FirebaseAuthException catch (e) {
        _showLoginError("Login failed: ${e.message}");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _navigateTo(Widget route) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => route));
  }

  void _showLoginError(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Login Error'),
        content: Text(message),
        actions: [
          TextButton(child: Text('OK'), onPressed: () => Navigator.of(ctx).pop()),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFc9d6ff), Color(0xFFe2e2e2)],
          ),
        ),
        child: Stack(
          children: [
            Opacity(
              opacity: 0.1,
              child: SvgPicture.asset('assets/pattern.svg', fit: BoxFit.cover),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Nepal भ्रमण',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2c3e50),
                          letterSpacing: 2,
                          fontFamily: 'FairPlay',
                        ),
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        hint: 'Email',
                        onChanged: (value) => _email = value,
                        isObscure: false,
                        fontFamily: 'FairPlay',
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        hint: 'Password',
                        onChanged: (value) => _password = value,
                        isObscure: true,
                        fontFamily: 'FairPlay',
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFfa8072),
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: _login,
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'FairPlay',
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen())),
                        child: Text(
                          'Don\'t have an account? Register',
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
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final Function(String) onChanged;
  final bool isObscure;
  final String fontFamily;

  CustomTextField({
    Key? key,
    required this.hint,
    required this.onChanged,
    required this.isObscure,
    required this.fontFamily,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        border: UnderlineInputBorder(),
      ),
    );
  }
}
