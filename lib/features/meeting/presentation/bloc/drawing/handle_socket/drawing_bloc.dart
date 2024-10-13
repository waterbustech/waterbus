import 'package:flutter/foundation.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/models/draw_model.dart';
import 'package:waterbus_sdk/types/models/draw_socket_event.dart';

import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/presentation/xmodels/drawing_model.dart';

// ignore: unused_import

// import 'package:waterbus_sdk/flutter_waterbus_sdk.dart'; // code not pushed yet

part 'drawing_event.dart';
part 'drawing_state.dart';

@injectable
class DrawingBloc extends Bloc<DrawingEvent, DrawingState> {
  final WaterbusSdk _waterbusSdk = WaterbusSdk.instance;

  DrawingBloc() : super(DrawingInitialState()) {
    on<DrawingEvent>((event, emit) {
      if (event is OnDrawingInitEvent) {
        _waterbusSdk.onDrawSocketChanged = _listenDrawSocket;

        _waterbusSdk.getWhiteBoard(event.meetingId);
      }
      if (event is OnDrawingChangedEvent) {
        final newState = addStrokeLocal([event.drawingModel]);
        final updateState = UpdateDrawingState(
            localProps: newState, remoteProps: state.remoteProps);
        emit(updateState);

        debugPrint("updateState localProps ${updateState.localProps}");
        debugPrint("updateState remoteProps${updateState.remoteProps}");
        debugPrint("State localProps ${state.localProps}");
        debugPrint("State remoteProps${state.remoteProps}");
        _waterbusSdk.updateWhiteBoard(
          AppBloc.meetingBloc.state.meeting!.id,
          event.drawingModel,
          event.action.name,
        );
      }
      if (event is OnDrawingDeletedEvent) {
        emit(UpdateDrawingState());
      }
      if (event is OnRemoteDrawingChangedEvent) {
        final newState = addStrokeRemote(event.points);

        final updateState = UpdateDrawingState(
            remoteProps: newState, localProps: state.localProps);

        emit(updateState);
      }

      if (event is OnRemoteDrawingDeletedEvent) {
        final updateState = UpdateDrawingState(remoteProps: []);

        emit(updateState);
      }
    });
  }
  // MARK: state
  // MARK: Private methods
  void _listenDrawSocket(DrawSocketEvent rawSocketEvent) {
    if (rawSocketEvent.event == DrawSocketEnum.start) {
      final List<DrawModel> message = rawSocketEvent.draw;
      AppBloc.drawingBloc.add(OnRemoteDrawingInitEvent(points: message));
    } else if (rawSocketEvent.event == DrawSocketEnum.update) {
      final List<DrawModel> message = rawSocketEvent.draw;
      debugPrint("DrawSocketEnum.update");
      AppBloc.drawingBloc.add(OnRemoteDrawingChangedEvent(points: message));
    } else {
      AppBloc.drawingBloc.add(OnRemoteDrawingDeletedEvent());
    }
  }

  addStrokeLocal(List<DrawModel> stroke) {
    return List<DrawModel>.from(state.localProps)..addAll(stroke);
  }

  addStrokeRemote(List<DrawModel> stroke) {
    return List<DrawModel>.from(state.remoteProps)..addAll(stroke);
  }
}
