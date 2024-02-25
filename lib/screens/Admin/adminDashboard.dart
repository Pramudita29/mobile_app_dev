import 'package:flutter/material.dart';
import 'package:travel_nepal/screens/Admin/userManagement.dart';
import 'package:travel_nepal/screens/Admin/viewBooking_screen.dart';
import 'tourList_screen.dart'; // Screen to display list of tours

class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        backgroundColor: Colors.blueGrey, // Your desired color
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AdminTaskCard(
                title: "Manage Tours",
                icon: Icons.tour,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminTourListScreen(isAdmin: true)),
                  );
                },
              ),
              AdminTaskCard(
                title: "View Bookings",
                icon: Icons.book_online,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewBookingsScreen()),
                  );
                },
              ),
              AdminTaskCard(
                title: "User Management",
                icon: Icons.people,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserManagementScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminTaskCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const AdminTaskCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple), // Match the icon color with AppBar
        title: Text(title),
        onTap: onTap,
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
