import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:imagetopdf/config/navigation.dart';
import 'package:imagetopdf/pages/pdfPage/pdfImageSelectionPage.dart';
import 'package:imagetopdf/sevices/data.dart';
import 'package:imagetopdf/utils/colors.dart';

class EditPage extends StatefulWidget {
  final List<File> images;

  const EditPage({super.key, required this.images});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late List<File> _editedImages;

  @override
  void initState() {
    super.initState();
    _editedImages = List<File>.from(widget.images);
  }

  Future<void> _cropImage(int index) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: _editedImages[index].path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Edit Image',
          toolbarColor: colors.primary,
          toolbarWidgetColor: colors.themeColor,
          activeControlsWidgetColor: colors.primary,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
    if (croppedFile != null) {
      setState(() {
        _editedImages[index] = File(croppedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: colors.primary,
        title: const Text("Edit Images"),
        actions: [
          IconButton(
              onPressed: () {
                for (var i in _editedImages) {
                  ImageToPDFLogic.cropImagesList.add(i);
                }
                Navigations nav = Navigations();
                nav.replace(context, const SelectionImages());
              },
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ))
        ],
      ),
      body: PageView.builder(
        itemCount: _editedImages.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.file(
                    // height: 500,
                    width: double.infinity,
                    _editedImages[index],
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                width: 150,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _editedImages.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 5,
                            child: CircleAvatar(
                              backgroundColor:
                                  (i == index) ? Colors.white : Colors.black,
                              radius: 3,
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {
                        _cropImage(index);
                      },
                      icon: const Icon(
                        Icons.crop,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () {
                        _editedImages.removeAt(index);
                        setState(() {});
                      },
                      icon: const Icon(Icons.delete, color: Colors.white)),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
