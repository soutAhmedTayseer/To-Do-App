import 'package:flutter/material.dart';
import 'constants.dart';
class NewTasks extends StatelessWidget {
  const NewTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index]),
        separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 2,
              color: Colors.grey[300],
            ),
        itemCount: tasks.length);
  }
}

Widget buildTaskItem(Map model) =>  Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text('${model['time']}'),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model['title']}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                '${model['date']}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.grey),
              ),
            ],
          )
        ],
      ),
    );
