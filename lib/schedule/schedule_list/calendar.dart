
import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget{
  final ValueChanged<DateTime> selectedDay;
  final StateSetter listUpdate;
  const Calendar({super.key, required this.selectedDay, required this.listUpdate});

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
    return TableCalendar(
      firstDay: DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        debugPrint("onSelect:" + selectedDay.toString());
        setState(() {
          widget.selectedDay(selectedDay);
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          widget.listUpdate;
        });
      },
      onFormatChanged: (format) {
        debugPrint("format:" + format.toString());
        setState(() {
          _calendarFormat = format;
        });
      },
      onPageChanged: (focusedDay) {
        debugPrint("focused:" + focusedDay.toString());
        _focusedDay = focusedDay;
      },
    );
  }

}