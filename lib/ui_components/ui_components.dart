import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:zameen_stage_2_dashboard/models/user_feedback.dart';
import 'package:zameen_stage_2_dashboard/utils/dashboard_constants.dart';

//Table headers
DataColumn headerTextDataColumn(String label,
    void onSort(int columnIndex, bool ascending), BuildContext context) {
  return DataColumn(
    label: Container(
      width: MediaQuery.of(context).size.width / 11,
      child: Text(
        label,
        style: TextStyle(
            // color: Colors.blue,
            color: Color(DashboardConstants.dashboardPrimaryColor)),
        textAlign: TextAlign.center,
      ),
    ),
    onSort: onSort,
  );
}

//Table record
DataRow getFeedbackRow(
    int index, UserFeedback? userFeedback, BuildContext context) {
  return DataRow(cells: [
    getDataCell(index.toString(), context),
    getDataCell(userFeedback?.feedbackDateString, context),
    getDataCell(userFeedback?.userId, context),
    getDataCell(userFeedback?.userName, context),
    getDataCell(userFeedback?.userMobile, context),
    getDataCell(userFeedback?.feedbackRating, context),
    getDataCell(userFeedback?.feedbackComment, context),
    getDataCell(userFeedback?.deviceOs, context),
    getDataCell(userFeedback?.appVersion, context),
    getDataCell(userFeedback?.deviceModel, context),
    getDataCell(userFeedback?.userEmail, context),
  ]);
}

//Single cell in record
DataCell getDataCell(String? value, BuildContext context) {
  return DataCell(
    Container(
      width: MediaQuery.of(context).size.width / 11,
      child: Text(
        value ?? "",
        textAlign: TextAlign.center,
        textScaleFactor: 0.8,
      ),
    ),
  );
}

Future<DateTimeRange?> selectDateRange(
    BuildContext context, DateTimeRange? initialDateTimeRange) async {
  DateTimeRange? dateTimeRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      useRootNavigator: false,
      initialDateRange: initialDateTimeRange,
      saveText: "Apply",
      builder: (context, child) {
        return Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(
                right: 30, top: DashboardConstants.defaultConstraintSize + 14),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 500.0,
                maxHeight: 500.0,
              ),
              child: child,
            ),
          ),
        );
      });

  return dateTimeRange;
}

showAlert(BuildContext context, {String? message}) {
  showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text(
              message ?? "Ending date must not be greater than starting date."),
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
  Loader.show(
    context,
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
