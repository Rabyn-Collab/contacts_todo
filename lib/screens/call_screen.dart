import 'package:flutter/material.dart';
import 'package:flutter_contacts/providers/call_log.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class CallScreen extends ConsumerWidget {

  @override
  Widget build(BuildContext context, watch) {
    final logs = watch(callProvider);
    context.refresh(callProvider);
    return Scaffold(
      body: logs.when(
          data: (data){
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index){
                final entry = data[index];
                return Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: <Widget>[
                      Divider(),
                      Text('F. NUMBER: ${entry.formattedNumber}'),
                      Text('NUMBER   : ${entry.number}'),
                      Text('NAME     : ${entry.name}'),
                      Text('TYPE     : ${entry.callType}'),
                      Text(
                          'DATE     : ${DateTime.fromMillisecondsSinceEpoch(entry.timestamp)}',),
                      Text('DURATION :  ${entry.duration}',),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
                );
              }
            );
          },
          loading: () => Center(child: CircularProgressIndicator(),),
          error: (err, stack) =>Center(child: Text('$err')))
    );
  }
}


