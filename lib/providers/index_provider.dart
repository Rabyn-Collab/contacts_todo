import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/screens/call_screen.dart';
import 'package:flutter_contacts/screens/contact_screen.dart';
import 'package:flutter_contacts/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class WidgetIndexProvider extends ChangeNotifier{
  int currentIndex = 0;
  List<Widget> _widgets = [
    HomeScreen(),
   ContactScreen(),
    HomeScreen(),
   CallScreen(),
    HomeScreen(),
  ];
  List<Widget> get widget{
    return [..._widgets];
  }

  void onItemTap(int index, GlobalKey<ScaffoldState> key){
    if(index == 4){
      key.currentState.openDrawer();
    }else{
        currentIndex = index;
        notifyListeners();
    }
  }

}

final widgetProvider = ChangeNotifierProvider((ref) => WidgetIndexProvider());