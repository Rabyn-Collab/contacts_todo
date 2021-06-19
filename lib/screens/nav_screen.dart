import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/providers/index_provider.dart';
import 'package:flutter_contacts/widgets/drawer_.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

bool isVisible  = false;
class NavScreen extends ConsumerWidget {

final  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context, watch) {
    final _widgets = watch(widgetProvider);
    return Scaffold(
        key: _drawerKey,
        drawer: DrawerShow(),
        body: PageTransitionSwitcher(
            duration: Duration(seconds: 1),
            transitionBuilder: (child,
                animation,
                secondaryAnimation) => SharedAxisTransition(
                child: child,
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal
            ),
            child: _widgets.widget[_widgets.currentIndex]
        ),
        bottomNavigationBar: Visibility(
          child: KeyboardVisibilityBuilder(
            builder: (context, visible) => Visibility(
              visible: visible ? false : true,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                selectedFontSize: 12.0,
                unselectedFontSize: 12.0,
                currentIndex: _widgets.currentIndex,
                  onTap:(index) =>  context.read(widgetProvider).onItemTap(index, _drawerKey),
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined),
                        activeIcon: Icon(Icons.home),
                        label:'Home'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.contacts_outlined),
                        activeIcon: Icon(Icons.contacts),
                        label:'Contacts'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.add_circle_outline, size: 30,),
                        activeIcon: Icon(Icons.add_circle, size: 30,),
                        label:'Add'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.call_outlined),
                        activeIcon:  Icon(Icons.call),
                        label:'Calls'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.menu_outlined),
                        activeIcon: Icon(Icons.menu),
                        label:'Menu'),
                  ]
              )
            ),
          ),
        ),
    );
  }
}