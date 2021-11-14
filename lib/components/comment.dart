import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  const Comment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Icon(Icons.account_circle_outlined, color: Colors.black87, size: 36,),
          Expanded(child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text("Author_nickname", textAlign: TextAlign.left,),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text("Comment_body", textAlign: TextAlign.left,),
                  ),
                ],
              ),
              Text("28 Sep 21"),
            ],
          ))
        ],
      ),
    );
  }
}
