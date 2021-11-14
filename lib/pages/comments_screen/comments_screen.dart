import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_apps/components/comment.dart';
import 'package:mobile_apps/components/navigation_bar.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({Key? key}) : super(key: key);

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
                _commentsHeaderBuilder(context),
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

  Widget _commentsBuilder() => Container(
      child: Expanded(
        child: Scrollbar(
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black54, thickness: 1,),
            // padding: EdgeInsets.all(16),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            itemCount: 20,
            itemBuilder: (BuildContext context, int index) {
              return Comment();
            },
          ),
        )
      )
  );

  Widget _commentsHeaderBuilder(BuildContext context) => Container(
    child: Row(
      children: [
        IconButton(
            icon: const Icon(Icons.keyboard_backspace, size: 40,),
            onPressed: () {
              Navigator.pop(context);
            }),
        const Spacer(flex: 2,),
        Container(
          // alignment: Alignment.topCenter,
          child: Align(
              alignment: Alignment.center,
              child: Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: const Text("Comments",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 40,
                          fontWeight: FontWeight.w300
                      )))),
        ),
        const Spacer(flex: 3,),
      ],
    ),
  );
}
