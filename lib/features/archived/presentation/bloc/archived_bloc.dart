import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/models/chat_status_enum.dart';

part 'archived_event.dart';
part 'archived_state.dart';

@injectable
class ArchivedBloc extends Bloc<ArchivedEvent, ArchivedState> {
  final List<Meeting> _archivedConversations = [];
  bool _isOverArchived = false;
  final WaterbusSdk _waterbusSdk = WaterbusSdk.instance;

  ArchivedBloc() : super(ArchivedInitial()) {
    on<ArchivedEvent>((event, emit) async {
      if (event is OnArchivedEvent) {
        await _getArchivedConversationList();
        emit(_getDoneArchived);
      }

      if (event is GetMoreArchivedEvent) {
        if (state is GettingArchivedState || _isOverArchived) return;

        emit(_gettingArchived);
        await _getArchivedConversationList();
        emit(_getDoneArchived);
      }

      if (event is RefreshArchivedEvent) {
        _archivedConversations.clear();
        await _getArchivedConversationList();
        emit(_getDoneArchived);
        event.handleFinish.call();
      }

      if (event is InsertArchivedEvent) {
        if (_archivedConversations.isEmpty && !_isOverArchived) return;

        final int index = _archivedConversations
            .indexWhere((conversation) => conversation.id == event.meeting.id);

        if (index == -1) {
          _archivedConversations.insert(0, event.meeting);
        }

        emit(_getDoneArchived);
      }
    });
  }

  GettingArchivedState get _gettingArchived => GettingArchivedState(
        archivedConversations: _archivedConversations,
      );
  GetDoneArchivedState get _getDoneArchived => GetDoneArchivedState(
        archivedConversations: _archivedConversations,
      );

  Future<void> _getArchivedConversationList() async {
    final List<Meeting> result = await _waterbusSdk.getConversations(
      skip: _archivedConversations.length,
      status: ChatStatusEnum.archived.status,
    );

    _archivedConversations.addAll(result);

    if (result.length < 10) {
      _isOverArchived = true;
    }
  }
}
