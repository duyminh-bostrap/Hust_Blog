import 'package:flutter/material.dart';

class Full_button extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  Color textColor;
  Color backgroundColor;

  Full_button({required this.onPressed,required  this.text,required  this.textColor,required  this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width*0.77,
      child: FlatButton(
        color: Colors.black,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(15.0)
        ),
        child:  Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: textColor),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
