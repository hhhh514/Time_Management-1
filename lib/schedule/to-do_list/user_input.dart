import 'package:flutter/material.dart';
import 'to-do.dart';
import '../schedule_list/scheduleDateTime.dart';

class UserInput extends StatelessWidget {
  var textController = TextEditingController();
  final Function insertFunction;

  UserInput({required this.insertFunction, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [

          Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2.0, color: const Color(0xff8f8f8f))),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    hintText: 'add new todo',
                    border: InputBorder.none,
                  ),
                ),
              )),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              insertFunction(textController.text, ScheduleDateTime.now(), false);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
