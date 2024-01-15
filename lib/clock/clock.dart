import 'package:flutter/material.dart';
import 'stopwatch/stopwatch.dart';
import 'world_clock/world_clock.dart';
import '../kit/function_menu.dart';

class Clock extends StatefulWidget{
  final String title = "時鐘管理";
  const Clock({super.key});
  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> with SingleTickerProviderStateMixin{
  TabController ?_controller;
  var _tabs = <Tab>[];

  @override
  void initState(){
    super.initState();
    _controller = TabController(initialIndex: 0, length: 2, vsync: this);
    _tabs = <Tab>[
      const Tab(text: "碼表",),
      const Tab(text: "世界時鐘",),
    ];
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(tabs: _tabs,
          indicatorColor: Colors.white,
          indicatorWeight: 5,
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _controller,
        ),
      ),
      drawer: const FunctionMenu(),
      body: TabBarView(
          controller: _controller,
          children: const <Widget>[
            Center(
              child: StopWatch(),
            ),
            Center(
              child: WorldClock(),
            ),
          ]
      ),
    );
  }

  @override
  void dispose(){
    super.dispose();
    _controller?.dispose();
  }
}