import 'package:flutter_contacts/models/todos.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hive/hive.dart';

import '../main.dart';

class Boxes{
  static Box getTodos() => Hive.box<Todo>('todo');
}


final boxProvider = StateNotifierProvider<HiveBox, List<Todo>>((ref) => HiveBox(ref.read));
final stateProvider = StateProvider((ref) => HiveBox(ref.read));

class HiveBox extends StateNotifier<List<Todo>>{
  HiveBox(this.read) : super(read(boxA));
  final Reader read;



 

  Future addTodos(String task, String dateTime, String time) async{
    final todo = Todo(
        task: task,
        dateTime: dateTime,
        time: time,
      id: DateTime.now().toString()
    );

    final box = Boxes.getTodos();
    box.add(todo);
    state = [...state, todo];

  }

  void editTodos(Todo todo, String task, String dateTime, String time, int index){
    final editTrans = state[index];
    todo.time = time;
    todo.dateTime = dateTime;
    todo.task = task;

    state = [
      for(final element in state)
        if(element == editTrans) todo else element
    ];
todo.save();

  }

  void deleteTodos(Todo todo, int index, id, key){
    final box = Boxes.getTodos();
    box.delete(key);
    state =  state.where((element) => element.id != id).toList();

  }

  @override
  void dispose() {
    Hive.box('todo').close();
    super.dispose();
  }

}
