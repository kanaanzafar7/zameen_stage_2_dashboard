import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String getFormattedDateFromTimeStamp(Timestamp timestamp) {
  String formattedDate = "";
  DateTime dateTime = timestamp.toDate();
  int year = dateTime.year;
  String month = getMonth(dateTime.month);

  int date = dateTime.day;
  String weekday = getWeekday(dateTime.weekday);

  int hour = dateTime.hour;
  int minute = dateTime.minute;
  TimeOfDay timeOfDay = TimeOfDay(hour: hour, minute: minute);
  String period = timeOfDay.period == DayPeriod.am ? "AM" : "PM";
  formattedDate =
      "$weekday ${correctFormatForNumbers(date)} $month $year ${correctHour(hour)}:${correctFormatForNumbers(minute)} $period";

  return formattedDate;
}

String getFormattedDateOnly(DateTime dateTime) {
  return "${correctFormatForNumbers(dateTime.day)}/${correctFormatForNumbers(dateTime.month)}/${dateTime.year}";
}

String correctHour(int hour) {
  if (hour == 0) {
    hour = 12;
  } else if (hour > 12) {
    hour = hour % 12;
  }
  String correctHour = correctFormatForNumbers(hour);

  return correctHour;
}

String correctFormatForNumbers(int number) {
  String correctNumber = "$number";
  if (number < 10) {
    correctNumber = "0$number";
  }
  return correctNumber;
}

String getWeekday(int weekday) {
  switch (weekday) {
    case 1:
      return "Mon";
    case 2:
      return "Tue";
    case 3:
      return "Wed";
    case 4:
      return "Thu";
    case 5:
      return "Fri";
    case 6:
      return "Sat";
    default:
      return "Sun";
  }
}

String getMonth(int month) {
  switch (month) {
    case 1:
      return "Jan";
    case 2:
      return "Feb";
    case 3:
      return "Mar";
    case 4:
      return "Apr";
    case 5:
      return "May";
    case 6:
      return "Jun";
    case 7:
      return "Jul";
    case 8:
      return "Aug";
    case 9:
      return "Sep";
    case 10:
      return "Oct";
    case 11:
      return "Nov";
    default:
      return "Dec";
  }
}

int compareString(bool ascending, String value1, String value2) =>
    ascending ? value1.compareTo(value2) : value2.compareTo(value1);

Timestamp? extractTimeStamp(final dateTime) {
  Timestamp? timestamp;
  if (dateTime is Timestamp) {
    timestamp = dateTime;
  } else if (dateTime is String) {
    try {
      DateTime convertedDateTime = DateTime.parse(dateTime);

      timestamp = Timestamp.fromDate(convertedDateTime);
    } catch (e) {
      return timestamp;
    }
  }
  return timestamp;
}
