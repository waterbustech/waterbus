import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/features/app/bloc/bloc.dart';

part 'user_search_event.dart';
part 'user_search_state.dart';

@injectable
class UserSearchBloc extends Bloc<UserSearchsEvent, UserSearchState> {
  // MARK: private
  final List<User> _userSearchs = [];
  final WaterbusSdk _waterbusSdk = WaterbusSdk.instance;
  bool _isOver = false;
  String keyword = "";

  UserSearchBloc() : super(UserInitial()) {
    on<UserSearchsEvent>(
      (event, emit) async {
        if (event is SearchUsersEvent) {
          emit(_userSearchingState);
          keyword = event.keyword;
          add(const RefreshUserSearchEvent());
        }

        if (event is GetMoreUserSearchEvent) {
          if (state is UserSearchGetMore || !_isOver) return;

          emit(_userGetMore);
          await _handleSearchUsers();
          emit(_userGetDone);
        }

        if (event is RefreshUserSearchEvent) {
          _cleanUserSearch();
          await _handleSearchUsers();
          emit(_userGetDone);
          event.handleFinish?.call();
        }
      },
    );
  }

  // MARK: state
  UserSearchGetDone get _userGetDone => UserSearchGetDone(
        userSearchs: _searchs,
      );
  UserSearchGetMore get _userGetMore => UserSearchGetMore(
        userSearchs: _searchs,
      );
  UserSearchingState get _userSearchingState => UserSearchingState(
        userSearchs: _searchs,
      );

  List<User> get _searchs {
    _userSearchs.removeWhere((model) => model.id == AppBloc.userBloc.user?.id);

    return _userSearchs;
  }

  // MARK: private methods
  Future<void> _handleSearchUsers() async {
    if (keyword.isEmpty) return;

    final List<User> users = await _waterbusSdk.searchUsers(
      keyword: keyword,
      skip: _userSearchs.length,
    );

    _userSearchs.addAll(users);

    if (users.length < 10) {
      _isOver = true;
    }
  }

  _cleanUserSearch() {
    _isOver = false;
    _userSearchs.clear();
  }
}
