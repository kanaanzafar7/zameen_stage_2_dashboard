import 'package:flutter/material.dart';

class DateSelectionCell extends StatelessWidget {
  final String? buttonName;
  final Function()? onPressed;
  final String? dateText;

  DateSelectionCell(
      {this.buttonName, this.onPressed, this.dateText = "Not Selected"});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
            onPressed: onPressed,
            child: Text(
              buttonName ?? "",
              style: TextStyle(color: Colors.white),
            )),
        SizedBox(
          width: 25,
        ),
        Text(
          dateText ?? "Not Selected",
          style: TextStyle(
              decoration: TextDecoration.underline,
              color: dateText == null
                  ? Colors.grey.withOpacity(0.5)
                  : Colors.black),
        ),
      ],
    );
    ;
  }
}
