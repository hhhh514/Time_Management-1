import 'scheduleDateTime.dart';

// stores ExpansionPanel state information
class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    required this.date,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  ScheduleDateTime date;
  bool isExpanded;
}