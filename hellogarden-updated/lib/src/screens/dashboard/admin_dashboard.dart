import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final TextEditingController _plantNameController = TextEditingController();
  final TextEditingController _plantDescriptionController =
      TextEditingController();
  String _selectedCategory = 'Vegetables';
  XFile? _selectedImage;

  // Placeholder list for plant data
  final List<Map<String, dynamic>> _plants = [];

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
      _showSnackBar('Image selected successfully');
    } else {
      _showSnackBar('No image selected');
    }
  }

  Future<String?> _uploadImage(XFile image) async {
    try {
      // Read image as bytes
      final bytes = await image.readAsBytes();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';

      // Upload the file to the storage bucket
      final response = await Supabase.instance.client.storage
          .from('plant_images')
          .uploadBinary(fileName, bytes);

      // Check if the upload was successful
      if (response.isNotEmpty) {
        // Generate the public URL for the uploaded file
        final publicUrl = Supabase.instance.client.storage
            .from('plant_images')
            .getPublicUrl(fileName);

        if (publicUrl.isNotEmpty) {
          return publicUrl;
        } else {
          _showSnackBar('Failed to generate public URL');
          return null;
        }
      } else {
        // Handle the error if `response` is empty
        _showSnackBar('Image upload failed. The response was empty.');
        return null;
      }
    } catch (error) {
      // Handle any unexpected errors
      print('Upload error: $error');
      _showSnackBar('An error occurred during image upload: $error');
      return null;
    }
  }

  Future<void> _addPlant() async {
    if (_plantNameController.text.isEmpty ||
        _plantDescriptionController.text.isEmpty ||
        _selectedImage == null) {
      _showSnackBar('Please fill all fields and select an image');
      return;
    }

    final imageUrl = await _uploadImage(_selectedImage!);
    if (imageUrl == null) return;

    setState(() {
      _plants.add({
        'name': _plantNameController.text,
        'description': _plantDescriptionController.text,
        'category': _selectedCategory,
        'imageUrl': imageUrl,
      });
      _plantNameController.clear();
      _plantDescriptionController.clear();
      _selectedImage = null;
      _selectedCategory = 'Vegetables';
    });

    _showSnackBar('Plant added successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4DE165),
      body: SingleChildScrollView(
        child: Column(
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Add Plant Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Add New Plant',
                                style: GoogleFonts.openSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.logout,
                                    color: Colors.redAccent),
                                onPressed: () => Navigator.pushReplacementNamed(
                                    context, '/login'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Plant Form Fields
                          _buildFormField(
                            controller: _plantNameController,
                            label: 'Plant Name',
                            icon: Icons.local_florist,
                          ),
                          const SizedBox(height: 12),
                          _buildFormField(
                            controller: _plantDescriptionController,
                            label: 'Description',
                            icon: Icons.description,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 12),
                          _buildCategoryDropdown(),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _pickImage,
                                  icon: const Icon(Icons.image),
                                  label: const Text('Select Image'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4DE165),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _addPlant,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4DE165),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('Add Plant'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Plant List Section
                  Text(
                    'Plant List',
                    style: GoogleFonts.openSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPlantList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.green[700]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: InputDecoration(
          labelText: 'Category',
          prefixIcon: Icon(Icons.category, color: Colors.green[700]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        items: ['Vegetables', 'Fruits'].map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedCategory = newValue!;
          });
        },
      ),
    );
  }

  Widget _buildPlantList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _plants.length,
      itemBuilder: (context, index) {
        final plant = _plants[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                plant['imageUrl'],
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              plant['name'],
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              plant['description'],
              style: GoogleFonts.openSans(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showSnackBar('Edit functionality'),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() => _plants.removeAt(index));
                    _showSnackBar('Plant deleted');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
