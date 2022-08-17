import 'package:flutter/material.dart';

class rounded_button extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  Color textColor;
  Color backgroundColor;

  rounded_button({required this.onPressed,
    required this.text,
    required this.textColor,
    required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width/2-20,
      child: OutlinedButton(

        style: OutlinedButton.styleFrom(
          side: BorderSide(
            width: 2.0,
            color: Colors.black,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
        ),

        // style: ButtonStyle(

        //     padding:
        //         MaterialStateProperty.all(const EdgeInsets.all(10)),
        //     shape: MaterialStateProperty.all(RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(40),
        //         ))),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                text,
                style: TextStyle(fontSize: 20, color: textColor),
              ),
            ),
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}
