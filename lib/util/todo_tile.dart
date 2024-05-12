import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;

  ToDoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
                onPressed: deleteFunction,
                icon: Icons.delete,
                backgroundColor: Colors.red.shade500,
                borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(24.0),
          child: Row(
            children:[
              //checkbox
              Checkbox(
                  value: taskCompleted,
                  onChanged: onChanged,
                activeColor: Colors.lightGreen,
                ),
              //task name
              Text(taskName,
              style: TextStyle(
                  //decoration: taskCompleted
                      //? TextDecoration.lineThrough
                      //: TextDecoration.none,
                color: Colors.white,
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: taskCompleted
              ? Colors.green.shade400
              : Colors.grey.shade600,
         ),
        ),
      )
    );
  }
}
