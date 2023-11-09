import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shopping_checkpoint_app/editlist.dart';
import 'package:shopping_checkpoint_app/aftercamera.dart';

class CameraScreen extends StatefulWidget {
  final SList slist;

  const CameraScreen({Key? key, required this.slist}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState(slist);
}

class _CameraScreenState extends State<CameraScreen> {
  late final CameraController _controller;
  final SList slist;

  _CameraScreenState(this.slist);

  // Initializes camera controller to preview on screen
  void _initializeCamera() async {
    final CameraController cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
    );
    _controller = cameraController;

    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  // Takes picture with the selected device camera, and
  // returns the image path
  Future<String?> _takePicture() async {
    if (!_controller.value.isInitialized) {
      print("Controller is not initialized");
      return null;
    }

    String? imagePath;

    if (_controller.value.isTakingPicture) {
      print("Processing is progress ...");
      return null;
    }

    try {
      // Turning off the camera flash
      _controller.setFlashMode(FlashMode.off);
      // Returns the image in cross-platform file abstraction
      final XFile file = await _controller.takePicture();
      // Retrieving the path
      imagePath = file.path;
    } on CameraException catch (e) {
      print("Camera Exception: $e");
      return null;
    }

    return imagePath;
  }

  @override
  void initState() {
    _initializeCamera();
    super.initState();
  }

  @override
  void dispose() {
    // dispose the camera controller when navigated
    // to a different page
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ML camera'),
      ),
      body: _controller.value.isInitialized
          ? Stack(
              children: <Widget>[
                CameraPreview(_controller),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.camera),
                      label: const Text("Click"),
                      onPressed: () async {
                        // If the returned path is not null navigate
                        // to the DetailScreen
                        await _takePicture().then((String? path) {
                          if (path != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                  imagePath: path,
                                  slist: slist,
                                ),
                              ),
                            );
                          } else {
                            print('Image path not found!');
                          }
                        });
                      },
                    ),
                  ),
                )
              ],
            )
          : Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}