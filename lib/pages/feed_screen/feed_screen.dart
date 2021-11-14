import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:mobile_apps/components/navigation_bar.dart';
import 'package:mobile_apps/components/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body:
          Scaffold(
            body: _showImagesBuilder(),
            bottomNavigationBar: const NavigationBar()
          ),
    );
  }

  Widget _showImagesBuilder() {
    // return LazyLoadScrollView(
    //   onEndOfPage: () {  },
      return Scrollbar(
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black54, thickness: 1,),
            // padding: EdgeInsets.all(16),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return PostCard(
              );
            },
          )
      );
  }

  // todo uncomment
  /*
  Widget _showImagesBuilder() {
    return LazyLoadScrollView(
      // scrollOffset:(MediaQuery.of(context).size.height * 0.7).toInt(),
      onEndOfPage: () {  },
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
            return PhotoCard(
              // image: image,
              // index: index,
              // onLikeTap: () {
              //   _homeScreenBloc.add(HomeScreenEvent.changeLikeStatus(image.likeStatus ?? LikeStatus.inactive, image.id));
              // },
            );
          // } else
          //   return Center(
          //     child: CircularProgressIndicator(),
          //   );
        },
      ),
      // onEndOfPage: () {
      //   _homeScreenBloc.add(HomeScreenEvent.loadMore());
      // },
    );
  }
   */

  // Widget _showImagesBuilder(List<ImageModel> imagesToShow) {
  //   return LazyLoadScrollView(
  //     scrollOffset: (MediaQuery.of(context).size.height * 0.7).toInt(),
  //     child: ListView.builder(
  //       padding: EdgeInsets.all(16),
  //       shrinkWrap: true,
  //       physics: BouncingScrollPhysics(),
  //       itemCount: imagesToShow.length + 1,
  //       itemBuilder: (BuildContext context, int index) {
  //         if (index != imagesToShow.length) {
  //           ImageModel image = imagesToShow[index];
  //           return ImageCard(
  //             image: image,
  //             index: index,
  //             onLikeTap: () {
  //               _homeScreenBloc.add(HomeScreenEvent.changeLikeStatus(image.likeStatus ?? LikeStatus.inactive, image.id));
  //             },
  //           );
  //         } else
  //           return Center(
  //             child: CircularProgressIndicator(),
  //           );
  //       },
  //     ),
  //     onEndOfPage: () {
  //       _homeScreenBloc.add(HomeScreenEvent.loadMore());
  //     },
  //   );
  // }
}
