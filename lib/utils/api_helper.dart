import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zameen_stage_2_dashboard/models/user_feedback.dart';
import 'package:zameen_stage_2_dashboard/utils/api_constants.dart';

class ApiHelper {
  Future<List<UserFeedback>> listenToFireStore() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(ApiConstants.userFeedback)
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
      // print("-------map: ${map}");
    }
    return feedBacks;
  }
}
