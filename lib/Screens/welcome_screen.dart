import 'package:flutter/material.dart';
import 'package:hust_blog/Screens/Widget/rounded_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body:
      Image.asset(
        'images/logo_main.png',
        width: size.width,
      ),
      bottomNavigationBar:
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            rounded_button(
              text: "LOG IN",
              textColor: Colors.black,
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              backgroundColor: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            rounded_button(
              text: "REGISTER",
              textColor: Colors.black,
              backgroundColor: Colors.transparent,
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },

            ),
          ],
        ),
      ),
    );
  }
}
