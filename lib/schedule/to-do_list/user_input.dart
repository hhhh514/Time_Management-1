import 'package:flutter/material.dart';
import 'to-do.dart';
import '../schedule_list/scheduleDateTime.dart';

class UserInput extends StatefulWidget{
  var textController = TextEditingController();
  final Function insertFunction;
  String selectedOption = 'generally';
  List<String> options = ['important', 'generally'];


  UserInput({required this.insertFunction, Key? key}) : super(key: key);
  @override
  State<UserInput> createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {


  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          DropdownButton<String>(
            hint: const Text('等級'),
            value: widget.selectedOption,
            onChanged: (String? newValue) {
              // 使用者選擇時觸發
              if (newValue != null) {
                // 更新選擇的值
                widget.selectedOption = newValue;
                setState(() {

                });
              }
            },
            items: widget.options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2.0, color: const Color(0xff8f8f8f))),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  controller: widget.textController,
                  decoration: const InputDecoration(
                    hintText: 'add new todo',
                    border: InputBorder.none,
                  ),
                ),
              )),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              var t = widget.textController.text;
              if(widget.selectedOption == 'important'){
                t += '(緊急)';
              }
              widget.insertFunction(t, ScheduleDateTime.now(), false);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: const Icon(
                Icons.send,
                color: Color(0xFFBBDEFB),
              ),
            ),
          )
        ],
      ),
    );
  }
}
