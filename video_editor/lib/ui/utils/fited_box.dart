import 'package:flutter/material.dart';

FittedBox fitedBox(double edge) {
    return FittedBox(
      child: Padding(
        padding: EdgeInsets.all(edge),
      ),
    );
  }