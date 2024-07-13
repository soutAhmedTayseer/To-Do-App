import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/ArchivedTasks.dart';
import 'package:flutter_projects/DoneTasks.dart';
import 'package:flutter_projects/NewTasks.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'constants.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  List<Widget> screens = [
    const NewTasks(),
    const DoneTasks(),
    const ArchivedTasks(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  Database? database;

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
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.teal[500],
        title: Text(
          titles[currentIndex],
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: tasks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState!.validate()) {
              insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text)
                  .then((value) {
                getDataFromDatabase(database).then((value) {
                  Navigator.pop(context);
                  setState(() {
                    isBottomSheetShown = false;
                    fabIcon = Icons.edit;
                    tasks = value;
                    if (kDebugMode) {
                      print(tasks);
                    }
                  });
                });
              });
            }
          } else {
            scaffoldKey.currentState
                ?.showBottomSheet(
                  (context) => Container(
                    color: Colors.grey[300],
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                              controller: titleController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Title must not be empty';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  labelText: 'Task Title',
                                  prefixIcon: Icon(Icons.title),
                                  border: OutlineInputBorder())),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                              controller: timeController,
                              onTap: () {
                                showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now())
                                    .then((value) {
                                  if (kDebugMode) {
                                    timeController.text =
                                        (value?.format(context)).toString();
                                    print(value?.format(context));
                                  }
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Time must not be empty';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  labelText: 'Task Time',
                                  prefixIcon: Icon(Icons.access_time_outlined),
                                  border: OutlineInputBorder())),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                              controller: dateController,
                              onTap: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2025-01-08'))
                                    .then((value) {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value!);
                                  if (kDebugMode) {
                                    print(DateFormat.yMMMd().format(value));
                                  }
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Date must not be empty';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  labelText: 'Task Date',
                                  prefixIcon:
                                      Icon(Icons.calendar_month_outlined),
                                  border: OutlineInputBorder())),
                        ],
                      ),
                    ),
                  ),
                )
                .closed
                .then((value) {
              isBottomSheetShown = false;
              setState(() {
                fabIcon = Icons.edit;
              });
            });
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
        showSelectedLabels: true,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline_outlined), label: 'Done'),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined), label: 'Archived'),
        ],
      ),
    );
  }

  void createDatabase() async {
    database = await openDatabase(
      'Task.db',
      version: 1,
      onCreate: (database, version) {
        if (kDebugMode) {
          print('database created');
        }
        database
            .execute(
                'CREATE TABLE Task(id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)')
            .then((value) {
          if (kDebugMode) {
            print('table created');
          }
        }).catchError((error) {
          if (kDebugMode) {
            print('Error When Creating Table ${error.toString()}');
          }
        });
      },
      onOpen: (database) {
        if (kDebugMode) {
          getDataFromDatabase(database).then((value) {
            tasks = value;
            if (kDebugMode) {
              print(tasks);
            }
          });
          print('database opened');
        }
      },
    );
  }

  Future<int> insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    if (database != null) {
      return await database!.transaction((txn) async {
        int id = await txn.rawInsert(
          'INSERT INTO Task(title, time, date, status) VALUES(?, ?, ?, ?)',
          [title, date, time, 'new'], // Use parameterized query
        );
        if (id > 0) {
          if (kDebugMode) {
            print('$id inserted successfully');
          }
        } else {
          if (kDebugMode) {
            print('Error inserting new record');
          }
        }
        return id;
      });
    } else {
      if (kDebugMode) {
        print('Error: Database not initialized');
      }
      return -1; // Or throw an exception
    }
  }

  Future<List<Map>> getDataFromDatabase(database) async {
    return await database.rawQuery('Select * from Task');
  }
}
