import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter_contacts/screens/today_screen.dart';
import 'package:flutter_contacts/screens/todo_screen.dart';
import 'package:flutter_contacts/screens/tomorrow_screen.dart';




class HomeScreen extends StatelessWidget {

 final List<Widget> _tab = [
  Tab(text: 'All'),
  Tab(text: 'Today',),
  Tab(text: 'Tomorrow',),
 ];



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('TO DO APP'),
      bottom: TabBar(
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BubbleTabIndicator(
            indicatorHeight: 25.0,
            indicatorColor: Colors.teal[500],
            tabBarIndicatorSize: TabBarIndicatorSize.tab
          ),
          tabs: _tab,

      ),
        ),
        body: TabBarView(
            children: [
            AllScreen(),
            TodayScreen(),
            TomorrowScreen(),
            ]),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
              showDialog(context: context, builder: (context) => TodoWidget());
            }
        ),
      ),
    );
  }
}
