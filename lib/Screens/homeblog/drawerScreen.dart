import 'package:flutter/material.dart';
import 'package:hust_blog/Screens/Profile/profile_screen.dart';
import 'package:hust_blog/Screens/Widget/profile_avatar.dart';
import 'package:hust_blog/get_data/get_user_info.dart';
import 'package:hust_blog/models/configuration.dart';
import 'package:hust_blog/models/searchUsers_model.dart';

String link = 'https://t4.ftcdn.net/jpg/00/65/77/27/360_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: size.width,
          child: Image.asset(
            'images/logo_menu.png',
            fit: BoxFit.fitWidth,
          ),
        ),
        Container(
          color: Colors.black38,
          padding: EdgeInsets.only(top:50,bottom: 70,left: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder<UserData>(
                future: UsersApi.getCurrentUserData(),
                builder: (context, snapshot) {
                  final user = snapshot.data;
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return user != null?
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen(isProfile: true,)))
                            },
                            child: ProfileAvatar(
                                minSize: 18,
                                maxSize: 20,
                                hasBorder: true,
                                isActive: true,
                                imageUrl: user != null
                                    ? "$host${user.avatar.fileName}"
                                    : link),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen(isProfile: true,)));
                                  },
                                  child: Text(
                                    user!= null? user.username: 'username',
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                              ),
                              Text('Active Status',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500))
                            ],
                          )
                        ],
                      )
                          : Container(height: 10,);
                    default:
                      if (snapshot.hasError) {
                        return Center(child: Text('Some error occurred!'));
                      } else {
                        return
                          user != null?
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen(isProfile: true,)))
                                },
                                child: ProfileAvatar(
                                    minSize: 18,
                                    maxSize: 20,
                                    hasBorder: true,
                                    isActive: true,
                                    imageUrl: user != null
                                        ? "$host${user.avatar.fileName}"
                                        : link),
                              ),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen(isProfile: true,)));
                                      },
                                      child: Text(
                                      user!= null? user.username: 'username',
                                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                                  ),
                                  Text('Active Status',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500))
                                ],
                              )
                            ],
                          )
                              : Container(height: 10,);
                      }
                  }
                },
              ),

              Column(
                children: drawerItems.map((element) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(element['icon'],color: Colors.white,size: 30,),
                      SizedBox(width: 10,),
                      GestureDetector(
                          onTap: (){
                            if (element['title'] == 'Profile') {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(isProfile: true,)));
                            };
                          },
                          child:
                          Text(element['title'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20))
                      ),
                    ],

                  ),
                )).toList(),
              ),

              Row(
                children: [
                  Icon(Icons.settings,color: Colors.white,),
                  SizedBox(width: 10,),
                  Text('Settings',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  SizedBox(width: 10,),
                  Container(width: 2,height: 20,color: Colors.white,),
                  SizedBox(width: 10,),
                  GestureDetector(
                      onTap: (){
                        Navigator.pushReplacementNamed(context, '/welcome');
                      },
                      child: Text('Log out',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                  )
                ],
              )
            ],
          ),

        ),
      ],
    );
  }
}
