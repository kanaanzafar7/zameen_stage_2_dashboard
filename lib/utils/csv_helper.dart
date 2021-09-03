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

}
