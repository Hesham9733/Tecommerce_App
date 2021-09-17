import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const CircleIcon({this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Icon(
        icon,
        color: Colors.white,
      ),
      backgroundColor: color,
    );
  }
}
