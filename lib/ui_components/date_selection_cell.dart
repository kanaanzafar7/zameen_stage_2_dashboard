import 'package:flutter/material.dart';
import 'package:zameen_stage_2_dashboard/utils/helper_functions.dart';

class DateSelectionCell extends StatelessWidget {
  final Function()? onTap;

  // final String? dateText;
// final DateTime? startDate;
// final DateTime? endDate;
  final DateTimeRange? dateTimeRange;

  DateSelectionCell({this.onTap, this.dateTimeRange});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(right: 30),
          width: 200,
          height: double.infinity,
          child: Center(
            child: dateTimeRange == null
                ? Text(
                    "Not Selected",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.grey.withOpacity(0.5)),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(getFormattedDateOnly(dateTimeRange!.start)),
                      Text("-"),
                      Text(getFormattedDateOnly(dateTimeRange!.end))
                    ],
                  ),
          ),
        ),
      ),
    );
    ;
  }
}
