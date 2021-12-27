import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_apps/models/user.dart';

class PostCard extends StatelessWidget {
  final UserModel? user;
  const PostCard({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: _bottomMargin,
      height: 400,
      // decoration: _boxDecoration,
      child: Column(
        children: [
          Container(
              child: _buildPostHeader(context)
          ),
          Expanded(
            child: _buildImage(context),
          ),
          // Positioned.fill(
          //   child: DecoratedBox(
          //     decoration: BoxDecoration(color: Colors.black.withOpacity(0.05)),
          //   ),
          // ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: _buildLikeIcon()
                ),
                Container(
                    child: _buildCommentIcon(context)
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  EdgeInsets get _bottomMargin => EdgeInsets.only(
    bottom: 30,
  );

  Decoration get _boxDecoration => BoxDecoration(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10),
    ),
    border: Border.all(
      color: Colors.grey,
      width: 1,
    ),
  );

  Widget _buildImage(BuildContext context) => Container(
    child: GestureDetector(
      child: Image(
        image: AssetImage('assets/montain.jpg'),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/post');
      },
    )
  );

  //     Hero(
  //   tag: image.id,
  //   child: Image.network(
  //     image.imageUrl,
  //     fit: BoxFit.cover,
  //   ),
  // );

  Widget _buildLikeIcon() => Container(
    padding: EdgeInsets.symmetric(
      vertical: 8,
    ),
    child: Icon(Icons.favorite_border_outlined, color: Colors.black87, size: 36,)
    // GestureDetector(
    //   onTap: onLikeTap,
    //   child: Icon(
    //     image.likeStatus == LikeStatus.inactive ? Icons.favorite_outline : Icons.favorite,
    //     color: image.likeStatus == LikeStatus.inactive ? Colors.white : Colors.redAccent,
    //   ),
    // ),
  );

  Widget _buildCommentIcon(BuildContext context) => Container(
      padding: EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: IconButton(
        icon: Icon(Icons.comment_outlined, color: Colors.black87, size: 36,),
        onPressed: () {
          Navigator.pushNamed(context, '/comments');
        },
      )
  );

  Widget _buildOptionsIcon(BuildContext context) => Container(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: Colors.black87, size: 36,),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text("Share post"),
                        value: 1,
                      ),
                      PopupMenuItem(
                        child: GestureDetector(child: Text("Delete post"),
                          onTap: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Delete post?'),
                              // content: const Text('AlertDialog description'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => {},//Navigator.pop(context, 'Cancel'),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () => {},//Navigator.pop(context, 'OK'),
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        value: 2,
                        // onTap: () => showDialog<String>(
                        //   context: context,
                        //   builder: (BuildContext context) => AlertDialog(
                        //     title: const Text('AlertDialog Title'),
                        //     content: const Text('AlertDialog description'),
                        //     actions: <Widget>[
                        //       // TextButton(
                        //       //   onPressed: () => {},//Navigator.pop(context, 'Cancel'),
                        //       //   child: const Text('Cancel'),
                        //       // ),
                        //       // TextButton(
                        //       //   onPressed: () => {},//Navigator.pop(context, 'OK'),
                        //       //   child: const Text('OK'),
                        //       // ),
                        //     ],
                        //   ),
                        // ),
                      )
                    ]
                    //todo
                    //   showDialog<String>(
                    //   context: context,
                    //   builder: (BuildContext context) => AlertDialog(
                    //     title: const Text('AlertDialog Title'),
                    //     content: const Text('AlertDialog description'),
                    //     actions: <Widget>[
                    //       TextButton(
                    //         onPressed: () => Navigator.pop(context, 'Cancel'),
                    //         child: const Text('Cancel'),
                    //       ),
                    //       TextButton(
                    //         onPressed: () => Navigator.pop(context, 'OK'),
                    //         child: const Text('OK'),
                    //       ),
                    //     ],
                    //   ),

                )
            );


  Widget _buildPostHeader(BuildContext context) => Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10 ,0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: Icon(Icons.account_circle_outlined, color: Colors.black87, size: 36,),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nickname"/*user!.name*/),
                      Text("Date")
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildOptionsIcon(context)
        ],
      )
  );
}
