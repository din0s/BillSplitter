import 'package:flutter/material.dart';

class CircleButton extends SizedBox {
  final Widget content;
  final dynamic onPress;
  final dynamic onLongPress;
  final Color color;

  CircleButton(
    this.content, {
    this.onPress,
    this.onLongPress,
    this.color = Colors.blueAccent,
  }) : super(
          width: 32,
          child: InkWell(
            onLongPress: onLongPress,
            child: FloatingActionButton(
              backgroundColor: color,
              child: content,
              onPressed: onPress,
            ),
          ),
        );
}
