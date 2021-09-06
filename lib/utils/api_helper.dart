import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zameen_stage_2_dashboard/models/user_feedback.dart';
import 'package:zameen_stage_2_dashboard/utils/api_constants.dart';

class ApiHelper {
  fetchFirstPage(
      void onCompletion(
          DocumentSnapshot documentSnapshot, List<UserFeedback> feedbacks),
      {DateTime? startDate,
      DateTime? endDate}) async {

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(ApiConstants.userFeedback)
        .orderBy(ApiConstants.feedbackDate, descending: startDate == null)
        .where(ApiConstants.feedbackDate,
            isGreaterThan: Timestamp.fromDate(startDate ?? DateTime(2000)))
        .where(ApiConstants.feedbackDate,
            isLessThanOrEqualTo: Timestamp.fromDate(endDate ?? DateTime.now()))
        .limit(ApiConstants.pageSize)
        .get();
    List<UserFeedback> feedBacks = [];

    List<QueryDocumentSnapshot> queryDocumentSnapshots = querySnapshot.docs;
    for (int i = 0; i < queryDocumentSnapshots.length; i++) {
      QueryDocumentSnapshot queryDocumentSnapshot = queryDocumentSnapshots[i];
      Map<String, Object?> map =
          queryDocumentSnapshot.data() as Map<String, Object?>;
      UserFeedback userFeedback = UserFeedback.fromJson(map);
      feedBacks.add(userFeedback);
    }
    onCompletion(queryDocumentSnapshots.last, feedBacks);
  }

  fetchNextFeedBacks(
      void onCompletion(
          DocumentSnapshot documentSnapshot, List<UserFeedback> feedBacks),
      DocumentSnapshot lastDocument,
      {DateTime? startDate,
      DateTime? endDate}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(ApiConstants.userFeedback)
        .orderBy(ApiConstants.feedbackDate, descending: startDate == null)
        .where(ApiConstants.feedbackDate,
            isGreaterThan: Timestamp.fromDate(startDate ?? DateTime(2000)))
        .where(ApiConstants.feedbackDate,
            isLessThanOrEqualTo: Timestamp.fromDate(endDate ?? DateTime.now()))
        .startAfterDocument(lastDocument)
        .limit(ApiConstants.pageSize)
        .get();
    List<UserFeedback> feedBacks = [];

    List<QueryDocumentSnapshot> queryDocumentSnapshots = querySnapshot.docs;
    for (int i = 0; i < queryDocumentSnapshots.length; i++) {
      QueryDocumentSnapshot queryDocumentSnapshot = queryDocumentSnapshots[i];
      Map<String, Object?> map =
          queryDocumentSnapshot.data() as Map<String, Object?>;
      UserFeedback userFeedback = UserFeedback.fromJson(map);
      feedBacks.add(userFeedback);
    }
    onCompletion(queryDocumentSnapshots.last, feedBacks);
  }
}
