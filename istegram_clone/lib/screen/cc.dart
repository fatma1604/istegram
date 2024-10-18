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
  int _selectedCameraIndex = 0;

  final List<String> _texts = ["Text 1", "Text 2", "Text 3", "Text 4"];

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

  Future<void> _takePicture(String selectedText) async {
    if (_cameraController == null || _initializeControllerFuture == null)
      return;

    await _initializeControllerFuture;
    final XFile picture = await _cameraController!.takePicture();

    // Navigate to TextPage with the selected text
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TextPage(text: selectedText, imagePath: picture.path),
      ),
    );
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
          return GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.delta.dy < -5) {
                _pickImage(ImageSource.gallery);
              }
            },
            child: Stack(
              children: [
                Container(color: Colors.black),
                if (snapshot.connectionState == ConnectionState.done)
                  CameraPreview(_cameraController!),
                if (_image != null)
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(File(_image!.path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                Positioned(
                  left: 10,
                  bottom: 80,
                  right: 20,
                  child: IconButton(
                    icon: Icon(Icons.camera, size: 30, color: Colors.white),
                    onPressed: () =>
                        _takePicture(_texts[0]), // Default to first text
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: IconButton(
                    icon: Icon(Icons.photo_library,
                        size: 30, color: Colors.white),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: IconButton(
                    icon: Icon(Icons.cached_rounded,
                        size: 30, color: Colors.white),
                    onPressed: _switchCamera,
                  ),
                ),
                Positioned(
                  left: 60,
                  right: 60,
                  bottom: 20,
                  child: Container(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _texts.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (_image != null) {
                              _takePicture(_texts[index]);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.center,
                            child: Text(
                              _texts[index],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TextPage extends StatelessWidget {
  final String text;
  final String imagePath;

  const TextPage({Key? key, required this.text, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Text Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(File(imagePath),
                fit: BoxFit.cover, height: 300), // Display the captured image
            SizedBox(height: 20),
            Text(
              text,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
