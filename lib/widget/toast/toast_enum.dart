import 'package:flutter/material.dart';

enum ToastEnum {
  info(color: Colors.blue),
  success(color: Colors.green),
  error(color: Colors.redAccent);

  final Color color;

  const ToastEnum({required this.color});
}
