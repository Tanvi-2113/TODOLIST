import 'package:flutter/material.dart';
import 'package:todolistlocaldatabase/adduser.dart';
import 'package:todolistlocaldatabase/createdatabase.dart';
import 'package:todolistlocaldatabase/usermodel.dart';

class ViewTasksScreen extends StatefulWidget {
  const ViewTasksScreen({super.key});

  @override
  State<ViewTasksScreen> createState() => _ViewTasksScreenState();
}

class _ViewTasksScreenState extends State<ViewTasksScreen> {
  TextEditingController taskController = TextEditingController();
  final UserRepository userRepository = UserRepository();
  List<TableValues> usersList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__) {
      getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Text(
            "View Tasks",
            style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          Navigator.pop(context,
              MaterialPageRoute(builder: (context) => AddTasksScreen()));
               taskController.clear();
        },
        child: Icon(Icons.add),
      ),
      body:usersList.isEmpty
          ? Center(child: Text("No Tasks added"))
          : ListView.builder(
              itemCount: usersList.length,
              itemBuilder: ((context, index) {
                final user = usersList[index];
                return ListTile(
                  title: Text(user.task.toString()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                       navigateToUpdateScreen(user);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          deleteButtonPress(index);
                        },
                      ),
                    ],
                  ),
                );
              }),
            ),
    );
  }

  Future<void> getUsers() async {
    final users = await userRepository.getUsers();
    setState(() {
      usersList.clear();
      usersList.addAll(users);
      print("Length ${usersList.length}");
    });
  }
  
  
 void navigateToUpdateScreen(TableValues tableValues) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AddTasksScreen(oldTableValues: tableValues),
      ),
    ).then((value) {
      // Refresh the list when returning from the AddTasksScreen
      getUsers();
    });
  }
  void deleteButtonPress(int index) {
    showDialog(
        context: context,
        builder: (__) {
          return AlertDialog(
            content: SizedBox(
              height: MediaQuery.of(context).size.height*0.2,
              child: Column(
                children: [
                  const Text("Delete User"),
                  const Text("Do you want to delete this user?"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("No")),
                      TextButton(
                          onPressed: () async {
                            await userRepository.removeUser(usersList[index]);
                            getUsers();
                            Navigator.pop(context);
                          },
                          child: const Text("Yes"))
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
