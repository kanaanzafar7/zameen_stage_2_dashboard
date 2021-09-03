import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zameen_stage_2_dashboard/models/user_feedback.dart';
import 'package:zameen_stage_2_dashboard/utils/api_constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Zameen stage 2 dashboard"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(ApiConstants.userFeedback)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: DataTable(
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
                rows: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  UserFeedback feedback = UserFeedback.fromJson(data);
                  return getFeedbackRow(feedback);
                }).toList(),
                dividerThickness: 1.5,
                showBottomBorder: true,
              ),
            );
          }
          return Center(
            child: Text("Please Wait"),
          );
        },
      ),
    );
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
    );
  }

  DataRow getFeedbackRow(UserFeedback? userFeedback) {
    return DataRow(cells: [
      getDataCell(userFeedback?.feedbackDate),
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
        value ?? "Empty",
        style: TextStyle(color: value == null ? Colors.red : Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }
}
