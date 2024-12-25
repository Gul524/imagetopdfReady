import 'dart:async';

import 'package:flutter/material.dart';
import 'package:imagetopdf/config/navigation.dart';
import 'package:imagetopdf/pages/homepage/homepage.dart';
import 'package:imagetopdf/pages/splashpage/splashwidgets.dart';
import 'package:imagetopdf/utils/assets.dart';
import 'package:imagetopdf/utils/colors.dart';

class Splashpage extends StatefulWidget {
  const Splashpage({super.key});

  @override
  State<Splashpage> createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {
  Navigations nav = Navigations();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      nav.replace(context, const HomePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colors.primary,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(""),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height: 100, width: 100, child: Image.asset(myImages.Logo)),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Easy",
                      style: TextStyle(
                          fontSize: 25,
                          color: colors.themeColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " Scan",
                      style: TextStyle(
                          fontSize: 35,
                          color: colors.InvrsethemeColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const LoadingAnimation()
              ],
            ),
            Text(
              " SNAGUL.ltd  ",
              style: TextStyle(
                  fontSize: 20,
                  color: colors.InvrsethemeColor,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
