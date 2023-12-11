import 'package:flutter/material.dart';
import 'item.dart';
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
  VerticalFlipShowingType headerFlipShowingType = VerticalFlipShowingType.calendar;
  final ScrollController scrollController = ScrollController();
  final double headerFlipThreshold = 50;
  final double headerFlipHeightA = 400;
  final double headerFlipHeightB = 0;
  double get headerFlipHeight => headerFlipHeightA + headerFlipHeightB;

  late List<Item> _allData;
  late List<Item> _data;
  String ?dateTime;
  DateTime selectDate = DateTime.now();
  DateTime changeSelectDate = DateTime.now();

  void addSchedule(){
    dateTime = '';
    showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return const ScheduleDialog();
        }
    ).then(
            (item){
          setState(() {
            _allData.add(item);
            if(headerFlipShowingType == VerticalFlipShowingType.calendar) {
              addSelectedDataItem(item);
            }else{
              _data.add(item);
            }
          });
        }
    );
  }

  void setSelectedData(){
    _data.clear();
    for(Item i in _allData){
      if(isSelectedDay(i.date.getDateTime())){
        _data.add(i);
      }
    }
  }

  void addSelectedDataItem(Item i){
    if(isSelectedDay(i.date.getDateTime())){
      _data.add(i);
    }
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

  @override
  void initState(){
    super.initState();
    _allData = <Item>[];
    _data = <Item>[];
  }

  @override
  Widget build(BuildContext context){
    if(!isSelectedDay(changeSelectDate)){
      setSelectedData();
    }
    changeSelectDate = selectDate;
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

                  if(headerFlipShowingType == VerticalFlipShowingType.all){
                    _data = List.from(_allData);
                  }else{
                    setSelectedData();
                  }
                });
              },
            ),
          ),
          SliverToBoxAdapter(
              child: Container(
                  child: ExpansionPanelList(
                    expansionCallback: (index, isExpanded){
                      setState(
                              () {
                            _data[index].isExpanded = isExpanded;
                          }
                      );
                    },
                    children: _data.map<ExpansionPanel>(
                            (Item item) {
                          return ExpansionPanel(
                            headerBuilder: (BuildContext context, bool isExpanded){
                              return ListTile(
                                title: Text(item.headerValue),
                                subtitle: Text(item.date.toString()),
                              );
                            },
                            body: ListTile(
                                title: Text(item.expandedValue),
                                subtitle: Text(item.date.toString()),
                                trailing: const Icon(Icons.delete),
                                onTap: () {
                                  setState(() {
                                    _data.removeWhere((Item currentItem) => item == currentItem);
                                    _allData.removeWhere((Item currentItem) => item == currentItem);
                                  });
                                }),
                            isExpanded: item.isExpanded,
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

  void sortScheculeList(){
    _allData.sort(
            (a, b){
          var adate = a.date.getDateTime();
          var bdate = b.date.getDateTime();
          return adate.compareTo(bdate);
        }
    );
  }

  Widget _buildHeaderWidget() {
    return SizedBox( // 限制 Stack 的高度，否则报错
      height: headerFlipShowingType == VerticalFlipShowingType.calendar
          ? headerFlipHeightA
          : headerFlipHeightB,
      child : Stack(
        clipBehavior: Clip.none, // 子视图超出 Stack 不裁剪，依旧显示
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: headerFlipHeight, // AAA 与 BBB 加起来的总高度
            child: ListView(
              padding: EdgeInsets.zero, // 消除顶部刘海造成的安全区域偏移
              physics: const NeverScrollableScrollPhysics(), // 不可滚动
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


