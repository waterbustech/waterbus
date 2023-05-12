// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/cached_network_image/cached_network_image.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/widgets/app_drawer.dart';
import 'package:waterbus/features/chats/widgets/chat_card.dart';
import 'package:waterbus/features/chats/xmodels/chat_model.dart';
import 'package:waterbus/features/home/widgets/enter_code_box.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppDrawer(
        sliderDrawerKey: _sliderDrawerKey,
        appBar: appBarTitleBack(
          context,
          'Chats',
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: GestureWrapper(
            onTap: () {
              _sliderDrawerKey.currentState?.toggle();
            },
            child: Container(
              alignment: Alignment.centerRight,
              child: CustomNetworkImage(
                height: 24.sp,
                urlToImage:
                    'https://avatars.githubusercontent.com/u/60530946?v=4',
              ),
            ),
          ),
          actions: [
            Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(
                vertical: 12.sp,
                horizontal: 16.sp,
              ),
              alignment: Alignment.center,
              child: Text(
                "Edit",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              SizedBox(height: 10.sp),
              EnterCodeBox(
                hintTextContent: 'Search your chat',
                onTap: () {},
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: listFakeChat.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.sp,
                    vertical: 20.sp,
                  ),
                  itemBuilder: (context, index) {
                    return ChatCard(
                      chatModel: listFakeChat[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
