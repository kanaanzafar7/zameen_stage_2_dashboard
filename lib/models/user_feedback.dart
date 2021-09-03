import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zameen_stage_2_dashboard/utils/api_constants.dart';
import 'package:zameen_stage_2_dashboard/utils/helper_functions.dart';

class UserFeedback {
  String? appVersion,
      deviceModel,
      deviceOs,
      feedbackComment,
      feedbackDateString,
      feedbackRating,
      userEmail,
      userId,
      userMobile,
      userName;
  DateTime? feedbackDate;

  Map<String, Object?> toJson() {
    return {
      ApiConstants.appVersion: this.appVersion,
      ApiConstants.deviceModel: this.deviceModel,
      ApiConstants.deviceOs: this.deviceOs,
      ApiConstants.feedbackComment: this.feedbackComment,
      ApiConstants.feedbackDate: this.feedbackDateString,
      ApiConstants.feedbackRating: this.feedbackRating,
      ApiConstants.userEmail: this.userEmail,
      ApiConstants.userId: this.userId,
      ApiConstants.userMobile: this.userMobile,
      ApiConstants.userName: this.userName
    };
  }

  UserFeedback.fromJson(Map<String, Object?> json) {
    this.appVersion = json[ApiConstants.appVersion] as String?;
    this.deviceModel = json[ApiConstants.deviceModel] as String?;
    this.deviceOs = json[ApiConstants.deviceOs] as String?;

    this.feedbackComment = json[ApiConstants.feedbackComment] as String?;
    var dateTime = json[ApiConstants.feedbackDate];
    if (dateTime != null) {
      Timestamp timestamp = extractTimeStamp(dateTime)!;
      this.feedbackDate = timestamp.toDate();
      String formattedDate = getFormattedDateFromTimeStamp(timestamp);
      this.feedbackDateString = formattedDate;
    } else {
      this.feedbackDate = null;
      this.feedbackDateString = "";
    }
    this.feedbackRating = json[ApiConstants.feedbackRating] as String?;
    this.userEmail = json[ApiConstants.userEmail] as String?;
    this.userId = json[ApiConstants.userId] as String?;
    this.userMobile = json[ApiConstants.userMobile] as String?;
    this.userName = json[ApiConstants.userName] as String?;
  }

  @override
  String toString() {
    return 'Feedback{appVersion: $appVersion, deviceModel: $deviceModel, deviceOs: $deviceOs, feedbackComment: $feedbackComment, feedbackDate: $feedbackDateString, feedbackRating: $feedbackRating, userEmail: $userEmail, userId: $userId, userMobile: $userMobile, userName: $userName}';
  }
}
