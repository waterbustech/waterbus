import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/error/result.dart';

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
        if (event is UserSearchStarted) {
          emit(_userSearchInprogress);
          keyword = event.keyword;
          add(const UserSearchRefreshed());
        }

        if (event is UserSearchFetched) {
          if (state is UserSearchLoadMore || !_isOver) return;

          emit(_userSearchLoadMore);
          await _handleSearchUsers();
          emit(_userSearchDone);
        }

        if (event is UserSearchRefreshed) {
          _cleanUserSearch();
          await _handleSearchUsers();
          emit(_userSearchDone);
          event.handleFinish?.call();
        }
      },
    );
  }

  // MARK: state
  UserSearchDone get _userSearchDone => UserSearchDone(
        userSearchs: _searchs,
      );
  UserSearchLoadMore get _userSearchLoadMore => UserSearchLoadMore(
        userSearchs: _searchs,
      );
  UserSearchInprogress get _userSearchInprogress => UserSearchInprogress(
        userSearchs: _searchs,
      );

  List<User> get _searchs {
    _userSearchs.removeWhere((model) => model.id == AppBloc.userBloc.user?.id);

    return _userSearchs;
  }

  // MARK: private methods
  Future<void> _handleSearchUsers() async {
    if (keyword.isEmpty) return;

    final Result<List<User>> result = await _waterbusSdk.searchUsers(
      keyword: keyword,
      skip: _userSearchs.length,
    );

    if (result.isSuccess) {
      final List<User> users = result.value ?? [];
      _userSearchs.addAll(users);

      if (users.length < 10) {
        _isOver = true;
      }
    }
  }

  _cleanUserSearch() {
    _isOver = false;
    _userSearchs.clear();
  }
}
