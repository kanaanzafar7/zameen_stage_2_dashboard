import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zameen_stage_2_dashboard/models/feedback_data.dart';
import 'package:zameen_stage_2_dashboard/models/user_feedback.dart';
import 'package:zameen_stage_2_dashboard/ui_components/date_selection_cell.dart';
import 'package:zameen_stage_2_dashboard/ui_components/ui_components.dart';
import 'package:zameen_stage_2_dashboard/utils/api_helper.dart';
import 'package:zameen_stage_2_dashboard/utils/dashboard_constants.dart';
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

  ScrollController scrollController = ScrollController();
  bool hasNextPage = true;
  DateTimeRange? dateTimeRange;
  DataTableSource? feedbackData;
  int pageSize = 50;

  @override
  void initState() {
    DateTime todayDate = DateTime.now();
    feedbackData = FeedbackData(userFeedbacks: feedBacksList, context: context);
    dateTimeRange = DateTimeRange(
        start: DateTime(todayDate.year, todayDate.month), end: todayDate);
    fetchFirstPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
          child: Container(
            color: Colors.white,
            child: Stack(
              children: [
                PositionedDirectional(
                  top: 15,
                  start: 15,
                  child: Text(
                    "Zameen - Production",

                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 0.87)),
                  ),
                ),
              ],
            ),
          ),
          preferredSize:
              Size(double.infinity, DashboardConstants.defaultConstraintSize)),
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
                      // bottom: DashboardConstants.defaultConstraintSize,
                      start: 0,
                      end: 0,
                      child: viewContent()),
                  /*   PositionedDirectional(
                    child: footerView(),
                    bottom: 0,
                    start: 0,
                    end: 0,
                  ) */
                ],
              ),
            ),
    );
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
    feedbackData = FeedbackData(userFeedbacks: feedBacksList, context: context);
    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  applyFilters() async {
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
          dateTimeRange: dateTimeRange);
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
    feedbackData = FeedbackData(userFeedbacks: feedBacksList, context: context);
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
          dateTimeRange: dateTimeRange);
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
    hideLoading();
    // restoreDates();
    showAlert(context, message: message);
    setState(() {});
  }

  Widget viewContent() {
    // return DataGrid
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              PaginatedDataTable(
                columns: [
                  headerTextDataColumn("No.", (boolVal, intVal) {}, context),
                  headerTextDataColumn("Feedback\nDate", onSort, context),
                  headerTextDataColumn("User\nId", onSort, context),
                  headerTextDataColumn("User\nName", onSort, context),
                  headerTextDataColumn("User\nMobile", onSort, context),
                  headerTextDataColumn("Feedback\nRating", onSort, context),
                  headerTextDataColumn("Feedback\nComment", onSort, context),
                  headerTextDataColumn("Device\nOS", onSort, context),
                  headerTextDataColumn("App\nVersion", onSort, context),
                  headerTextDataColumn("Device\nModel", onSort, context),
                  headerTextDataColumn("User\nemail", onSort, context),
                ],

                source: feedbackData!,
                sortAscending: isAscending,
                sortColumnIndex: sortColumnIndex,
                rowsPerPage: pageSize,
                horizontalMargin: 0,

                // showCheckboxColumn: true,
                columnSpacing: 0,
                //ApiConstants.pageSize,
                onRowsPerPageChanged: (value) {
                  if (value != null) {
                    setState(() {
                      pageSize = value;
                    });
                  }
                },
              ),
              Container(
                height: DashboardConstants.defaultConstraintSize * 3,
              ),
            ],
          ),
        ),
      );
    });
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            PaginatedDataTable(
              columns: [
                headerTextDataColumn("No.", (boolVal, intVal) {}, context),
                headerTextDataColumn("Feedback\nDate", onSort, context),
                headerTextDataColumn("User\nId", onSort, context),
                headerTextDataColumn("User\nName", onSort, context),
                headerTextDataColumn("User\nMobile", onSort, context),
                headerTextDataColumn("Feedback\nRating", onSort, context),
                headerTextDataColumn("Feedback\nComment", onSort, context),
                headerTextDataColumn("Device\nOS", onSort, context),
                headerTextDataColumn("App\nVersion", onSort, context),
                headerTextDataColumn("Device\nModel", onSort, context),
                headerTextDataColumn("User\nemail", onSort, context),
              ],

              source: feedbackData!,
              sortAscending: isAscending,
              sortColumnIndex: sortColumnIndex,
              rowsPerPage: pageSize,
              horizontalMargin: 0,

              // showCheckboxColumn: true,
              // columnSpacing: 12.5,
              //ApiConstants.pageSize,
              onRowsPerPageChanged: (value) {
                if (value != null) {
                  setState(() {
                    pageSize = value;
                  });
                }
              },
            ),
            Container(
              height: DashboardConstants.defaultConstraintSize * 3,
            ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Image.asset(
                "assets/images/feedback_icon.png",
                height: 25,
                width: 25,
                color: Color(DashboardConstants.dashboardPrimaryColor),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Feedbacks | ",
                // style: GoogleFonts.,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "Dashboard",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DateSelectionCell(
                onTap: () async {
                  DateTimeRange? dateTimeRangeTemp =
                      await selectDateRange(context, dateTimeRange);
                  if (dateTimeRangeTemp != null) {
                    dateTimeRange = dateTimeRangeTemp;
                    setState(() {});
                    applyFilters();
                  }
                },
                dateTimeRange: dateTimeRange,
              ),
              IconButton(
                  onPressed: () async {
                    await exportCsv(feedBacksList);
                  },
                  icon: Icon(
                    Icons.download_outlined,

                    // color: Colors.blue,
                  )),
              SizedBox(
                width: 30,
              )
            ],
          ),
        ],
      ),
    );
  }
}
