import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zameen_stage_2_dashboard/models/user_feedback.dart';
import 'package:zameen_stage_2_dashboard/utils/api_helper.dart';
import 'package:zameen_stage_2_dashboard/utils/csv_helper.dart';
import 'package:zameen_stage_2_dashboard/utils/helper_functions.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<UserFeedback> feedBacksList = [];
  bool isAscending = false;
  int? sortColumnIndex;
  ApiHelper apiHelper = ApiHelper();

  @override
  void initState() {
    getFeedBacks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Zameen stage 2 dashboard"),
        actions: [
          IconButton(
              onPressed: () async {
                await exportCsv(feedBacksList);
              },
              icon: Icon(
                Icons.download_outlined,
                color: Colors.white,
              ))
        ],
      ),
      body: feedBacksList.isEmpty
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : DataTable(
              sortAscending: isAscending,
              sortColumnIndex: sortColumnIndex,
              columns: [
                headerTextDataColumn("Feedback\nDate"),
                headerTextDataColumn("User\nId"),
                headerTextDataColumn("User\nName"),
                headerTextDataColumn("User\nMobile"),
                headerTextDataColumn("Feedback\nRating"),
                headerTextDataColumn("Feedback\nComment"),
                headerTextDataColumn("Device\nOS"),
                headerTextDataColumn("App\nVersion"),
                headerTextDataColumn("Device\nModel"),
                headerTextDataColumn("User\nemail"),
              ],
              rows: getDataRows()),
    );
  }

  List<DataRow> getDataRows() {
    List<DataRow> dataRows = [];
    for (int i = 0; i < feedBacksList.length; i++) {
      UserFeedback userFeedback = feedBacksList[i];
      DataRow dataRow = getFeedbackRow(userFeedback);
      dataRows.add(dataRow);
    }
    return dataRows;
  }

  DataColumn headerTextDataColumn(String label) {
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

  onSort(int columnIndex, bool ascending) {
    switch (columnIndex) {
      case 0:
        feedBacksList.sort((feedback1, feedback2) => ascending
            ? feedback1.feedbackDate!.compareTo(feedback2.feedbackDate!)
            : feedback2.feedbackDate!.compareTo(feedback1.feedbackDate!));

        break;
      case 1:
        feedBacksList.sort((feedback1, feedback2) => compareString(
            ascending, feedback1.userId ?? "", feedback2.userId ?? ""));

        break;
      case 2:
        feedBacksList.sort((feedback1, feedback2) => compareString(
            ascending, feedback1.userName ?? "", feedback2.userName ?? ""));

        break;
      case 3:
        feedBacksList.sort((feedback1, feedback2) => compareString(
            ascending, feedback1.userMobile ?? "", feedback2.userMobile ?? ""));

        break;
      case 4:
        feedBacksList.sort((feedback1, feedback2) => compareString(ascending,
            feedback1.feedbackRating ?? "", feedback2.feedbackRating ?? ""));

        break;

      case 5:
        feedBacksList.sort((feedback1, feedback2) => compareString(ascending,
            feedback1.feedbackComment ?? "", feedback2.feedbackComment ?? ""));

        break;

      case 6:
        feedBacksList.sort((feedback1, feedback2) => compareString(
            ascending, feedback1.deviceOs ?? "", feedback2.deviceOs ?? ""));
        break;
      case 7:
        feedBacksList.sort((feedback1, feedback2) => compareString(
            ascending, feedback1.appVersion ?? "", feedback2.appVersion ?? ""));

        break;
      case 8:
        feedBacksList.sort((feedback1, feedback2) => compareString(ascending,
            feedback1.deviceModel ?? "", feedback2.deviceModel ?? ""));

        break;
      default:
        feedBacksList.sort((feedback1, feedback2) => compareString(
            ascending, feedback1.userEmail ?? "", feedback2.userEmail ?? ""));

        break;
    }

    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

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

  DataCell getDataCell(String? value) {
    return DataCell(
      Text(
        value ?? "",
        style: TextStyle(color: value == null ? Colors.red : Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }

  getFeedBacks() async {
    List<UserFeedback> feedbacks = await apiHelper.listenToFireStore();
    feedBacksList.clear();
    feedBacksList.addAll(feedbacks);
    setState(() {});
  }
}
