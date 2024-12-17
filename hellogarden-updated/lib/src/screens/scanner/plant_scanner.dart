import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class PlantScanner extends StatefulWidget {
  const PlantScanner({Key? key}) : super(key: key);

  @override
  State<PlantScanner> createState() => _PlantScannerState();
}

class _PlantScannerState extends State<PlantScanner> {
  CameraController? controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    // Request camera permission
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      return;
    }

    // Get available cameras
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    // Initialize controller
    controller = CameraController(
      cameras.first,
      ResolutionPreset.max,
      enableAudio: false,
    );

    try {
      await controller!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Camera Preview
          if (controller != null && controller!.value.isInitialized)
            CameraPreview(controller!),

          // Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 2.0,
                ),
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Capture Button
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                backgroundColor: Colors.green,
                child: const Icon(Icons.camera),
                onPressed: () async {
                  if (controller != null &&
                      controller!.value.isInitialized &&
                      !controller!.value.isTakingPicture) {
                    try {
                      final image = await controller!.takePicture();
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Image captured!'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      print('Image saved to: ${image.path}');
                    } catch (e) {
                      print('Error taking picture: $e');
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}