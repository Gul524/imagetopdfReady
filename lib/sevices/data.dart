import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagetopdf/services/commons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart' as pdfp;
import 'package:imagetopdf/config/navigation.dart';
import 'package:imagetopdf/pages/pdfPage/pdfImageSelectionPage.dart';
import 'package:imagetopdf/pages/pdfPage/pdf_viewer_screen.dart';
import 'package:imagetopdf/utils/colors.dart';

class Errormsj {
  static String? fatchingPDFfilesFromDIR;
}

class OldPdf {
  static List<File> pdfFiles = [];
  static Directory? directory;
  static bool dirStatus = false;
  static String searchQuery = '';

  static Future<void> getDir() async {
    directory = await getExternalStorageDirectory();
    if (directory != null) {
      dirStatus = true;
    }
  }

  static Future<List<File>> fetchPdfFiles() async {
    List<File> files = [];
    Directory directory =
        Directory((await getExternalStorageDirectory())!.path);
    try {
      final entities = directory.listSync(recursive: true);
      for (FileSystemEntity entity in entities) {
        if (entity is File && entity.path.endsWith(".pdf")) {
          files.add(entity);
        }
      }
      files
          .sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      if (searchQuery.isNotEmpty) {
        files = files.where((file) {
          final fileName = file.path.split('/').last.toLowerCase();
          return fileName.contains(searchQuery.toLowerCase());
        }).toList();
      }
      pdfFiles = files;
      return pdfFiles;
    } catch (e) {
      Errormsj.fatchingPDFfilesFromDIR = e.toString();
      print("while fatching eror : $e");
    }
    return pdfFiles;
  }
}

class ImageToPDFLogic {
  static List<File> cropImagesList = [];
  static String? readyPdfPath;
  static File? currentPDF;
  static bool storingStatus = false;
  static String? filename;
  static TextEditingController fileNameTec = TextEditingController();
  static Function()? onImagesChanged;
  static bool isBlackAndWhite = false;
  static bool isFullPage = true;
  static String? pdfPath;
  static bool EPicImagests = true;
  static String EPicImage = "";
  static bool removeCamerafrombg = false;

  static Future<void> pickMultipleImages(context, bool fromHome) async {
    final ImagePicker imagePicker = ImagePicker();

    try {
      final List<XFile> images = await imagePicker.pickMultiImage();

      if (images.isNotEmpty) {
        for (XFile image in images) {
          cropImagesList.add(File(image.path));
        }
        //onImagesChanged?.call();
        Navigations nav = Navigations();
        if (fromHome) {
          nav.push(context, const SelectionImages());
        } else {
          nav.replace(context, const SelectionImages());
        }
      } else {
        Commons.showSnackbar(context, const Text("NO Image Selected"));
      }
    } catch (e) {
      Commons.showSnackbar(context, const Text("Improper Image Selection"));
    }
  }

  static Future<void> CropImage(
      BuildContext context, File image, int index) async {
    try {
      final croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Crop",
            toolbarColor: colors.primary,
            toolbarWidgetColor: colors.themeColor,
            lockAspectRatio: false,
            hideBottomControls: false,
            initAspectRatio: CropAspectRatioPreset.original,
            statusBarColor: colors.primary,
          ),
        ],
        compressQuality: 100,
      );

      if (croppedImage != null) {
        final processedImage = File(croppedImage.path);
        cropImagesList[index] = processedImage;
        onImagesChanged?.call();
      }
    } catch (e) {
      Commons.showSnackbar(context, Text("Failed to Crop : $e"));
    }
  }

  static generateName() {
    String fileName = "EasyScan_${DateTime.now().millisecondsSinceEpoch}.pdf";
    ImageToPDFLogic.fileNameTec.text = fileName;
  }

  static Future<void> newPdf(name, context) async {
    final pdfDocument = pw.Document();

    // Process images in parallel
    final futures = cropImagesList.map((image) async {
      final imgBytes = await image.readAsBytes();
      final processedBytes = imgBytes;
      return processedBytes;
    }).toList();

    final processedImages = await Future.wait(futures);

    // Add pages to PDF
    for (var processedBytes in processedImages) {
      final img = pw.MemoryImage(processedBytes);
      pdfDocument.addPage(
        pw.Page(
          margin: isFullPage
              ? const pw.EdgeInsets.all(5)
              : const pw.EdgeInsets.all(30),
          build: (context) => pw.Center(
            child: isFullPage
                ? pw.SizedBox(
                    width: pdfp.PdfPageFormat.a4.width - 10,
                    height: pdfp.PdfPageFormat.a4.height - 10,
                    child: pw.Image(img),
                  )
                : pw.Image(img),
          ),
        ),
      );
    }

    final tempDir = await getTemporaryDirectory();
    final tempPath = "${tempDir.path}/$name";
    currentPDF = File(tempPath);
    await currentPDF!.writeAsBytes(await pdfDocument.save());
    await storePdf(name, context);
  }

  static Future<void> storePdf(String name, context) async {
    storingStatus = false;

    String filePath = "${OldPdf.directory?.path}/$name.pdf";
    ImageToPDFLogic.filename = name;
    final pdfBytes = await currentPDF!.readAsBytes();
    await File(filePath).writeAsBytes(pdfBytes);
    readyPdfPath = filePath;
    currentPDF = File(filePath);
    ImageToPDFLogic.storingStatus = true;
    cropImagesList.clear();
    pdfPath = filePath;
  }

  static Future<void> viewCurrentPdf(BuildContext context) async {
    Navigations nav = Navigations();
    if (currentPDF != null) {
      nav.push(
        context,
        PDFViewerScreen(
          file: currentPDF!,
          fileName: fileNameTec.text,
        ),
      );
    } else {
      Commons.showSnackbar(context, const Text("no pdf to view"));
    }
  }
}
