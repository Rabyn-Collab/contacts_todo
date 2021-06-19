import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';


import '../main.dart';
part 'todos.g.dart';


@HiveType(typeId: 0)
class Todo extends HiveObject{
  
  @HiveField(0)
  String task;
  
  @HiveField(1)
  String dateTime;

  @HiveField(2)
  String time;

  @HiveField(3)
  String id;


  Todo({this.time, this.dateTime, this.task, this.id});

}
