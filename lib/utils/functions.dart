import 'package:flutter/material.dart';

Future<dynamic> goTo(BuildContext context,Widget widget){
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}