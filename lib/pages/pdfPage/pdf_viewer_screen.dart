import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:imagetopdf/utils/colors.dart';

class PDFViewerScreen extends StatelessWidget {
  final File file;
  final String fileName;

  const PDFViewerScreen({
    super.key,
    required this.file,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        foregroundColor: colors.themeColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          fileName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: PDFView(
          filePath: file.path,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: true,
          pageFling: true,
          pageSnap: true,
          defaultPage: 0,
          fitPolicy: FitPolicy.BOTH,
          preventLinkNavigation: false,
          onError: (error) {
            print('PDF Error: $error');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error loading PDF: $error'),
                backgroundColor: colors.primary,
              ),
            );
          },
          onPageError: (page, error) {
            print('Page $page: $error');
          },
          onViewCreated: (PDFViewController pdfViewController) {
            // PDF loaded successfully
          },
        ),
      ),
    );
  }
}
