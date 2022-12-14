import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hust_blog/Screens/Block/block_list.dart';
import 'package:hust_blog/Screens/NewsFeed/create_post_container.dart';
import 'package:hust_blog/Screens/NewsFeed/new_post_screen.dart';
import 'package:hust_blog/Screens/NewsFeed/post_container.dart';
import 'package:hust_blog/Screens/Profile/edit_profile_screen.dart';
import 'package:hust_blog/Screens/Widget/background.dart';
import 'package:hust_blog/Screens/Widget/color.dart';
import 'package:hust_blog/Screens/Widget/full_button.dart';
import 'package:hust_blog/Screens/Widget/profile_avatar.dart';
import 'package:hust_blog/Screens/Message/auth_firebase.dart';
import 'package:hust_blog/get_data/get_post.dart';
import 'package:hust_blog/get_data/get_user_info.dart';
import 'package:hust_blog/models/models.dart';
import 'package:hust_blog/network_handler.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hust_blog/Screens/Message/auth_firebase.dart';
import '../../get_data/get_info.dart';

String link =dotenv.env['link']??"";
String link2 =dotenv.env['link2']??"";
String host = dotenv.env['host'] ?? "";

NetworkHandler networkHandler = NetworkHandler();
final storage = new FlutterSecureStorage();

