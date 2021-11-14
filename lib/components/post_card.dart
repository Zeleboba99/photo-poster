import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: _bottomMargin,
      height: 400,
      // decoration: _boxDecoration,
      child: Stack(
        children: [
          Positioned(top: 0, child: _buildPostHeader()),
          Positioned(top: 0, right: 5, child: _buildOptionsIcon()),
          Positioned(
            left: 5,
            right: 5,
            top: 20,
            bottom: 20,
            child: _buildImage(),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.05)),
            ),
          ),
          Positioned(left: 16, bottom: 0, child: _buildLikeIcon()),
          Positioned(right: 16, bottom: 0, child: _buildCommentIcon()),
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

  Widget _buildImage() => Container(
    child: Image(
      image: AssetImage('assets/montain.jpg'),
    ),
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

  Widget _buildCommentIcon() => Container(
      padding: EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Icon(Icons.comment_outlined, color: Colors.black87, size: 36,)
  );

  Widget _buildOptionsIcon() => Container(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.black87, size: 36,),
                  onPressed: () {
                    print("qwer");
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
                    // );
                  },
                )
            );


  Widget _buildPostHeader() => Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10 ,0),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              children: const [
                Text("Name"),
                Text("Date")
              ],
            ),
          ),
        ],
      )
  );
}
