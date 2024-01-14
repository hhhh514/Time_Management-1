import 'package:flutter/material.dart';
import 'to-do.dart';
import 'to-do_card.dart';
import '../schedule_list/scheduleDateTime.dart';
import 'user_input.dart';

class TodoList extends StatefulWidget{
  const TodoList({super.key});
  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {

  var db = TodoDatabase();


  void addItem(String title, ScheduleDateTime date, bool isChecked) async {
    await db.add(title, date, isChecked);
    setState(() {});
  }

  void editItem(int id, String title, ScheduleDateTime date, bool isChecked) async {
    await db.edit(id, title, date, isChecked);
    setState(() {});
  }


  void deleteItem(Todo todo) async {
    db.remove(todo);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo app'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
          child: FutureBuilder(
            future: db.selectTodayTodo(),
              initialData: const [],
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                var data = snapshot.data;
                var dataLength = data == null ? 0 : data.length;
                return dataLength == 0
                    ? const Center(
                  child: Text("no data found"),
                )
                    : ListView.builder(
                    itemCount: dataLength,
                    itemBuilder: (context, i) => TodoCard(
                      id: data![i].id,
                      title: data[i].title,
                      isChecked: data[i].isChecked,
                      creationDate: data[i].creationDate,
                      insertFunction: editItem,
                      deleteFunction: deleteItem,
                    ));
              },
            )
          ),
          UserInput(insertFunction: addItem),
        ],
      ),
    );
  }
}