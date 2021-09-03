import 'package:cloud_firestore/cloud_firestore.dart';
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
  DocumentSnapshot? lastDocument;
  int pageNumber = 0;
  DateTime? startingDate;
  DateTime? endingDate;

  @override
  void initState() {
    fetchFirstPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            color: Colors.blue,
          ),
          Text("Page"),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_forward_ios,
            ),
            color: Colors.blue,
          ),
        ],
      ),
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
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    // color: Colors.white,
                    height: 56,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        selectDateWidget(
                            buttonName: "Select Starting Date",
                            onPressed: () async {
                              DateTime? dateTime =
                                  await selectDate(context, startingDate);
                              if (dateTime != null) {
                                setState(() {
                                  startingDate = dateTime;
                                });
                              }
                            },
                            dateText: startingDate == null
                                ? null
                                : getFormattedDateOnly(startingDate!)),
                        selectDateWidget(
                            buttonName: "Select Ending Date",
                            onPressed: () async {
                              DateTime? dateTime =
                                  await selectDate(context, endingDate);
                              if (dateTime != null) {
                                setState(() {
                                  endingDate = dateTime;
                                });
                              }
                            },
                            dateText: endingDate == null
                                ? null
                                : getFormattedDateOnly(endingDate!)),
                        ElevatedButton(
                          onPressed: () {
                            if (startingDate != null && endingDate != null) {
                              if (endingDate!.isBefore(startingDate!)) {
                                _showAlert(context);
                                return;
                              }
                            }
                          },
                          child: Text(
                            "Apply Filters",
                            style: TextStyle(color: Colors.blue),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            // textStyle: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataTable(
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
                ],
              ),
            ),
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
        /* feedBacksList.sort((feedback1, feedback2) {
          if (feedback1.feedbackDate == null ||
              feedback2.feedbackDate == null) {
            return;
          }

          return;
        }) */
//        list.sort((a, b) => a == null ? 1 : 0);
//         feedBacksList.sort((feedBack1, feedBack2) =>
//         ascending ? feedBack1.feedbackDate == null ||
//             feedBack2.feedbackDate == null ? 0 :
//         );

        feedBacksList.sort((feedback1, feedback2) {
          if (feedback1.feedbackDate == null ||
              feedback2.feedbackDate == null) {
            return ascending ? 0 : 1;
          } else {
            return ascending
                ? feedback1.feedbackDate!.compareTo(feedback2.feedbackDate!)
                : feedback2.feedbackDate!.compareTo(feedback1.feedbackDate!);
          }
        });

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
        textAlign: TextAlign.center,
        textScaleFactor: 0.8,
      ),
    );
  }

  fetchFirstPage() async {
    await apiHelper.fetchFirstPage(onCompletion);
  }

  void onCompletion(
      DocumentSnapshot documentSnapshot, List<UserFeedback> feedbacks) {
    if (lastDocument == null) {
      feedBacksList.clear();
    }
    lastDocument = documentSnapshot;
    feedBacksList.addAll(feedbacks);
    pageNumber = pageNumber + 1;
    setState(() {});
  }

  fetchNextPage() async {
    await apiHelper.fetchNextFeedBacks(onCompletion, lastDocument!);
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

  void _showAlert(BuildContext context) {
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
    return;
  }
}
