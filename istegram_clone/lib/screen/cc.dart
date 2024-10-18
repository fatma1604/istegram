import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PhotoPicker extends StatefulWidget {
  @override
  _PhotoPickerState createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  int _selectedCameraIndex = 0; // Track the currently selected camera

  // List of messages for each page
  final List<String> _messages = [
    'Welcome to the Photo Picker!',
    'Swipe up for more options.',
    'Take a picture or choose from gallery.',
    'Enjoy capturing memories!'
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _cameraController = CameraController(
          cameras[_selectedCameraIndex], ResolutionPreset.high);
      _initializeControllerFuture = _cameraController!.initialize();
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    setState(() {
      _image = image;
    });
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || _initializeControllerFuture == null)
      return;

    await _initializeControllerFuture;
    final XFile picture = await _cameraController!.takePicture();
    setState(() {
      _image = picture;
    });
  }

  Future<void> _switchCamera() async {
    _selectedCameraIndex =
        (_selectedCameraIndex + 1) % (await availableCameras()).length;
    await _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          return Stack(
            children: [
              // Black background
              Container(color: Colors.black),
              if (snapshot.connectionState == ConnectionState.done)
                CameraPreview(_cameraController!),
              if (_image != null)
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(_image!.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Positioned(
                left: 10,
                bottom: 80,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.camera, size: 30, color: Colors.white),
                  onPressed: _takePicture,
                ),
              ),
              Positioned(
                left: 20,
                bottom: 20,
                child: IconButton(
                  icon:
                      Icon(Icons.photo_library, size: 30, color: Colors.white),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
              ),
              Positioned(
                right: 20,
                bottom: 20,
                child: IconButton(
                  icon:
                      Icon(Icons.cached_rounded, size: 30, color: Colors.white),
                  onPressed: _switchCamera,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 200, // Adjust height as needed
                child: PageView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.black,
                      alignment: Alignment.center,
                      child: Text(
                        _messages[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
