import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  final String label;
  final Function fct;

  const ReusableButton({@required this.label, @required this.fct});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return OutlineButton(
      onPressed: fct,
      shape: StadiumBorder(),
      borderSide: BorderSide(color: Colors.deepPurple, width: 2),
      highlightColor: Colors.deepPurple.shade200,
      child: Text(
        label.toUpperCase(),
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
