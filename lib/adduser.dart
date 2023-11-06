import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todolistlocaldatabase/createdatabase.dart';

import 'package:todolistlocaldatabase/usermodel.dart';
import 'package:todolistlocaldatabase/viewuser.dart';

class AddTasksScreen extends StatefulWidget {
    final TableValues? oldTableValues;
    const AddTasksScreen({super.key, this.oldTableValues});




  @override
  State<AddTasksScreen> createState() => _AddTasksScreenState();
}

class _AddTasksScreenState extends State<AddTasksScreen> {
  final UserRepository userRepository = UserRepository();
  TextEditingController taskController = TextEditingController();
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    if (widget.oldTableValues != null) {
      isUpdate = true;
      taskController.text = widget.oldTableValues?.task ?? "";
    }
  }

  // Function to clear the text field
  void clearTextField() {
    setState(() {
      taskController.clear();
    });
  }

  // void onButtonClick() async {
  //   if (taskController.text.isEmpty) {
  //     Fluttertoast.showToast(
  //       msg: "Task is Empty",
  //     );
  //   } else {
  //     final tableValues = TableValues(task: taskController.text);

  //     if (isUpdate) {
  //       // Update operation
  //       tableValues.id = widget.oldTableValues?.id;
  //       await userRepository.updateUser(tableValues);
  //       Fluttertoast.showToast(
  //         msg: "Data Updated",
  //       );
  //       clearTextField(); // Clear the text field
  //     } else {
  //       // Insert new task
  //       await userRepository.insertTask(tableValues);
  //       Fluttertoast.showToast(
  //         msg: "Data Inserted",
  //       );
  //       clearTextField(); // Clear the text field
  //     }
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(color: Colors.white),
        title: Center(
          child: Text(
            isUpdate ? "Edit Your Task" : "Add Task",
            style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 200, 10, 0),
              child: TextField(
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink, width: 2)),
                    hintText: "Write Task"),
                controller: taskController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.pink),
                      shape: MaterialStatePropertyAll(
                          ContinuousRectangleBorder())),
                  onPressed: () {
                    onButtonClick();
                  },
                  child: Text(
                    "Add Task",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.blue),
                      shape: MaterialStatePropertyAll(
                          ContinuousRectangleBorder())),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewTasksScreen(),
                        ));
                  },
                  child: Text(
                    "See Your tasks",
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }

  void onButtonClick() async {
    if (taskController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Task is Empty",
      );
    } else {
      final tableValues =
          TableValues(task: taskController.text);

      if (isUpdate) {
        tableValues.id = widget.oldTableValues?.id;
        await userRepository.updateUser(tableValues);
        Fluttertoast.showToast(
          msg: "Task Updated",
          
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => ViewTasksScreen(), ));
        task:taskController.clear();
      }else {
      
      await userRepository.insertTask(tableValues);

      Fluttertoast.showToast(
        msg: "Task Inserted",
      );
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewTasksScreen(),
          ));
      task:
      taskController.clear();
    }
  }
}
}
