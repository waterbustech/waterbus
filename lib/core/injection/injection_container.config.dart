// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

// Package imports:
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

// Project imports:
import '../../features/auth/data/datasources/auth_local_datasource.dart' as _i6;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i25;
import '../../features/auth/domain/usecases/check_auth.dart' as _i29;
import '../../features/auth/domain/usecases/login_with_social.dart' as _i28;
import '../../features/auth/domain/usecases/logout.dart' as _i30;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i40;
import '../../features/home/bloc/home/home_bloc.dart' as _i3;
import '../../features/meeting/domain/usecases/create_meeting.dart' as _i31;
import '../../features/meeting/domain/usecases/get_call_settings.dart' as _i33;
import '../../features/meeting/domain/usecases/get_info_meeting.dart' as _i35;
import '../../features/meeting/domain/usecases/get_recent_joined.dart' as _i38;
import '../../features/meeting/domain/usecases/join_meeting.dart' as _i32;
import '../../features/meeting/domain/usecases/save_call_settings.dart' as _i39;
import '../../features/meeting/domain/usecases/update_meeting.dart' as _i34;
import '../../features/profile/domain/usecases/get_presigned_url.dart' as _i22;
import '../../features/profile/domain/usecases/get_profile.dart' as _i23;
import '../../features/profile/domain/usecases/update_profile.dart' as _i21;
import '../../features/profile/domain/usecases/upload_avatar.dart' as _i24;
import '../../features/profile/presentation/bloc/user_bloc.dart' as _i27;
import '../../features/settings/lang/datasource/lang_datasource.dart' as _i10;
import '../../features/settings/themes/bloc/themes_bloc.dart' as _i11;
import '../../features/settings/themes/data/themes_datasource.dart' as _i9;
import '../method_channels/pip_channel.dart' as _i5;
import '../utils/datasources/base_remote_data.dart' as _i12;
import '../utils/dio/dio_configuration.dart' as _i14;

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i13;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i26;
import '../../features/meeting/data/datasources/call_settings_datasource.dart'
    as _i8;
import '../../features/meeting/data/datasources/meeting_local_datasource.dart'
    as _i7;
import '../../features/meeting/data/datasources/meeting_remote_datasource.dart'
    as _i15;
import '../../features/meeting/data/repositories/meeting_repository_impl.dart'
    as _i20;
import '../../features/meeting/domain/repositories/meeting_repository.dart'
    as _i19;
import '../../features/meeting/domain/usecases/clean_all_recent_joined.dart'
    as _i37;
import '../../features/meeting/domain/usecases/remove_recent_joined.dart'
    as _i36;
import '../../features/meeting/presentation/bloc/beauty_filters/beauty_filters_bloc.dart'
    as _i4;
import '../../features/meeting/presentation/bloc/meeting/meeting_bloc.dart'
    as _i42;
import '../../features/meeting/presentation/bloc/recent_joined/recent_joined_bloc.dart'
    as _i41;
import '../../features/profile/data/datasources/user_remote_datasource.dart'
    as _i16;
import '../../features/profile/data/repositories/user_repository_impl.dart'
    as _i18;
