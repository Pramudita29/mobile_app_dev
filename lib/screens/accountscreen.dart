import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_nepal/screens/edit_accountscreen.dart';
import 'package:travel_nepal/screens/myBooking_screen.dart';
import 'login.dart'; // Adjust the import path to your login screen

class accountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<accountScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? _fullName;
  String? _email;
  String _initials = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    if (user != null) {
      DocumentSnapshot userData = await firestore.collection('users').doc(user!.uid).get();
      setState(() {
        _fullName = userData['fullName'];
        _email = user!.email;
        _initials = _fullName!.split(' ').map((name) => name[0]).take(2).join().toUpperCase();
      });
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  Future<void> _navigateAndRefreshProfile() async {
    // Wait for the EditProfilePage to pop and check if the profile was updated
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(),
      ),
    );

    // If the profile was updated, refresh the user data
    if (result == true) {
      _loadUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Text(
                _initials,
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            SizedBox(height: 8),
            Text(_fullName ?? "No Name", style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 4),
            Text(_email ?? "No Email", style: Theme.of(context).textTheme.bodyText2),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Account'),
              onTap: _navigateAndRefreshProfile,
            ),
            ListTile(
              leading: Icon(Icons.book_online),
              title: Text('My Bookings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyBookingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
