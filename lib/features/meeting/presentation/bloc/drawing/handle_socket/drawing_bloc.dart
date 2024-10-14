import 'package:flutter/foundation.dart';

import 'package:diffutil_dart/diffutil.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/enums/draw_types.dart';
import 'package:waterbus_sdk/types/models/draw_model.dart';
import 'package:waterbus_sdk/types/models/draw_socket_event.dart';

import 'package:waterbus/features/app/bloc/bloc.dart';

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
        if (event.action == UpdateDrawEnum.remove) {
          final List<DrawModel> newList = List.from(state.localProps)
            ..removeLast();
          final updateState = UpdateDrawingState(
            localProps: newList,
            remoteProps: state.remoteProps,
          );
          emit(updateState);
          _waterbusSdk.updateWhiteBoard(
            AppBloc.meetingBloc.state.meeting!.id,
            event.drawingModel,
            event.action.name,
          );
        } else if (event.action == UpdateDrawEnum.add) {
          final newState = addStrokeLocal([event.drawingModel]);
          final updateState = UpdateDrawingState(
            localProps: newState,
            remoteProps: state.remoteProps,
          );
          emit(updateState);
          _waterbusSdk.updateWhiteBoard(
            AppBloc.meetingBloc.state.meeting!.id,
            event.drawingModel,
            event.action.name,
          );
        } else {
          // debugPrint("wrong Update Enum");
        }
      }
      if (event is OnRemoteDrawingChangedEvent) {
        if (event.action == UpdateDrawEnum.remove) {
          final List<DrawModel> newList = List.from(state.remoteProps)
            ..removeLast();
          final updateState = UpdateDrawingState(
            localProps: state.localProps,
            remoteProps: newList,
          );
          emit(updateState);
        } else if (event.action == UpdateDrawEnum.remove) {
          final newState = addStrokeRemote(event.points);

          final updateState = UpdateDrawingState(
            remoteProps: newState,
            localProps: state.localProps,
          );

          emit(updateState);
        }
      }
      if (event is OnDrawingDeletedEvent) {
        emit(const UpdateDrawingState());
      }
      if (event is OnRemoteDrawingDeletedEvent) {
        emit(const UpdateDrawingState());
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
      AppBloc.drawingBloc.add(
        OnRemoteDrawingChangedEvent(
          points: message,
          action: rawSocketEvent.action!,
        ),
      );
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
