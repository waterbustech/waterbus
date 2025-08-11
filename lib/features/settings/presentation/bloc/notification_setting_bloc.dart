import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus/features/settings/data/datasource/notification_setting_local_data_source.dart';
import 'package:waterbus/features/settings/domain/entities/notification_settings.dart';

part 'notification_setting_event.dart';
part 'notification_setting_state.dart';

@injectable
class NotificationSettingBloc
    extends Bloc<NotificationSettingEvent, NotificationSettingState> {
  NotificationSettings settings = NotificationSettings();

  final NotificationSettingLocalDataSource _notificationSettingLocal;
  NotificationSettingBloc(this._notificationSettingLocal)
      : super(
          NotificationSettingInitial(NotificationSettings()),
        ) {
    on<NotificationSettingEvent>((event, emit) {
      if (event is NotificationSettingGet) {
        emit(_updating);
        settings = _notificationSettingLocal.getNotificationSettings;
        emit(_successed);
      }

      if (event is NotificationSettingUpdate) {
        emit(_updating);
        settings = event.settings;
        _notificationSettingLocal.updateNotificationSettings(settings);
        emit(_successed);
      }
    });
  }

  NotificationSettingUpdating get _updating =>
      NotificationSettingUpdating(settings);
  NotificationSettingSuccessed get _successed =>
      NotificationSettingSuccessed(settings);
}
