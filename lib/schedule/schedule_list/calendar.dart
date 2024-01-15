
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:jiffy/jiffy.dart';
import 'event.dart';
import 'trip.dart';

class Calendar extends StatefulWidget{
  final ValueChanged<DateTime> selectedDay;
  final StateSetter listUpdate;
  final List<Trip> tripList;
  Map<DateTime, int> eventsMapCount = {};
  Calendar({super.key, required this.selectedDay, required this.listUpdate, required this.tripList}){
    for (Trip trip in tripList){
      DateTime dateTime = DateTime(trip.date.year, trip.date.month, trip.date.day);
      if(eventsMapCount.containsKey(dateTime)) {
        eventsMapCount[dateTime] = eventsMapCount[dateTime]! + 1;
      } else {
        eventsMapCount[dateTime] = 1;
      }
    }
  }

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar>{
  DateTime _focusedDay = DateTime.now();
  late DateTime _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState(){
    super.initState();
    _selectedDay = _focusedDay;
    //widget.selectedDay(_focusedDay);
  }

  @override
  Widget build(BuildContext context){
    DateTime tenYearsLater = Jiffy.parseFromDateTime(DateTime.now()).add(years: 3).dateTime;
    return TableCalendar(
      locale: 'zh_TW',
      firstDay: DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDay: DateTime.utc(tenYearsLater.year, tenYearsLater.year, tenYearsLater.day),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        //debugPrint("onSelect:" + selectedDay.toString());
        setState(() {
          widget.selectedDay(selectedDay);
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          widget.listUpdate;
        });
      },
      onFormatChanged: (format) {
        //debugPrint("format:" + format.toString());
        setState(() {
          _calendarFormat = format;
        });
      },
      onPageChanged: (focusedDay) {
        //debugPrint("focused:" + focusedDay.toString());
        _focusedDay = focusedDay;
      },
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day){
          if(day.weekday == DateTime.sunday){
            return const Center(
              child: Text(
                '週日',
                style: TextStyle(color: Colors.red),
              ),
            );
          }else if(day.weekday == DateTime.saturday){
            return const Center(
              child: Text(
                '週六',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
        }
      ),
      eventLoader: (day){
        DateTime dateTime = DateTime(day.year, day.month, day.day);
        //debugPrint(day.toString());
        if(widget.eventsMapCount.containsKey(dateTime)){
          debugPrint(day.toString());
          return List<Event>.filled(widget.eventsMapCount[dateTime]!, const Event('Cyclic event'));
        }
        return [];
      },
    );
  }

}