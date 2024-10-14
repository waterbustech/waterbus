import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/models/draw_model.dart';
import 'package:waterbus_sdk/types/models/draw_socket_event.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';

part 'drawing_event.dart';
part 'drawing_state.dart';

@injectable
class DrawingBloc extends Bloc<DrawingEvent, DrawingState> {
  final WaterbusSdk _waterbusSdk = WaterbusSdk.instance;

  DrawingBloc() : super(DrawingInitialState()) {
    on<DrawingEvent>((event, emit) {
      if (event is OnDrawingInitEvent) {
        _handleDrawingInit(event, emit);
      } else if (event is OnDrawingChangedEvent) {
        _handleDrawingChanged(event, emit);
      } else if (event is OnRemoteDrawingChangedEvent) {
        _handleRemoteDrawingChanged(event, emit);
      } else if (event is OnDrawingDeletedEvent) {
        _handleDrawingDeleted(emit);
      } else if (event is OnRemoteDrawingDeletedEvent) {
        _handleRemoteDrawingDeleted(emit);
      }
    });
  }

  // MARK: Private methods
  void _handleDrawingInit(
    OnDrawingInitEvent event,
    Emitter<DrawingState> emit,
  ) {
    _waterbusSdk.onDrawSocketChanged = _listenDrawSocket;
    _waterbusSdk.getWhiteBoard(event.meetingId);
  }

  void _handleDrawingChanged(
    OnDrawingChangedEvent event,
    Emitter<DrawingState> emit,
  ) {
    if (event.action == UpdateDrawEnum.remove) {
      _removeLastStroke(emit);
    } else if (event.action == UpdateDrawEnum.add) {
      _addStrokeLocal(event.drawingModel, emit);
    }
  }

  void _removeLastStroke(Emitter<DrawingState> emit) {
    final List<DrawModel> newList = List.from(state.localProps)..removeLast();
    final updateState = UpdateDrawingState(
      localProps: newList,
      remoteProps: state.remoteProps,
    );
    _waterbusSdk.updateWhiteBoard(
      AppBloc.meetingBloc.state.meeting!.id,
      state.localProps.last,
      UpdateDrawEnum.remove.name,
    );
    emit(updateState);
  }

  void _addStrokeLocal(DrawModel drawingModel, Emitter<DrawingState> emit) {
    final newState = addStrokeLocal([drawingModel]);
    final updateState = UpdateDrawingState(
      localProps: newState,
      remoteProps: state.remoteProps,
    );
    _waterbusSdk.updateWhiteBoard(
      AppBloc.meetingBloc.state.meeting!.id,
      drawingModel,
      UpdateDrawEnum.add.name,
    );
    emit(updateState);
  }

  void _handleRemoteDrawingChanged(
    OnRemoteDrawingChangedEvent event,
    Emitter<DrawingState> emit,
  ) {
    debugPrint(event.action.toString());

    if (event.action == UpdateDrawEnum.remove) {
      _removeRemoteStrokes(event.points, emit);
    } else if (event.action == UpdateDrawEnum.add) {
      _addStrokeRemote(event.points, emit);
    }
  }

  void _removeRemoteStrokes(
    List<DrawModel> points,
    Emitter<DrawingState> emit,
  ) {
    final List<DrawModel> newList = List.from(state.remoteProps);
    final itemToRemove = points.map((e) => e.createdAt).toSet();
    final updatedList = newList
        .where((element) => !itemToRemove.contains(element.createdAt))
        .toList();
    for (final a in updatedList) {
      debugPrint(a.createdAt.toIso8601String());
    }
    final updateState = UpdateDrawingState(
      localProps: state.localProps,
      remoteProps: updatedList,
    );
    emit(updateState);
  }

  void _addStrokeRemote(List<DrawModel> points, Emitter<DrawingState> emit) {
    final newState = addStrokeRemote(points);
    final updateState = UpdateDrawingState(
      remoteProps: newState,
      localProps: state.localProps,
    );
    emit(updateState);
  }

  void _handleDrawingDeleted(Emitter<DrawingState> emit) {
    _waterbusSdk.cleanWhiteBoard();
    emit(const UpdateDrawingState());
  }

  void _handleRemoteDrawingDeleted(Emitter<DrawingState> emit) {
    emit(const UpdateDrawingState());
  }

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

  List<DrawModel> addStrokeLocal(List<DrawModel> stroke) {
    return List<DrawModel>.from(state.localProps)..addAll(stroke);
  }

  List<DrawModel> addStrokeRemote(List<DrawModel> stroke) {
    return List<DrawModel>.from(state.remoteProps)..addAll(stroke);
  }
}
