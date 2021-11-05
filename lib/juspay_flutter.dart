import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class Juspay {
  static MethodChannel _juspay = const MethodChannel('juspay');
  final Function onInitiateResult;
  final Function onProcessResult;
  final Function onShowLoader;
  final Function onHideLoader;

  Juspay({
    required this.onInitiateResult,
    required this.onProcessResult,
    required this.onShowLoader,
    required this.onHideLoader,
  }) {
    _juspay.setMethodCallHandler(_juspayCallbacks);
  }

  void dispose() {
    _juspay.setMethodCallHandler(null);
  }

  Future<bool> isInitialised() async {
    var result = await _juspay.invokeMethod('isInitialised');
    return result;
  }

  static Future<String> prefetch(Map<String, dynamic> params) async {
    var result = await _juspay.invokeMethod('prefetch', <String, dynamic>{
      'params': params,
    });
    return result.toString();
  }

  Future<String> initiate(Map<String, dynamic> params) async {
    var result = await _juspay.invokeMethod('initiate', <String, dynamic>{
      'params': params,
    });
    return result.toString();
  }

  Future<String> process(Map<String, dynamic> params) async {
    var result = await _juspay.invokeMethod('process', <String, dynamic>{
      'params': params,
    });
    return result.toString();
  }

  Future<String> terminate() async {
    var result = await _juspay.invokeMethod('terminate');
    return result.toString();
  }

  Future<dynamic> _juspayCallbacks(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'onShowLoader':
        return this.onShowLoader.call(jsonDecode(methodCall.arguments));
      case 'onHideLoader':
        return this.onHideLoader.call(jsonDecode(methodCall.arguments));
      case 'onInitiateResult':
        return this.onInitiateResult.call(jsonDecode(methodCall.arguments));
      case 'onProcessResult':
        return this.onProcessResult.call(jsonDecode(methodCall.arguments));
      default:
        return Future.error('invalid method ${methodCall.method}');
    }
  }
}
