import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:waterbus/core/app/languages/localization.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/common/widgets/app_bar_title_back.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/common/widgets/textfield/shadcn_text_field.dart';
import 'package:waterbus/features/room/presentation/bloc/room/room_bloc.dart';

enum RoomType { videoConferencing, liveStreaming }

enum StreamingProtocol { sfu, hls, moq }

class MeetingFormScreen extends StatefulWidget {
  final bool isChatScreen;
  final bool isEdit;
  const MeetingFormScreen({
    super.key,
    this.isChatScreen = false,
    this.isEdit = false,
  });

  @override
  State<MeetingFormScreen> createState() => _MeetingFormScreenState();
}

class _MeetingFormScreenState extends State<MeetingFormScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _maxParticipantsController =
      TextEditingController();

  late final bool _isEditing = widget.isEdit;
  RoomType _selectedRoomType = RoomType.videoConferencing;
  StreamingProtocol _selectedProtocol = StreamingProtocol.sfu;

  @override
  void initState() {
    super.initState();

    if (AppBloc.userBloc.user?.fullName != null) {
      _roomNameController.text = _isEditing
          ? AppBloc.chatBloc.conversationCurrent?.title ?? ""
          : '${Strings.meetingWith.i18n} ${AppBloc.userBloc.user!.fullName}';
    }
  }

  void _handleFormSubmission() {
    if (!(_formStateKey.currentState?.validate() ?? false)) return;

    displayLoadingLayer();

    final roomName = _roomNameController.text.trim();
    final password = _passwordController.text;
    // final maxParticipants = int.tryParse(_maxParticipantsController.text);

    if (widget.isChatScreen) {
      if (_isEditing) {
        AppBloc.chatBloc.add(
          ChatUpdated(
            title: roomName,
            password: password,
          ),
        );
      } else {
        AppBloc.chatBloc.add(
          ChatCreated(
            title: roomName,
            password: password,
          ),
        );
      }
    } else {
      if (_isEditing) {
        AppBloc.roomBloc.add(
          RoomUpdated(
            roomName: roomName,
            password: password,
          ),
        );
      } else {
        AppBloc.roomBloc.add(
          RoomCreated(
            roomName: roomName,
            password: password,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter): _handleFormSubmission,
      },
      child: Scaffold(
        appBar: appBarTitleBack(
          context,
          titleWidget: Text(
            _isEditing ? Strings.editMeeting.i18n : Strings.createMeeting.i18n,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          actions: [
            IconButton(
              onPressed: _handleFormSubmission,
              icon: Icon(
                PhosphorIcons.check(),
                size: 20.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        body: Form(
          key: _formStateKey,
          child: Column(
            children: [
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.sp),
                      ShadcnTextField(
                        controller: _roomNameController,
                        label: Strings.roomTitle.i18n,
                        hint: Strings.nameOrTitleHint.i18n,
                        validator: (val) {
                          if (val?.isEmpty ?? true) {
                            return Strings.roomTitleEmpty.i18n;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12.sp),
                      ShadcnTextField(
                        controller: _passwordController,
                        label: Strings.passwordOptional.i18n,
                        hint: Strings.passwordHint.i18n,
                        obscureText: true,
                      ),
                      SizedBox(height: 12.sp),
                      _buildDropdown<RoomType>(
                        label: Strings.roomType.i18n,
                        value: _selectedRoomType,
                        items: RoomType.values,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedRoomType = value;
                            });
                          }
                        },
                        itemBuilder: (type) {
                          return Text(
                            type == RoomType.videoConferencing
                                ? Strings.videoConferencing.i18n
                                : Strings.liveStreaming.i18n,
                          );
                        },
                      ),
                      if (_selectedRoomType == RoomType.liveStreaming) ...[
                        SizedBox(height: 12.sp),
                        _buildDropdown<StreamingProtocol>(
                          label: Strings.streamingProtocol.i18n,
                          value: _selectedProtocol,
                          items: StreamingProtocol.values,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedProtocol = value;
                              });
                            }
                          },
                          itemBuilder: (protocol) {
                            return Text(protocol.name.toUpperCase());
                          },
                        ),
                      ],
                      SizedBox(height: 12.sp),
                      ShadcnTextField(
                        controller: _maxParticipantsController,
                        label: Strings.maxParticipants.i18n,
                        hint: Strings.maxHint.i18n,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      SizedBox(height: 24.sp),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required Widget Function(T) itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        SizedBox(height: 8.sp),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 0.sp),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: .1),
            borderRadius: BorderRadius.zero,
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(
                    alpha: 0.3,
                  ),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              focusColor: Colors.transparent,
              value: value,
              isExpanded: true,
              icon: Icon(
                PhosphorIcons.caretDown(),
                size: 14.sp,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onChanged: onChanged,
              dropdownColor: Theme.of(context).colorScheme.surface,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              items: items.map<DropdownMenuItem<T>>((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: itemBuilder(item),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
