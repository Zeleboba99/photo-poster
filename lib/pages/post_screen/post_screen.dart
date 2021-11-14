import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:mobile_apps/components/comment.dart';
import 'package:mobile_apps/components/navigation_bar.dart';
import 'package:mobile_apps/components/post_card.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body:
      Scaffold(
          body: Container(
            margin: EdgeInsets.only(top: 25),
            child: Column(
              children: [
                _postBuilder(),
                _commentsBuilder(),
                Divider(color: Colors.black87,)
              ],
            ),
            // child: _buildOptionsIcon(context),
          ),
          bottomNavigationBar: const NavigationBar()
      ),
    );
  }

  Widget _postBuilder() {
    return PostCard();
  }

  Widget _commentsBuilder() => Container(
    child: Expanded(
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black54, thickness: 1,),
        // padding: EdgeInsets.all(16),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return Comment();
        },
      ),
    )
  );



}
