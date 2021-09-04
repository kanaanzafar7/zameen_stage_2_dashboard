import 'package:flutter/material.dart';

class DashboardPrimaryButton extends StatelessWidget {
  final String? buttonName;
  final Function()? onPressed;

  DashboardPrimaryButton({this.buttonName, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        buttonName ?? "",
        style: TextStyle(color: Colors.blue),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        // textStyle: TextStyle(color: Colors.blue),
      ),
    );
  }
}
