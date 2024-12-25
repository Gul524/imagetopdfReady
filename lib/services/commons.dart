import 'package:flutter/material.dart';
import 'package:imagetopdf/utils/colors.dart';

class Commons {
  static void showcustomDialog(BuildContext context, Widget widget) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: colors.themeColor,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(width: 1 , color: colors.primary),
            borderRadius: BorderRadius.circular(20),
            color: colors.themeColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: widget,
        ),
      );
    },
  );
}

  

  static showSnackbar(context, Widget widget) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: widget));
  }

  static showMaterialbanner(context, Widget widget, Widget ActionWidget) {
    ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(content: widget, actions: [ActionWidget]));
  }
}

class button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool mainbutton ;
  const button({super.key, required this.text, required this.onPressed, required this.mainbutton});

  @override
  Widget build(BuildContext context) {
    return (mainbutton)?ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(colors.primary),
        foregroundColor: WidgetStatePropertyAll(colors.themeColor),     
      ),
      onPressed:onPressed, child:Text(text) ):
      ElevatedButton(
  style: ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(colors.themeColor),
    foregroundColor: WidgetStateProperty.all(colors.primary),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0), // Optional: Rounded corners
        side: BorderSide(color: colors.primary, width: 2), // Border color and width
      ),
    ),
  ),
  onPressed: onPressed,
  child: Text(text),
);
  }
}
