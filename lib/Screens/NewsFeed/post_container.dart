import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hust_blog/Screens/Friends/friends_profile.dart';
import 'package:hust_blog/Screens/NewsFeed/create_post_container.dart';
import 'package:hust_blog/Screens/NewsFeed/edit_post_screen.dart';
import 'package:hust_blog/Screens/NewsFeed/post_view.dart';
import 'package:hust_blog/Screens/Profile/current_user_profile.dart';
import 'package:hust_blog/Screens/Profile/profile_screen.dart';
import 'package:hust_blog/Screens/Widget/color.dart';
import 'package:hust_blog/Screens/homeblog/blogscreen.dart';
import 'package:hust_blog/Screens/main_page.dart';
import 'package:hust_blog/get_data/get_post.dart';
import 'package:hust_blog/Screens/Widget/profile_avatar.dart';
import 'package:hust_blog/get_data/get_user_info.dart';
import 'package:hust_blog/models/configuration.dart';
import 'package:hust_blog/models/img_model.dart';
import 'package:hust_blog/models/models.dart';
import 'package:hust_blog/models/post_model.dart';
import 'package:hust_blog/models/profile_model.dart';
import 'package:hust_blog/network_handler.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

String link = dotenv.env['link'] ?? "";
String host = dotenv.env['host'] ?? "";

NetworkHandler networkHandler = NetworkHandler();
final storage = new FlutterSecureStorage();

class PostContainer extends StatefulWidget {
  final PostData post;
  final bool isPersonalPost;
  int pageIndex = 0;

  PostContainer({
    Key? key,
    required this.post,
    required this.isPersonalPost,
  }) : super(key: key);

  @override
  _PostContainer createState() => _PostContainer(
      post: post, isPersonalPost: isPersonalPost, pageIndex: pageIndex);
}

class _PostContainer extends State<PostContainer> {
  final PostData post;
  final bool isPersonalPost;
  int pageIndex;

