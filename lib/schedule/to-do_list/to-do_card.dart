import 'package:flutter/material.dart';
import 'to-do.dart';
import '../schedule_list/scheduleDateTime.dart';

class TodoCard extends StatefulWidget {
  final int id;
  final String title;
  final ScheduleDateTime creationDate;
  bool isChecked;
  final Function insertFunction;
  final Function deleteFunction;

  TodoCard(
      {Key? key,
        required this.id,
        required this.title,
        required this.isChecked,
        required this.creationDate,
        required this.insertFunction,
        required this.deleteFunction})
      : super(key: key);

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(BuildContext context) {
    var anotherTodo = Todo(
      id: widget.id,
      title: widget.title,
      creationDate: widget.creationDate,
      isChecked: widget.isChecked,
    );
    return Card(
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Checkbox(
              value: widget.isChecked,
              onChanged: (bool? value) {
                setState(() {
                  widget.isChecked = value!;
                });

                anotherTodo.isChecked = value!;

                widget.insertFunction(anotherTodo.id, anotherTodo.title, anotherTodo.creationDate, anotherTodo.isChecked);
              },
            ),
          ),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.creationDate.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xff8f8f8f)),
                  ),
                ],
              )),
          IconButton(
              onPressed: () {
                widget.deleteFunction(anotherTodo);
              },
              icon: const Icon(Icons.close))
        ],
      ),
    );
  }
}
