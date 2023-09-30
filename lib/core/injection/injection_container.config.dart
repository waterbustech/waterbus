// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

// Package imports:
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

// Project imports:
import '../../features/auth/data/datasources/auth_local_datasource.dart' as _i3;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i19;
import '../../features/auth/domain/usecases/check_auth.dart' as _i21;
import '../../features/auth/domain/usecases/login_with_social.dart' as _i31;
import '../../features/auth/domain/usecases/logout.dart' as _i30;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i35;
import '../../features/home/bloc/home/home_bloc.dart' as _i6;
import '../../features/meeting/domain/usecases/create_meeting.dart' as _i23;
import '../../features/meeting/domain/usecases/get_info_meeting.dart' as _i24;
import '../../features/meeting/domain/usecases/get_recent_joined.dart' as _i27;
import '../../features/meeting/domain/usecases/join_meeting.dart' as _i28;
import '../../features/meeting/domain/usecases/leave_meeting.dart' as _i29;
import '../../features/meeting/domain/usecases/update_meeting.dart' as _i13;
import '../../features/meeting/presentation/bloc/meeting_bloc.dart' as _i32;
import '../../features/profile/domain/usecases/get_presigned_url.dart' as _i25;
import '../../features/profile/domain/usecases/get_profile.dart' as _i26;
import '../../features/profile/domain/usecases/update_profile.dart' as _i33;
import '../../features/profile/presentation/bloc/user_bloc.dart' as _i34;
import '../../features/schedule/blocs/schedule/schedule_bloc.dart' as _i11;
import '../../services/socket.dart' as _i12;
import '../../services/webrtc.dart' as _i17;
import '../utils/datasources/base_remote_data.dart' as _i4;
import '../utils/dio/dio_configuration.dart' as _i5;

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i18;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i20;
import '../../features/meeting/data/datasources/meeting_local_datasource.dart'
    as _i7;
import '../../features/meeting/data/datasources/meeting_remote_datasource.dart'
    as _i8;
import '../../features/meeting/data/repositories/meeting_repository_impl.dart'
    as _i10;
import '../../features/meeting/domain/repositories/meeting_repository.dart'
    as _i9;
import '../../features/meeting/domain/usecases/clean_all_recent_joined.dart'
    as _i22;
import '../../features/profile/data/datasources/user_remote_datasource.dart'
    as _i14;
import '../../features/profile/data/repositories/user_repository_impl.dart'
    as _i16;
import '../../features/profile/domain/repositories/user_repository.dart'
    as _i15;

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
  gh.lazySingleton<_i3.AuthLocalDataSource>(
      () => _i3.AuthLocalDataSourceImpl());
  gh.singleton<_i4.BaseRemoteData>(
      _i4.BaseRemoteData(gh<_i3.AuthLocalDataSource>()));
  gh.singleton<_i5.DioConfiguration>(_i5.DioConfiguration(
    gh<_i4.BaseRemoteData>(),
    gh<_i3.AuthLocalDataSource>(),
  ));
  gh.factory<_i6.HomeBloc>(() => _i6.HomeBloc());
  gh.lazySingleton<_i7.MeetingLocalDataSource>(
      () => _i7.MeetingLocalDataSourceImpl());
  gh.lazySingleton<_i8.MeetingRemoteDataSource>(
      () => _i8.MeetingRemoteDataSourceImpl(gh<_i4.BaseRemoteData>()));
  gh.lazySingleton<_i9.MeetingRepository>(() => _i10.MeetingRepositoryImpl(
        gh<_i8.MeetingRemoteDataSource>(),
        gh<_i7.MeetingLocalDataSource>(),
      ));
  gh.factory<_i11.ScheduleBloc>(() => _i11.ScheduleBloc());
  gh.lazySingleton<_i12.SocketConnection>(
      () => _i12.SocketConnectionImpl(gh<_i3.AuthLocalDataSource>()));
  gh.factory<_i13.UpdateMeeting>(
      () => _i13.UpdateMeeting(gh<_i9.MeetingRepository>()));
  gh.lazySingleton<_i14.UserRemoteDataSource>(
      () => _i14.UserRemoteDataSourceImpl(gh<_i4.BaseRemoteData>()));
  gh.lazySingleton<_i15.UserRepository>(
      () => _i16.UserRepositoryImpl(gh<_i14.UserRemoteDataSource>()));
  gh.lazySingleton<_i17.WaterbusWebRTCManager>(
      () => _i17.WaterbusWebRTCManagerIpml(gh<_i12.SocketConnection>()));
  gh.lazySingleton<_i18.AuthRemoteDataSource>(
      () => _i18.AuthRemoteDataSourceImpl(gh<_i4.BaseRemoteData>()));
  gh.lazySingleton<_i19.AuthRepository>(() => _i20.AuthRepositoryImpl(
        gh<_i3.AuthLocalDataSource>(),
        gh<_i18.AuthRemoteDataSource>(),
      ));
  gh.factory<_i21.CheckAuth>(() => _i21.CheckAuth(gh<_i19.AuthRepository>()));
  gh.factory<_i22.CleanAllRecentJoined>(
      () => _i22.CleanAllRecentJoined(gh<_i9.MeetingRepository>()));
  gh.factory<_i23.CreateMeeting>(
      () => _i23.CreateMeeting(gh<_i9.MeetingRepository>()));
  gh.factory<_i24.GetInfoMeeting>(
      () => _i24.GetInfoMeeting(gh<_i9.MeetingRepository>()));
  gh.factory<_i25.GetPresignedUrl>(
      () => _i25.GetPresignedUrl(gh<_i15.UserRepository>()));
  gh.factory<_i26.GetProfile>(() => _i26.GetProfile(gh<_i15.UserRepository>()));
  gh.factory<_i27.GetRecentJoined>(
      () => _i27.GetRecentJoined(gh<_i9.MeetingRepository>()));
  gh.factory<_i28.JoinMeeting>(
      () => _i28.JoinMeeting(gh<_i9.MeetingRepository>()));
  gh.factory<_i29.LeaveMeeting>(
      () => _i29.LeaveMeeting(gh<_i9.MeetingRepository>()));
  gh.factory<_i30.LogOut>(() => _i30.LogOut(gh<_i19.AuthRepository>()));
  gh.factory<_i31.LoginWithSocial>(
      () => _i31.LoginWithSocial(gh<_i19.AuthRepository>()));
  gh.factory<_i32.MeetingBloc>(() => _i32.MeetingBloc(
        gh<_i27.GetRecentJoined>(),
        gh<_i22.CleanAllRecentJoined>(),
        gh<_i23.CreateMeeting>(),
        gh<_i28.JoinMeeting>(),
        gh<_i13.UpdateMeeting>(),
        gh<_i24.GetInfoMeeting>(),
        gh<_i29.LeaveMeeting>(),
        gh<_i17.WaterbusWebRTCManager>(),
      ));
  gh.factory<_i33.UpdateProfile>(
      () => _i33.UpdateProfile(gh<_i15.UserRepository>()));
  gh.factory<_i34.UserBloc>(() => _i34.UserBloc(
        gh<_i33.UpdateProfile>(),
        gh<_i25.GetPresignedUrl>(),
        gh<_i26.GetProfile>(),
      ));
  gh.factory<_i35.AuthBloc>(() => _i35.AuthBloc(
        gh<_i21.CheckAuth>(),
        gh<_i31.LoginWithSocial>(),
        gh<_i30.LogOut>(),
        gh<_i12.SocketConnection>(),
      ));
  return getIt;
}
