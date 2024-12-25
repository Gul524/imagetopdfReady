import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:imagetopdf/pages/homepage/homepage.dart';
import 'package:imagetopdf/pages/homepage/homewidgets.dart';
import 'package:imagetopdf/services/ad_service.dart';
import 'package:imagetopdf/services/appServices.dart';
import 'package:imagetopdf/services/commons.dart';
import 'package:imagetopdf/sevices/data.dart';
import 'package:imagetopdf/utils/assets.dart';
import 'package:imagetopdf/utils/colors.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({super.key});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  bool isStoringComplete = false;
  BannerAd? bannerAd = AdService.secondBannerAd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bannerAd = AdService.createSecondBannerAd();
    AdService.loadRewardedInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
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
              child: (AdService.secondBannerAd != null)
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
                          Icon(Icons.ad_units, size: 40, color: colors.primary),
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
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
                height: 100, width: 100, child: Image.asset(myImages.Logo)),
          ),
          if (!isStoringComplete) ...[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: (!isStoringComplete)
                  ? TextField(
                      controller: ImageToPDFLogic.fileNameTec,
                      enabled: !isStoringComplete,
                      decoration: const InputDecoration(
                        labelText: 'File Name',
                        border: OutlineInputBorder(),
                      ),
                    )
                  : const Text(
                      "",
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PDF Options",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colors.InvrsethemeColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    title: Text(
                      'Full Page Images',
                      style: TextStyle(color: colors.InvrsethemeColor),
                    ),
                    value: ImageToPDFLogic.isFullPage,
                    onChanged: (bool value) {
                      setState(() {
                        ImageToPDFLogic.isFullPage = value;
                      });
                    },
                    activeColor: colors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            MyButton(
              text: "SAVE",
              onTap: () async {
                if (ImageToPDFLogic.cropImagesList.isEmpty) {
                  Commons.showSnackbar(
                      context, const Text('No Images Selected'));
                  return;
                }

                try {
                  AdService.showRewardedInterstitialAd(() {});
                  await ImageToPDFLogic.newPdf(
                      ImageToPDFLogic.fileNameTec.text, context);

                  if (ImageToPDFLogic.storingStatus) {
                    setState(() => isStoringComplete = true);
                    Commons.showSnackbar(
                      context,
                      const Text('PDF saved successfully!'),
                    );
                  }
                } catch (e) {
                  Commons.showSnackbar(
                    context,
                    Text(
                      'Failed to save PDF: $e',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }
              },
            ),
          ] else
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "File saved as:",
                        style: TextStyle(
                          color: colors.InvrsethemeColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        ImageToPDFLogic.fileNameTec.text,
                        style: TextStyle(
                          color: colors.InvrsethemeColor,
                          fontSize: 22,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          ImageToPDFLogic.pdfPath ?? '',
                          style: TextStyle(
                            color: colors.InvrsethemeColor.withOpacity(0.8),
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: colors.themeColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                              (route) => false,
                            );
                          },
                          icon: const Icon(Icons.home),
                          label: const Text('Go Home'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: colors.themeColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            ImageToPDFLogic.viewCurrentPdf(context);
                          },
                          icon: const Icon(Icons.picture_as_pdf),
                          label: const Text('View PDF'),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: button(
                            text: "Share",
                            onPressed: () {
                              Appservices.fileShare(
                                  ImageToPDFLogic.pdfPath.toString());
                            },
                            mainbutton: true),
                      ),
                    ],
                  ),
                )
              ],
            ),
        ],
      ),
    ));
  }
}
