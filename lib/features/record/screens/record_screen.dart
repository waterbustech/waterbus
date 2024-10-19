import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/types/models/record_model.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/record/bloc/record/record_bloc.dart';
import 'package:waterbus/features/record/widgets/record_card.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  @override
  void initState() {
    super.initState();
    AppBloc.recordBloc.add(OnRecordsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SizerUtil.isDesktop
          ? Theme.of(context).colorScheme.surfaceContainerLow
          : null,
      appBar: appBarTitleBack(
        context,
        title: Strings.storage.i18n,
        leadingWidth: 60.sp,
        isVisibleBackButton: !SizerUtil.isDesktop,
      ),
      body: Column(
        children: [
          divider,
          SizedBox(height: 8.sp),
          Expanded(
            child: BlocBuilder<RecordBloc, RecordState>(
              builder: (context, state) {
                final List<RecordModel> records =
                    state is GetRecordDone ? state.records : [];

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: records.length,
                  itemBuilder: (context, index) => RecordCard(
                    record: records[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
