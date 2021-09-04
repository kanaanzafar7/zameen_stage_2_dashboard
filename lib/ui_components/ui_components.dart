import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:zameen_stage_2_dashboard/models/user_feedback.dart';

//Table headers
DataColumn headerTextDataColumn(
    String label, void onSort(int columnIndex, bool ascending)) {
  return DataColumn(
    label: Text(
      label,
      style: TextStyle(
        color: Colors.blue,
      ),
      textAlign: TextAlign.center,
    ),
    onSort: onSort,
  );
}

//Table record
DataRow getFeedbackRow(UserFeedback? userFeedback) {
  return DataRow(cells: [
    getDataCell(userFeedback?.feedbackDateString),
    getDataCell(userFeedback?.userId),
    getDataCell(userFeedback?.userName),
    getDataCell(userFeedback?.userMobile),
    getDataCell(userFeedback?.feedbackRating),
    getDataCell(userFeedback?.feedbackComment),
    getDataCell(userFeedback?.deviceOs),
    getDataCell(userFeedback?.appVersion),
    getDataCell(userFeedback?.deviceModel),
    getDataCell(userFeedback?.userEmail),
  ]);
}

//Single cell in record
DataCell getDataCell(String? value) {
  return DataCell(
    Text(
      value ?? "",
      textAlign: TextAlign.center,
      textScaleFactor: 0.8,
    ),
  );
}




Widget selectDateWidget(
    {final String buttonName = "",
      final Function()? onPressed,
      final String? dateText = "Not Selected"}) {
  return Row(
    children: [
      ElevatedButton(
          onPressed: onPressed,
          child: Text(
            buttonName,
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
}


Future<DateTime?> selectDate(
    BuildContext context, DateTime? limitDate) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: limitDate ?? DateTime.now(),
    initialDatePickerMode: DatePickerMode.day,
    firstDate: DateTime(2015),
    lastDate: DateTime.now(), //DateTime(2101),
  );
  if (picked != null) limitDate = picked;

  return limitDate;
}

showAlert(BuildContext context) {
  showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content:
          Text("Ending date must not be greater than starting date."),
          actions: [
            CupertinoDialogAction(
              child: Text("Okay"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      });
}


showLoading(BuildContext context) {
  Loader.show(context,
      isSafeAreaOverlay: false,
      isAppbarOverlay: true,
      isBottomBarOverlay: false,
      progressIndicator: CupertinoActivityIndicator(),
      // themeData: Theme.of(context).copyWith(accentColor: Colors.black38),
      // overlayColor: Color(0x99E8EAF6),
  );
}

hideLoading() {
  Loader.hide();
}