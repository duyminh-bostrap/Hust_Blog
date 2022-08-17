import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hust_blog/Screens/NewsFeed/post_container.dart';
import 'package:hust_blog/Screens/Profile/profile_screen.dart';
import 'package:hust_blog/Screens/Widget/profile_avatar.dart';
import 'package:hust_blog/Screens/homeblog/blogscreen.dart';
import 'package:hust_blog/get_data/get_post.dart';
import 'package:hust_blog/get_data/get_user_info.dart';
import 'package:hust_blog/models/configuration.dart';
import 'package:hust_blog/models/post_model.dart';
import 'package:hust_blog/models/searchUsers_model.dart';
import 'package:hust_blog/network_handler.dart';

String link =dotenv.env['link']??"";
String link2 =dotenv.env['link2']??"";
String host = dotenv.env['host'] ?? "";

NetworkHandler networkHandler = NetworkHandler();
final storage = new FlutterSecureStorage();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        transform: Matrix4.translationValues(xOffset, yOffset, 0)
          ..scale(scaleFactor)..rotateY(isDrawerOpen? -0.5:0),
        duration: Duration(milliseconds: 250),

        decoration: BoxDecoration(
            color: Colors.grey[200],

            borderRadius: BorderRadius.circular(isDrawerOpen?40:0.0)

        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isDrawerOpen?IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () async {
                        setState(() {
                          xOffset=0;
                          yOffset=0;
                          scaleFactor=1;
                          isDrawerOpen=false;

                        });
                      },

                    ): GestureDetector(
                        child: Icon(Icons.menu),
                        onTap: () async {
                          setState(() {
                            xOffset = 230;
                            yOffset = 150;
                            scaleFactor = 0.6;
                            isDrawerOpen=true;
                          });
                        }),
                    Column(
                      children: [
                        Text('Location',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: primaryGreen,
                            ),
                            Text('Ha Noi',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),),
                          ],
                        ),
                      ],
                    ),
                    FutureBuilder<UserData>(
                      future: UsersApi.getCurrentUserData(),
                      builder: (context, snapshot) {
                        final user = snapshot.data;
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return user != null?
                            GestureDetector(
                              onTap: () => {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen(isProfile: true,)))
                              },
                              child: ProfileAvatar(
                                  minSize: 18,
                                  maxSize: 18,
                                  imageUrl: user != null
                                      ? "$host${user.avatar.fileName}"
                                      : link),
                            )
                                : Container(height: 10,);
                          default:
                            if (snapshot.hasError) {
                              return Center(child: Text('Some error occurred!'));
                            } else {
                              return
                                user != null?
                                GestureDetector(
                                  onTap: () => {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen(isProfile: true,)))
                                  },
                                  child: ProfileAvatar(
                                      minSize: 18,
                                      maxSize: 18,
                                      imageUrl: user != null
                                          ? "$host${user.avatar.fileName}"
                                          : link),
                                ): Container(height: 10,);
                            }
                        }
                      },
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.fromLTRB(20,5,10,2),
                margin: EdgeInsets.symmetric(vertical: 30,horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ),
                child:
                TextFormField(
                  controller: searchController,
                  validator: (value) {
                    return null;
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
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none),
                      // filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: 'Search here',
                      fillColor: Colors.white70
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Icon(Icons.search),
                //     // Text('Search here...',
                //     //   style: TextStyle(
                //     //     fontWeight: FontWeight.w400,
                //     //     fontSize: 15,
                //     //     color: Colors.black,
                //     //     decoration: TextDecoration.none,
                //     //   ),),
                //     Icon(Icons.settings)
                //
                //   ],
                // ),
              ),

              Container(height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: drawerItems.length,
                  itemBuilder: (context,index){
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                // boxShadow: shadowList,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Icon(drawerItems[index]['icon'],color: Colors.black,size: 30,),
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(20,10,20,0) ,
                              child:
                              Text(drawerItems[index]['title'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 16))

                          ),
                        ],
                      ),
                    );
                  },

                ),
              ),

              FutureBuilder<List<PostData>>(
                future: PostsApi.getPosts(),
                builder: (context, snapshot) {
                  final posts = snapshot.data;
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
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
                        height: 600,
                        margin: const EdgeInsets.fromLTRB(40 , 40, 40, 0),
                        padding: const EdgeInsets.fromLTRB(20, 40 , 20, 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Text(
                          'Bạn chưa có bài viết nào',
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
                              height: 600,
                              margin: const EdgeInsets.fromLTRB(40 , 40, 40, 0),
                              padding: const EdgeInsets.fromLTRB(20, 40 , 20, 20),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Text(
                                'Bạn chưa có bài viết nào',
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
              // GestureDetector(
              //   onTap: (){
              //     //Navigator.push(context, MaterialPageRoute(builder: (context)=> BlogScreen()));
              //   },
              //   child: Container(
              //     height: 240,
              //     margin: EdgeInsets.symmetric(horizontal: 20),
              //     child: Row(
              //       children: [
              //         Stack(
              //           children: [
              //             Container(
              //               decoration: BoxDecoration(color: Colors.blueGrey[300],
              //                 borderRadius: BorderRadius.circular(20),
              //                 boxShadow: shadowList,
              //               ),
              //               margin: EdgeInsets.only(top: 50),
              //             ),
              //             Align(
              //               child: Hero(
              //                   tag:1,child: Image.asset('images/pet-cat2.png')),
              //             )
              //
              //           ],
              //         ),
              //         Expanded(child: Container(
              //           margin: EdgeInsets.only(top: 60,bottom: 20),
              //           decoration: BoxDecoration(color: Colors.white,
              //
              //               boxShadow: shadowList,
              //               borderRadius: BorderRadius.only(
              //                   topRight: Radius.circular(20),
              //                   bottomRight: Radius.circular(20)
              //
              //               )
              //           ),
              //
              //         ))
              //
              //       ],
              //     ),
              //
              //   ),
              // ),
              // Container(
              //   height: 240,
              //   margin: EdgeInsets.symmetric(horizontal: 20),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Stack(
              //           children: [
              //             Container(
              //               decoration: BoxDecoration(color: Colors.orange[100],
              //                 borderRadius: BorderRadius.circular(20),
              //                 boxShadow: shadowList,
              //               ),
              //               margin: EdgeInsets.only(top: 50),
              //             ),
              //             Align(
              //               child: Image.asset('images/pet-cat1.png'),
              //             )
              //
              //           ],
              //         ),
              //       ),
              //       Expanded(child: Container(
              //         margin: EdgeInsets.only(top: 60,bottom: 20),
              //         decoration: BoxDecoration(color: Colors.white,
              //
              //             boxShadow: shadowList,
              //             borderRadius: BorderRadius.only(
              //                 topRight: Radius.circular(20),
              //                 bottomRight: Radius.circular(20)
              //
              //             )
              //         ),
              //
              //       ))
              //
              //     ],
              //   ),
              //
              // ),
              SizedBox(height: 50,)






            ],
          ),
        ),
      );
  }
}
