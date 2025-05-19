import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:toastification/toastification.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/types/extensions/failure_x.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/conversation/bloc/message_bloc.dart';
import 'package:waterbus/features/conversation/xmodels/string_extension.dart';

part 'archived_event.dart';
part 'archived_state.dart';

@injectable
class ArchivedBloc extends Bloc<ArchivedEvent, ArchivedState> {
  final List<Room> _archivedConversations = [];
  bool _isOverArchived = false;
  final WaterbusSdk _waterbusSdk = WaterbusSdk.instance;

  ArchivedBloc() : super(ArchivedInitial()) {
    on<ArchivedEvent>((event, emit) async {
      if (event is ArchivedStarted) {
        await _getArchivedConversationList();
        emit(_archivedDone);
      }

      if (event is ArchivedDataFetched) {
        if (state is ArchivedInProgress || _isOverArchived) return;

        emit(_archivedInProgress);
        await _getArchivedConversationList();
        emit(_archivedDone);
      }

      if (event is ArchivedRefreshed) {
        _archivedConversations.clear();
        AppBloc.messageBloc.add(
          MessageCleaned(
            meetingIds: _archivedConversations
                .map((conversation) => conversation.id)
                .toList(),
          ),
        );
        await _getArchivedConversationList();
        emit(_archivedDone);
        event.handleFinish.call();
      }

      if (event is ArchivedInserted) {
        if (_archivedConversations.isEmpty && !_isOverArchived) return;

        final int index = _archivedConversations
            .indexWhere((conversation) => conversation.id == event.room.id);

        if (index == -1) {
          _archivedConversations.insert(0, event.room);
        }

        emit(_archivedDone);
      }
    });
  }

  ArchivedInProgress get _archivedInProgress => ArchivedInProgress(
        archivedConversations: _archivedConversations,
      );
  ArchivedDone get _archivedDone => ArchivedDone(
        archivedConversations: _archivedConversations,
      );

  Future<void> _getArchivedConversationList() async {
    final Result<List<Room>> response =
        await _waterbusSdk.getArchivedConversations(
      skip: _archivedConversations.length,
    );

    if (response.isSuccess) {
      final List<Room> result = response.value ?? [];

      _archivedConversations.addAll(result);

      if (result.length < 10) {
        _isOverArchived = true;
      }
    } else {
      response.error.messageException.showToast(ToastificationType.error);
    }
  }
}
