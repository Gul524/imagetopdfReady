import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:imagetopdf/camera/edit.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({super.key, required this.cameras});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  bool _isFlashOn = false;
  bool _isRearCamera = true;
  bool _isCameraInitialized = false;
  final List<File> _capturedImages = [];
  bool blink = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera(context);
  }

  void _initializeCamera(context) {
    _cameraController = CameraController(
      _isRearCamera ? widget.cameras.first : widget.cameras.last,
      ResolutionPreset.max,
      enableAudio: false,
    );
    _cameraController.initialize().then((_) {
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });

        _cameraController.lockCaptureOrientation(DeviceOrientation.portraitUp);
      }
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Camera Does Not Intialize")));
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    try {
      final image = await _cameraController.takePicture();
      setState(() {
        blink = true;
        _capturedImages.add(File(image.path));
      });
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        blink = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Camera Does Not Intialize")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return (!blink)
        ? Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                children: [
                  if (_isCameraInitialized)
                    Column(
                      children: [
                        Expanded(
                            flex: 4,
                            child: CameraPreview(
                              _cameraController,
                            )),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isRearCamera = !_isRearCamera;
                                    _initializeCamera(context);
                                  });
                                },
                                icon: const Icon(Icons.cameraswitch,
                                    color: Colors.white),
                                iconSize: 30,
                              ),
                              GestureDetector(
                                onTap: _captureImage,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              (_capturedImages.isNotEmpty)
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => EditPage(
                                                    images: _capturedImages)));
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 20),
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                              image: DecorationImage(
                                                image: FileImage(
                                                    _capturedImages.last),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              child: Text(_capturedImages.length
                                                  .toString()),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(0.0),
                                        child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: Icon(
                                              Icons.photo,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ),
                            ],
                          ),
                        )),
                      ],
                    )
                  else
                    const Center(
                        child: Text("Loading Camera...",
                            style: TextStyle(color: Colors.white))),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isFlashOn = !_isFlashOn;
                              _cameraController.setFlashMode(
                                _isFlashOn ? FlashMode.torch : FlashMode.off,
                              );
                            });
                          },
                          icon: Icon(
                            _isFlashOn ? Icons.flash_on : Icons.flash_off,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : const Scaffold(backgroundColor: Colors.black);
  }
}
