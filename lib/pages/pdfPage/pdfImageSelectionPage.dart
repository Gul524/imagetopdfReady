import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:imagetopdf/pages/pdfPage/readpdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:imagetopdf/camera/cam.dart';
import 'package:imagetopdf/config/navigation.dart';
import 'package:imagetopdf/pages/homepage/homewidgets.dart';
import 'package:imagetopdf/services/commons.dart';
import 'package:imagetopdf/sevices/data.dart';
import 'package:imagetopdf/sevices/permissionfunctions.dart';
import 'package:imagetopdf/utils/colors.dart';

class SelectionImages extends StatefulWidget {
  const SelectionImages({super.key});

  @override
  State<SelectionImages> createState() => _SelectionImagesState();
}

class _SelectionImagesState extends State<SelectionImages> {
  Navigations nav = Navigations();
  bool isGeneratingPDF = false; // Add a flag for tracking PDF generation status

  @override
  void initState() {
    super.initState();
    ImageToPDFLogic.onImagesChanged = () {
      setState(() {});
    };
  }

  PickImagefunction() async {
    await Permission.storage.request();
    if ((await DataPermission.checkStoragePermissions())) {
      await ImageToPDFLogic.pickMultipleImages(context, false);
    } else {
      Commons.showcustomDialog(
          context,
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Storage Permission Required",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: button(
                        text: "cancel",
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger(
                              child: SnackBar(
                            content: Text("Storage Permission is not given"),
                            duration: Duration(seconds: 2),
                          ));
                        },
                        mainbutton: false),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: button(
                        text: "Allow",
                        onPressed: () async {
                          openAppSettings();
                          Navigator.pop(context);
                        },
                        mainbutton: true),
                  )
                ],
              )
            ],
          ));
    }
  }

  camerafunction() async {
    await Permission.camera.request();
    if ((await DataPermission.checkCameraPermissions())) {
      List<CameraDescription> cameralist = await availableCameras();
      nav.replace(context, CameraScreen(cameras: cameralist));
    } else {
      Commons.showcustomDialog(
          context,
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Camera Permission required",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: button(
                        text: "cancel",
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        mainbutton: false),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: button(
                        text: "Allow",
                        onPressed: () async {
                          await openAppSettings();
                          Navigator.pop(context);
                        },
                        mainbutton: true),
                  )
                ],
              )
            ],
          ));
    }
  }

  void generatePDF() async {
    setState(() {
      isGeneratingPDF = true; // Show progress indicator
    });
    ImageToPDFLogic.generateName();
    Navigations nav = Navigations();
    nav.replace(context, const PreviewPage());

    setState(() {
      isGeneratingPDF = false; // Hide progress indicator
    });
  }

  deleteImage(int index) {
    setState(() {
      ImageToPDFLogic.cropImagesList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        foregroundColor: colors.themeColor,
        title: const Text("Selected Images"),
        actions: [
          if (ImageToPDFLogic.cropImagesList.isNotEmpty)
            IconButton(
              onPressed: generatePDF, // Trigger PDF generation
              icon: const Icon(Icons.check),
            )
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              if (ImageToPDFLogic.cropImagesList.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 64,
                          color: colors.primary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Select multiple images to create PDF",
                          style: TextStyle(
                            fontSize: 16,
                            color: colors.InvrsethemeColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: ImageToPDFLogic.cropImagesList.length,
                      itemBuilder: (context, index) {
                        return ImageContainer(
                          file: ImageToPDFLogic.cropImagesList[index],
                          index: index,
                          onDelete: () {
                            deleteImage(index);
                          },
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
          if (isGeneratingPDF)
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: ImagePickerButton(
        camfunc: camerafunction,
        galerypicfunc: PickImagefunction,
      ),
    );
  }
}

class ImageContainer extends StatelessWidget {
  final File file;
  final int index;
  final VoidCallback onDelete;

  const ImageContainer({
    super.key,
    required this.file,
    required this.index,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            ImageToPDFLogic.CropImage(context, file, index);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                file,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
        Positioned(
          top: 2,
          right: 2,
          child: IconButton(
            icon: Icon(
              Icons.delete,
              color: colors.primary,
            ),
            onPressed: onDelete,
          ),
        ),
      ],
    );
  }
}
