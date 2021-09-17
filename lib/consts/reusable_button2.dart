import 'package:flutter/material.dart';
import 'package:shop_app/consts/colors.dart';

class ReusableButton2 extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color buttonColor;
  final Function fct;

  const ReusableButton2({@required this.label,@required this.icon, @required this.buttonColor, @required this.fct});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(buttonColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: ColorsConsts.backgroundColor)))),
        onPressed: fct,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(icon)
          ],
        ));
  }
}
