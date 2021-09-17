import 'package:flutter/material.dart';

class ListBodyTile extends StatelessWidget {
  final Function onTapFct;
  final IconData icon;
  final String labelText;
  final Color textColor;
  final Color iconColor;

  const ListBodyTile({@required this.onTapFct, @required this.icon, @required this.labelText, @required this.textColor, @required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapFct,
      splashColor: Colors.purpleAccent,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
          Text(
            labelText,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500, color: textColor),
          )
        ],
      ),
    );
  }
}
