import 'package:flutter/material.dart';
import 'package:flutter_projects/cubit.dart';

Widget buildTaskItem(BuildContext context, Map model) {
  return Dismissible(
    key: Key(model['id'].toString()),  // Use the task ID as the key for unique identification
    background: Container(
      color: Colors.red,  // Background color when swiping
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
    ),
    direction: DismissDirection.endToStart,
    confirmDismiss: (direction) async {
      bool? shouldDelete = await _showDeleteConfirmationDialog(context);
      if (shouldDelete ?? false) {  // If shouldDelete is null, it will be treated as false
        // ignore: use_build_context_synchronously
        AppCubit.get(context).deleteTask(id: model['id']);  // Call deleteTask to remove the task
        return true;
      } else {
        return false;
      }
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 50,
            child: Text('${model['time']}',style: const TextStyle(color: Colors.black87,fontSize: 21,fontWeight: FontWeight.bold),),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['title']}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24,),
                ),
                Text(
                  '${model['date']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          IconButton(
            onPressed: () {
              if (model['status'] != 'done') {
                AppCubit.get(context).updateTaskStatus(
                  id: model['id'],
                  status: 'done',
                );
              } else {
                AppCubit.get(context).updateTaskStatus(
                  id: model['id'],
                  status: 'new',
                );
              }
            },
            icon: Icon(
              model['status'] == 'done'
                  ? Icons.check_box  // Filled checkbox for Done tasks
                  : Icons.check_box_outline_blank,  // Empty checkbox for New tasks
              color: Colors.green,
            ),
          ),
          IconButton(
            onPressed: () {
              if (model['status'] != 'archived') {
                AppCubit.get(context).updateTaskStatus(
                  id: model['id'],
                  status: 'archived',
                );
              } else {
                AppCubit.get(context).updateTaskStatus(
                  id: model['id'],
                  status: 'new',
                );
              }
            },
            icon: Icon(
              model['status'] == 'archived'
                  ? Icons.unarchive  // Unarchive icon for Archived tasks
                  : Icons.archive,  // Archive icon for New tasks
              color: Colors.black45,
            ),
          ),
        ],
      ),
    ),
  );
}

Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Task'),
      content: const Text('Are you sure you want to delete this task?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);  // Return true to confirm deletion
          },
          child: const Text('Delete'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);  // Return false to cancel deletion
          },
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}