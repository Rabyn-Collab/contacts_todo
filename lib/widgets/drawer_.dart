import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawerShow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    return Container(
      child: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 5,
                    left: 15,
                    child: Text(
                      'Your Todo\'s',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),

                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.favorite, color: Colors.red[200],),
                title: Text('Favourites'),

              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: (){
                  Navigator.pop(context);
                },
                leading: Icon(Icons.info, color: Colors.brown,),
                title: Text('About'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}