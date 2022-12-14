import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hust_blog/Screens/Message/database_firebase.dart';
import 'package:hust_blog/Screens/Widget/background.dart';
import 'package:hust_blog/Screens/Widget/full_button.dart';
import 'package:hust_blog/Screens/Widget/rounded_button.dart';
import 'package:hust_blog/Screens/Widget/rounded_input_field.dart';
import 'package:hust_blog/network_handler.dart';
import 'dart:convert';
import 'Message/auth_firebase.dart';
import 'Message/database_firebase.dart';
import 'Widget/rounded_password_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}



class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  NetworkHandler networkHandler = NetworkHandler();
  final formKey = GlobalKey<FormState>();

  // for signup firebase
  AuthMethods authMethods = new AuthMethods();

  // for update data firebase
  DatabaseMethods databaseMethods = new DatabaseMethods();

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  void createUserInFirestore(){
    authMethods.signUpWithPhoneNumberAndPassword(phoneController.text+"@gmail.com",
        passwordController.text).then((value) {
      // dang ky thong tin tren firebase
      users.where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .limit(1)
          .get()
          .then(
              (QuerySnapshot querySnapshot){
            if (querySnapshot.docs.isEmpty){
              users.add({
                'name': nameController.text,
                'phone_nummber':phoneController.text,
                'uid': FirebaseAuth.instance.currentUser!.uid
              });
            }
          }
      );
    },);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: formKey,
        child: SizedBox(
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.08,
              ),
              Padding(
                padding: EdgeInsets.all(size.width * 0.125),
                child:
                Row(
                  children: [
                    Text(
                      'Register',
                      style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              rounded_input_field(
                size: size,
                text: "Full name",
                inputController: nameController,
                validator: (value) {
                  if (value!.isEmpty) return "B???n ch??a nh???p t??n";
                  if (value.length <= 8) {
                    return "T??n c???a b???n t???i thi???u 8 k?? t???";
                  }
                  return null;
                },
              ),
              rounded_input_field(
                size: size,
                text: "Phone numbers",
                inputController: phoneController,
                validator: (value) {
                  if (value!.isEmpty) return "B???n ch??a nh???p s??? ??i???n tho???i";
                  if (value.length < 9 || !RegExp(r'^[+]*[(]{0,1}[0-9]+$').hasMatch(value)) {
                    return "S??? ??i???n tho???i t???i thi???u 10 k?? t???";
                  }
                  return null;
                },
              ),
              rounded_password_field(
                size: size,
                text: "Password",
                passwordController: passwordController,
                validator: (value) {
                  if (value!.isEmpty) return "B???n ch??a nh???p m???t kh???u";
                  if (value.length < 6) {
                    return "M???t kh???u t???i thi???u 6 k?? t???";
                  }
                  if (passwordController.text != passwordController2.text) {
                    return "M???t kh???u kh??ng kh???p";
                  }
                  return null;
                },
              ),
              rounded_password_field(
                size: size,
                text: "Repeat",
                passwordController: passwordController2,
                validator: (value) {
                  if (value!.isEmpty) return "B???n ch??a nh???p l???i m???t kh???u";
                  if (value.length < 6 || passwordController.text != passwordController2.text) {
                    return "M???t kh???u kh??ng kh???p";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: size.height * 0.065,
              ),
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.1,
                  ),
                  Full_button(
                      textColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          Map<String, String> data = {
                            "username": nameController.text,
                            "phonenumber": phoneController.text,
                            "password": passwordController.text
                          };

                          createUserInFirestore();

                          // print(data);

                          createUserInFirestore();

                          var response =
                          await networkHandler.post("/users/register", data);
                          Map output = json.decode(response.body);
                          if (response.statusCode < 300) {
                            setState(() {
                              Fluttertoast.showToast(
                                  msg: "????ng k?? th??nh c??ng", fontSize: 18);
                            });


                            Navigator.pushNamed(context, '/mainpage');
                          }
                        }

                      },

                      text: "Next"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}