import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/cubit.dart';
import 'package:flutter_projects/states.dart';
import 'components.dart';

class ArchivedTasks extends StatelessWidget {
  const ArchivedTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).tasks
            .where((task) => task['status'] == 'archived')
            .toList();

        return ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(context, tasks[index]),
          separatorBuilder: (context, index) => Container(
            width: double.infinity,
            height: 2,
            color: Colors.grey[300],
          ),
          itemCount: tasks.length,
        );
      },
    );
  }
}
