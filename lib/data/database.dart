import 'package:hive/hive.dart';
import 'package:to_do/data/date_time.dart';

class ToDoDatabase{
  List toDoList = [];
  Map<DateTime, int> heatMapDataSet = {};

  // reference our box
  final _myBox = Hive.box('mybox');

  // run this method if this is the 1st time ever opening this app
  void createInitialData(){
    toDoList = [
      ["Create an app", false],
      ["Do Homework", false],
    ];

    _myBox.put("START_DATE", todaysDateFormatted());
  }
  // load the data from the database
  void loadData(){
    toDoList = _myBox.get("TODOLIST");

    if (_myBox.get(todaysDateFormatted()) == null){
      toDoList = _myBox.get("TODOLIST");

      for (int i = 0; i < toDoList.length; i++){
        toDoList[i][1] = false;

      }
    }
    else{
      toDoList = _myBox.get(todaysDateFormatted());
    }
  }
  //update the database
void updateDataBase(){
    _myBox.put("TODOLIST", toDoList);

    _myBox.put(todaysDateFormatted(), toDoList);

    calculatePercentages();

    loadHeatMap();
  }
  void calculatePercentages(){
    int countCompleted = 0;
    for (int i = 0; i < toDoList.length; i++){
      if (toDoList[i][1] == true) {
        countCompleted++;
      }
    }
    String percent = toDoList.isEmpty
      ? '0.0'
      : (countCompleted / toDoList.length).toStringAsFixed(1);

    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }
  void loadHeatMap(){
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    int daysInBetween = DateTime.now().difference(startDate).inDays;

    //heatMapDataSet.clear();

    for (int i = 0; i < daysInBetween + 1; i++){
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strength = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      int year = startDate.add(Duration(days: i)).year;

      int month = startDate.add(Duration(days: i)).month;

      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strength).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      print(heatMapDataSet);
    }
  }
}