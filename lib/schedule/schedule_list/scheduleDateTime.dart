import 'package:flutter/material.dart';

class ScheduleDateTime{
  late int year;
  late int month;
  late int day;
  late int hour;
  late int minute;

  static ScheduleDateTime fromString(String s){
    DateTime dateTime = DateTime.parse("$s:00");
    return ScheduleDateTime(
        year: dateTime.year,
        month: dateTime.month,
        day: dateTime.day,
        hour: dateTime.hour,
        minute: dateTime.minute);
  }

  @override
  String toString(){
    return '${year.toString()}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')} ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  DateTime getDateTime(){
    return DateTime.parse("${toString()}:00");
  }

  ScheduleDateTime({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
  });
}