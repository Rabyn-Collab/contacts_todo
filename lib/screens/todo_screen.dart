import 'package:flutter/material.dart';
import 'package:flutter_contacts/models/todos.dart';
import 'package:flutter_contacts/providers/todo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class AllScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final todos = watch(boxProvider);
    return Scaffold(
      body:todos.isEmpty ? Center(child: Text('Loading, Add Some Todo')) : Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index){
              final todo = todos[index];
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


class TodoWidget extends StatefulWidget {
  final Todo todo;
  final int index;
  TodoWidget({this.todo, this.index});
  @override
  _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {

  final _form = GlobalKey<FormState>();
  final taskController = TextEditingController();


  String date = '';

  void selectDate(BuildContext context)  {
    showDatePicker(context: context, initialDate: DateTime.now(),
        firstDate: DateTime(2019), lastDate: DateTime(2022)).then((value){
      if(value == null){
        return;
      }
      setState(() => date = value.toString());
    });
  }

  String time = '';
  Future<void> selectTime(BuildContext context) async {
    final now = DateTime.now();
    final newTime =   await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
    );

    if (newTime == null) return;
    setState(() => time = newTime.toString());
  }

  @override
  void initState() {
    if(widget.todo != null){
      taskController.text = widget.todo.task;
      date = widget.todo.dateTime;
      time = widget.todo.time;
    }
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;
    final title = isEditing ? 'Edit Todo' : 'Add Todo';


    return AlertDialog(
      title: Text(title),
      content: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('What is to be done ?'),
                  TextFormField(
                    validator: (val) {
                      if (val.isEmpty && val != null) {
                        return 'Enter a task';
                      }
                      return null;
                    },
                    controller: taskController,
                    decoration: InputDecoration(
                        labelText: 'Enter Task Here'
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Task Date'),
                  InkWell(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      selectDate(context);
                    },
                    child: IgnorePointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.date_range),
                          labelText: date == '' ? 'Date Time' : date,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Time of the Day'),
                  InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      selectTime(context);
                    },
                    child:  IgnorePointer(
                      child: TextFormField(
                        validator: (val){
                          if(time == ''){
                            return 'This field is required';
                          }
                          return null;
                        },
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelText: time == '' ? 'Time' : time,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop()
        ),
        Consumer(
          builder: (context, watch, child) => TextButton(
            child: Text(isEditing ? 'Edit' : 'Add'),
            onPressed: () async {
              final isValid = _form.currentState.validate();
              if (isValid) {
                final task = taskController.text;

                if(isEditing){
                  context.read(boxProvider.notifier).editTodos(
                      widget.todo, task,
                      date, time, widget.index);
                }else{
                  context.read(boxProvider.notifier).addTodos(
                      task, date, time
                  );
                }

                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ],
    );
  }

}