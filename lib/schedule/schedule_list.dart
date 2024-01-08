import 'package:flutter/material.dart';
import 'trip.dart';
import 'scheduleDialog.dart';
import 'calendar.dart';

enum VerticalFlipShowingType {
  calendar,
  all,
}

class ScheduleList extends StatefulWidget{
  const ScheduleList({super.key});
  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList>{
  VerticalFlipShowingType headerFlipShowingType = VerticalFlipShowingType.all;
  final ScrollController scrollController = ScrollController();
  final double headerFlipThreshold = 50;
  final double headerFlipHeightA = 400;
  final double headerFlipHeightB = 0;
  double get headerFlipHeight => headerFlipHeightA + headerFlipHeightB;

  late TripDatabase tripDatabase;
  late List<Trip> _data;
  String ?dateTime;
  DateTime selectDate = DateTime.now();
  DateTime changeSelectDate = DateTime.now();

  void choiceTrip(){
    setState(() {
      if(headerFlipShowingType == VerticalFlipShowingType.calendar) {
        _data = tripDatabase.getSelectDayTrip(selectDate);
      }else{
        _data = tripDatabase.getAllTrip();
      }
    });

  }

  void addSchedule(){
    dateTime = '';
    showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return const ScheduleDialog();
        }
    ).then(
            (value){
          setState(() {
            Trip ?trip = value is Trip ? value : null;
            if(trip != null){
              tripDatabase.add(trip.headerValue, trip.expandedValue, trip.date);
            }
            choiceTrip();
          });
        }
    );
  }


  bool isDateWithin24Hours(DateTime targetDate) {
    // 取得現在的日期時間
    DateTime now = DateTime.now();

    // 計算兩個日期時間的差異
    Duration difference = now.difference(targetDate);

    // 判斷差異是否在24小時以內
    return difference.inHours.abs() < 24;
  }

  bool isSelectedDay(DateTime targetDate){
    return selectDate.year == targetDate.year &&
        selectDate.month == targetDate.month &&
        selectDate.day == targetDate.day;
  }

  bool isDateToday(DateTime targetDate) {
    // 取得現在的日期時間
    DateTime now = DateTime.now();

    // 比較年、月、日是否相同
    return now.year == targetDate.year &&
        now.month == targetDate.month &&
        now.day == targetDate.day;
  }

  void _handleSelectDate(DateTime date){
    setState(() {
      selectDate = date;
    });
  }
  List<Trip> selectTrip(){
    if(headerFlipShowingType == VerticalFlipShowingType.calendar) {
      return tripDatabase.getSelectDayTrip(selectDate);
    }else{
      return tripDatabase.getAllTrip();
    }
  }

  @override
  void initState(){
    super.initState();
    tripDatabase = TripDatabase();
    tripDatabase.selectAllToTrip().then((result) {
      _data = tripDatabase.getAllTrip();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context){
    //if(!isSelectedDay(changeSelectDate)){
    choiceTrip();
    //}
    //changeSelectDate = selectDate;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeaderWidget()),
          SliverToBoxAdapter(
            child: IconButton(
              icon: headerFlipShowingType == VerticalFlipShowingType.calendar ?
              const Icon(Icons.keyboard_double_arrow_up) :
              const Icon(Icons.keyboard_double_arrow_down),
              onPressed: (){
                setState(() {
                  headerFlipShowingType =
                  headerFlipShowingType == VerticalFlipShowingType.calendar
                      ? VerticalFlipShowingType.all
                      : VerticalFlipShowingType.calendar;

                  choiceTrip();
                });
              },
            ),
          ),
          SliverToBoxAdapter(
              child: Container(
                  child:  ExpansionPanelList(
                    expansionCallback: (index, isExpanded){
                      setState(
                              () {
                            _data[index].isExpanded = isExpanded;
                          }
                      );
                    },
                    children: _data.map<ExpansionPanel>(
                            (Trip trip) {
                          return ExpansionPanel(
                            headerBuilder: (BuildContext context, bool isExpanded){
                              return ListTile(
                                title: Text(trip.headerValue),
                                subtitle: Text(trip.date.toString()),
                              );
                            },
                            body: ListTile(
                                title: Text(trip.expandedValue),
                                subtitle: Text(trip.date.toString()),
                                trailing: const Icon(Icons.delete),
                                onTap: () {
                                  setState(() {
                                    tripDatabase.remove(trip);
                                  });
                                }),
                            isExpanded: trip.isExpanded,
                          );
                        }
                    ).toList(),
                  )
              )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addSchedule,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeaderWidget() {
    return SizedBox(
      height: headerFlipShowingType == VerticalFlipShowingType.calendar
          ? headerFlipHeightA
          : headerFlipHeightB,
      child : Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: headerFlipHeight,
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(), // 不可滾動
              children: [
                SizedBox(
                  height: headerFlipHeightA,
                  child: Calendar(selectedDay: _handleSelectDate, listUpdate: setState,),
                ),
                SizedBox(
                  height: headerFlipHeightB,
                  child: null,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


