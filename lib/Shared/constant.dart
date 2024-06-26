import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  // can comment the following
  // if you want white fill
  fillColor: Color.fromARGB(255, 4, 37, 64),
  filled: false,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color.fromARGB(255, 4, 37, 64),
      width: 2.0,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.pink,
      width: 2.0,
    ),
  ),
);

var textStyleWhite = const TextStyle(color: Colors.white);
