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
import '../../features/home/presentation/bloc/home/home_bloc.dart' as _i495;
import '../../features/profile/presentation/bloc/user_bloc.dart' as _i600;
import '../../features/room/presentation/bloc/room/room_bloc.dart' as _i1030;
import '../method_channels/pip_channel.dart' as _i921;
import '../utils/audio/meeting_sound.dart' as _i89;

import '../../features/chats/data/datasources/user_local_data_source.dart'
    as _i839;
import '../../features/conversation/presentation/bloc/message_bloc.dart'
    as _i738;
import '../../features/room/data/datasources/media_config_data_source.dart'
    as _i1036;
import '../../features/room/data/datasources/room_local_data_source.dart'
    as _i502;
import '../../features/room/presentation/bloc/beauty_filters/beauty_filters_bloc.dart'
    as _i291;
import '../../features/room/presentation/bloc/recent_joined/recent_joined_bloc.dart'
    as _i211;
import '../../features/settings/data/datasource/language_local_data_source.dart'
    as _i1010;
import '../../features/settings/data/datasource/notification_setting_local_data_source.dart'
    as _i140;
import '../../features/settings/data/datasource/themes_local_data_source.dart'
    as _i213;
import '../../features/settings/data/repositories/language_repository.dart'
    as _i498;
import '../../features/settings/domain/repositories/language_repository.dart'
    as _i233;
import '../../features/settings/presentation/bloc/notification_setting/notification_setting_bloc.dart'
    as _i1051;
import '../../features/settings/presentation/bloc/notification_setting_bloc.dart'
    as _i469;
import '../../features/settings/presentation/bloc/themes/themes_bloc.dart'
    as _i947;

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
  gh.factory<_i495.HomeBloc>(() => _i495.HomeBloc());
  gh.factory<_i291.BeautyFiltersBloc>(() => _i291.BeautyFiltersBloc());
  gh.factory<_i600.UserBloc>(() => _i600.UserBloc());
  gh.factory<_i1043.ChatBloc>(() => _i1043.ChatBloc());
  gh.factory<_i935.ArchivedBloc>(() => _i935.ArchivedBloc());
  gh.factory<_i738.MessageBloc>(() => _i738.MessageBloc());
  gh.singleton<_i89.RoomSound>(() => _i89.RoomSound());
  gh.singleton<_i921.PipChannel>(() => _i921.PipChannel());
  gh.lazySingleton<_i140.NotificationSettingLocalDataSource>(
      () => _i140.NotificationSettingLocalImpl());
  gh.lazySingleton<_i213.ThemesLocalDataSource>(
      () => _i213.ThemesDatasourceImpl());
  gh.factory<_i947.ThemesBloc>(
      () => _i947.ThemesBloc(gh<_i213.ThemesLocalDataSource>()));
  gh.lazySingleton<_i233.LanguageRepository>(
      () => _i498.LanguageRepositoryImpl());
  gh.lazySingleton<_i1036.MediaConfigLocalDataSource>(
      () => _i1036.MediaConfigLocalDataSourceImpl());
  gh.lazySingleton<_i502.RoomLocalDataSource>(
      () => _i502.RoomLocalDataSourceImpl());
  gh.factory<_i469.NotificationSettingBloc>(() => _i469.NotificationSettingBloc(
      gh<_i140.NotificationSettingLocalDataSource>()));
  gh.factory<_i1051.NotificationSettingBloc>(() =>
      _i1051.NotificationSettingBloc(
          gh<_i140.NotificationSettingLocalDataSource>()));
  gh.lazySingleton<_i839.UserLocalDataSource>(
      () => _i839.UserLocalDataSourceImpl());
  gh.lazySingleton<_i1010.LanguageLocalDataSource>(
      () => _i1010.LanguageLocalDataSourceImpl());
  gh.factory<_i1030.RoomBloc>(() => _i1030.RoomBloc(
        gh<_i921.PipChannel>(),
        gh<_i89.RoomSound>(),
        gh<_i502.RoomLocalDataSource>(),
        gh<_i1036.MediaConfigLocalDataSource>(),
      ));
  gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(gh<_i839.UserLocalDataSource>()));
  gh.factory<_i211.RecentJoinedBloc>(
      () => _i211.RecentJoinedBloc(gh<_i502.RoomLocalDataSource>()));
  return getIt;
}
