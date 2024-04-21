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
import '../../features/auth/domain/repositories/auth_repository.dart' as _i22;
import '../../features/auth/domain/usecases/check_auth.dart' as _i26;
import '../../features/auth/domain/usecases/login_with_social.dart' as _i25;
import '../../features/auth/domain/usecases/logout.dart' as _i27;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i37;
import '../../features/home/bloc/home/home_bloc.dart' as _i3;
import '../../features/meeting/domain/usecases/create_meeting.dart' as _i28;
import '../../features/meeting/domain/usecases/get_call_settings.dart' as _i30;
import '../../features/meeting/domain/usecases/get_info_meeting.dart' as _i32;
import '../../features/meeting/domain/usecases/get_recent_joined.dart' as _i35;
import '../../features/meeting/domain/usecases/join_meeting.dart' as _i29;
import '../../features/meeting/domain/usecases/save_call_settings.dart' as _i36;
import '../../features/meeting/domain/usecases/update_meeting.dart' as _i31;
import '../../features/profile/domain/usecases/get_presigned_url.dart' as _i19;
import '../../features/profile/domain/usecases/get_profile.dart' as _i20;
import '../../features/profile/domain/usecases/update_profile.dart' as _i18;
import '../../features/profile/domain/usecases/upload_avatar.dart' as _i21;
import '../../features/profile/presentation/bloc/user_bloc.dart' as _i24;
import '../method_channels/pip_channel.dart' as _i5;
import '../utils/datasources/base_remote_data.dart' as _i9;
import '../utils/dio/dio_configuration.dart' as _i11;

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i10;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i23;
import '../../features/meeting/data/datasources/call_settings_datasource.dart'
    as _i8;
import '../../features/meeting/data/datasources/meeting_local_datasource.dart'
    as _i7;
import '../../features/meeting/data/datasources/meeting_remote_datasource.dart'
    as _i12;
import '../../features/meeting/data/repositories/meeting_repository_impl.dart'
    as _i17;
import '../../features/meeting/domain/repositories/meeting_repository.dart'
    as _i16;
import '../../features/meeting/domain/usecases/clean_all_recent_joined.dart'
    as _i34;
import '../../features/meeting/domain/usecases/remove_recent_joined.dart'
    as _i33;
import '../../features/meeting/presentation/bloc/beauty_filters/beauty_filters_bloc.dart'
    as _i4;
import '../../features/meeting/presentation/bloc/meeting/meeting_bloc.dart'
    as _i39;
import '../../features/meeting/presentation/bloc/recent_joined/recent_joined_bloc.dart'
    as _i38;
import '../../features/profile/data/datasources/user_remote_datasource.dart'
    as _i13;
import '../../features/profile/data/repositories/user_repository_impl.dart'
    as _i15;
import '../../features/profile/domain/repositories/user_repository.dart'
    as _i14;
import 'package:waterbus/features/settings/themes/data/themes_datasource.dart'
    as _40;