import '../../features/profile/domain/repositories/user_repository.dart'
    as _i17;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i3.HomeBloc>(() => _i3.HomeBloc());
  gh.factory<_i4.BeautyFiltersBloc>(() => _i4.BeautyFiltersBloc());
  gh.singleton<_i5.PipChannel>(() => _i5.PipChannel());
  gh.lazySingleton<_i6.AuthLocalDataSource>(
      () => _i6.AuthLocalDataSourceImpl());
  gh.lazySingleton<_i7.MeetingLocalDataSource>(
      () => _i7.MeetingLocalDataSourceImpl());
  gh.lazySingleton<_i8.CallSettingsLocalDataSource>(
      () => _i8.CallSettingsLocalDataSourceImpl());
  gh.lazySingleton<_i9.ThemesDatasource>(() => _i9.ThemesDatasourceImpl());
  gh.lazySingleton<_i10.LanguagesDatasource>(
      () => _i10.LanguagesDatasourceImpl());
  gh.factory<_i11.ThemesBloc>(
      () => _i11.ThemesBloc(gh<_i9.ThemesDatasource>()));
  gh.singleton<_i12.BaseRemoteData>(
      () => _i12.BaseRemoteData(gh<_i6.AuthLocalDataSource>()));
  gh.lazySingleton<_i13.AuthRemoteDataSource>(
      () => _i13.AuthRemoteDataSourceImpl(gh<_i12.BaseRemoteData>()));
  gh.singleton<_i14.DioConfiguration>(() => _i14.DioConfiguration(
        gh<_i12.BaseRemoteData>(),
        gh<_i6.AuthLocalDataSource>(),
      ));
  gh.lazySingleton<_i15.MeetingRemoteDataSource>(
      () => _i15.MeetingRemoteDataSourceImpl(gh<_i12.BaseRemoteData>()));
  gh.lazySingleton<_i16.UserRemoteDataSource>(
      () => _i16.UserRemoteDataSourceImpl(gh<_i12.BaseRemoteData>()));
  gh.lazySingleton<_i17.UserRepository>(
      () => _i18.UserRepositoryImpl(gh<_i16.UserRemoteDataSource>()));
  gh.lazySingleton<_i19.MeetingRepository>(() => _i20.MeetingRepositoryImpl(
        gh<_i15.MeetingRemoteDataSource>(),
        gh<_i7.MeetingLocalDataSource>(),
        gh<_i8.CallSettingsLocalDataSource>(),
      ));
  gh.factory<_i21.UpdateProfile>(
      () => _i21.UpdateProfile(gh<_i17.UserRepository>()));
  gh.factory<_i22.GetPresignedUrl>(
      () => _i22.GetPresignedUrl(gh<_i17.UserRepository>()));
  gh.factory<_i23.GetProfile>(() => _i23.GetProfile(gh<_i17.UserRepository>()));
  gh.factory<_i24.UploadAvatar>(
      () => _i24.UploadAvatar(gh<_i17.UserRepository>()));
  gh.lazySingleton<_i25.AuthRepository>(() => _i26.AuthRepositoryImpl(
        gh<_i6.AuthLocalDataSource>(),
        gh<_i13.AuthRemoteDataSource>(),
      ));
  gh.factory<_i27.UserBloc>(() => _i27.UserBloc(
        gh<_i21.UpdateProfile>(),
        gh<_i22.GetPresignedUrl>(),
        gh<_i23.GetProfile>(),
        gh<_i24.UploadAvatar>(),
      ));
  gh.factory<_i28.LoginWithSocial>(
      () => _i28.LoginWithSocial(gh<_i25.AuthRepository>()));
  gh.factory<_i29.CheckAuth>(() => _i29.CheckAuth(gh<_i25.AuthRepository>()));
  gh.factory<_i30.LogOut>(() => _i30.LogOut(gh<_i25.AuthRepository>()));
  gh.factory<_i31.CreateMeeting>(
      () => _i31.CreateMeeting(gh<_i19.MeetingRepository>()));
  gh.factory<_i32.JoinMeeting>(
      () => _i32.JoinMeeting(gh<_i19.MeetingRepository>()));
  gh.factory<_i33.GetCallSettings>(
      () => _i33.GetCallSettings(gh<_i19.MeetingRepository>()));
  gh.factory<_i34.UpdateMeeting>(
      () => _i34.UpdateMeeting(gh<_i19.MeetingRepository>()));
  gh.factory<_i35.GetInfoMeeting>(
      () => _i35.GetInfoMeeting(gh<_i19.MeetingRepository>()));
  gh.factory<_i36.RemoveRecentJoined>(
      () => _i36.RemoveRecentJoined(gh<_i19.MeetingRepository>()));
  gh.factory<_i37.CleanAllRecentJoined>(
      () => _i37.CleanAllRecentJoined(gh<_i19.MeetingRepository>()));
  gh.factory<_i38.GetRecentJoined>(
      () => _i38.GetRecentJoined(gh<_i19.MeetingRepository>()));
  gh.factory<_i39.SaveCallSettings>(
      () => _i39.SaveCallSettings(gh<_i19.MeetingRepository>()));
  gh.factory<_i40.AuthBloc>(() => _i40.AuthBloc(
        gh<_i29.CheckAuth>(),
        gh<_i28.LoginWithSocial>(),
        gh<_i30.LogOut>(),
        gh<_i6.AuthLocalDataSource>(),
      ));
  gh.factory<_i41.RecentJoinedBloc>(() => _i41.RecentJoinedBloc(
        gh<_i38.GetRecentJoined>(),
        gh<_i36.RemoveRecentJoined>(),
        gh<_i37.CleanAllRecentJoined>(),
      ));
  gh.factory<_i42.MeetingBloc>(() => _i42.MeetingBloc(
        gh<_i31.CreateMeeting>(),
        gh<_i32.JoinMeeting>(),
        gh<_i34.UpdateMeeting>(),
        gh<_i35.GetInfoMeeting>(),
        gh<_i33.GetCallSettings>(),
        gh<_i39.SaveCallSettings>(),
        gh<_i5.PipChannel>(),
      ));
  return getIt;
}
