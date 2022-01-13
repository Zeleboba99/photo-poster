import 'package:mobile_apps/models/post.dart';

abstract class PostScreenEvent{
}

class PostScreenStartedEvent extends PostScreenEvent {
  PostModel postModel;
  bool? redirect;
  bool? reloadComments;
  PostScreenStartedEvent({required this.postModel, this.redirect, this.reloadComments});
}

class PostScreenChangeLikeStatusEvent extends PostScreenEvent {
  PostModel postModel;

  PostScreenChangeLikeStatusEvent({required this.postModel});
}

class PostScreenRemovePostEvent extends PostScreenEvent {
  PostModel postModel;
  PostScreenRemovePostEvent({required this.postModel});
}
