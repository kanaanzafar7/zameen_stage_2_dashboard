import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:zameen_stage_2_dashboard/models/user_feedback.dart';
import 'package:zameen_stage_2_dashboard/utils/api_constants.dart';
import 'dart:html';

exportCsv(List<UserFeedback> feedBacksList) async {
  List<List> rows = [];
  List row = [];
  row.add(ApiConstants.feedbackDate);
  row.add(ApiConstants.userId);
  row.add(ApiConstants.userName);
  row.add(ApiConstants.userMobile);
  row.add(ApiConstants.feedbackRating);
  row.add(ApiConstants.feedbackComment);
  row.add(ApiConstants.deviceOs);
  row.add(ApiConstants.appVersion);
  row.add(ApiConstants.deviceModel);
  row.add(ApiConstants.userEmail);
  rows.add(row);

  for (int i = 0; i < feedBacksList.length; i++) {
    List row = [];
    row.add(feedBacksList[i].feedbackDate);
    row.add(feedBacksList[i].userId);
    row.add(feedBacksList[i].userName);
    row.add(feedBacksList[i].userMobile);
    row.add(feedBacksList[i].feedbackRating);
    row.add(feedBacksList[i].feedbackComment);
    row.add(feedBacksList[i].deviceOs);
    row.add(feedBacksList[i].appVersion);
    row.add(feedBacksList[i].deviceModel);
    row.add(feedBacksList[i].userEmail);
    rows.add(row);
  }
  String csv = const ListToCsvConverter().convert(rows);
  exportFile(csv);
}

exportFile(String csv) {
  AnchorElement(href: "data:text/plain;charset=utf-8,$csv")
    ..setAttribute("download", "userFeedBack.csv")
    ..click();
// prepare
  /*final bytes = utf8.encode(text);
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = 'some_name.txt';
  html.document.body.children.add(anchor);
// html.document.body.add
// download
  anchor.click();

// cleanup
  html.document.body.children.remove(anchor);
  html.Url.revokeObjectUrl(url); */
}
