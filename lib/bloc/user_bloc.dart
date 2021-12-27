import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/bloc/user_event.dart';
import 'package:mobile_apps/bloc/user_state.dart';
import 'package:mobile_apps/models/user.dart';
import 'package:mobile_apps/services/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UsersRepository usersRepository;
  UserBloc({required this.usersRepository}) : assert(usersRepository != null);
  @override
  UserState get initialState => UserEmptyState();//UserEmptyState();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserLoadEvent) {
      yield UserLoadingState();
      try {
        final List<UserModel> _loadedUserList = await usersRepository.getAllUsers();
        yield UserLoadedState(loadedUser: _loadedUserList);
      } catch (_) {
        yield UserErrorState();
      }
    } else if (event is UserClearEvent) {
      yield UserEmptyState();
    }
  }

}