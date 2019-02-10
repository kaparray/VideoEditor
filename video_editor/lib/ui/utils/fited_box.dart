import 'package:flutter/material.dart';

fitedBox(double edge) {
    return FittedBox(
      child: Padding(
        padding: EdgeInsets.all(edge),
      ),
    );
  }