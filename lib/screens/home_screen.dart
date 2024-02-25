import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:travel_nepal/screens/ToursList_screen.dart';
import 'package:travel_nepal/screens/accountscreen.dart';
import 'package:travel_nepal/screens/categoryDetail_screen.dart'; // Adjust with your correct path
import 'package:travel_nepal/models/tourCategory_model.dart';
import 'package:travel_nepal/screens/myBooking_screen.dart'; // Adjust with your correct path

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<String> imgList = [
    'https://th.bing.com/th/id/R.1606e3b99be35b876fb03e1431937be8?rik=f%2b7seaGZ655xfg&pid=ImgRaw&r=0',
    'https://th.bing.com/th/id/R.45cf0b790a9b1207a79536539a41f76c?rik=swoPxffJrVBLMw&riu=http%3a%2f%2fwww.nepaltour.info%2fwp-content%2fuploads%2f2015%2f07%2fpokhara-e1477299796656.jpg&ehk=KDmV8OstD3VfGx4cVhhHlfiuGH6FCQvH7XXTcikaX8g%3d&risl=&pid=ImgRaw&r=0',
    'https://1.bp.blogspot.com/-mLCwndWxpoY/V0PL7WbAbWI/AAAAAAAAAiU/aTH51N-8fxcHhyteRMy6M0-dGUXGrc_aACKgB/s1600/elephant%2Bbath.jpg',
    'https://th.bing.com/th/id/OIP.ceMGKABR9btM-Kc9z7bY6wHaEw?rs=1&pid=ImgDetMain',
    'https://www.muchbetteradventures.com/magazine/content/images/size/w2000/2018/07/23114614/Mustang-Nepal-.jpg',
  ];

  final List<TourCategoryModel> categories = [
    TourCategoryModel(category: "Experience Culture", imageUrl: "https://3.bp.blogspot.com/-LxMkkClEIi0/WaLkWfnuFjI/AAAAAAAADeY/DEUhrqcvB4w_qKh8LZlXmlwM1X2Mexs0ACLcBGAs/s1600/Swayambhunath%2BStupa%2B%2528Monkey%2BTemple%2529%2Bin%2BKathmandu%2BNepal.jpg"),
    TourCategoryModel(category: "Experience Nature", imageUrl: "https://www.andbeyond.com/wp-content/uploads/sites/5/nepal-village.jpg"),
    TourCategoryModel(category: "Experience Trail", imageUrl: "https://th.bing.com/th/id/R.8241e53266074f267be4b79b557a2189?rik=83v4qhUeCnKkxA&pid=ImgRaw&r=0"),
    TourCategoryModel(category: "Experience Adrenaline", imageUrl: "https://th.bing.com/th/id/R.a300f9391ee8b8651abdacd7713352ad?rik=YJmQsl82%2bKznuA&pid=ImgRaw&r=0"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Home', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
              ),
              items: imgList.map((item) => ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(item, fit: BoxFit.cover, width: MediaQuery.of(context).size.width),
              )).toList(),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text('Categories', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: categories.length,
              itemBuilder: (ctx, i) {
                final category = categories[i];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryDetailScreen(category: category),
                    ),
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: GridTile(
                        footer: GridTileBar(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          title: Text(category.category ?? 'Unknown', style: TextStyle(color: Colors.white)),
                        ),
                        child: FadeInImage(
                          placeholder: AssetImage('assets/placeholder.png'), // Assuming you have a placeholder asset
                          image: NetworkImage(category.imageUrl ?? ''),
                          fit: BoxFit.cover,
                          fadeInDuration: Duration(milliseconds: 200),
                          fadeOutDuration: Duration(milliseconds: 200),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.tour), label: 'Tours'),
          BottomNavigationBarItem(icon: Icon(Icons.book_online), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
      // Stay on Home Screen
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (_) => UserTourListScreen()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (_) => MyBookingsScreen()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (_) => accountScreen()));
        break;
    }
  }
}