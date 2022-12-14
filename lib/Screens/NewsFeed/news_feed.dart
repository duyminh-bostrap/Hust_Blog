import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hust_blog/Screens/NewsFeed/create_post_container.dart';
import 'package:hust_blog/Screens/NewsFeed/post_container.dart';
import 'package:hust_blog/Screens/Widget/color.dart';
import 'package:hust_blog/get_data/get_post.dart';
import 'package:hust_blog/models/post_model.dart';

class NewsFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<PostData>>(
        future: PostsApi.getPosts(),
        builder: (context, snapshot) {
          final posts = snapshot.data;
          // print(posts![3].content);
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                  child: CircularProgressIndicator(
                color: pinkColor,
              ));
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Some error occurred!'));
              } else {
                return
                    // buildPosts(posts!);
                    CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: CreatePostContainer(),
                    ),
                    posts!.isNotEmpty
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final PostData post =
                                    posts[posts.length - index - 1];
                                return PostContainer(
                                  post: post,
                                  isPersonalPost: false,
                                );
                              },
                              childCount: posts.length,
                            ),
                          )
                        : SliverToBoxAdapter(
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              padding:
                                  const EdgeInsets.fromLTRB(20, 15, 20, 15),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Text(
                                'B???n v?? b???n b?? ch??a c?? b??i vi???t n??o',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                  ],
                );
              }
          }
        },
      ),
    );
  }
}