class ProfileScreen extends StatefulWidget {
  bool isProfile;
  ProfileScreen({
    Key? key,
    required this.isProfile,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState(isProfile: isProfile);
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController searchController = TextEditingController();
  bool isProfile = false;
  AuthMethods authMethods = new AuthMethods();

  _ProfileScreenState({
    Key? key,
    required this.isProfile,
  });


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return //isProfile
      Scaffold(
        backgroundColor: Colors.grey[200],
        //appBar: null,
        body: ListView(
            shrinkWrap: true,
            children: [
              FutureBuilder<UserData>(
                future: UsersApi.getCurrentUserData(),
                builder: (context, snapshot) {
                  final user = snapshot.data;
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return user != null?
                      Stack(
                        children: [
                          // Container(
                          //   width: size.width,
                          //   height: 230,
                          //   child: GestureDetector(
                          //       onTap: () {print('coverimage');}, //_showProfile(post, context),
                          //       child:CachedNetworkImage(
                          //         imageUrl: user != null? "$host${user.coverImage.fileName}" :link2,
                          //         fit: BoxFit.fitWidth,
                          //       )
                          //   ),
                          // ),
                          Container(
                            width: size.width,
                            height: 200,
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              onTap: () {print('avatar');}, //_showProfile(post, context),
                              child: ProfileAvatar(
                                imageUrl: user != null? "$host${user.avatar.fileName}" : link,
                                hasBorder: false,
                                minSize: 75,
                                maxSize: 80,
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(225, 250, 0, 0), //top: 210, left: size.width*0.55
                          //   child: Container(
                          //       width: 48,
                          //       height: 48,
                          //       alignment: Alignment.center,
                          //       decoration: BoxDecoration(
                          //         color: Color.fromRGBO(35, 35, 35, 0.9),
                          //         borderRadius: BorderRadius.all(Radius.circular(size.width*0.225)),
                          //       ),
                          //       child: IconButton(
                          //         icon: Icon(Icons.photo_camera, color: Colors.white, size: 32,),
                          //         onPressed: () => createPost(context),
                          //       )
                          //   ),
                          // ),
                          Column(
                            children: [
                              SizedBox(height: 210.0,),
                              Container(
                                alignment: Alignment.bottomCenter,
                                height: 40.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(width: 10.0,),
                                    Text(
                                        user!= null? user.username: '',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        )
                                    ),
                                    // showName(color: Colors.black,
                                    //     size: 20,
                                    //     fontWeight: FontWeight.bold),
                                    SizedBox(width: 10.0,),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 0.0),
                                      child: Icon(Icons.check_circle, color: Colors.black,  size: 20,),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Text(
                                  'Your bio here',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300
                                  )
                              ),
                              SizedBox(height: 30.0,),
                              Full_button(
                                textColor: Colors.white,
                                onPressed: ()  {
                                  createPost(context);
                                },
                                text: "+ Add new post", backgroundColor: Colors.transparent,
                              ),
                              SizedBox(height: 10.0,),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(7),
                                height: size.height * 0.095,
                                width: size.width * 0.8,
                                child: TextFormField(
                                  controller: searchController,
                                  validator: (value) {return null;
                                  },
                                  // obscureText: checkPass,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.search, color: Colors.black,),
                                        onPressed: () {
                                          setState(() {
                                            print('hello');
                                          });
                                        },
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                          borderSide: BorderSide(
                                              color: Colors.black,
                                              style: BorderStyle.solid,
                                              width: 2)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black,)),
                                      errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red,)),
                                      filled: true,
                                      hintStyle: TextStyle(color: Colors.grey[800]),
                                      hintText: 'Search here',
                                      fillColor: Colors.white70),
                                ),
                              ),
                              // Container(
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //     children: <Widget>[
                              //       Column(
                              //         children: <Widget>[
                              //           IconButton(
                              //             icon: Icon(Icons.add_photo_alternate, size: 28, color: blueColor),
                              //             onPressed: () {
                              //               createPost(context);
                              //             },
                              //           ),
                              //           Text('Th??m ???nh', style: TextStyle(color: blueColor),)
                              //         ],
                              //       ),
                              //       Column(
                              //         children: <Widget>[
                              //           IconButton(
                              //             icon: Icon(Icons.edit, color: Colors.black),
                              //             onPressed: () {
                              //               showModalBottomSheet(
                              //                   isScrollControlled: true,
                              //                   context: context,
                              //                   builder: (BuildContext context) => EditProfilePage()
                              //               );
                              //             },
                              //           ),
                              //           Text('Ch???nh s???a', style: TextStyle(
                              //               color: Colors.black
                              //           ),)
                              //         ],
                              //       ),
                              //       Column(
                              //         children: <Widget>[
                              //           IconButton(
                              //             icon: Icon(Icons.more_vert, color: Colors.black),
                              //             onPressed: () {
                              //               _showMoreOption(context);
                              //             },
                              //           ),
                              //           Text('Th??m', style: TextStyle(
                              //               color: Colors.black
                              //           ),)
                              //         ],
                              //       )
                              //     ],
                              //   ),
                              //   // Row(
                              //   //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //   //   children: <Widget>[
                              //   //     Column(
                              //   //       children: <Widget>[
                              //   //         IconButton(
                              //   //           icon: Icon(Icons.person, size: 28, color: Colors.black),
                              //   //           onPressed: () {
                              //   //             print("collections");
                              //   //           },
                              //   //         ),
                              //   //         Text('B???n b??', style: TextStyle(color: Colors.black),)
                              //   //       ],
                              //   //     ),
                              //   //     Column(
                              //   //       children: <Widget>[
                              //   //         IconButton(
                              //   //           icon: Icon(MdiIcons.facebookMessenger, color: Colors.black),
                              //   //           onPressed: () {
                              //   //             print("collections");
                              //   //           },
                              //   //         ),
                              //   //         Text('Nh???n tin', style: TextStyle(
                              //   //             color: Colors.black
                              //   //         ),)
                              //   //       ],
                              //   //     ),
                              //   //     Column(
                              //   //       children: <Widget>[
                              //   //         IconButton(
                              //   //           icon: Icon(Icons.more_vert, color: Colors.black),
                              //   //           onPressed: () {
                              //   //             _showMoreOption(context);
                              //   //           },
                              //   //         ),
                              //   //         Text('Th??m', style: TextStyle(
                              //   //             color: Colors.black
                              //   //         ),)
                              //   //       ],
                              //   //     )
                              //   //   ],
                              //   // ),
                              // ),
                              SizedBox(height: 10.0,),
                              Container(
                                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                                child: Column(
                                  children: <Widget>[

                                    Container(
                                      height: 15.0,
                                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                      child:
                                      Divider(
                                        color: Colors.grey,
                                      ),
                                    ),

                                    // Container(
                                    //     height: 40,
                                    //     alignment: Alignment.centerLeft,
                                    //     child: Row(
                                    //       children: [
                                    //         Icon(Icons.style, color: Colors.black, size: 25.0),
                                    //         SizedBox(width: 10,),
                                    //         Text('Your posts', style: TextStyle(
                                    //           fontSize: 20.0,
                                    //           fontWeight: FontWeight.bold,
                                    //         ),),
                                    //       ],
                                    //     )
                                    // ),

                                    Container(child:
                                    Column(
                                      children: <Widget>[
                                        Row(children: <Widget>[
                                          Expanded(
                                              child: Card(
                                                child:
                                                Image.asset("images/cat.png"),
                                              )
                                          ),
                                          Expanded(
                                              child: Card(
                                                child:
                                                Image.asset("images/cat.png"),                                      )
                                          )
                                        ],),
                                        // Row(children: <Widget>[
                                        //   Expanded(
                                        //       child: Card(
                                        //         child:
                                        //         Image.asset("images/cat.png"),                                      )
                                        //   ),
                                        //   Expanded(
                                        //       child: Card(
                                        //         child:
                                        //         Image.asset("images/cat.png"),                                      )
                                        //   ),
                                        // ],),
                                        // Row(children: <Widget>[
                                        //   Expanded(
                                        //       child: Card(
                                        //         child:
                                        //         Image.asset("images/cat.png"),                                      )
                                        //   ),
                                        //   Expanded(
                                        //       child: Card(
                                        //         child:
                                        //         Image.asset("images/cat.png"),                                      )
                                        //   ),
                                        // ],),
                                      ],
                                    )
                                      ,),

                                    Container(
                                      height: 15.0,
                                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                      child:
                                      Divider(
                                        color: Colors.grey,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              // Container(
                              //   padding: EdgeInsets.only(left: 10.0, right: 10.0),
                              //   child: Column(
                              //     children: <Widget>[
                              //       Row(children: <Widget>[
                              //         Icon(Icons.home),
                              //         SizedBox(width: 5.0,),
                              //         Text('S???ng t???i', style: TextStyle(
                              //             fontSize: 16.0
                              //         ),),
                              //         SizedBox(width: 5.0,),
                              //         Text('Ch??a r??', style: TextStyle(
                              //             fontSize: 16.0,
                              //             fontWeight: FontWeight.w600
                              //         ),)
                              //       ],),
                              //
                              //
                              //       SizedBox(height: 10.0,),
                              //       Row(children: <Widget>[
                              //         Icon(Icons.male), //female
                              //         SizedBox(width: 5.0,),
                              //         Text('Gi???i t??nh', style: TextStyle(
                              //             fontSize: 16.0
                              //         ),),
                              //         SizedBox(width: 5.0,),
                              //         Text(user.gender, style: TextStyle(
                              //             fontSize: 16.0,
                              //             fontWeight: FontWeight.w600
                              //         ),)
                              //       ],),
                              //
                              //
                              //       SizedBox(height: 10.0,),
                              //       Row(children: <Widget>[
                              //         Icon(Icons.people),
                              //         SizedBox(width: 5.0,),
                              //         Text('B???n b??', style: TextStyle(
                              //             fontSize: 16.0
                              //         ),),
                              //         SizedBox(width: 5.0,),
                              //         Text('10 ng?????i b???n', style: TextStyle(
                              //             fontSize: 16.0,
                              //             fontWeight: FontWeight.w600
                              //         ),)
                              //       ],),
                              //       SizedBox(height: 20.0,),
                              //       Row(children: <Widget>[
                              //         Expanded(
                              //           child: RaisedButton(
                              //             color: pinkColor,
                              //             onPressed: () {
                              //               print("collections");
                              //             },
                              //             child: Row(
                              //               mainAxisAlignment: MainAxisAlignment.center,
                              //               children: [
                              //                 Text('Xem th??m v??? ' + user.username),
                              //               ],
                              //             ),
                              //           ),
                              //         )
                              //       ],),
                              //
                              //       Container(
                              //         height: 10.0,
                              //         child:
                              //         Divider(
                              //           color: Colors.grey,
                              //         ),
                              //       ),
                              //
                              //       Container(
                              //           height: 40,
                              //           alignment: Alignment.centerLeft,
                              //           child: Row(
                              //             children: [
                              //               Icon(Icons.photo_library, color: greenColor, size: 25.0),
                              //               SizedBox(width: 10,),
                              //               Text('???nh', style: TextStyle(
                              //                 fontSize: 20.0,
                              //                 fontWeight: FontWeight.bold,
                              //               ),),
                              //             ],
                              //           )
                              //       ),
                              //
                              //       Container(child:
                              //       Column(
                              //         children: <Widget>[
                              //           Row(children: <Widget>[
                              //             Expanded(
                              //                 child: Card(
                              //                   child:
                              //                   Image.network(user.coverImage != null? "$host${user.coverImage.fileName}" : link2),
                              //                 )
                              //             ),
                              //             Expanded(
                              //                 child: Card(
                              //                   child:
                              //                   Image.network(user.coverImage != null? "$host${user.coverImage.fileName}" : link2),
                              //                 )
                              //             )
                              //           ],),
                              //           Row(children: <Widget>[
                              //             Expanded(
                              //                 child: Card(
                              //                   child:
                              //                   Image.network(user.coverImage != null? "$host${user.coverImage.fileName}" : link2),
                              //                 )
                              //             ),
                              //             Expanded(
                              //                 child: Card(
                              //                   child:
                              //                   Image.network(user.coverImage != null? "$host${user.coverImage.fileName}" : link2),
                              //                 )
                              //             ),
                              //             Expanded(
                              //                 child: Card(
                              //                   child:
                              //                   Image.network(user.coverImage != null? "$host${user.coverImage.fileName}" : link2),
                              //                 )
                              //             )
                              //           ],)
                              //         ],
                              //       )
                              //         ,),
                              //
                              //       Container(
                              //         height: 10.0,
                              //         child:
                              //         Divider(
                              //           color: Colors.grey,
                              //         ),
                              //       ),
                              //
                              //       Container(
                              //           height: 40,
                              //           color: Colors.white,
                              //           alignment: Alignment.centerLeft,
                              //           child: Row(
                              //             children: [
                              //               Icon(Icons.style, color: blueColor, size: 25.0),
                              //               SizedBox(width: 10,),
                              //               Text('B??i vi???t', style: TextStyle(
                              //                 fontSize: 20.0,
                              //                 fontWeight: FontWeight.bold,
                              //               ),),
                              //             ],
                              //           )
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // CreatePostContainer(),
                            ],
                          ),
                        ],
                      )
                      : Container(height: 10,);
                    default:
                      if (snapshot.hasError) {
                        return Center(child: Text('Some error occurred!'));
                      } else {
                        return
                          user != null?
                          Stack(
                            children: [
                              // Container(
                              //   width: size.width,
                              //   height: 230,
                              //   child: GestureDetector(
                              //       onTap: () {print('coverimage');}, //_showProfile(post, context),
                              //       child:CachedNetworkImage(
                              //         imageUrl: user != null? "$host${user.coverImage.fileName}" :link2,
                              //         fit: BoxFit.fitWidth,
                              //       )
                              //   ),
                              // ),
                              Container(
                                width: size.width,
                                height: 200,
                                alignment: Alignment.bottomCenter,
                                child: GestureDetector(
                                  onTap: () {print('avatar');}, //_showProfile(post, context),
                                  child: ProfileAvatar(
                                    imageUrl: user != null? "$host${user.avatar.fileName}" : link,
                                    hasBorder: false,
                                    minSize: 75,
                                    maxSize: 80,
                                  ),
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.fromLTRB(225, 250, 0, 0), //top: 210, left: size.width*0.55
                              //   child: Container(
                              //       width: 48,
                              //       height: 48,
                              //       alignment: Alignment.center,
                              //       decoration: BoxDecoration(
                              //         color: Color.fromRGBO(35, 35, 35, 0.9),
                              //         borderRadius: BorderRadius.all(Radius.circular(size.width*0.225)),
                              //       ),
                              //       child: IconButton(
                              //         icon: Icon(Icons.photo_camera, color: Colors.white, size: 32,),
                              //         onPressed: () => createPost(context),
                              //       )
                              //   ),
                              // ),
                              Column(
                                children: [
                                  SizedBox(height: 210.0,),
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    height: 40.0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(width: 10.0,),
                                        Text(
                                            user!= null? user.username: '',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                            )
                                        ),
                                        // showName(color: Colors.black,
                                        //     size: 20,
                                        //     fontWeight: FontWeight.bold),
                                        SizedBox(width: 10.0,),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 0.0),
                                          child: Icon(Icons.check_circle, color: Colors.black,  size: 20,),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.0,),
                                  Text(
                                      'Your bio here',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300
                                      )
                                  ),
                                  SizedBox(height: 30.0,),
                                  Full_button(
                                    textColor: Colors.white,
                                    onPressed: ()  {
                                      createPost(context);
                                    },
                                    text: "+ Add new post", backgroundColor: Colors.transparent,
                                  ),
                                  SizedBox(height: 10.0,),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(7),
                                    height: size.height * 0.095,
                                    width: size.width * 0.8,
                                    child: TextFormField(
                                      controller: searchController,
                                      validator: (value) {return null;
                                      },
                                      // obscureText: checkPass,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.search, color: Colors.black,),
                                            onPressed: () {
                                              setState(() {
                                                print('hello');
                                              });
                                            },
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  style: BorderStyle.solid,
                                                  width: 2)),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black,)),
                                          errorBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.red,)),
                                          filled: true,
                                          hintStyle: TextStyle(color: Colors.grey[800]),
                                          hintText: 'Search here',
                                          fillColor: Colors.white70),
                                    ),
                                  ),
                                  // Container(
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  //     children: <Widget>[
                                  //       Column(
                                  //         children: <Widget>[
                                  //           IconButton(
                                  //             icon: Icon(Icons.add_photo_alternate, size: 28, color: blueColor),
                                  //             onPressed: () {
                                  //               createPost(context);
                                  //             },
                                  //           ),
                                  //           Text('Th??m ???nh', style: TextStyle(color: blueColor),)
                                  //         ],
                                  //       ),
                                  //       Column(
                                  //         children: <Widget>[
                                  //           IconButton(
                                  //             icon: Icon(Icons.edit, color: Colors.black),
                                  //             onPressed: () {
                                  //               showModalBottomSheet(
                                  //                   isScrollControlled: true,
                                  //                   context: context,
                                  //                   builder: (BuildContext context) => EditProfilePage()
                                  //               );
                                  //             },
                                  //           ),
                                  //           Text('Ch???nh s???a', style: TextStyle(
                                  //               color: Colors.black
                                  //           ),)
                                  //         ],
                                  //       ),
                                  //       Column(
                                  //         children: <Widget>[
                                  //           IconButton(
                                  //             icon: Icon(Icons.more_vert, color: Colors.black),
                                  //             onPressed: () {
                                  //               _showMoreOption(context);
                                  //             },
                                  //           ),
                                  //           Text('Th??m', style: TextStyle(
                                  //               color: Colors.black
                                  //           ),)
                                  //         ],
                                  //       )
                                  //     ],
                                  //   ),
                                  //   // Row(
                                  //   //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  //   //   children: <Widget>[
                                  //   //     Column(
                                  //   //       children: <Widget>[
                                  //   //         IconButton(
                                  //   //           icon: Icon(Icons.person, size: 28, color: Colors.black),
                                  //   //           onPressed: () {
                                  //   //             print("collections");
                                  //   //           },
                                  //   //         ),
                                  //   //         Text('B???n b??', style: TextStyle(color: Colors.black),)
                                  //   //       ],
                                  //   //     ),
                                  //   //     Column(
                                  //   //       children: <Widget>[
                                  //   //         IconButton(
                                  //   //           icon: Icon(MdiIcons.facebookMessenger, color: Colors.black),
                                  //   //           onPressed: () {
                                  //   //             print("collections");
                                  //   //           },
                                  //   //         ),
                                  //   //         Text('Nh???n tin', style: TextStyle(
                                  //   //             color: Colors.black
                                  //   //         ),)
                                  //   //       ],
                                  //   //     ),
                                  //   //     Column(
                                  //   //       children: <Widget>[
                                  //   //         IconButton(
                                  //   //           icon: Icon(Icons.more_vert, color: Colors.black),
                                  //   //           onPressed: () {
                                  //   //             _showMoreOption(context);
                                  //   //           },
                                  //   //         ),
                                  //   //         Text('Th??m', style: TextStyle(
                                  //   //             color: Colors.black
                                  //   //         ),)
                                  //   //       ],
                                  //   //     )
                                  //   //   ],
                                  //   // ),
                                  // ),
                                  SizedBox(height: 10.0,),
                                  Container(
                                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                                    child: Column(
                                      children: <Widget>[

                                        Container(
                                          height: 15.0,
                                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                          child:
                                          Divider(
                                            color: Colors.grey,
                                          ),
                                        ),

                                        // Container(
                                        //     height: 40,
                                        //     alignment: Alignment.centerLeft,
                                        //     child: Row(
                                        //       children: [
                                        //         Icon(Icons.style, color: Colors.black, size: 25.0),
                                        //         SizedBox(width: 10,),
                                        //         Text('Your posts', style: TextStyle(
                                        //           fontSize: 20.0,
                                        //           fontWeight: FontWeight.bold,
                                        //         ),),
                                        //       ],
                                        //     )
                                        // ),

                                        Container(child:
                                        Column(
                                          children: <Widget>[
                                            Row(children: <Widget>[
                                              Expanded(
                                                  child: Card(
                                                    child:
                                                    Image.asset("images/cat.png"),
                                                  )
                                              ),
                                              Expanded(
                                                  child: Card(
                                                    child:
                                                    Image.asset("images/cat.png"),                                      )
                                              )
                                            ],),
                                            // Row(children: <Widget>[
                                            //   Expanded(
                                            //       child: Card(
                                            //         child:
                                            //         Image.asset("images/cat.png"),                                      )
                                            //   ),
                                            //   Expanded(
                                            //       child: Card(
                                            //         child:
                                            //         Image.asset("images/cat.png"),                                      )
                                            //   ),
                                            // ],),
                                            // Row(children: <Widget>[
                                            //   Expanded(
                                            //       child: Card(
                                            //         child:
                                            //         Image.asset("images/cat.png"),                                      )
                                            //   ),
                                            //   Expanded(
                                            //       child: Card(
                                            //         child:
                                            //         Image.asset("images/cat.png"),                                      )
                                            //   ),
                                            // ],),
                                          ],
                                        )
                                          ,),

                                        Container(
                                          height: 15.0,
                                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                          child:
                                          Divider(
                                            color: Colors.grey,
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                  // Container(
                                  //   padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                  //   child: Column(
                                  //     children: <Widget>[
                                  //       Row(children: <Widget>[
                                  //         Icon(Icons.home),
                                  //         SizedBox(width: 5.0,),
                                  //         Text('S???ng t???i', style: TextStyle(
                                  //             fontSize: 16.0
                                  //         ),),
                                  //         SizedBox(width: 5.0,),
                                  //         Text('Ch??a r??', style: TextStyle(
                                  //             fontSize: 16.0,
                                  //             fontWeight: FontWeight.w600
                                  //         ),)
                                  //       ],),
                                  //
                                  //
                                  //       SizedBox(height: 10.0,),
                                  //       Row(children: <Widget>[
                                  //         Icon(Icons.male), //female
                                  //         SizedBox(width: 5.0,),
                                  //         Text('Gi???i t??nh', style: TextStyle(
                                  //             fontSize: 16.0
                                  //         ),),
                                  //         SizedBox(width: 5.0,),
                                  //         Text(user.gender, style: TextStyle(
                                  //             fontSize: 16.0,
                                  //             fontWeight: FontWeight.w600
                                  //         ),)
                                  //       ],),
                                  //
                                  //
                                  //       SizedBox(height: 10.0,),
                                  //       Row(children: <Widget>[
                                  //         Icon(Icons.people),
                                  //         SizedBox(width: 5.0,),
                                  //         Text('B???n b??', style: TextStyle(
                                  //             fontSize: 16.0
                                  //         ),),
                                  //         SizedBox(width: 5.0,),
                                  //         Text('10 ng?????i b???n', style: TextStyle(
                                  //             fontSize: 16.0,
                                  //             fontWeight: FontWeight.w600
                                  //         ),)
                                  //       ],),
                                  //       SizedBox(height: 20.0,),
                                  //       Row(children: <Widget>[
                                  //         Expanded(
                                  //           child: RaisedButton(
                                  //             color: pinkColor,
                                  //             onPressed: () {
                                  //               print("collections");
                                  //             },
                                  //             child: Row(
                                  //               mainAxisAlignment: MainAxisAlignment.center,
                                  //               children: [
                                  //                 Text('Xem th??m v??? ' + user.username),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         )
                                  //       ],),
                                  //
                                  //       Container(
                                  //         height: 10.0,
                                  //         child:
                                  //         Divider(
                                  //           color: Colors.grey,
                                  //         ),
                                  //       ),
                                  //
                                  //       Container(
                                  //           height: 40,
                                  //           alignment: Alignment.centerLeft,
                                  //           child: Row(
                                  //             children: [
                                  //               Icon(Icons.photo_library, color: greenColor, size: 25.0),
                                  //               SizedBox(width: 10,),
                                  //               Text('???nh', style: TextStyle(
                                  //                 fontSize: 20.0,
                                  //                 fontWeight: FontWeight.bold,
                                  //               ),),
                                  //             ],
                                  //           )
                                  //       ),
                                  //
                                  //       Container(child:
                                  //       Column(
                                  //         children: <Widget>[
                                  //           Row(children: <Widget>[
                                  //             Expanded(
                                  //                 child: Card(
                                  //                   child:
                                  //                   Image.network(user.coverImage != null? "$host${user.coverImage.fileName}" : link2),
                                  //                 )
                                  //             ),
                                  //             Expanded(
                                  //                 child: Card(
                                  //                   child:
                                  //                   Image.network(user.coverImage != null? "$host${user.coverImage.fileName}" : link2),
                                  //                 )
                                  //             )
                                  //           ],),
                                  //           Row(children: <Widget>[
                                  //             Expanded(
                                  //                 child: Card(
                                  //                   child:
                                  //                   Image.network(user.coverImage != null? "$host${user.coverImage.fileName}" : link2),
                                  //                 )
                                  //             ),
                                  //             Expanded(
                                  //                 child: Card(
                                  //                   child:
                                  //                   Image.network(user.coverImage != null? "$host${user.coverImage.fileName}" : link2),
                                  //                 )
                                  //             ),
                                  //             Expanded(
                                  //                 child: Card(
                                  //                   child:
                                  //                   Image.network(user.coverImage != null? "$host${user.coverImage.fileName}" : link2),
                                  //                 )
                                  //             )
                                  //           ],)
                                  //         ],
                                  //       )
                                  //         ,),
                                  //
                                  //       Container(
                                  //         height: 10.0,
                                  //         child:
                                  //         Divider(
                                  //           color: Colors.grey,
                                  //         ),
                                  //       ),
                                  //
                                  //       Container(
                                  //           height: 40,
                                  //           color: Colors.white,
                                  //           alignment: Alignment.centerLeft,
                                  //           child: Row(
                                  //             children: [
                                  //               Icon(Icons.style, color: blueColor, size: 25.0),
                                  //               SizedBox(width: 10,),
                                  //               Text('B??i vi???t', style: TextStyle(
                                  //                 fontSize: 20.0,
                                  //                 fontWeight: FontWeight.bold,
                                  //               ),),
                                  //             ],
                                  //           )
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // CreatePostContainer(),
                                ],
                              ),
                            ],
                          )
                            : Container(height: 10,);
                      }
                  }
                },
              ),
              FutureBuilder<List<PostData>>(
                future: PostsApi.getMyPosts(),
                builder: (context, snapshot) {
                  final posts = snapshot.data;
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Container(
                        margin: const EdgeInsets.fromLTRB(40 , 20, 40, 0),
                        padding: const EdgeInsets.fromLTRB(20, 17 , 20, 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Text(
                          'B???n ch??a c?? b??i vi???t n??o',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Center(child: Text('Some error occurred!'));
                      } else {
                        return posts!.length != 0?
                        ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              final post = posts[posts.length - 1 - index];
                              return PostContainer(post: post, isPersonalPost: false,);
                            })
                          : Container(
                            margin: const EdgeInsets.fromLTRB(40 , 20, 40, 0),
                            padding: const EdgeInsets.fromLTRB(20, 17 , 20, 20),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Text(
                              'B???n ch??a c?? b??i vi???t n??o',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                      }
                  }
                },
              ),
              SizedBox(height: 10.0,),
              Container(
                margin: EdgeInsets.fromLTRB(40 , 10, 40, 40),
                child: Full_button(
                  textColor: Colors.white,
                  onPressed: () async {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) => EditProfilePage()
                    );
                  },
                  text: "Edit profile", backgroundColor: Colors.transparent,
                ),
              ),
            ]
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
        floatingActionButton:
        IconButton(
          icon: Icon(Icons.chevron_left,size: 30,color: Colors.white60,),
          onPressed: () {setState(() { isProfile = false;});},
        ),

      );
    //   : SingleChildScrollView(
    //     child: Container(
    //       color: Color.fromRGBO(0, 0, 0, 0.05),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           FutureBuilder<UserData>(
    //             future: UsersApi.getCurrentUserData(),
    //             builder: (context, snapshot) {
    //               final user = snapshot.data;
    //               switch (snapshot.connectionState) {
    //                 case ConnectionState.waiting:
    //                   return Container(
    //                     margin: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 10.0),
    //                     padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
    //                     decoration: BoxDecoration(
    //                       color: Colors.white,
    //                       borderRadius: BorderRadius.all(Radius.circular(15.0)),
    //                     ),
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       children: [
    //                         GestureDetector(
    //                           onTap: () async{
    //                             setState(() {
    //                               isProfile = true;
    //                             });
    //                           },
    //                           child: Container(
    //                             // color: Colors.red,
    //                             height: 60,
    //                             width: 60,
    //                             alignment: Alignment.center,
    //                             // color: Colors.red,
    //                             child: ProfileAvatar(
    //                               imageUrl: link,
    //                               maxSize: 40,
    //                             ),
    //                           ),
    //                         ),
    //                         SizedBox(
    //                           width: 20,
    //                         ),
    //                         Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           mainAxisAlignment: MainAxisAlignment.start,
    //                           children: [
    //                             SizedBox(
    //                               height: size.height * 0.01,
    //                             ),
    //                             GestureDetector(
    //                               onTap: () async{
    //                                 setState(() {
    //                                   isProfile = true;
    //                                 });
    //                               },
    //                               child: Column(
    //                                   crossAxisAlignment: CrossAxisAlignment.start,
    //                                   children: [
    //                                     showName(
    //                                       color: Colors.black87,
    //                                       size: 20,
    //                                       fontWeight: FontWeight.w600,
    //                                     ),
    //                                     SizedBox(
    //                                       height: 5,
    //                                     ),
    //                                     Text(
    //                                       'Xem trang c?? nh??n c???a b???n',
    //                                       style: TextStyle(
    //                                         color: Colors.black87,
    //                                         fontSize: 14,
    //                                       ),
    //                                       // fontWeight: FontWeight.bold),
    //                                     ),
    //                                     SizedBox(
    //                                       height: 5,
    //                                     ),
    //                                   ]),
    //                             )
    //                           ],
    //                         ),
    //                       ],
    //                     ),
    //                   );
    //                 default:
    //                   if (snapshot.hasError) {
    //                     return Center(child: Text('Some error occurred!'));
    //                   } else {
    //                     return Container(
    //                       margin: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 10.0),
    //                       padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
    //                       decoration: BoxDecoration(
    //                         color: Colors.white,
    //                         borderRadius: BorderRadius.all(Radius.circular(15.0)),
    //                       ),
    //                       child: Row(
    //                         mainAxisAlignment: MainAxisAlignment.start,
    //                         children: [
    //                           GestureDetector(
    //                             onTap: () async{
    //                               setState(() {
    //                                 isProfile = true;
    //                               });
    //                             },
    //                             child: Container(
    //                               // color: Colors.red,
    //                               height: 60,
    //                               width: 60,
    //                               alignment: Alignment.center,
    //                               // color: Colors.red,
    //                               child: ProfileAvatar(
    //                                 imageUrl: user!=null? "$host${user.avatar.fileName}" : link,
    //                                 maxSize: 40,
    //                               ),
    //                             ),
    //                           ),
    //                           SizedBox(
    //                             width: 20,
    //                           ),
    //                           Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             mainAxisAlignment: MainAxisAlignment.start,
    //                             children: [
    //                               SizedBox(
    //                                 height: size.height * 0.01,
    //                               ),
    //                               GestureDetector(
    //                                 onTap: () async{
    //                                   setState(() {
    //                                     isProfile = true;
    //                                   });
    //                                 },
    //                                 child: Column(
    //                                     crossAxisAlignment: CrossAxisAlignment.start,
    //                                     children: [
    //                                       Text(
    //                                         user!.username,
    //                                         style: TextStyle(
    //                                           color: Colors.black87,
    //                                           fontSize: 20,
    //                                           fontWeight: FontWeight.w600,
    //                                         )
    //                                       ),
    //                                       SizedBox(
    //                                         height: 5,
    //                                       ),
    //                                       Text(
    //                                         'Xem trang c?? nh??n c???a b???n',
    //                                         style: TextStyle(
    //                                           color: Colors.black87,
    //                                           fontSize: 14,
    //                                         ),
    //                                         // fontWeight: FontWeight.bold),
    //                                       ),
    //                                       SizedBox(
    //                                         height: 5,
    //                                       ),
    //                                     ]),
    //                               )
    //                             ],
    //                           ),
    //                         ],
    //                       ),
    //                     );
    //                   }
    //               }
    //             },
    //           ),
    //           Container(
    //               margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
    //               padding: EdgeInsets.fromLTRB(1.0, 10.0, 10.0, 10.0),
    //               decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.all(Radius.circular(15.0)),
    //               ),
    //               child: Column(children: [
    //                 GestureDetector(
    //                   onTap: () {
    //                     showModalBottomSheet(
    //                         isScrollControlled: true,
    //                         context: context,
    //                         builder: (BuildContext context) => EditProfilePage()
    //                     );
    //                   },
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.start,
    //                     children: [
    //                       SizedBox(
    //                         width: 20,
    //                       ),
    //                       Container(
    //                         width: size.width * 0.12,
    //                         height: size.height * 0.05,
    //                         child: Icon(Icons.edit,
    //                             size: 30, color: Colors.black87),
    //                       ),
    //                       SizedBox(
    //                         width: 20,
    //                       ),
    //                       Text(
    //                         'Ch???nh s???a trang c?? nh??n',
    //                         style: TextStyle(
    //                             color: Colors.black87,
    //                             fontSize: 16,
    //                             fontWeight: FontWeight.w500),
    //                       )
    //                     ],
    //                   ),
    //                 ),
    //                 Divider(
    //                   height: 10,
    //                   color: Colors.black54,
    //                   thickness: 1.2,
    //                   indent: 20,
    //                   endIndent: 20,
    //                 ),
    //                 GestureDetector(
    //                   onTap: () => Navigator.pushNamed(context, '/changepass'),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.start,
    //                     children: [
    //                       SizedBox(
    //                         width: 20,
    //                       ),
    //                       Container(
    //                         width: size.width * 0.12,
    //                         height: size.height * 0.05,
    //                         child: Icon(MdiIcons.keyVariant,
    //                             size: 30, color: Colors.black87),
    //                       ),
    //                       SizedBox(
    //                         width: 20,
    //                       ),
    //                       Text(
    //                         '?????i m???t kh???u',
    //                         style: TextStyle(
    //                             color: Colors.black87,
    //                             fontSize: 16,
    //                             fontWeight: FontWeight.w500),
    //                       )
    //                     ],
    //                   ),
    //                 ),
    //                 Divider(
    //                   height: 10,
    //                   color: Colors.black54,
    //                   thickness: 1.2,
    //                   indent: 20,
    //                   endIndent: 20,
    //                 ),
    //                 GestureDetector(
    //                   onTap: () => Navigator.pushNamed(context, '/block'),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.start,
    //                     children: [
    //                       SizedBox(
    //                         width: 20,
    //                       ),
    //                       Container(
    //                         width: size.width * 0.12,
    //                         height: size.height * 0.05,
    //                         // color: Colors.green,
    //                         child:
    //                             Icon(Icons.block, size: 30, color: Colors.black87),
    //                       ),
    //                       SizedBox(
    //                         width: 20,
    //                       ),
    //                       Text(
    //                         'Ng?????i b??? ch???n',
    //                         style: TextStyle(
    //                             color: Colors.black87,
    //                             fontSize: 16,
    //                             fontWeight: FontWeight.w500),
    //                       )
    //                     ],
    //                   ),
    //                 ),
    //                 Divider(
    //                     height: 10,
    //                     color: Colors.black54,
    //                     thickness: 1.2,
    //                     indent: 20,
    //                     endIndent: 20),
    //                 GestureDetector(
    //                   onTap: () async {
    //
    //                     // logout Firebase
    //                     authMethods.signOut();
    //
    //                     Navigator.pushNamed(context, '/');
    //                     await storage.deleteAll();
    //                   },
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.start,
    //                     children: [
    //                       SizedBox(
    //                         width: 20,
    //                       ),
    //                       Container(
    //                         width: size.width * 0.12,
    //                         height: size.height * 0.05,
    //                         // color: Colors.green,
    //                         child:
    //                             Icon(Icons.logout, size: 30, color: Colors.black87),
    //                       ),
    //                       SizedBox(
    //                         width: 20,
    //                       ),
    //                       Text(
    //                         '????ng xu???t',
    //                         style: TextStyle(
    //                             color: Colors.black87,
    //                             fontSize: 16,
    //                             fontWeight: FontWeight.w500),
    //                       )
    //                     ],
    //                   ),
    //                 ),
    //               ])),
    //           SizedBox(
    //             height: size.width * 0.50,
    //           ),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.end,
    //             children: [
    //               Padding(
    //                 padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
    //                 child: Image.asset(
    //                   'assets/watermelon2.png',
    //                   width: size.width * 0.25,
    //                 ),
    //               )
    //             ],
    //           ),
    //           SizedBox(
    //             height: size.width * 0.1,
    //       ),
    //     ],
    //   ),
    // ));
  }
}

