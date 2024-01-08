import 'package:flutter/material.dart';
import '../schedule/schedule.dart';
import '../studycloock/tomato.dart';
class FunctionMenu extends StatefulWidget{
  const FunctionMenu({super.key});
  @override
  State<FunctionMenu> createState() => _FunctionMenuState();
}

class _FunctionMenuState extends State<FunctionMenu>{
  late List<Widget> _list;

  @override
  void initState(){
    super.initState();
    _list = <Widget>[
      UserAccountsDrawerHeader(
        accountName: Text("ABC"),
        accountEmail: Text("address@example.com"),
        currentAccountPicture: Icon(Icons.person),
      ),
      ListTile(
        leading: const Icon(Icons.access_time),
        title: const Text('行程管理'),
        subtitle: const Text("編輯你的行程、代辦事項"),
        onTap: () => {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Schedule(),
              ),
              (route) => false,
          )
        },
      ),
      ListTile(
        leading: const Icon(Icons.access_time),
        title: const Text('學習時鐘'),
        subtitle: const Text("番茄鐘"),
        onTap: () => {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => PomodoroTimer(),
            ),
                (route) => false,
          )
        },
      ),
      ListTile(
        leading: CircleAvatar(child: Text("B")),
        title: Text('Bob'),
        subtitle: Text("Click to start talk"),
        onTap: () => {debugPrint('Bob')},
      ),
      ListTile(
        leading: CircleAvatar(child: Text("C")),
        title: Text('Cindy'),
        subtitle: Text("Click to start talk"),
        onTap: () => {debugPrint('Cindy')},
      ),
      const AboutListTile(
        child: Text("About this App"),
        icon: Icon(Icons.info),
      )
    ];
  }

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: ListView(
        children: _list
      )
    );
  }
}