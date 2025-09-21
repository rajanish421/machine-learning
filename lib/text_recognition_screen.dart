import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class TextRecognitionScreen extends StatefulWidget {
  const TextRecognitionScreen({super.key});

  @override
  State<TextRecognitionScreen> createState() => _TextRecognitionScreenState();
}

class _TextRecognitionScreenState extends State<TextRecognitionScreen> {
  File? _image;
  String _extractedText = '';
  final ImagePicker _imagePicker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();

  Future<void> pickedImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _recognizeText();
    }
  }

  Future<void> _recognizeText() async {
    if (_image == null) return;
    final InputImage inputImage = InputImage.fromFile(_image!);

    final RecognizedText recognizedText =
        await _textRecognizer.processImage(inputImage);
    setState(() {
      _extractedText = recognizedText.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text Recognition"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_image != null)
            Image.file(
              _image!,
              height: 200,
              width: 200,
            ),
          ElevatedButton(
            onPressed: pickedImage,
            child: Text("pick image"),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(8),
              child: Text(_extractedText),
            ),
          )
        ],
      ),
    );
  }
}
