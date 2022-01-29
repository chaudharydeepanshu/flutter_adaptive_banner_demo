import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// Platform messages are asynchronous, so we initialize in an async method.
Future<ConnectivityResult?> initConnectivity(
    {required Connectivity connectivity}) async {
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    return await connectivity.checkConnectivity();
  } on PlatformException catch (e) {
    debugPrint(e.toString());
    return null;
  }
}
