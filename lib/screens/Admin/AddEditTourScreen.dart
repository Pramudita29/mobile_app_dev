import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travel_nepal/screens/register.dart';
import 'package:travel_nepal/models/tour_model.dart'; // Make sure this model has a 'category' field
import 'package:travel_nepal/repositories/tour_repo.dart';
import 'package:travel_nepal/screens/Admin/adminDashboard.dart';
import 'package:travel_nepal/screens/home_screen.dart';

class AddEditTourScreen extends StatefulWidget {
  final String? tourId;

  const AddEditTourScreen({Key? key, this.tourId}) : super(key: key);

  @override
  _AddEditTourScreenState createState() => _AddEditTourScreenState();
}

class _AddEditTourScreenState extends State<AddEditTourScreen> {
  final _formKey = GlobalKey<FormState>();
  final TourRepository _tourRepository = TourRepository();

  late String _tourName, _description, _imageUrl, _location, _selectedCategory;
  late double _price;

  // Define the list of categories
  final List<String> _categories = [
    'Experience Culture',
    'Experience Nature',
    'Experience Trails',
    'Experience Adrenaline',
  ];

  @override
  void initState() {
    super.initState();
    _tourName = '';
    _description = '';
    _imageUrl = '';
    _location = '';
    _price = 0;
    _selectedCategory = _categories.first; // Default to the first category

    if (widget.tourId != null) {
      _loadTourDetails();
    }
  }

  Future<void> _loadTourDetails() async {
    var tour = await _tourRepository.getOneTour(widget.tourId!);
    if (tour != null) {
      setState(() {
        _tourName = tour.tourName ?? '';
        _description = tour.description ?? '';
        _imageUrl = tour.imageUrl ?? '';
        _location = tour.location ?? '';
        _price = tour.price ?? 0;
        _selectedCategory = tour.category ?? _categories.first;
      });
    }
  }

  Future<void> _saveTour() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      TourModel tour = TourModel(
        tourName: _tourName,
        description: _description,
        imageUrl: _imageUrl,
        location: _location,
        price: _price,
        category: _selectedCategory,
      );
      bool isSuccess;
      if (widget.tourId == null) {
        // Adding a new tour
        isSuccess = await _tourRepository.addTour(tour);
      } else {
        // Editing an existing tour
        isSuccess = await _tourRepository.editTour(widget.tourId!, tour);
      }
      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tour saved successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save tour')));
      }
      Navigator.pop(context);
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
      appBar: AppBar(
        title: Text(widget.tourId == null ? 'Add Tour' : 'Edit Tour'),
        backgroundColor: Colors.blueGrey, // Your desired color
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: _tourName,
                  decoration: InputDecoration(labelText: 'Tour Name'),
                  onSaved: (value) => _tourName = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter a tour name' : null,
                ),
                TextFormField(
                  initialValue: _description,
                  decoration: InputDecoration(labelText: 'Description'),
                  onSaved: (value) => _description = value!,
                ),
                TextFormField(
                  initialValue: _location,
                  decoration: InputDecoration(labelText: 'Location'),
                  onSaved: (value) => _location = value!,
                ),
                TextFormField(
                  initialValue: _imageUrl,
                  decoration: InputDecoration(labelText: 'Image URL'),
                  onSaved: (value) => _imageUrl = value!,
                ),
                TextFormField(
                  initialValue: _price.toString(),
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _price = double.parse(value!),
                ),
                DropdownButtonFormField(
                  value: _selectedCategory,
                  decoration: InputDecoration(labelText: 'Category'),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                  onSaved: (value) => _selectedCategory = value!,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveTour,
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
