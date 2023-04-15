// Flutter imports:
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/features/chats/models/chat_model.dart';
import 'package:waterbus/features/chats/widgets/chat_card.dart';
import 'package:waterbus/features/chats/widgets/chats_header.dart';
import 'package:waterbus/features/home/widgets/enter_code_box.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ChatsHeader(),
            SizedBox(height: 10.sp),
            EnterCodeBox(
              hintTextContent: 'Search',
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
    );
  }
}
