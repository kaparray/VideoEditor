import 'package:flutter/material.dart';

SnackBar snackBarCustom(String text) {
  return SnackBar(
        content: Text(text,
            textAlign: TextAlign.center),
        backgroundColor: Colors.grey[700],
        duration: Duration(milliseconds: 1500),
  );
}