import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AnalyseSurrounding extends StatefulWidget {
  final String title;

  const AnalyseSurrounding({super.key, required this.title});

  @override
  State<AnalyseSurrounding> createState() => _AnalyseSurroundingState();
}

class _AnalyseSurroundingState extends State<AnalyseSurrounding> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final ImageLabeler _imageLabeler = GoogleMlKit.vision.imageLabeler();
  final FlutterTts _flutterTts = FlutterTts();
  String _resultText = "Capturing image...";

  @override
  void initState() {
    super.initState();
    getImageFromCamera();
  }

  // Function to get an image from the camera
  Future<void> getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _resultText = "Processing image...";
      });

      analyzeImage(_imageFile!);
    }
  }

  // Function to analyze the image using ML Kit
  Future<void> analyzeImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final List<ImageLabel> labels = await _imageLabeler.processImage(inputImage);

    if (labels.isNotEmpty) {
      String detectedObjects = labels.map((label) => label.label).join(", ");
      setState(() {
        _resultText = "Detected: $detectedObjects";
      });

      // Speak out the detected result
      speakResult(_resultText);
    } else {
      setState(() {
        _resultText = "No objects detected.";
      });

      speakResult(_resultText);
    }
  }

  // Function to speak out the result
  Future<void> speakResult(String text) async {
    await _flutterTts.speak(text);
  }

  @override
  void dispose() {
    _imageLabeler.close();
    super.dispose();
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
          children: [
            _imageFile != null
                ? Image.file(_imageFile!, height: 200)
                : const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              _resultText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}