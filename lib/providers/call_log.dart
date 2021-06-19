import 'package:call_log/call_log.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:permission_handler/permission_handler.dart';


class CallLogs {

  Future<dynamic> phonePermission() async{
    if(await Permission.phone.request().isGranted){
        dynamic entries = await CallLog.get();
       return entries.toList();

    }else {
      print('');
    }

  }

  Stream<dynamic> getLogs() async*{
    final callLogs = await phonePermission();
    yield callLogs;
  }

}

final callProvider = StreamProvider((ref) => CallLogs().getLogs());