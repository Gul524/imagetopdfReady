import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:imagetopdf/pages/pdfPage/pdfImageSelectionPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:imagetopdf/config/navigation.dart';
import 'package:imagetopdf/pages/homepage/homewidgets.dart';
import 'package:imagetopdf/pages/pdfPage/pdf_viewer_screen.dart';
import 'package:imagetopdf/services/ad_service.dart';
import 'package:imagetopdf/services/appServices.dart';
import 'package:imagetopdf/camera/cam.dart';
import 'package:imagetopdf/services/commons.dart';
import 'package:imagetopdf/sevices/data.dart';
import 'package:imagetopdf/sevices/permissionfunctions.dart';
import 'package:imagetopdf/utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Navigations nav = Navigations();
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  BannerAd? bannerAd;

  viewPdf(File file, context) {
    nav.push(context,
        PDFViewerScreen(file: file, fileName: file.path.split('/').last));
  }

  void requesting() async {
    await DataPermission.requestCameraePermissions();
    await DataPermission.requestStoragePermissions();
  }

  @override
  void initState() {
    super.initState();
    requesting();
    AdService.loadAppOpenAd();
    AdService.showAppOpenAd();
    bannerAd = AdService.createBannerAd();
    OldPdf.getDir();
  }

  PickImagefunction() async {
    await Permission.storage.request();
    if ((await DataPermission.checkStoragePermissions())) {
      await ImageToPDFLogic.pickMultipleImages(context, true);
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
      nav.push(context, CameraScreen(cameras: cameralist));
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
                        onPressed: () {
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

  checkold() {
    Commons.showcustomDialog(
        context,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Your Last pdf Conversion is not completed"),
            const Text("Would you like to Continue"),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: button(
                      text: "No",
                      onPressed: () async {
                        ImageToPDFLogic.cropImagesList.clear();
                        Navigator.pop(context);
                        showOption(context, camerafunction, PickImagefunction);
                      },
                      mainbutton: false),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: button(
                      text: "Yes",
                      onPressed: () {
                        Navigator.pop(context);
                        nav.push(context, const SelectionImages());
                      },
                      mainbutton: true),
                )),
              ],
            )
          ],
        ));
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.picture_as_pdf_outlined,
            size: 64,
            color: colors.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: colors.InvrsethemeColor.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          if (OldPdf.searchQuery.isEmpty) ...[
            const SizedBox(height: 8),
            Text(
              "Create your first PDF by scanning documents",
              style: TextStyle(
                fontSize: 14,
                color: colors.InvrsethemeColor.withOpacity(0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: colors.primary,
        foregroundColor: colors.themeColor,
        onPressed: () {
          (ImageToPDFLogic.cropImagesList.isEmpty)
              ? showOption(context, camerafunction, PickImagefunction)
              : checkold();
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        foregroundColor: colors.themeColor,
        backgroundColor: colors.primary,
        title: isSearching
            ? TextField(
                controller: searchController,
                style: TextStyle(color: colors.themeColor),
                decoration: InputDecoration(
                  hintText: 'Search PDFs...',
                  hintStyle:
                      TextStyle(color: colors.themeColor.withOpacity(0.7)),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    OldPdf.searchQuery = value;
                  });
                },
              )
            : const Text(
                "Image to PDF",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                  if (!isSearching) {
                    searchController.clear();
                    OldPdf.searchQuery = '';
                  }
                });
              },
              icon: Icon(isSearching ? Icons.close : Icons.search))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              height: 100,
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: colors.primary.withOpacity(0.3)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: (AdService.bannerAd != null)
                    ? Center(
                        child: SizedBox(
                          height: bannerAd!.size.height.toDouble(),
                          width: bannerAd!.size.width.toDouble(),
                          child: AdWidget(ad: bannerAd!),
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.ad_units,
                                size: 40, color: colors.primary),
                            const SizedBox(height: 8),
                            Text(
                              "Advertisement Space",
                              style: TextStyle(
                                color: colors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                OldPdf.searchQuery.isEmpty ? "Recent PDFs" : "Search Results",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.InvrsethemeColor,
                ),
              ),
            ),
            Expanded(
                child: FutureBuilder(
              future: OldPdf.fetchPdfFiles(),
              builder: (context, snp) {
                if (snp.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snp.hasData) {
                  final data = snp.data;
                  if (data != null && data.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final file = data[index];
                        final fileName = file.path.split('/').last;
                        final modifiedDate = file.lastModifiedSync().toLocal();

                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: colors.themeColor,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.picture_as_pdf,
                                color: colors.primary,
                                size: 28,
                              ),
                            ),
                            title: Text(
                              fileName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            subtitle: Text(
                              "${modifiedDate.day}/${modifiedDate.month}/${modifiedDate.year}   ${modifiedDate.hour}:${modifiedDate.minute}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            trailing: SizedBox(
                              width: 100,
                              child: FittedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Appservices.fileShare(file.path);
                                        },
                                        icon: Icon(
                                          Icons.share,
                                          color: colors.primary,
                                          size: 30,
                                        )),
                                    IconButton(
                                        onPressed: () async {
                                          await Appservices.deleteFile(
                                              file.path);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(Messages.EdeleteMSj),
                                          ));
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: colors.primary,
                                          size: 30,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            onTap: () => viewPdf(file, context),
                          ),
                        );
                      },
                    );
                  }
                  return _buildEmptyState(OldPdf.searchQuery.isEmpty
                      ? "No PDF files found"
                      : "No matching PDFs found");
                }
                return _buildEmptyState("No PDF files found");
              },
            )),
          ],
        ),
      ),
    );
  }
}