import 'package:waterbus/features/settings/themes/bloc/themes_bloc.dart' as _41;

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
  gh.singleton<_i9.BaseRemoteData>(
      () => _i9.BaseRemoteData(gh<_i6.AuthLocalDataSource>()));
  gh.lazySingleton<_i10.AuthRemoteDataSource>(
      () => _i10.AuthRemoteDataSourceImpl(gh<_i9.BaseRemoteData>()));
  gh.singleton<_i11.DioConfiguration>(() => _i11.DioConfiguration(
        gh<_i9.BaseRemoteData>(),
        gh<_i6.AuthLocalDataSource>(),
      ));
  gh.lazySingleton<_i12.MeetingRemoteDataSource>(
      () => _i12.MeetingRemoteDataSourceImpl(gh<_i9.BaseRemoteData>()));
  gh.lazySingleton<_i13.UserRemoteDataSource>(
      () => _i13.UserRemoteDataSourceImpl(gh<_i9.BaseRemoteData>()));
  gh.lazySingleton<_i14.UserRepository>(
      () => _i15.UserRepositoryImpl(gh<_i13.UserRemoteDataSource>()));
  gh.lazySingleton<_i16.MeetingRepository>(() => _i17.MeetingRepositoryImpl(
        gh<_i12.MeetingRemoteDataSource>(),
        gh<_i7.MeetingLocalDataSource>(),
        gh<_i8.CallSettingsLocalDataSource>(),
      ));
  gh.factory<_i18.UpdateProfile>(
      () => _i18.UpdateProfile(gh<_i14.UserRepository>()));
  gh.factory<_i19.GetPresignedUrl>(
      () => _i19.GetPresignedUrl(gh<_i14.UserRepository>()));
  gh.factory<_i20.GetProfile>(() => _i20.GetProfile(gh<_i14.UserRepository>()));
  gh.factory<_i21.UploadAvatar>(
      () => _i21.UploadAvatar(gh<_i14.UserRepository>()));
  gh.lazySingleton<_i22.AuthRepository>(() => _i23.AuthRepositoryImpl(
        gh<_i6.AuthLocalDataSource>(),
        gh<_i10.AuthRemoteDataSource>(),
      ));
  gh.factory<_i24.UserBloc>(() => _i24.UserBloc(
        gh<_i18.UpdateProfile>(),
        gh<_i19.GetPresignedUrl>(),
        gh<_i20.GetProfile>(),
        gh<_i21.UploadAvatar>(),
      ));
  gh.factory<_i25.LoginWithSocial>(
      () => _i25.LoginWithSocial(gh<_i22.AuthRepository>()));
  gh.factory<_i26.CheckAuth>(() => _i26.CheckAuth(gh<_i22.AuthRepository>()));
  gh.factory<_i27.LogOut>(() => _i27.LogOut(gh<_i22.AuthRepository>()));
  gh.factory<_i28.CreateMeeting>(
      () => _i28.CreateMeeting(gh<_i16.MeetingRepository>()));
  gh.factory<_i29.JoinMeeting>(
      () => _i29.JoinMeeting(gh<_i16.MeetingRepository>()));
  gh.factory<_i30.GetCallSettings>(
      () => _i30.GetCallSettings(gh<_i16.MeetingRepository>()));
  gh.factory<_i31.UpdateMeeting>(
      () => _i31.UpdateMeeting(gh<_i16.MeetingRepository>()));
  gh.factory<_i32.GetInfoMeeting>(
      () => _i32.GetInfoMeeting(gh<_i16.MeetingRepository>()));
  gh.factory<_i33.RemoveRecentJoined>(
      () => _i33.RemoveRecentJoined(gh<_i16.MeetingRepository>()));
  gh.factory<_i34.CleanAllRecentJoined>(
      () => _i34.CleanAllRecentJoined(gh<_i16.MeetingRepository>()));
  gh.factory<_i35.GetRecentJoined>(
      () => _i35.GetRecentJoined(gh<_i16.MeetingRepository>()));
  gh.factory<_i36.SaveCallSettings>(
      () => _i36.SaveCallSettings(gh<_i16.MeetingRepository>()));
  gh.factory<_i37.AuthBloc>(() => _i37.AuthBloc(
        gh<_i26.CheckAuth>(),
        gh<_i25.LoginWithSocial>(),
        gh<_i27.LogOut>(),
        gh<_i6.AuthLocalDataSource>(),
      ));
  gh.factory<_i38.RecentJoinedBloc>(() => _i38.RecentJoinedBloc(
        gh<_i35.GetRecentJoined>(),
        gh<_i33.RemoveRecentJoined>(),
        gh<_i34.CleanAllRecentJoined>(),
      ));
  gh.factory<_i39.MeetingBloc>(() => _i39.MeetingBloc(
        gh<_i28.CreateMeeting>(),
        gh<_i29.JoinMeeting>(),
        gh<_i31.UpdateMeeting>(),
        gh<_i32.GetInfoMeeting>(),
        gh<_i30.GetCallSettings>(),
        gh<_i36.SaveCallSettings>(),
        gh<_i5.PipChannel>(),
      ));
  gh.lazySingleton<_40.ThemesDatasource>(() => _40.ThemesDatasourceImpl());

  gh.factory<_41.ThemesBloc>(() => _41.ThemesBloc(gh<_40.ThemesDatasource>()));
  
  return getIt;
}
