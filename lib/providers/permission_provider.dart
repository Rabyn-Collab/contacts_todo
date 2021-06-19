import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';


final permissionProvider = StateNotifierProvider.family((ref, BuildContext context) => PermissionNotifier(context: context));

class PermissionNotifier extends StateNotifier<PermissionStatus>{
  PermissionNotifier({PermissionStatus state, this.context}) : super(state ?? PermissionStatus.denied){
    _askPermissions();
  }


  BuildContext context;

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      state = permissionStatus;
    } else {
      state = permissionStatus;
    }
  }
  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }




}

