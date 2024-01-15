import 'package:flutter/material.dart';
import 'package:time_management/schedule/schedule_list/scheduleDateTime.dart';
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


  void updateSchedule(Trip trip){
    showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return ScheduleDialog.update(name: trip.headerValue, content: trip.expandedValue, dateTime: trip.date);
        }
    ).then(
            (value){
          setState(() {
            Trip ?newTrip = value is Trip ? value : null;
            if(newTrip != null){
              tripDatabase.edit(trip.id, newTrip.headerValue, newTrip.expandedValue, newTrip.date).then(
                      (value){
                    choiceTrip();
                    setState(() {

                    });
                  }
              );
            }
          });
        }
    );
  }
  bool isToday(DateTime date) {
    DateTime now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  void addSchedule(){

    dateTime = '';
    showDialog(
        context: context,
        builder: (BuildContext context)
        {
          if(isToday(selectDate)){
            return ScheduleDialog();
          }else {
            return ScheduleDialog.select(dateTime: ScheduleDateTime.fromDateTime(selectDate));
          }
        }
    ).then(
            (value){
          setState(() {
            Trip ?trip = value is Trip ? value : null;
            if(trip != null){
              tripDatabase.add(trip.headerValue, trip.expandedValue, trip.date).then(
                      (value){

                        choiceTrip();
                        setState(() {

                    });
                  }
              );
            }
          });
        }
    );
  }

  void _handleSelectDate(DateTime date){
    setState(() {
      selectDate = date;
    });
  }


  @override
  void initState(){
    super.initState();
    tripDatabase = TripDatabase();
    tripDatabase.selectLaterTrips().then((result) {
      _data = tripDatabase.getAllTrip();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context){
    choiceTrip();
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
                            canTapOnHeader: true,
                            headerBuilder: (BuildContext context, bool isExpanded){
                              return ListTile(
                                title: Text(trip.headerValue),
                                subtitle: Text(trip.date.toString()),
                              );
                            },
                            body: ListTile(
                                //tileColor: Colors.grey,
                                title: Text(trip.expandedValue),
                                //subtitle: Text(trip.date.toString()),
                                trailing: Wrap(
                                  spacing: 12,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        setState(() {
                                          updateSchedule(trip);
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          tripDatabase.remove(trip);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                            ),
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
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: headerFlipHeightA,
                  child: Calendar(selectedDay: _handleSelectDate, listUpdate: setState, tripList: tripDatabase.getAllTrip(),),
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