  _PostContainer({
    Key? key,
    required this.post,
    required this.isPersonalPost,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context) {
    final List<ImageModel> img = post.images;
    final pageController = PageController(viewportFraction: 1);
    // post.images.add(link);

    return Container(
      decoration: BoxDecoration(
          // color: Colors.white,
          // shaboxShadow: [BoxShadow(color: Color.fromRGBO(203, 203, 203, 1.0), blurRadius: 20, offset: Offset(0, 20))],
          // borderRadius: BorderRadius.circular(10)
      ),
      // margin: const EdgeInsets.symmetric(vertical: 8.0),
      // padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0, 20,0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // PostHeader(
                //   post: post,
                //   isPersonalPost: isPersonalPost,
                // ),
                // const SizedBox(height: 5.0),
                // GestureDetector(
                //   onTap: (){
                //     //Navigator.push(context, MaterialPageRoute(builder: (context)=> BlogScreen()));
                //
                //   },
                //   child: Container(
                //     height: 240,
                //     margin: EdgeInsets.symmetric(horizontal: 20),
                //     child: Row(
                //       children: [
                //         Expanded(
                //           child: Stack(
                //             children: [
                //               Container(
                //                 decoration: BoxDecoration(color: Colors.blueGrey[300],
                //                   borderRadius: BorderRadius.circular(20),
                //                 ),
                //                 margin: EdgeInsets.only(top: 50),
                //               ),
                //               Align(
                //                 child: Hero(
                //                     tag:1,child: Image.asset('images/pet-cat2.png')),
                //               )
                //
                //             ],
                //           ),
                //         ),
                //         Expanded(child: Container(
                //           margin: EdgeInsets.only(top: 60,bottom: 20),
                //           decoration: BoxDecoration(color: Colors.white,
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
                GestureDetector(
                  onTap: (){
                    _openPost(post, context, pageIndex);
                  },
                  child: Container(
                    height: 250,
                    // width: 250,
                    // margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            img.length == 0 ?
                              Hero(
                                tag: 1,
                                child: Container(
                                  height: 200,
                                  width: 170,
                                  decoration: BoxDecoration(color: Colors.black,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                ),
                              )
                            : Container(
                              height: img.length > 0 ? 200 : 0,
                              width: 180,
                              // padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Hero(
                                tag:1,
                                child: PageView.builder(
                                  controller: pageController,
                                  itemCount: img.length,
                                  itemBuilder: (context, index) {
                                    final image = img[index];
                                    return Stack(
                                      children: [
                                        Container(
                                          height: 220,
                                          width: 200,
                                          child: GestureDetector(
                                            onTap: () => _openPost(post, context, pageIndex),
                                            child: Container(
                                              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              child: image != ''
                                                  ? ClipRRect(
                                                borderRadius: BorderRadius.circular(20.0),
                                                child: CachedNetworkImage(
                                                  imageUrl: "$host${image.name}",
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                                  : Container(
                                                height: 300,
                                              ),
                                            ),
                                          ),
                                        ),
                                        img.length > 1 ?
                                          Container(
                                            height: 260,
                                            alignment: Alignment.bottomCenter,
                                            padding: const EdgeInsets.fromLTRB(0,175, 0, 0),
                                            child: Center(
                                              child: AnimatedSmoothIndicator(
                                              count: img.length,
                                              activeIndex: pageIndex,
                                              effect: const ExpandingDotsEffect(
                                              dotHeight: 8,
                                              dotWidth: 8,
                                              expansionFactor: 2.3,
                                              activeDotColor: Colors.white,
                                              dotColor: Colors.white60,
                                              ),
                                            ),
                                         ),
                                          )
                                        : Container(),

                                      ]
                                    );
                                  },
                                  onPageChanged: (index) => setState(() {
                                    pageIndex = index;
                                    print(index);
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20,bottom: 20),
                          height: 160,
                          width: 180,
                          decoration: const BoxDecoration(color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                  topRight: const Radius.circular(20),
                                  bottomRight: const Radius.circular(20)

                              )

                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                                alignment: Alignment.center,
                                width: 200,
                                child: PostHeader(
                                  post: post,
                                  isPersonalPost: isPersonalPost,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 10, 10),
                                  alignment: Alignment.topLeft,
                                  child: ExpandableText(
                                    post.content.runtimeType == String ? post.content : '',
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400),
                                    expandText: 'Xem thêm',
                                    collapseText: 'Rút gọn',
                                    maxLines: 3,
                                    linkColor: Colors.black54,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(15, 0, 20, 20),
                                width: 200,
                                child: FutureBuilder<PostData>(
                                  future: PostsApi.getAPost(post.id),
                                  builder: (context, snapshot) {
                                    final onlyPost = snapshot.data;
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return onlyPost != null
                                            ? Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  onlyPost.isLike =
                                                  onlyPost.isLike ? false : true;
                                                  PostsApi.likePost(post);
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(5.0),
                                                decoration: const BoxDecoration(
                                                  color:
                                                  const Color.fromRGBO(246, 81, 82, 1.0),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.favorite,
                                                  size: 10.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 4.0),
                                            Expanded(
                                              child: Text(
                                                '${onlyPost.like.length}',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ),
                                            // Expanded(
                                            //   child: onlyPost.images.length > 1
                                            //       ? Center(
                                            //     child: AnimatedSmoothIndicator(
                                            //       count: onlyPost.images.length,
                                            //       activeIndex: pageIndex,
                                            //       effect: ExpandingDotsEffect(
                                            //         dotHeight: 8,
                                            //         dotWidth: 8,
                                            //         expansionFactor: 2.3,
                                            //         activeDotColor: pinkColor,
                                            //         dotColor: Colors.black26,
                                            //       ),
                                            //     ),
                                            //   )
                                            //       : Container(),
                                            // ),
                                            // SizedBox(width: 20.0),
                                            GestureDetector(
                                              onTap: () => _openPost(
                                                  onlyPost, context, pageIndex),
                                              child: Text(
                                                '${onlyPost.countComments} comments',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                            : Container(height: 10,);
                                      default:
                                        if (snapshot.hasError) {
                                          return const Center(child: Text('Some error occurred!'));
                                        } else {
                                          return onlyPost != null
                                              ? Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        onlyPost.isLike =
                                                        onlyPost.isLike ? false : true;
                                                        PostsApi.likePost(post);
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(5.0),
                                                      decoration: const BoxDecoration(
                                                        color:
                                                        Color.fromRGBO(246, 81, 82, 1.0),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(
                                                        Icons.favorite,
                                                        size: 10.0,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4.0),
                                                  Expanded(
                                                    child: Text(
                                                      '${onlyPost.like.length}',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ),
                                                  // Expanded(
                                                  //   child: onlyPost.images.length > 1
                                                  //       ? Center(
                                                  //     child: AnimatedSmoothIndicator(
                                                  //       count: onlyPost.images.length,
                                                  //       activeIndex: pageIndex,
                                                  //       effect: ExpandingDotsEffect(
                                                  //         dotHeight: 8,
                                                  //         dotWidth: 8,
                                                  //         expansionFactor: 2.3,
                                                  //         activeDotColor: pinkColor,
                                                  //         dotColor: Colors.black26,
                                                  //       ),
                                                  //     ),
                                                  //   )
                                                  //       : Container(),
                                                  // ),
                                                  // SizedBox(width: 20.0),
                                                  GestureDetector(
                                                    onTap: () => _openPost(
                                                        onlyPost, context, pageIndex),
                                                    child: Text(
                                                      '${onlyPost.countComments} comments',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                              : Container(height: 10,);
                                        }
                                    }
                                  },
                                ),
                              )
                            ]
                          ),

                        ))

                      ],
                    ),

                  ),
                ),
                // GestureDetector(
                //   onTap: () => _openPost(post, context, pageIndex),
                //   child: ExpandableText(
                //     post.content.runtimeType == String ? post.content : '',
                //     style: TextStyle(
                //         color: Colors.black87,
                //         fontSize: 15.0,
                //         fontWeight: FontWeight.w400),
                //     expandText: 'Xem thêm',
                //     collapseText: 'Rút gọn',
                //     maxLines: 3,
                //     linkColor: Colors.black54,
                //   ),
                //   // ShowPostInfo()
                // ),
              ],
            ),
          ),
          // Container(
          //   height: img.length > 0 ? 250 : 0,
          //   width: 200,
          //   padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          //   child: PageView.builder(
          //     controller: pageController,
          //     itemCount: img.length,
          //     itemBuilder: (context, index) {
          //       final image = img[index];
          //       return GestureDetector(
          //         onTap: () => _openPost(post, context, pageIndex),
          //         child: Container(
          //           margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          //           child: image != ''
          //               ? ClipRRect(
          //                   borderRadius: BorderRadius.circular(20.0),
          //                   child: CachedNetworkImage(
          //                     imageUrl: "$host${image.name}",
          //                     fit: BoxFit.cover,
          //                   ),
          //                 )
          //               : Container(
          //                   height: 300,
          //                 ),
          //         ),
          //       );
          //     },
          //     onPageChanged: (index) => setState(() {
          //       pageIndex = index;
          //       print(index);
          //     }),
          //   ),
          // ),
          // GestureDetector(
          //   onTap: () => _openPost(post, context),
          //   child: img.isNotEmpty
          //       ? GridView.count(
          //           physics: NeverScrollableScrollPhysics(),
          //           shrinkWrap: true,
          //           crossAxisCount: 1,
          //           children: img
          //               .map((e) => Image.network(
          //                   "http://localhost:8000/files/${e.name}"))
          //               .toList(),
          //         )
          //       : Container(height: 10,),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
          //   child: FutureBuilder<PostData>(
          //     future: PostsApi.getAPost(post.id),
          //     builder: (context, snapshot) {
          //       final onlyPost = snapshot.data;
          //       switch (snapshot.connectionState) {
          //         case ConnectionState.waiting:
          //           return onlyPost != null
          //               ? Column(
          //                   children: [
          //                     Padding(
          //                       padding: const EdgeInsets.all(6.0),
          //                       child: Row(
          //                         children: [
          //                           Container(
          //                             padding: const EdgeInsets.all(5.0),
          //                             decoration: BoxDecoration(
          //                               color: Color.fromRGBO(246, 81, 82, 1.0),
          //                               shape: BoxShape.circle,
          //                             ),
          //                             child: const Icon(
          //                               Icons.favorite,
          //                               size: 10.0,
          //                               color: Colors.white,
          //                             ),
          //                           ),
          //                           SizedBox(width: 4.0),
          //                           GestureDetector(
          //                             onTap: () => _openPost(
          //                                 onlyPost, context, pageIndex),
          //                             child: Text(
          //                               '${onlyPost.like.length} lượt thích',
          //                               style: TextStyle(
          //                                 color: Colors.grey[600],
          //                               ),
          //                             ),
          //                           ),
          //                           Expanded(
          //                             child: onlyPost.images.length > 1
          //                                 ? Center(
          //                                     child: AnimatedSmoothIndicator(
          //                                       count: onlyPost.images.length,
          //                                       activeIndex: pageIndex,
          //                                       effect: ExpandingDotsEffect(
          //                                         dotHeight: 8,
          //                                         dotWidth: 8,
          //                                         expansionFactor: 2.3,
          //                                         activeDotColor: pinkColor,
          //                                         dotColor: Colors.black26,
          //                                       ),
          //                                     ),
          //                                   )
          //                                 : Container(),
          //                           ),
          //                           SizedBox(width: 20.0),
          //                           GestureDetector(
          //                             onTap: () => _openPost(
          //                                 onlyPost, context, pageIndex),
          //                             child: Text(
          //                               '${onlyPost.countComments} bình luận',
          //                               style: TextStyle(
          //                                 color: Colors.grey[600],
          //                               ),
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                     Divider(),
          //                     Row(
          //                       children: [
          //                         Expanded(
          //                           child: InkWell(
          //                             onTap: () {
          //                               setState(() {
          //                                 onlyPost.isLike =
          //                                     onlyPost.isLike ? false : true;
          //                                 PostsApi.likePost(post);
          //                               });
          //                             },
          //                             child: Container(
          //                               height: 25.0,
          //                               child: Row(
          //                                 mainAxisAlignment:
          //                                     MainAxisAlignment.center,
          //                                 children: [
          //                                   onlyPost.isLike
          //                                       ? Icon(
          //                                           Icons.favorite,
          //                                           color: pinkColor,
          //                                           size: 20.0,
          //                                         )
          //                                       : Icon(
          //                                           Icons.favorite_border,
          //                                           color: Colors.grey[600],
          //                                           size: 20.0,
          //                                         ),
          //                                   const SizedBox(width: 4.0),
          //                                   Text('Thích'),
          //                                 ],
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                         Expanded(
          //                           child: InkWell(
          //                             onTap: () =>
          //                                 _openPost(post, context, pageIndex),
          //                             child: Container(
          //                               height: 25.0,
          //                               child: Row(
          //                                 mainAxisAlignment:
          //                                     MainAxisAlignment.center,
          //                                 children: [
          //                                   Icon(
          //                                     MdiIcons.commentOutline,
          //                                     color: Colors.grey[600],
          //                                     size: 20.0,
          //                                   ),
          //                                   const SizedBox(width: 4.0),
          //                                   Text('Bình luận'),
          //                                 ],
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                         Expanded(
          //                           child: InkWell(
          //                             onTap: () {},
          //                             child: Container(
          //                               height: 25.0,
          //                               child: Row(
          //                                 mainAxisAlignment:
          //                                     MainAxisAlignment.center,
          //                                 children: [
          //                                   Icon(
          //                                     Icons.bookmark_border,
          //                                     color: Colors.grey[600],
          //                                     size: 25.0,
          //                                   ),
          //                                   const SizedBox(width: 4.0),
          //                                   Text('Lưu trữ'),
          //                                 ],
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ],
          //                 )
          //               : Column(
          //                   children: [
          //                     Padding(
          //                       padding: const EdgeInsets.all(6.0),
          //                       child: Row(
          //                         children: [
          //                           Container(
          //                             padding: const EdgeInsets.all(5.0),
          //                             decoration: BoxDecoration(
          //                               color: Color.fromRGBO(246, 81, 82, 1.0),
          //                               shape: BoxShape.circle,
          //                             ),
          //                             child: const Icon(
          //                               Icons.favorite,
          //                               size: 10.0,
          //                               color: Colors.white,
          //                             ),
          //                           ),
          //                           SizedBox(width: 4.0),
          //                           Text(
          //                             '0 lượt thích',
          //                             style: TextStyle(
          //                               color: Colors.grey[600],
          //                             ),
          //                           ),
          //                           Expanded(
          //                             child: Center(
          //                               child: AnimatedSmoothIndicator(
          //                                 count: 0,
          //                                 activeIndex: pageIndex,
          //                                 effect: ExpandingDotsEffect(
          //                                   dotHeight: 8,
          //                                   dotWidth: 8,
          //                                   expansionFactor: 2.3,
          //                                   activeDotColor: pinkColor,
          //                                   dotColor: Colors.black26,
          //                                 ),
          //                               ),
          //                             ),
          //                           ),
          //                           SizedBox(width: 20.0),
          //                           Text(
          //                             '0 bình luận',
          //                             style: TextStyle(
          //                               color: Colors.grey[600],
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                     Divider(),
          //                     Row(
          //                       children: [
          //                         Expanded(
          //                           child: Container(
          //                             height: 25.0,
          //                             child: Row(
          //                               mainAxisAlignment:
          //                                   MainAxisAlignment.center,
          //                               children: [
          //                                 Icon(
          //                                   Icons.favorite_border,
          //                                   color: Colors.grey[600],
          //                                   size: 20.0,
          //                                 ),
          //                                 const SizedBox(width: 4.0),
          //                                 Text('Thích'),
          //                               ],
          //                             ),
          //                           ),
          //                         ),
          //                         Expanded(
          //                           child: InkWell(
          //                             onTap: () =>
          //                                 _openPost(post, context, pageIndex),
          //                             child: Container(
          //                               height: 25.0,
          //                               child: Row(
          //                                 mainAxisAlignment:
          //                                     MainAxisAlignment.center,
          //                                 children: [
          //                                   Icon(
          //                                     MdiIcons.commentOutline,
          //                                     color: Colors.grey[600],
          //                                     size: 20.0,
          //                                   ),
          //                                   const SizedBox(width: 4.0),
          //                                   Text('Bình luận'),
          //                                 ],
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                         Expanded(
          //                           child: InkWell(
          //                             onTap: () {},
          //                             child: Container(
          //                               height: 25.0,
          //                               child: Row(
          //                                 mainAxisAlignment:
          //                                     MainAxisAlignment.center,
          //                                 children: [
          //                                   Icon(
          //                                     Icons.bookmark_border,
          //                                     color: Colors.grey[600],
          //                                     size: 25.0,
          //                                   ),
          //                                   const SizedBox(width: 4.0),
          //                                   Text('Lưu trữ'),
          //                                 ],
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ],
          //                 );
          //         default:
          //           if (snapshot.hasError) {
          //             return Center(child: Text('Some error occurred!'));
          //           } else {
          //             return onlyPost != null
          //                 ? Column(
          //                     children: [
          //                       Padding(
          //                         padding: const EdgeInsets.all(6.0),
          //                         child: Row(
          //                           children: [
          //                             Container(
          //                               padding: const EdgeInsets.all(5.0),
          //                               decoration: BoxDecoration(
          //                                 color:
          //                                     Color.fromRGBO(246, 81, 82, 1.0),
          //                                 shape: BoxShape.circle,
          //                               ),
          //                               child: const Icon(
          //                                 Icons.favorite,
          //                                 size: 10.0,
          //                                 color: Colors.white,
          //                               ),
          //                             ),
          //                             SizedBox(width: 4.0),
          //                             GestureDetector(
          //                               onTap: () => _openPost(
          //                                   onlyPost, context, pageIndex),
          //                               child: Text(
          //                                 '${onlyPost.like.length} lượt thích',
          //                                 style: TextStyle(
          //                                   color: Colors.grey[600],
          //                                 ),
          //                               ),
          //                             ),
          //                             Expanded(
          //                               child: onlyPost.images.length > 1
          //                                   ? Center(
          //                                       child: AnimatedSmoothIndicator(
          //                                         count: onlyPost.images.length,
          //                                         activeIndex: pageIndex,
          //                                         effect: ExpandingDotsEffect(
          //                                           dotHeight: 8,
          //                                           dotWidth: 8,
          //                                           expansionFactor: 2.3,
          //                                           activeDotColor: pinkColor,
          //                                           dotColor: Colors.black26,
          //                                         ),
          //                                       ),
          //                                     )
          //                                   : Container(),
          //                             ),
          //                             SizedBox(width: 20.0),
          //                             GestureDetector(
          //                               onTap: () => _openPost(
          //                                   onlyPost, context, pageIndex),
          //                               child: Text(
          //                                 '${onlyPost.countComments} bình luận',
          //                                 style: TextStyle(
          //                                   color: Colors.grey[600],
          //                                 ),
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                       Divider(),
          //                       Row(
          //                         children: [
          //                           Expanded(
          //                             child: InkWell(
          //                               onTap: () async {
          //                                 setState(() {
          //                                   onlyPost.isLike =
          //                                       onlyPost.isLike ? false : true;
          //                                 });
          //                                 String? token =
          //                                     await storage.read(key: "token");
          //                                 String postId = post.id;
          //                                 if (token != null) {
          //                                   String url =
          //                                       "/postLike/action/" + postId;
          //                                   var response = await networkHandler
          //                                       .postAuthWithoutBody(
          //                                           url, token);
          //                                 }
          //                                 ;
          //                               },
          //                               child: Container(
          //                                 height: 25.0,
          //                                 child: Row(
          //                                   mainAxisAlignment:
          //                                       MainAxisAlignment.center,
          //                                   children: [
          //                                     onlyPost.isLike
          //                                         ? Icon(
          //                                             Icons.favorite,
          //                                             color: pinkColor,
          //                                             size: 20.0,
          //                                           )
          //                                         : Icon(
          //                                             Icons.favorite_border,
          //                                             color: Colors.grey[600],
          //                                             size: 20.0,
          //                                           ),
          //                                     const SizedBox(width: 4.0),
          //                                     Text('Thích'),
          //                                   ],
          //                                 ),
          //                               ),
          //                             ),
          //                           ),
          //                           Expanded(
          //                             child: InkWell(
          //                               onTap: () =>
          //                                   _openPost(post, context, pageIndex),
          //                               child: Container(
          //                                 height: 25.0,
          //                                 child: Row(
          //                                   mainAxisAlignment:
          //                                       MainAxisAlignment.center,
          //                                   children: [
          //                                     Icon(
          //                                       MdiIcons.commentOutline,
          //                                       color: Colors.grey[600],
          //                                       size: 20.0,
          //                                     ),
          //                                     const SizedBox(width: 4.0),
          //                                     Text('Bình luận'),
          //                                   ],
          //                                 ),
          //                               ),
          //                             ),
          //                           ),
          //                           Expanded(
          //                             child: InkWell(
          //                               onTap: () {},
          //                               child: Container(
          //                                 height: 25.0,
          //                                 child: Row(
          //                                   mainAxisAlignment:
          //                                       MainAxisAlignment.center,
          //                                   children: [
          //                                     Icon(
          //                                       Icons.bookmark_border,
          //                                       color: Colors.grey[600],
          //                                       size: 25.0,
          //                                     ),
          //                                     const SizedBox(width: 4.0),
          //                                     Text('Lưu trữ'),
          //                                   ],
          //                                 ),
          //                               ),
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ],
          //                   )
          //                 : Container(
          //                     height: 10,
          //                   );
          //           }
          //       }
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

class PostHeader extends StatefulWidget {
  final PostData post;
  final bool isPersonalPost;

  // bool _liked;

  const PostHeader({
    Key? key,
    required this.post,
    required this.isPersonalPost,
  }) : super(key: key);

  @override
  _PostHeader createState() => _PostHeader(post: post);
}

class _PostHeader extends State<PostHeader> {
  final PostData post;
  bool isReport = false;
  TextEditingController head = TextEditingController();
  TextEditingController description = TextEditingController();

  _PostHeader({
    Key? key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData>(
      future: UsersApi.getUserData(post.userID),
      builder: (context, snapshot) {
        final user = snapshot.data;
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => _showProfile(post, context),
                        child: Text(
                          post.username,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // SizeBox(height: 5.0),
                      // Row(
                      //   children: [
                      //     Text(
                      //       '${post.createAt} • ',
                      //       style: TextStyle(
                      //         color: Colors.grey[600],
                      //         fontSize: 12.0,
                      //       ),
                      //     ),
                      //     Icon(
                      //       Icons.public,
                      //       color: Colors.grey[600],
                      //       size: 15.0,
                      //     )
                      //   ],
                      // ),
                    ],
                  ),
                ),
                const SizedBox(width: 10.0),
                GestureDetector(
                  onTap: () => _showProfile(post, context),
                  child: ProfileAvatar(
                      minSize: 16,
                      maxSize: 16,
                      imageUrl: user != null
                          ? "$host${user.avatar.fileName}"
                          : link),
                ),
                // IconButton(
                //   icon: const Icon(Icons.more_vert),
                //   onPressed: () async {
                //     String? userID = await storage.read(key: "id");
                //     print(post.userID.toString());
                //     showModalBottomSheet(
                //       isScrollControlled: false,
                //       backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
                //       context: context,
                //       builder: (BuildContext bcx) {
                //         Size size = MediaQuery.of(context).size;
                //         return post.userID.toString() == userID.toString()
                //             ? Container(
                //                 margin: EdgeInsets.fromLTRB(
                //                     10.0, size.height * 0.5 - 195, 10.0, 115),
                //                 padding: EdgeInsets.fromLTRB(
                //                     10.0, 10.0, 10.0, 10.0),
                //                 decoration: BoxDecoration(
                //                   color: Colors.white,
                //                   borderRadius:
                //                       BorderRadius.all(Radius.circular(15.0)),
                //                 ),
                //                 child: Column(children: [
                //                   GestureDetector(
                //                     onTap: () => EditPost(),
                //                     child: Row(
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.start,
                //                       children: [
                //                         SizedBox(
                //                           width: 20,
                //                         ),
                //                         Container(
                //                           width: 20,
                //                           height: 50,
                //                           child: Icon(Icons.edit,
                //                               size: 30,
                //                               color: Colors.black87),
                //                         ),
                //                         SizedBox(
                //                           width: 25,
                //                         ),
                //                         Text(
                //                           'Chỉnh sửa bài viết',
                //                           style: TextStyle(
                //                               color: Colors.black87,
                //                               fontSize: 16,
                //                               fontWeight: FontWeight.w500),
                //                         )
                //                       ],
                //                     ),
                //                   ),
                //                   Divider(
                //                     height: size.height * 0.01,
                //                     color: Colors.black54,
                //                     thickness: 1.2,
                //                     indent: 20,
                //                     endIndent: 20,
                //                   ),
                //                   GestureDetector(
                //                     onTap: () => RemovePost(),
                //                     child: Row(
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.start,
                //                       children: [
                //                         SizedBox(
                //                           width: 20,
                //                         ),
                //                         Container(
                //                           width: 20,
                //                           height: 50,
                //                           child: Icon(Icons.delete,
                //                               size: 30,
                //                               color: Colors.black87),
                //                         ),
                //                         SizedBox(
                //                           width: 25,
                //                         ),
                //                         Text(
                //                           'Xoá bài viết',
                //                           style: TextStyle(
                //                               color: Colors.black87,
                //                               fontSize: 16,
                //                               fontWeight: FontWeight.w500),
                //                         )
                //                       ],
                //                     ),
                //                   ),
                //                 ]))
                //             : Container(
                //                 margin: EdgeInsets.fromLTRB(
                //                     10.0,
                //                     size.height * 0.09,
                //                     10.0,
                //                     size.height * 0.145),
                //                 padding: EdgeInsets.fromLTRB(
                //                     10.0, 10.0, 10.0, 10.0),
                //                 decoration: BoxDecoration(
                //                   color: Colors.white,
                //                   borderRadius:
                //                       BorderRadius.all(Radius.circular(15.0)),
                //                 ),
                //                 child: Column(children: [
                //                   Row(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.start,
                //                     children: [
                //                       SizedBox(width: 20),
                //                       Container(
                //                         width: 20,
                //                         height: 50,
                //                         child: Icon(
                //                             Icons.report_gmailerrorred,
                //                             size: 30,
                //                             color: Colors.black87),
                //                       ),
                //                       SizedBox(
                //                         width: 25,
                //                       ),
                //                       Expanded(
                //                         child: Text(
                //                           'Báo cáo bài viết',
                //                           style: TextStyle(
                //                               color: Colors.black87,
                //                               fontSize: 16,
                //                               fontWeight: FontWeight.w500),
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                   Container(
                //                     height: 130,
                //                     margin:
                //                         EdgeInsets.fromLTRB(20, 0, 20, 10),
                //                     padding:
                //                         EdgeInsets.fromLTRB(15, 5, 15, 5),
                //                     decoration: BoxDecoration(
                //                       color: Colors.black12,
                //                       borderRadius: BorderRadius.all(
                //                           Radius.circular(15)),
                //                     ),
                //                     child: Column(
                //                       children: [
                //                         Row(
                //                           children: [
                //                             Expanded(
                //                               child: TextFormField(
                //                                 controller: head,
                //                                 cursorColor: Colors.black45,
                //                                 decoration: InputDecoration(
                //                                     hintText: 'Tiêu đề?',
                //                                     hintStyle: TextStyle(
                //                                         fontSize: 17,
                //                                         color: Colors.black87,
                //                                         fontWeight:
                //                                             FontWeight.w300),
                //                                     border: InputBorder.none),
                //                               ),
                //                             ),
                //                             SizedBox(width: 10),
                //                             GestureDetector(
                //                               onTap: () async {
                //                                 PostsApi.reportPost(
                //                                     post, head, description);
                //                                 Navigator.pop(context);
                //                                 setState(() {
                //                                   Fluttertoast.showToast(
                //                                       msg:
                //                                           "Báo cáo bài viết thành công",
                //                                       fontSize: 18);
                //                                 });
                //                               },
                //                               child: Icon(
                //                                 MdiIcons.send,
                //                                 size: 24,
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                         Divider(
                //                           height: size.height * 0.01,
                //                           color: Colors.black54,
                //                           thickness: 1,
                //                         ),
                //                         Expanded(
                //                           child: TextFormField(
                //                             maxLines: 2,
                //                             controller: description,
                //                             cursorColor: Colors.black45,
                //                             decoration: InputDecoration(
                //                                 hintText: 'Nội dung báo cáo',
                //                                 hintStyle: TextStyle(
                //                                     fontSize: 15,
                //                                     color: Colors.black87,
                //                                     fontWeight:
                //                                         FontWeight.w300),
                //                                 border: InputBorder.none),
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                   Divider(
                //                     height: size.height * 0.01,
                //                     color: Colors.black54,
                //                     thickness: 1.2,
                //                     indent: 20,
                //                     endIndent: 20,
                //                   ),
                //                   GestureDetector(
                //                     onTap: () => BlockPost(),
                //                     child: Row(
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.start,
                //                       children: [
                //                         SizedBox(
                //                           width: 20,
                //                         ),
                //                         Container(
                //                           width: 20,
                //                           height: 50,
                //                           child: Icon(
                //                               Icons.cancel_presentation,
                //                               size: 30,
                //                               color: Colors.black87),
                //                         ),
                //                         SizedBox(
                //                           width: 25,
                //                         ),
                //                         Text(
                //                           'Chặn bài viết',
                //                           style: TextStyle(
                //                               color: Colors.black87,
                //                               fontSize: 16,
                //                               fontWeight: FontWeight.w500),
                //                         )
                //                       ],
                //                     ),
                //                   ),
                //                 ]));
                //       },
                //     );
                //   },
                // ),
              ],
            );
          default:
            if (snapshot.hasError) {
              return const Center(child: Text('Some error occurred!'));
            } else {
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => _showProfile(post, context),
                          child: Text(
                            post.username,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // SizedBox(height: 5.0),
                        // Row(
                        //   children: [
                        //     Text(
                        //       '${post.createAt} • ',
                        //       style: TextStyle(
                        //         color: Colors.grey[600],
                        //         fontSize: 12.0,
                        //       ),
                        //     ),
                        //     Icon(
                        //       Icons.public,
                        //       color: Colors.grey[600],
                        //       size: 15.0,
                        //     )
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  GestureDetector(
                    onTap: () => _showProfile(post, context),
                    child: ProfileAvatar(
                        minSize: 16,
                        maxSize: 16,
                        imageUrl: user != null
                            ? "$host${user.avatar.fileName}"
                            : link),
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.more_vert),
                  //   onPressed: () async {
                  //     String? userID = await storage.read(key: "id");
                  //     print(post.userID.toString());
                  //     showModalBottomSheet(
                  //       isScrollControlled: false,
                  //       backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
                  //       context: context,
                  //       builder: (BuildContext bcx) {
                  //         Size size = MediaQuery.of(context).size;
                  //         return post.userID.toString() == userID.toString()
                  //             ? Container(
                  //                 margin: EdgeInsets.fromLTRB(
                  //                     10.0, size.height * 0.5 - 195, 10.0, 115),
                  //                 padding: EdgeInsets.fromLTRB(
                  //                     10.0, 10.0, 10.0, 10.0),
                  //                 decoration: BoxDecoration(
                  //                   color: Colors.white,
                  //                   borderRadius:
                  //                       BorderRadius.all(Radius.circular(15.0)),
                  //                 ),
                  //                 child: Column(children: [
                  //                   GestureDetector(
                  //                     onTap: () => EditPost(),
                  //                     child: Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.start,
                  //                       children: [
                  //                         SizedBox(
                  //                           width: 20,
                  //                         ),
                  //                         Container(
                  //                           width: 20,
                  //                           height: 50,
                  //                           child: Icon(Icons.edit,
                  //                               size: 30,
                  //                               color: Colors.black87),
                  //                         ),
                  //                         SizedBox(
                  //                           width: 25,
                  //                         ),
                  //                         Text(
                  //                           'Chỉnh sửa bài viết',
                  //                           style: TextStyle(
                  //                               color: Colors.black87,
                  //                               fontSize: 16,
                  //                               fontWeight: FontWeight.w500),
                  //                         )
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   Divider(
                  //                     height: size.height * 0.01,
                  //                     color: Colors.black54,
                  //                     thickness: 1.2,
                  //                     indent: 20,
                  //                     endIndent: 20,
                  //                   ),
                  //                   GestureDetector(
                  //                     onTap: () => RemovePost(),
                  //                     child: Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.start,
                  //                       children: [
                  //                         SizedBox(
                  //                           width: 20,
                  //                         ),
                  //                         Container(
                  //                           width: 20,
                  //                           height: 50,
                  //                           child: Icon(Icons.delete,
                  //                               size: 30,
                  //                               color: Colors.black87),
                  //                         ),
                  //                         SizedBox(
                  //                           width: 25,
                  //                         ),
                  //                         Text(
                  //                           'Xoá bài viết',
                  //                           style: TextStyle(
                  //                               color: Colors.black87,
                  //                               fontSize: 16,
                  //                               fontWeight: FontWeight.w500),
                  //                         )
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ]))
                  //             : Container(
                  //                 margin: EdgeInsets.fromLTRB(
                  //                     10.0,
                  //                     size.height * 0.09,
                  //                     10.0,
                  //                     size.height * 0.145),
                  //                 padding: EdgeInsets.fromLTRB(
                  //                     10.0, 10.0, 10.0, 10.0),
                  //                 decoration: BoxDecoration(
                  //                   color: Colors.white,
                  //                   borderRadius:
                  //                       BorderRadius.all(Radius.circular(15.0)),
                  //                 ),
                  //                 child: Column(children: [
                  //                   Row(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.start,
                  //                     children: [
                  //                       SizedBox(width: 20),
                  //                       Container(
                  //                         width: 20,
                  //                         height: 50,
                  //                         child: Icon(
                  //                             Icons.report_gmailerrorred,
                  //                             size: 30,
                  //                             color: Colors.black87),
                  //                       ),
                  //                       SizedBox(
                  //                         width: 25,
                  //                       ),
                  //                       Expanded(
                  //                         child: Text(
                  //                           'Báo cáo bài viết',
                  //                           style: TextStyle(
                  //                               color: Colors.black87,
                  //                               fontSize: 16,
                  //                               fontWeight: FontWeight.w500),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   Container(
                  //                     height: 130,
                  //                     margin:
                  //                         EdgeInsets.fromLTRB(20, 0, 20, 10),
                  //                     padding:
                  //                         EdgeInsets.fromLTRB(15, 5, 15, 5),
                  //                     decoration: BoxDecoration(
                  //                       color: Colors.black12,
                  //                       borderRadius: BorderRadius.all(
                  //                           Radius.circular(15)),
                  //                     ),
                  //                     child: Column(
                  //                       children: [
                  //                         Row(
                  //                           children: [
                  //                             Expanded(
                  //                               child: TextFormField(
                  //                                 controller: head,
                  //                                 cursorColor: Colors.black45,
                  //                                 decoration: InputDecoration(
                  //                                     hintText: 'Tiêu đề?',
                  //                                     hintStyle: TextStyle(
                  //                                         fontSize: 17,
                  //                                         color: Colors.black87,
                  //                                         fontWeight:
                  //                                             FontWeight.w300),
                  //                                     border: InputBorder.none),
                  //                               ),
                  //                             ),
                  //                             SizedBox(width: 10),
                  //                             GestureDetector(
                  //                               onTap: () async {
                  //                                 PostsApi.reportPost(
                  //                                     post, head, description);
                  //                                 Navigator.pop(context);
                  //                                 setState(() {
                  //                                   Fluttertoast.showToast(
                  //                                       msg:
                  //                                           "Báo cáo bài viết thành công",
                  //                                       fontSize: 18);
                  //                                 });
                  //                               },
                  //                               child: Icon(
                  //                                 MdiIcons.send,
                  //                                 size: 24,
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                         Divider(
                  //                           height: size.height * 0.01,
                  //                           color: Colors.black54,
                  //                           thickness: 1,
                  //                         ),
                  //                         Expanded(
                  //                           child: TextFormField(
                  //                             maxLines: 2,
                  //                             controller: description,
                  //                             cursorColor: Colors.black45,
                  //                             decoration: InputDecoration(
                  //                                 hintText: 'Nội dung báo cáo',
                  //                                 hintStyle: TextStyle(
                  //                                     fontSize: 15,
                  //                                     color: Colors.black87,
                  //                                     fontWeight:
                  //                                         FontWeight.w300),
                  //                                 border: InputBorder.none),
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   Divider(
                  //                     height: size.height * 0.01,
                  //                     color: Colors.black54,
                  //                     thickness: 1.2,
                  //                     indent: 20,
                  //                     endIndent: 20,
                  //                   ),
                  //                   GestureDetector(
                  //                     onTap: () => BlockPost(),
                  //                     child: Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.start,
                  //                       children: [
                  //                         SizedBox(
                  //                           width: 20,
                  //                         ),
                  //                         Container(
                  //                           width: 20,
                  //                           height: 50,
                  //                           child: Icon(
                  //                               Icons.cancel_presentation,
                  //                               size: 30,
                  //                               color: Colors.black87),
                  //                         ),
                  //                         SizedBox(
                  //                           width: 25,
                  //                         ),
                  //                         Text(
                  //                           'Chặn bài viết',
                  //                           style: TextStyle(
                  //                               color: Colors.black87,
                  //                               fontSize: 16,
                  //                               fontWeight: FontWeight.w500),
                  //                         )
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ]));
                  //       },
                  //     );
                  //   },
                  // ),
                ],
              );
            }
        }
      },
    );
  }

  Future EditPost() async {
    Navigator.pop(context);
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bcx) => EditPostScreen(post: post));
  }

  Future RemovePost() async {
    Size size = MediaQuery.of(context).size;
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          height: 130,
          width: size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(
            children: [
              Container(
                width: size.width * 0.6,
                height: 50,
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: const Text(
                  'Bạn có chắc chắn muốn xoá bài viết?',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      String? token = await storage.read(key: "token");
                      if (token != null) {
                        String postID = post.id;
                        String url = "posts/delete/" + postID;
                        var response =
                            await networkHandler.getWithAuth(url, token);
                        Map output = json.decode(response.body);

                        if (response.statusCode < 300) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: Container(
                      height: 40,
                      width: size.width * 0.3,
                      margin: const EdgeInsets.fromLTRB(10, 5, 4, 5),
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: pinkColor,
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: const Text(
                        'Xoá bài viết',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: size.width * 0.3,
                      margin: const EdgeInsets.fromLTRB(4, 5, 10, 5),
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black87,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: const Text(
                        'Trở lại',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future BlockPost() async {
    Size size = MediaQuery.of(context).size;
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          height: 130,
          width: size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(
            children: [
              Container(
                width: size.width * 0.6,
                height: 50,
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: const Text(
                  'Bạn có chắc chắn muốn chặn bài viết?',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async { Navigator.pop(context);},
                    child: Container(
                      height: 40,
                      width: size.width * 0.3,
                      margin: const EdgeInsets.fromLTRB(10, 5, 4, 5),
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: pinkColor,
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: const Text(
                        'Chặn bài viết',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: size.width * 0.3,
                      margin: const EdgeInsets.fromLTRB(4, 5, 10, 5),
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black87,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: const Text(
                        'Trở lại',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

_showProfile(PostData post, BuildContext context) async {
  String? userID = await storage.read(key: "id");
  // print(userID);
  // print(post.userID);
  print("profile");
  post.userID.toString() == userID.toString()
      ? Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>  ProfileScreen(isProfile: true,)
          ))
      : Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FriendsProfile(
                userId: post.userID,
                userName: post.username,
              )));
}

_openPost(PostData post, BuildContext context, int pageIndex) {
  print(pageIndex.toString());
  Navigator.of(context).push(PageRouteBuilder(
    transitionDuration: const Duration(seconds: 1),
    reverseTransitionDuration: const Duration(seconds: 1),
    pageBuilder: (context, animation, secondaryAnimation) {
      final curvedAnimation =
          CurvedAnimation(parent: animation, curve: const Interval(0, 0.5));
      return FadeTransition(
          opacity: curvedAnimation,
          child: BlogScreen(animation: animation, post: post));
    },
  ));
}
