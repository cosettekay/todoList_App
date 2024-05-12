import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:to_do/data/database.dart';
import 'package:to_do/util/dialog_box.dart';
import 'package:to_do/util/monthly_summary.dart';
import 'package:to_do/util/todo_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  // reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState(){
    //TODO: implement initState

    //if this is the 1st time ever opening the app, then create the default data
    if (_myBox.get("TODOLIST") == null){
      db.createInitialData();
    } else {
      // there already exists data
      db.loadData();
    }

    super.initState();
  }

  // text controller
  final _controller = TextEditingController();

  //list of todo tasks
  //List toDoList = [
  //  ["Make an App", false],
  //  ["Do exercise", false],
  //];

  // checkbox was tapped
  void checkBoxChanged(bool? value, int index){
    setState((){
      db.toDoList[index][1] = !db.toDoList[index][1];
      }
    );
    db.updateDataBase();
  }

  // save new task
  void saveNewTask(){
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  //create a new task
  void createNewTask(){
    showDialog(
        context: context,
        builder: (context){
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
      },
    );
  }

  // delete task
  void deleteTask(int index){
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey.shade700,
        title: Text('Your List',
        style: TextStyle(
          color: Colors.white,
        ),),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // monthly summary heat map
          MonthlySummary(
              datasets: db.heatMapDataSet,
              startDate: _myBox.get("START_DATE")
                 ?? DateTime.now().toString(),
          ),

          // list of to-do
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: db.toDoList.length,
              itemBuilder: (context, index){
                return ToDoTile(
                  taskName: db.toDoList[index][0],
                  taskCompleted: db.toDoList[index][1] ,
                  onChanged: (value) => checkBoxChanged(value, index),
                  deleteFunction: (context) => deleteTask(index),
                );
              }
          ),
        ],
      )
    );
  }
}