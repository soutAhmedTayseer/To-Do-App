import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'ArchivedTasks.dart';
import 'DoneTasks.dart';
import 'NewTasks.dart';

class homeLayout extends StatefulWidget {
  const homeLayout({super.key});

  @override
  State<homeLayout> createState() => _homeLayoutState();
}

class _homeLayoutState extends State<homeLayout> {
  int currentIndex = 0;
  List<Widget> SCREENS = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  List<String> Titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  // Database database ;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    createDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          Titles[currentIndex],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: SCREENS[currentIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState != null &&
                formKey.currentState!.validate()) {
              // insertToDatabase(titleController.text,dateController.text,timeController.text,
              // ).then((value)
              // {
              Navigator.pop(context);
              isBottomSheetShown = false;
              setState(() {
                fabIcon = Icons.edit;
              });
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        defaultFormField(
                          controller: titleController,
                          type: TextInputType.text,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'title must not be empty';
                            }
                            return null;
                          },
                          label: 'Task Title',
                          prefix: Icons.title,
                          onTap: () {},
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: timeController,
                          type: TextInputType.datetime,
                          onTap: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((value) {
                              timeController.text =
                                  //     value.format(context).toString();
                                  // print(value.format(context));
                                  value.toString();
                              print(value);
                            });
                          },
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'time must not be empty';
                            }

                            return null;
                          },
                          label: 'Task Time',
                          prefix: Icons.watch_later_outlined,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: dateController,
                          type: TextInputType.datetime,
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.parse('2024-08-01'),
                            ).then((value) {
                              dateController.text = value.toString();
                              print(value);
                            });
                          },
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'date must not be empty';
                            }
                            return null;
                          },
                          label: 'Task Date',
                          prefix: Icons.calendar_today,
                        ),
                      ],
                    ),
                  ),
                ),
                elevation: 20.0,
              ),
            );
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(
          fabIcon,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            print(index);
          });
        },
        fixedColor: Colors.purple,
        elevation: 20,
        backgroundColor: Colors.grey[100],
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_circle_outline,
            ),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.archive_outlined,
            ),
            label: 'Archived',
          ),
        ],
      ),
    );
  }

  Future<String> getName() async {
    return 'Nour Muhammed';
  }

  void createDataBase() async {
    var database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async {
        print('DataBase created');
        await database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT ,date TEXT ,time TEXT ,status TEXT ,)')
            .then((value) {
          print('Table created');
        }).catchError((error) {
          print('Error when created Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        print('DataBase opened');
      },
    );
  }

  defaultFormField(
          {required TextEditingController controller,
          required TextInputType type,
          required Null Function() onTap,
          required String? Function(String value) validate,
          required String label,
          required IconData prefix}) =>
      TextFormField(
        controller: controller,
        keyboardType: type,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            prefix,
          ),
        ),
      );

// Future insertToDatabase(
//    String title,
//    String time,
//    String date,
// ) async {
//   return await database.transaction((txn)
//   {
//     txn
//         .rawInsert(
//       'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$time", "$date", "new")',
//     )
//         .then((value) {
//       print('$value inserted successfully');
//     }).catchError((error) {
//       print('Error When Inserting New Record ${error.toString()}');
//     });
//
//     return null;
//   });
// }
}
