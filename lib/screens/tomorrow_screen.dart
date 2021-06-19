import 'package:flutter/material.dart';
import 'package:flutter_contacts/models/todos.dart';
import 'package:flutter_contacts/providers/todo_provider.dart';
import 'package:flutter_contacts/screens/todo_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TomorrowScreen extends ConsumerWidget {
  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  @override
  Widget build(BuildContext context, watch) {
    final todos = watch(boxProvider);
    List<Todo> tomoTodo = todos.where((element) =>
    calculateDifference(DateTime.parse(element.dateTime.substring(0,10))) == 1
    ).toList();
    return Scaffold(
      body:tomoTodo.isEmpty ? Center(child: Text(' Add Some Todo for Tomorrow')) : Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ListView.builder(
            itemCount: tomoTodo.length,
            itemBuilder: (context, index){
              final todo = tomoTodo[index];
              final dateTime = DateTime.parse(todo.dateTime);
              return  ExpansionTile(
                backgroundColor: Colors.black,
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${todo.task}'),
                ),
                trailing: Text('${todo.time}'),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(dateTime.toString().substring(0, 10)),
                ),
                children: [
                  Row(
                    children: [
                      Expanded(child: TextButton.icon(onPressed: (){
                        showDialog(context: context, builder: (context)=> TodoWidget(todo: todo, index:  index,));
                      }, icon: Icon(Icons.edit, color: Colors.green,), label: Text('Edit', style: TextStyle(color: Colors.white)))),
                      Expanded(child: TextButton.icon(onPressed: (){
                        showDialog(context: context, builder: (context)=> AlertDialog(
                          title: Text('Are you sure ?'),
                          actions: [
                            TextButton.icon(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: Colors.black,), label: Text('No', style: TextStyle(color: Colors.white))),
                            TextButton.icon(onPressed: (){
                              context.read(boxProvider.notifier).deleteTodos(todo, index, todo.id, todo.key);
                              Navigator.pop(context);
                            }, icon: Icon(Icons.delete, color: Colors.pink,), label: Text('Yes', style: TextStyle(color: Colors.white))),
                          ],
                        ));
                      }, icon: Icon(Icons.delete, color: Colors.pink,), label: Text('Remove', style: TextStyle(color: Colors.white),)))
                    ],
                  )
                ],
              );
            }),
      ),

    );
  }
}
