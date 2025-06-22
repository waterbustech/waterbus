// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/archived/presentation/bloc/archived_bloc.dart' as _i935;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/chats/presentation/bloc/chat_bloc.dart' as _i1043;
import '../../features/conversation/bloc/message_bloc.dart' as _i819;
import '../../features/home/bloc/home/home_bloc.dart' as _i430;
import '../../features/profile/presentation/bloc/user_bloc.dart' as _i600;
import '../../features/room/presentation/bloc/room/room_bloc.dart' as _i1030;
import '../../features/settings/lang/datasource/lang_datasource.dart' as _i193;
import '../../features/settings/themes/bloc/themes_bloc.dart' as _i339;
import '../../features/settings/themes/data/themes_datasource.dart' as _i455;
import '../method_channels/pip_channel.dart' as _i921;
import '../utils/audio/meeting_sound.dart' as _i89;

import '../../features/chats/data/datasources/user_local_datasource.dart'
    as _i843;
import '../../features/room/data/datasources/media_config_datasource.dart'
    as _i421;
import '../../features/room/data/datasources/meeting_local_datasource.dart'
    as _i366;
import '../../features/room/presentation/bloc/beauty_filters/beauty_filters_bloc.dart'
    as _i291;
import '../../features/room/presentation/bloc/recent_joined/recent_joined_bloc.dart'
    as _i211;

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
  gh.factory<_i430.HomeBloc>(() => _i430.HomeBloc());
  gh.factory<_i291.BeautyFiltersBloc>(() => _i291.BeautyFiltersBloc());
  gh.factory<_i600.UserBloc>(() => _i600.UserBloc());
  gh.factory<_i1043.ChatBloc>(() => _i1043.ChatBloc());
  gh.factory<_i935.ArchivedBloc>(() => _i935.ArchivedBloc());
  gh.factory<_i819.MessageBloc>(() => _i819.MessageBloc());
  gh.singleton<_i89.RoomSound>(() => _i89.RoomSound());
  gh.singleton<_i921.PipChannel>(() => _i921.PipChannel());
  gh.lazySingleton<_i366.RoomLocalDataSource>(
      () => _i366.RoomLocalDataSourceImpl());
  gh.lazySingleton<_i421.MediaConfigLocalDataSource>(
      () => _i421.MediaConfigLocalDataSourceImpl());
  gh.lazySingleton<_i455.ThemesDatasource>(() => _i455.ThemesDatasourceImpl());
  gh.lazySingleton<_i193.LanguagesDatasource>(
      () => _i193.LanguagesDatasourceImpl());
  gh.lazySingleton<_i843.UserLocalDataSource>(
      () => _i843.UserLocalDataSourceImpl());
  gh.factory<_i1030.RoomBloc>(() => _i1030.RoomBloc(
        gh<_i921.PipChannel>(),
        gh<_i89.RoomSound>(),
        gh<_i366.RoomLocalDataSource>(),
        gh<_i421.MediaConfigLocalDataSource>(),
      ));
  gh.factory<_i339.ThemesBloc>(
      () => _i339.ThemesBloc(gh<_i455.ThemesDatasource>()));
  gh.factory<_i211.RecentJoinedBloc>(
      () => _i211.RecentJoinedBloc(gh<_i366.RoomLocalDataSource>()));
  gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(gh<_i843.UserLocalDataSource>()));
  return getIt;
}
