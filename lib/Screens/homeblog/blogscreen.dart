import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hust_blog/Screens/Comment/comments_container.dart';
import 'package:hust_blog/Screens/Widget/color.dart';
import 'package:hust_blog/models/comment_list.dart';
import 'package:hust_blog/models/configuration.dart';
import 'package:hust_blog/models/img_model.dart';
import 'package:hust_blog/models/post_model.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../get_data/get_post.dart';

String link = dotenv.env['link'] ?? "";
String link2 = dotenv.env['link2'] ?? "";
String host = dotenv.env['host'] ?? "";

class BlogScreen extends StatefulWidget {
  final PostData post;
  final Animation animation;

  const BlogScreen({
    required this.post,
    required this.animation,
    Key? key,
  }) : super(key: key);

  @override
  _BlogScreenState createState() => _BlogScreenState(post: post, animation: animation);
}

class _BlogScreenState extends State<BlogScreen> {
  final PostData post;
  final Animation animation;
  bool viewAll = false;
  TextEditingController writeComment = TextEditingController();
  int pageIndex = 0;
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  _BlogScreenState({
    required this.post,
    required this.animation,
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final List<ImageModel> img = post.images;
    final pageController = PageController(viewportFraction: 1);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                    ),
                  )
                ],
              )),
          ListView(
            shrinkWrap: true,
            children: [
              Column(children: [
                Stack(
                  children: [
                    Positioned.fill(
                        child: Column(
                          children: [
                            Container(
                              height: 400,
                              color: Colors.black,
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                              ),
                            )
                          ],
                        )),
                    Container(
                      height: 400,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Hero(
                          tag: 1,
                          child: link != null
                              ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0.0),
                            child: img.length != 0?
                            Container(
                              height: 400,
                              child: PageView.builder(
                                controller: pageController,
                                itemCount: img.length,
                                itemBuilder: (context, index) {
                                  final image = img[index];
                                  return image != null
                                      ? CachedNetworkImage(
                                    imageUrl: "$host${image.name}",
                                    fit: BoxFit.cover,
                                  )
                                      : Container(
                                    height: 10,
                                  );
                                },
                                onPageChanged: (index) => setState(() {
                                  pageIndex = index;
                                  print(index);
                                }),
                              ),
                            )
                                : Container(height: 0,),
                          )
                              : Container(
                            height: 400,
                            color: Colors.black,
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              boxShadow: [BoxShadow(color: Color.fromRGBO(203, 203, 203, 1.0), blurRadius: 20, offset: Offset(0, 20))],
                              // borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin:EdgeInsets.only(top: 20),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                        alignment: Alignment.topCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                                onPressed: (){
                                  Navigator.pop(context);
                                }),
                            IconButton(icon: Icon(Icons.more_vert, color: Colors.white,),
                                onPressed: () async {
                                  String? userID = await storage.read(key: "id");
                                  // showModalBottomSheet(
                                  //     isScrollControlled: false,
                                  //     backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
                                  //     context: context,
                                  //     builder: (BuildContext bcx) {
                                  //       Size size = MediaQuery.of(context).size;
                                  //       return post.userID.toString() == userID.toString()
                                  //           ? Container(
                                  //           margin: EdgeInsets.fromLTRB(
                                  //               10.0, size.height * 0.5 - 195, 10.0, 115),
                                  //           padding:
                                  //           EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                  //           decoration: BoxDecoration(
                                  //             color: Colors.white,
                                  //             borderRadius:
                                  //             BorderRadius.all(Radius.circular(15.0)),
                                  //           ),
                                  //           child: Column(children: [
                                  //             GestureDetector(
                                  //               onTap: () {
                                  //                 Navigator.pop(context);
                                  //                 showModalBottomSheet(
                                  //                     isScrollControlled: true,
                                  //                     context: context,
                                  //                     builder: (BuildContext bcx) => EditPostScreen(post: post)
                                  //                 );
                                  //               },
                                  //               child: Row(
                                  //                 mainAxisAlignment: MainAxisAlignment.start,
                                  //                 children: [
                                  //                   SizedBox(
                                  //                     width: 20,
                                  //                   ),
                                  //                   Container(
                                  //                     width: 20,
                                  //                     height: 50,
                                  //                     child: Icon(Icons.edit,
                                  //                         size: 30, color: Colors.black87),
                                  //                   ),
                                  //                   SizedBox(
                                  //                     width: 25,
                                  //                   ),
                                  //                   Text(
                                  //                     'Chỉnh sửa bài viết',
                                  //                     style: TextStyle(
                                  //                         color: Colors.black87,
                                  //                         fontSize: 16,
                                  //                         fontWeight: FontWeight.w500),
                                  //                   )
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //             Divider(
                                  //               height: size.height * 0.01,
                                  //               color: Colors.black54,
                                  //               thickness: 1.2,
                                  //               indent: 20,
                                  //               endIndent: 20,
                                  //             ),
                                  //             GestureDetector(
                                  //               onTap: () => RemovePost(),
                                  //               child: Row(
                                  //                 mainAxisAlignment: MainAxisAlignment.start,
                                  //                 children: [
                                  //                   SizedBox(
                                  //                     width: 20,
                                  //                   ),
                                  //                   Container(
                                  //                     width: 20,
                                  //                     height: 50,
                                  //                     child: Icon(Icons.delete,
                                  //                         size: 30, color: Colors.black87),
                                  //                   ),
                                  //                   SizedBox(
                                  //                     width: 25,
                                  //                   ),
                                  //                   Text(
                                  //                     'Xoá bài viết',
                                  //                     style: TextStyle(
                                  //                         color: Colors.black87,
                                  //                         fontSize: 16,
                                  //                         fontWeight: FontWeight.w500),
                                  //                   )
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //           ]))
                                  //           : Container(
                                  //           margin: EdgeInsets.fromLTRB(10.0,
                                  //               size.height * 0.255, 10.0, size.height * 0.145),
                                  //           padding:
                                  //           EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                  //           decoration: BoxDecoration(
                                  //             color: Colors.white,
                                  //             borderRadius:
                                  //             BorderRadius.all(Radius.circular(15.0)),
                                  //           ),
                                  //           child: Column(children: [
                                  //             GestureDetector(
                                  //               onTap: () async {
                                  //                 String? userID =
                                  //                 await storage.read(key: "id");
                                  //                 print(post.userID.toString() +
                                  //                     "___" +
                                  //                     userID.toString());
                                  //               },
                                  //               child: Row(
                                  //                 mainAxisAlignment: MainAxisAlignment.start,
                                  //                 children: [
                                  //                   SizedBox(
                                  //                     width: 20,
                                  //                   ),
                                  //                   Container(
                                  //                     width: 20,
                                  //                     height: 50,
                                  //                     child: Icon(Icons.report_gmailerrorred,
                                  //                         size: 30, color: Colors.black87),
                                  //                   ),
                                  //                   SizedBox(
                                  //                     width: 25,
                                  //                   ),
                                  //                   Text(
                                  //                     'Báo cáo bài viết',
                                  //                     style: TextStyle(
                                  //                         color: Colors.black87,
                                  //                         fontSize: 16,
                                  //                         fontWeight: FontWeight.w500),
                                  //                   )
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //             Divider(
                                  //               height: size.height * 0.01,
                                  //               color: Colors.black54,
                                  //               thickness: 1.2,
                                  //               indent: 20,
                                  //               endIndent: 20,
                                  //             ),
                                  //             GestureDetector(
                                  //               onTap: () => BlockPost(),
                                  //               child: Row(
                                  //                 mainAxisAlignment: MainAxisAlignment.start,
                                  //                 children: [
                                  //                   SizedBox(
                                  //                     width: 20,
                                  //                   ),
                                  //                   Container(
                                  //                     width: 20,
                                  //                     height: 50,
                                  //                     child: Icon(Icons.cancel_presentation,
                                  //                         size: 30, color: Colors.black87),
                                  //                   ),
                                  //                   SizedBox(
                                  //                     width: 25,
                                  //                   ),
                                  //                   Text(
                                  //                     'Chặn bài viết',
                                  //                     style: TextStyle(
                                  //                         color: Colors.black87,
                                  //                         fontSize: 16,
                                  //                         fontWeight: FontWeight.w500),
                                  //                   )
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //           ]));
                                  //     }),
                                }),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 800,
                      margin: EdgeInsets.fromLTRB(20, 350, 20, 0),
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: shadowList,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          FutureBuilder<PostData>(
                            future: PostsApi.getAPost(post.id),
                            builder: (context, snapshot) {
                              final onlyPost = snapshot.data;
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return onlyPost != null
                                      ? Container(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Column(
                                      children: [
                                        Container(
                                            height: 80,
                                            width: 300,
                                            padding:
                                            EdgeInsets.fromLTRB(15, 0, 15, 0),
                                            child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    post.username,
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.public,
                                                        color: Colors.grey[600],
                                                        size: 16,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        'Public  '+post.createAt.toString().substring(8, 10)+
                                                            '-'+post.createAt.toString().substring(5, 8)+post.createAt.toString().substring(0, 4)
                                                            +' '+post.createAt.toString().substring(11, 16),
                                                        style: TextStyle(fontSize: 14),
                                                      ),
                                                    ],
                                                  ),
                                                ])),
                                      ],
                                    ),
                                  )
                                      : Container(
                                    height: 10,
                                  );
                                default:
                                  if (snapshot.hasError) {
                                    return Center(child: Text('Some error occurred!'));
                                  } else {
                                    return onlyPost != null
                                        ? Container(
                                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 80,
                                              width: 300,
                                              padding:
                                              EdgeInsets.fromLTRB(15, 0, 15, 0),
                                              child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      post.username,
                                                      style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          Icons.public,
                                                          color: Colors.grey[600],
                                                          size: 16,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          'Public  '+post.createAt.toString().substring(8, 10)+
                                                          '-'+post.createAt.toString().substring(5, 8)+post.createAt.toString().substring(0, 4)
                                                          +' '+post.createAt.toString().substring(11, 16),
                                                          style: TextStyle(fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ])),
                                        ],
                                      ),
                                    )
                                        : Container(
                                      height: 10,
                                    );
                                  }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<PostData>(
                      future: PostsApi.getAPost(post.id),
                      builder: (context, snapshot) {
                        final onlyPost = snapshot.data;
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return onlyPost != null
                                ? img.length > 1
                                ? Container(
                              padding: EdgeInsets.fromLTRB(0,330, 0, 0),
                              child: Center(
                                child:
                                AnimatedSmoothIndicator(
                                  count: img.length,
                                  activeIndex: pageIndex,
                                  effect:
                                  ExpandingDotsEffect(
                                    dotHeight: 8,
                                    dotWidth: 8,
                                    expansionFactor: 2.3,
                                    activeDotColor:
                                    Colors.white,
                                    dotColor:
                                    Colors.white24,
                                  ),
                                ),
                              ),
                            )
                                : Container(
                              height: 10,
                            )
                                : Container(
                              height: 10,
                            );
                          default:
                            if (snapshot.hasError) {
                              return Center(child: Text('Some error occurred!'));
                            } else {
                              return onlyPost != null
                                  ? img.length > 1
                                      ? Container(
                                      padding: EdgeInsets.fromLTRB(0,330, 0, 0),
                                        child: Center(
                                          child:
                                          AnimatedSmoothIndicator(
                                            count: img.length,
                                            activeIndex: pageIndex,
                                            effect:
                                            ExpandingDotsEffect(
                                              dotHeight: 8,
                                              dotWidth: 8,
                                              expansionFactor: 2.3,
                                              activeDotColor:
                                              Colors.white,
                                              dotColor:
                                              Colors.white24,
                                            ),
                                          ),
                                        ),
                                      )
                                      : Container(height: 10,)
                                  : Container(
                                height: 10,
                              );
                            }
                        }
                      },
                    ),
                  ],
                ),
                FutureBuilder<PostData>(
                  future: PostsApi.getAPost(post.id),
                  builder: (context, snapshot) {
                    final onlyPost = snapshot.data;
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return onlyPost != null
                            ? Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                EdgeInsets.fromLTRB(15, 0, 15, 10),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: ExpandableText(
                                    post.content,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    expandText: 'Xem thêm',
                                    collapseText: 'Rút gọn',
                                    maxLines: 3,
                                    linkColor: Colors.black54,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _whoLike(onlyPost, context),
                                child: Container(
                                    padding:
                                    EdgeInsets.fromLTRB(15, 5, 15, 0),
                                    child: Row(children: [
                                      Text(
                                        '${onlyPost.like.length}',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'lượt thích',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ])),
                              ),
                            ],
                          ),
                        )
                            : Container(
                          height: 10,
                        );
                      default:
                        if (snapshot.hasError) {
                          return Center(child: Text('Some error occurred!'));
                        } else {
                          return onlyPost != null
                              ? Container(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                      EdgeInsets.fromLTRB(15, 0, 15, 10),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: ExpandableText(
                                          post.content,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          expandText: 'Xem thêm',
                                          collapseText: 'Rút gọn',
                                          maxLines: 3,
                                          linkColor: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => _whoLike(onlyPost, context),
                                      child: Container(
                                          padding:
                                          EdgeInsets.fromLTRB(15, 5, 15, 0),
                                          child: Row(children: [
                                            Text(
                                              '${onlyPost.like.length}',
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'lượt thích',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ])),
                                    ),
                                  ],
                                ),
                              )
                              : Container(
                            height: 10,
                          );
                        }
                    }
                  },
                ),
                FutureBuilder<List<CommentData>>(
                  future: PostsApi.getPostComments(post),
                  builder: (context, snapshot) {
                    final comments = snapshot.data;
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return comments != null
                            ? Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  viewAll = viewAll ? false : true;
                                });
                              },
                              child: Container(
                                  padding:
                                  EdgeInsets.fromLTRB(15, 5, 15, 0),
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          comments.length != 0
                                              ? viewAll
                                              ? 'Rút gọn'
                                              : 'Xem tất cả ${comments.length} bình luận'
                                              : 'Chưa có bình luận',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black54),
                                        ),
                                      ])),
                            ),
                            comments.length != 0
                                ? viewAll
                                ? ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  final comment = comments[
                                  comments.length -
                                      1 -
                                      index];
                                  return CommentsWidget(
                                      comment: comment);
                                })
                                : CommentsWidget(
                                comment:
                                comments[comments.length - 1])
                                : SizedBox(
                              height: 5,
                            ),
                          ],
                        )
                            : Container(
                          height: 10,
                        );
                      default:
                        if (snapshot.hasError) {
                          return Center(child: Text('Some error occurred!'));
                        } else {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    viewAll = viewAll ? false : true;
                                  });
                                },
                                child: Container(
                                    padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
                                    child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            comments!.length != 0
                                                ? viewAll
                                                ? 'Rút gọn'
                                                : 'Xem tất cả ${comments.length} bình luận'
                                                : 'Chưa có bình luận',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black54),
                                          ),
                                        ])),
                              ),
                              comments.length != 0
                                  ? viewAll
                                  ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: comments.length,
                                  itemBuilder: (context, index) {
                                    final comment = comments[
                                    comments.length - 1 - index];
                                    return CommentsWidget(
                                        comment: comment);
                                  })
                                  : CommentsWidget(
                                  comment:
                                  comments[comments.length - 1])
                                  : SizedBox(
                                height: 5,
                              ),
                            ],
                          );
                        }
                    }
                  },
                ),
                SizedBox(
                  height: 55,
                ),
              ]),
            ],
          ),
          // Align(
          //   alignment: Alignment.center,
          //   child: Container(
          //     height: 100,
          //     width: 800,
          //     margin: EdgeInsets.symmetric(horizontal: 20),
          //     padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         boxShadow: shadowList,
          //         borderRadius: BorderRadius.circular(20)),
          //     child: Row(
          //       children: [
          //         Expanded(child: Text('data')),
          //         Text('data'),
          //       ],
          //     ),
          //   ),
          // ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: 100,
              child: Row(
                children: [
                  FutureBuilder<PostData>(
                    future: PostsApi.getAPost(post.id),
                    builder: (context, snapshot) {
                      final onlyPost = snapshot.data;
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return onlyPost != null
                                ? GestureDetector(
                              onTap: (){
                                print("_______________________");
                                setState(() {
                                  onlyPost.isLike =
                                  onlyPost.isLike
                                      ? false
                                      : true;

                                  print(
                                      "_______________________");
                                });
                                PostsApi.likePost(onlyPost);
                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(20)),
                                child:
                                onlyPost.isLike
                                    ? Icon(
                                  Icons.favorite,
                                  color: pinkColor,
                                  size: 25.0,
                                )
                                    : Icon(Icons.favorite_outline,
                                    color: Colors.white,
                                    size: 25.0),
                              ),
                            )
                                : Container(
                              height: 10,
                            );
                        default:
                          if (snapshot.hasError) {
                            return Center(child: Text('Some error occurred!'));
                          } else {
                            return onlyPost != null
                                ? GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      onlyPost.isLike =
                                      onlyPost.isLike
                                          ? false
                                          : true;

                                      print(
                                          "_______________________");
                                    });
                                    PostsApi.likePost(onlyPost);
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius: BorderRadius.circular(20)),
                                    child:
                                    onlyPost.isLike
                                        ? Icon(
                                        Icons.favorite,
                                        color: pinkColor,
                                        size: 25.0,
                                        )
                                        : Icon(Icons.favorite_outline,
                                        color: Colors.white,
                                        size: 25.0),
                                  ),
                                )
                                : Container(
                              height: 10,
                            );
                          }
                      }
                    },
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 4, 0, 5),
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(15.0)
                      ),
                      child:
                      TextFormField(
                        style: TextStyle(fontSize: 16),
                        controller: writeComment,
                        validator: (value) {
                          return null;
                        },
                        // obscureText: checkPass,
                        enableSuggestions: false,
                        autocorrect: false,

                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.send, color: Colors.black87,),
                              onPressed: () {
                                PostsApi.commentPost(post, writeComment);
                                Future.delayed(Duration(milliseconds: 1000), () {
                                  writeComment.text = '';
                                  FocusScope.of(context).unfocus();
                                });
                              },
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            // filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: 'Comment here',
                            fillColor: Colors.white70
                        ),
                      ),
                      // Center(child: Text('Comment',style: TextStyle(color: Colors.white,fontSize: 24),)),
                    ),
                  )
                ],
              )
              ,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40), )
              ),
            ),
          )



        ],
      ),
    );
  }
}

_whoLike(PostData post, BuildContext context) {
  print("${post.like.length} người thích bài viết");
}
_whoShare(PostData post, BuildContext context) {}