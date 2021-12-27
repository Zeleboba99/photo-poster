import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_event.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_state.dart';
import 'package:mobile_apps/services/user_repository.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  UsersRepository _usersRepository = UsersRepository();

  @override
  FeedState get initialState => FeedInitialState();

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) {
    if (event is FeedLoadEvent) {

    } else if (state is FeedShowPostsState) {

    } else { // FeedErrorState

    }
  }

}