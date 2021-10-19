import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class Juspay {
  late MethodChannel _juspay;
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
    _juspay = const MethodChannel('juspay');
    _juspay.setMethodCallHandler(_juspayCallbacks);
  }

  Future<String> prefetch(Map<String, dynamic> params) async {
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
      case 'onInitiateResult':
        return this.onInitiateResult.call(jsonDecode(methodCall.arguments));
      case 'onProcessResult':
        return this.onProcessResult.call(jsonDecode(methodCall.arguments));
      default:
        return Future.error('invalid method ${methodCall.method}');
    }
  }
}
