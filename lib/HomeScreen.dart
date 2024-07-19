import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/cubit.dart';
import 'package:flutter_projects/states.dart';
import 'package:intl/intl.dart';


class HomeLayout extends StatefulWidget {

  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  bool isBottomSheetShown = false;

  IconData fabIcon = Icons.edit;

  var titleController = TextEditingController();

  var timeController = TextEditingController();

  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.cyan,
              title: Center(
                child: Text(
                  cubit.titles[cubit.currentIndex],
                  style: const TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 30,),
                ),
              ),
            ),
            body: cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    ).then((value) {
                      Navigator.pop(context);
                      isBottomSheetShown = false;
                      fabIcon = Icons.edit;
                    });
                  }
                } else {
                  scaffoldKey.currentState?.showBottomSheet(
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
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: timeController,
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  timeController.text =
                                      (value?.format(context)).toString();
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
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: dateController,
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2025-01-08'),
                                ).then((value) {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value!);
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
                                prefixIcon: Icon(Icons.calendar_month_outlined),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).closed.then((value) {
                    isBottomSheetShown = false;
                    fabIcon = Icons.edit;
                  });
                  isBottomSheetShown = true;
                  fabIcon = Icons.add;
                }
              },
              child: Icon(fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline_outlined),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
