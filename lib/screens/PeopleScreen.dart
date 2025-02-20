import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Peoplescreen extends StatefulWidget {
  final String title;

  const Peoplescreen({super.key, required this.title});

  @override
  State<Peoplescreen> createState() => _PeoplescreenState();
}

class _PeoplescreenState extends State<Peoplescreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final Map<String, File> _records = {}; // Stores name-image pairs

  // Function to open the bottom sheet
  void _openImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  getImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  getImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to get an image from the gallery
  Future<void> getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _showNameInputDialog(); // Prompt user to enter a name
    }
  }

  // Function to get an image from the camera
  Future<void> getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _showNameInputDialog(); // Prompt user to enter a name
    }
  }

  // Function to show a dialog for entering a name
  void _showNameInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Name'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _saveRecord(); // Save the record
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to save the record (name and image)
  void _saveRecord() {
    if (_nameController.text.isNotEmpty && _imageFile != null) {
      setState(() {
        _records[_nameController.text] = _imageFile!; // Save the record
      });
      _nameController.clear(); // Clear the text field
      _imageFile = null; // Clear the image
    }
  }

  // Function to search for a record by name
  void _searchRecord() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Record'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Enter Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _displayRecord(_nameController.text); // Display the record
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  // Function to display the searched record
  void _displayRecord(String name) {
    if (_records.containsKey(name)) {
      setState(() {
        _imageFile = _records[name]; // Set the image to display
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record not found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: _openImagePickerBottomSheet, // Open bottom sheet
              child: const Text("Add Person"),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: _searchRecord, // Search for a record
              child: const Text("Detect Person"),
            ),
            if (_imageFile != null) // Display the selected image
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.file(_imageFile!),
              ),
          ],
        ),
      ),
    );
  }
}