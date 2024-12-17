import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hellogarden/src/screens/guides/vegetable_guide.dart';
import 'package:hellogarden/src/screens/guides/fruit_guide.dart';
import 'package:hellogarden/src/screens/guides/compost_guide.dart';
import 'package:hellogarden/src/screens/guides/soil_guide.dart';
import 'package:hellogarden/src/screens/scanner/plant_scanner.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    SizedBox.shrink(), // Empty container for Home Page
    SizedBox.shrink(), // QR Scanner page
    SizedBox.shrink(), // Favorites page
    SizedBox.shrink(), // Profile page
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      // Open scanner
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PlantScanner()),
      );
      return;
    }
    
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onNewsTap(String newsTitle) {
    print('Clicked on: $newsTitle');
  }

  final List<String> newsImages = [
    'assets/images/plant1.jpg',
    'assets/images/plant2.jpg',
    'assets/images/plant3.jpg',
    'assets/images/plant4.jpg',
    'assets/images/plant5.jpg',
  ];

  void _onBoxTap(String label) {
    switch (label) {
      case 'Vegetables':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VegetableGuide()),
        );
        break;
      case 'Fruits':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FruitGuide()),
        );
        break;
      case 'Compost':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CompostGuide()),
        );
        break;
      case 'Soil':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SoilGuide()),
        );
        break;
    }
  }

  void _logout() {
    // Add your logout logic here (e.g., clear user session, token, etc.)
    print('User logged out');
    Navigator.of(context)
        .pushReplacementNamed('/login'); // Navigate to the login page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4DE165),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Logo Section
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(5),
              child: Center(
                child: Image.asset(
                  'assets/images/logo2.png',
                  height: 80,
                  width: 80,
                ),
              ),
            ),

            // Home Page Content (Search Bar, News Carousel, and Four Boxes)
            if (_selectedIndex == 0) ...[
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) {
                      print('Search query: $value');
                    },
                  ),
                ),
              ),

              // News Carousel
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 150,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                  ),
                  items: newsImages.map((imagePath) {
                    return GestureDetector(
                      onTap: () => _onNewsTap('News: $imagePath'),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Four Boxes
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _buildBox('Vegetables', Icons.grass),
                    _buildBox('Fruits', Icons.apple),
                    _buildBox('Compost', Icons.recycling),
                    _buildBox('Soil', Icons.landscape),
                  ],
                ),
              ),
            ],

            // Shop Page Content
            if (_selectedIndex == 1) _pages[1],
            if (_selectedIndex == 2) _pages[2],

            // Profile Page Content with Logout Button
            if (_selectedIndex == 3)
              Container(
                color: Color(0xFF4DE165),
                child: Column(
                  children: [
                    // Back button and title row
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _selectedIndex = 0; // Go back to home
                              });
                            },
                          ),
                          Text(
                            'Account & Settings',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // White container with options
                    Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          // Profile section
                          ListTile(
                            leading: Icon(Icons.person_outline),
                            title: Text('Abdurahman Pogi'),
                            trailing: Icon(Icons.keyboard_arrow_down),
                            onTap: () {
                              // Handle profile tap
                            },
                          ),
                          Divider(),

                          // Settings
                          ListTile(
                            leading: Icon(Icons.settings),
                            title: Text('Settings'),
                            onTap: () {
                              // Handle settings tap
                            },
                          ),
                          
                          // Help and Support
                          ListTile(
                            leading: Icon(Icons.help_outline),
                            title: Text('Help and Support'),
                            onTap: () {
                              // Handle help tap
                            },
                          ),

                          // Display
                          ListTile(
                            leading: Icon(Icons.dark_mode),
                            title: Text('Display'),
                            onTap: () {
                              // Handle display tap
                            },
                          ),

                          // Logout
                          ListTile(
                            leading: Icon(Icons.logout),
                            title: Text('Logout'),
                            onTap: _logout,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildBox(String label, IconData icon) {
    return GestureDetector(
      onTap: () => _onBoxTap(label),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.green),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
