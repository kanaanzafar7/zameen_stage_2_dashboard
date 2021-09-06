import 'package:flutter/material.dart';
import 'package:zameen_stage_2_dashboard/models/user_feedback.dart';
import 'package:zameen_stage_2_dashboard/ui_components/ui_components.dart';

class FeedbackData extends DataTableSource {
  final List<UserFeedback> userFeedbacks;

  FeedbackData({this.userFeedbacks = const []});

  @override
  DataRow? getRow(int index) {
    // TODO: implement getRow
    return getFeedbackRow(userFeedbacks[index]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => userFeedbacks.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
