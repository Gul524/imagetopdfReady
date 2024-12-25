import 'package:flutter/material.dart';
import 'package:imagetopdf/pages/splashpage/splashview.dart';
import 'package:imagetopdf/services/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdService.initializeAds();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splashpage(),
    );
  }
}
