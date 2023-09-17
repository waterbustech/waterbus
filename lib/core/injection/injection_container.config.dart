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
import '../../features/auth/domain/repositories/auth_repository.dart' as _i17;
import '../../features/auth/domain/usecases/check_auth.dart' as _i19;
import '../../features/auth/domain/usecases/login_with_social.dart' as _i27;
import '../../features/auth/domain/usecases/logout.dart' as _i26;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i31;
import '../../features/home/bloc/home/home_bloc.dart' as _i6;
import '../../features/meeting/domain/usecases/create_meeting.dart' as _i20;
import '../../features/meeting/domain/usecases/get_info_meeting.dart' as _i21;
import '../../features/meeting/domain/usecases/join_meeting.dart' as _i24;
import '../../features/meeting/domain/usecases/leave_meeting.dart' as _i25;
import '../../features/meeting/domain/usecases/update_meeting.dart' as _i12;
import '../../features/meeting/presentation/bloc/meeting_bloc.dart' as _i28;
import '../../features/profile/domain/usecases/get_presigned_url.dart' as _i22;
import '../../features/profile/domain/usecases/get_profile.dart' as _i23;
import '../../features/profile/domain/usecases/update_profile.dart' as _i29;
import '../../features/profile/presentation/bloc/user_bloc.dart' as _i30;
import '../../features/schedule/blocs/schedule/schedule_bloc.dart' as _i10;
import '../../services/socket.dart' as _i11;
import '../utils/datasources/base_remote_data.dart' as _i4;
import '../utils/dio/dio_configuration.dart' as _i5;

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i16;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i18;
import '../../features/meeting/data/datasources/meeting_remote_datasource.dart'
    as _i7;
import '../../features/meeting/data/repositories/meeting_repository_impl.dart'
    as _i9;
import '../../features/meeting/domain/repositories/meeting_repository.dart'
    as _i8;
import '../../features/profile/data/datasource/user_remote_datasource.dart'
    as _i13;
import '../../features/profile/data/repositories/user_repository_impl.dart'
    as _i15;
import '../../features/profile/domain/repositories/user_repository.dart'
    as _i14;

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
  gh.lazySingleton<_i7.MeetingRemoteDataSource>(
      () => _i7.MeetingRemoteDataSourceImpl(gh<_i4.BaseRemoteData>()));
  gh.lazySingleton<_i8.MeetingRepository>(() => _i9.MeetingRepositoryImpl());
  gh.factory<_i10.ScheduleBloc>(() => _i10.ScheduleBloc());
  gh.lazySingleton<_i11.SocketConnection>(
      () => _i11.SocketConnection(gh<_i3.AuthLocalDataSource>()));
  gh.factory<_i12.UpdateMeeting>(
      () => _i12.UpdateMeeting(gh<_i8.MeetingRepository>()));
  gh.lazySingleton<_i13.UserRemoteDataSource>(
      () => _i13.UserRemoteDataSourceImpl(gh<_i4.BaseRemoteData>()));
  gh.lazySingleton<_i14.UserRepository>(
      () => _i15.UserRepositoryImpl(gh<_i13.UserRemoteDataSource>()));
  gh.lazySingleton<_i16.AuthRemoteDataSource>(
      () => _i16.AuthRemoteDataSourceImpl(gh<_i4.BaseRemoteData>()));
  gh.lazySingleton<_i17.AuthRepository>(() => _i18.AuthRepositoryImpl(
        gh<_i3.AuthLocalDataSource>(),
        gh<_i16.AuthRemoteDataSource>(),
      ));
  gh.factory<_i19.CheckAuth>(() => _i19.CheckAuth(gh<_i17.AuthRepository>()));
  gh.factory<_i20.CreateMeeting>(
      () => _i20.CreateMeeting(gh<_i8.MeetingRepository>()));
  gh.factory<_i21.GetInfoMeeting>(
      () => _i21.GetInfoMeeting(gh<_i8.MeetingRepository>()));
  gh.factory<_i22.GetPresignedUrl>(
      () => _i22.GetPresignedUrl(gh<_i14.UserRepository>()));
  gh.factory<_i23.GetProfile>(() => _i23.GetProfile(gh<_i14.UserRepository>()));
  gh.factory<_i24.JoinMeeting>(
      () => _i24.JoinMeeting(gh<_i8.MeetingRepository>()));
  gh.factory<_i25.LeaveMeeting>(
      () => _i25.LeaveMeeting(gh<_i8.MeetingRepository>()));
  gh.factory<_i26.LogOut>(() => _i26.LogOut(gh<_i17.AuthRepository>()));
  gh.factory<_i27.LoginWithSocial>(
      () => _i27.LoginWithSocial(gh<_i17.AuthRepository>()));
  gh.factory<_i28.MeetingBloc>(() => _i28.MeetingBloc(
        gh<_i20.CreateMeeting>(),
        gh<_i24.JoinMeeting>(),
        gh<_i12.UpdateMeeting>(),
        gh<_i21.GetInfoMeeting>(),
        gh<_i25.LeaveMeeting>(),
      ));
  gh.factory<_i29.UpdateProfile>(
      () => _i29.UpdateProfile(gh<_i14.UserRepository>()));
  gh.factory<_i30.UserBloc>(() => _i30.UserBloc(
        gh<_i29.UpdateProfile>(),
        gh<_i22.GetPresignedUrl>(),
        gh<_i23.GetProfile>(),
      ));
  gh.factory<_i31.AuthBloc>(() => _i31.AuthBloc(
        gh<_i19.CheckAuth>(),
        gh<_i27.LoginWithSocial>(),
        gh<_i26.LogOut>(),
        gh<_i11.SocketConnection>(),
      ));
  return getIt;
}