_showMoreOption(cx) {

  showModalBottomSheet(
    context: cx,
    builder: (BuildContext bcx) {

      return new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child:
            Row(children: <Widget>[
              Icon(Icons.feedback,
                color: Colors.black,),
              SizedBox(width: 10.0,),
              Text('Give feedback or report this profile',
                style: TextStyle(
                    fontSize: 18.0
                ),)
            ],),),


          Container(
            padding: EdgeInsets.all(10.0),
            child:
            Row(children: <Widget>[
              Icon(Icons.block,
                color: Colors.black,),
              SizedBox(width: 10.0,),
              Text('Block',
                style: TextStyle(
                    fontSize: 18.0
                ),)
            ],),),



          Container(
            padding: EdgeInsets.all(10.0),
            child:
            Row(children: <Widget>[
              Icon(Icons.link,
                color: Colors.black,),
              SizedBox(width: 10.0,),
              Text('Copy link to profile',
                style: TextStyle(
                    fontSize: 18.0
                ),)
            ],),),



          Container(
            padding: EdgeInsets.all(10.0),
            child:
            Row(children: <Widget>[
              Icon(Icons.search,
                color: Colors.black,),
              SizedBox(width: 10.0,),
              Text('Search Profile',
                style: TextStyle(
                    fontSize: 18.0
                ),)
            ],),)






        ],
      );

    },


  );


}