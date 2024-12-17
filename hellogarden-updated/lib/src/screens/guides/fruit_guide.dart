import 'package:flutter/material.dart';

class FruitGuide extends StatelessWidget {
  const FruitGuide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4DE165),
      body: Column(
        children: [
          // Logo Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(5),
            child: Center(
              child: Image.asset(
                'assets/images/logo2.png',
                height: 80,
                width: 80,
              ),
            ),
          ),
          // Header
          Container(
            color: Colors.green[700],
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Fruit Growing Guide',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildGuideCard(
                  title: 'Strawberries',
                  content:
                      'Plant in spring. Needs full sun and well-drained soil.',
                  icon: Icons.spa,
                ),
                _buildGuideCard(
                  title: 'Blueberries',
                  content:
                      'Requires acidic soil. Plant multiple varieties for better yields.',
                  icon: Icons.grass,
                ),
                _buildGuideCard(
                  title: 'Apples',
                  content:
                      'Need full sun and good air circulation. Prune annually.',
                  icon: Icons.apple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.green[700], size: 30),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
