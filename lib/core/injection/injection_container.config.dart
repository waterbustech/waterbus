// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/chats/presentation/bloc/chat_bloc.dart' as _i1043;
import '../../features/chats/presentation/bloc/invited_chat_bloc.dart' as _i262;
import '../../features/conversation/bloc/message_bloc.dart' as _i819;
import '../../features/home/bloc/home/home_bloc.dart' as _i430;
import '../../features/profile/presentation/bloc/user_bloc.dart' as _i600;
import '../../features/settings/lang/datasource/lang_datasource.dart' as _i193;
import '../../features/settings/themes/bloc/themes_bloc.dart' as _i339;
import '../../features/settings/themes/data/themes_datasource.dart' as _i455;
import '../method_channels/pip_channel.dart' as _i921;

import '../../features/chats/data/datasources/user_local_datasource.dart'
    as _i843;
import '../../features/meeting/data/datasources/call_settings_datasource.dart'
    as _i688;
import '../../features/meeting/data/datasources/meeting_local_datasource.dart'
    as _i254;
import '../../features/meeting/presentation/bloc/beauty_filters/beauty_filters_bloc.dart'
    as _i861;
import '../../features/meeting/presentation/bloc/drawing/handle_socket/drawing_bloc.dart'
    as _i1026;
import '../../features/meeting/presentation/bloc/drawing/options/drawing_options_bloc.dart'
    as _i51;
import '../../features/meeting/presentation/bloc/meeting/meeting_bloc.dart'
    as _i545;
import '../../features/meeting/presentation/bloc/recent_joined/recent_joined_bloc.dart'
    as _i324;
import '../../features/profile/presentation/bloc/user_search_bloc.dart'
    as _i254;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i1043.ChatBloc>(() => _i1043.ChatBloc());
  gh.factory<_i262.InvitedChatBloc>(() => _i262.InvitedChatBloc());
  gh.factory<_i819.MessageBloc>(() => _i819.MessageBloc());
  gh.factory<_i430.HomeBloc>(() => _i430.HomeBloc());
  gh.factory<_i861.BeautyFiltersBloc>(() => _i861.BeautyFiltersBloc());
  gh.factory<_i1026.DrawingBloc>(() => _i1026.DrawingBloc());
  gh.factory<_i51.DrawingOptionsBloc>(() => _i51.DrawingOptionsBloc());
  gh.factory<_i600.UserBloc>(() => _i600.UserBloc());
  gh.factory<_i254.UserSearchBloc>(() => _i254.UserSearchBloc());
  gh.singleton<_i921.PipChannel>(() => _i921.PipChannel());
  gh.lazySingleton<_i254.MeetingLocalDataSource>(
      () => _i254.MeetingLocalDataSourceImpl());
  gh.lazySingleton<_i688.CallSettingsLocalDataSource>(
      () => _i688.CallSettingsLocalDataSourceImpl());
  gh.lazySingleton<_i455.ThemesDatasource>(() => _i455.ThemesDatasourceImpl());
  gh.lazySingleton<_i193.LanguagesDatasource>(
      () => _i193.LanguagesDatasourceImpl());
  gh.lazySingleton<_i843.UserLocalDataSource>(
      () => _i843.UserLocalDataSourceImpl());
  gh.factory<_i339.ThemesBloc>(
      () => _i339.ThemesBloc(gh<_i455.ThemesDatasource>()));
  gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(gh<_i843.UserLocalDataSource>()));
  gh.factory<_i545.MeetingBloc>(() => _i545.MeetingBloc(
        gh<_i921.PipChannel>(),
        gh<_i254.MeetingLocalDataSource>(),
        gh<_i688.CallSettingsLocalDataSource>(),
      ));
  gh.factory<_i324.RecentJoinedBloc>(
      () => _i324.RecentJoinedBloc(gh<_i254.MeetingLocalDataSource>()));
  return getIt;
}
