import 'dart:async';

import 'package:flutter/material.dart';
import 'package:imagetopdf/config/navigation.dart';
import 'package:imagetopdf/pages/homepage/homepage.dart';
import 'package:imagetopdf/pages/splashpage/splashwidgets.dart';
import 'package:imagetopdf/utils/assets.dart';
import 'package:imagetopdf/utils/colors.dart';

class Splashpage extends StatelessWidget {
  const Splashpage({super.key});
  @override
  Widget build(BuildContext context) {
      Navigations nav = Navigations();
     Timer(const Duration(seconds: 2), () {
      nav.replace(context, const HomePage());
    });
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
