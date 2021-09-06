import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zameen_stage_2_dashboard/models/user_feedback.dart';
import 'package:zameen_stage_2_dashboard/ui_components/dashboard_primary_button.dart';
import 'package:zameen_stage_2_dashboard/ui_components/date_selection_cell.dart';
import 'package:zameen_stage_2_dashboard/ui_components/ui_components.dart';
import 'package:zameen_stage_2_dashboard/utils/api_helper.dart';
import 'package:zameen_stage_2_dashboard/utils/constants.dart';
import 'package:zameen_stage_2_dashboard/utils/csv_helper.dart';
import 'package:zameen_stage_2_dashboard/utils/helper_functions.dart';
import 'package:zameen_stage_2_dashboard/utils/static_info.dart';

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
  ScrollController scrollController = ScrollController();
  bool hasNextPage = true;
  DateTime? previousStartingDate;
  DateTime? previousEndingDate;

  @override
  void initState() {
    fetchFirstPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Zameen production dashboard"),
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
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  PositionedDirectional(
                      top: 0, start: 0, end: 0, child: headerView()),
                  PositionedDirectional(
                      top: DashboardConstants.defaultConstraintSize,
                      bottom: DashboardConstants.defaultConstraintSize,
                      start: 0,
                      end: 0,
                      child: viewContent()),
                  PositionedDirectional(
                    child: footerView(),
                    bottom: 0,
                    start: 0,
                    end: 0,
                  )
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

  onSort(int columnIndex, bool ascending) {
    switch (columnIndex) {
      case 0:
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

  restoreStartingDate() {
    startingDate = previousStartingDate;
  }

  restoreEndingDate() {
    endingDate = previousEndingDate;
  }

  backupStartingDate() {
    previousStartingDate = startingDate;
  }

  backupEndingDate() {
    previousEndingDate = endingDate;
  }

  clearFilters() {
    setState(() {
      startingDate = null;
      endingDate = null;
    });
  }

  applyFilters() async {
    if (startingDate == null && endingDate == null) {
      return;
    }
    if (startingDate != null && endingDate != null) {
      if (endingDate!.isBefore(startingDate!)) {
        showAlert(context);
        return;
      }
    }
    showLoading(context);
    pageNumber = 0;
    StaticInfo.totalPagesFetched = 0;
    StaticInfo.feedBackCollections.clear();
    await fetchFirstPage();
    hideLoading();
  }

  fetchFirstPage() async {
    try {
      await apiHelper.fetchFirstPage(onCompletion,
          startDate: startingDate, endDate: endingDate);
    } catch (e) {
      handleFailureCase(e.toString());
    }
  }

  void onCompletion(
      DocumentSnapshot documentSnapshot, List<UserFeedback> feedBacks) {
    if (lastDocument == null) {
      StaticInfo.feedBackCollections.clear();
    }
    if (feedBacks.isEmpty) {
      hasNextPage = false;
    }
    lastDocument = documentSnapshot;

    feedBacksList = feedBacks;
    StaticInfo.totalPagesFetched = StaticInfo.totalPagesFetched + 1;
    pageNumber = StaticInfo.totalPagesFetched;
    StaticInfo.feedBackCollections[pageNumber] = feedBacks;
    scrollToTop();
    setState(() {});
  }

  scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(0,
          duration: Duration(milliseconds: 750), curve: Curves.ease);
    }
  }

  fetchNextPage() async {
    if (pageNumber < StaticInfo.totalPagesFetched) {
      pageNumber = pageNumber + 1;
      feedBacksList = StaticInfo.feedBackCollections[pageNumber]!;
      setState(() {});
      return;
    }
    try {
      await apiHelper.fetchNextFeedBacks(onCompletion, lastDocument!,
          startDate: startingDate, endDate: endingDate);
    } catch (e) {
      handleFailureCase(e.toString());
    }
  }

  fetchPreviousPage() async {
    pageNumber = pageNumber - 1;
    feedBacksList = StaticInfo.feedBackCollections[pageNumber]!;
    setState(() {});
  }

  handleFailureCase(String message) {
    restoreStartingDate();
    restoreEndingDate();

    hideLoading();
    // restoreDates();
    showAlert(context, message: message);
    setState(() {});
  }

  Widget viewContent() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            DataTable(
                sortAscending: isAscending,
                sortColumnIndex: sortColumnIndex,
                columns: [
                  headerTextDataColumn("Feedback\nDate", onSort),
                  headerTextDataColumn("User\nId", onSort),
                  headerTextDataColumn("User\nName", onSort),
                  headerTextDataColumn("User\nMobile", onSort),
                  headerTextDataColumn("Feedback\nRating", onSort),
                  headerTextDataColumn("Feedback\nComment", onSort),
                  headerTextDataColumn("Device\nOS", onSort),
                  headerTextDataColumn("App\nVersion", onSort),
                  headerTextDataColumn("Device\nModel", onSort),
                  headerTextDataColumn("User\nemail", onSort),
                ],
                rows: getDataRows()),
          ],
        ),
      ),
    );
  }

  Widget footerView() {
    return Container(
      color: Colors.white,
      height: DashboardConstants.defaultConstraintSize,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: pageNumber == 1
                ? null
                : () {
                    fetchPreviousPage();
                  },
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            color: Colors.blue,
          ),
          SizedBox(
            width: 20,
          ),
          Text("$pageNumber"),
          SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: () async {
              showLoading(context);
              await fetchNextPage();
              hideLoading();
            },
            icon: Icon(
              Icons.arrow_forward_ios,
            ),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget headerView() {
    return Container(
      height: DashboardConstants.defaultConstraintSize,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DateSelectionCell(
              buttonName: "Select Starting Date",
              onPressed: () async {
                DateTime? dateTime = await selectDate(context, startingDate);
                if (dateTime != null) {
                  backupStartingDate();
                  setState(() {
                    startingDate = dateTime;
                  });
                }
              },
              dateText: startingDate == null
                  ? null
                  : getFormattedDateOnly(startingDate!)),
          DateSelectionCell(
              buttonName: "Select Ending Date",
              onPressed: () async {
                DateTime? dateTime = await selectDate(context, endingDate);
                if (dateTime != null) {
                  backupEndingDate();
                  setState(() {
                    endingDate = dateTime;
                  });
                }
              },
              dateText: endingDate == null
                  ? null
                  : getFormattedDateOnly(endingDate!)),
          DashboardPrimaryButton(
            buttonName: "Apply Filters",
            onPressed: applyFilters,
          )
        ],
      ),
    );
  }
}
