import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/types/models/record_model.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/helpers/date_time_helper.dart';
import 'package:waterbus/core/utils/cached_network_image/cached_network_image.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/record/bloc/record/record_bloc.dart';

class RecordCard extends StatelessWidget {
  final RecordModel record;
  const RecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
      child: Row(
        children: [
          CustomNetworkImage(
            height: 55.sp,
            width: 80.sp,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4.sp),
            urlToImage: record.thumbnail,
          ),
          SizedBox(width: 12.sp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.meeting.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 4.sp),
                Text(
                  '${Strings.duration.i18n}: ${DateTimeHelper().formatDuration(record.duration)}',
                  style: TextStyle(fontSize: 10.sp),
                ),
                SizedBox(height: 4.sp),
                Text(
                  '${Strings.createdAt.i18n}: ${DateFormat.yMMMMd().format(record.createdAt)}',
                  style: TextStyle(fontSize: 10.sp),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.sp),
          Row(
            children: [
              IconButton(
                onPressed: () => {},
                icon: Icon(PhosphorIcons.playPause()),
              ),
              IconButton(
                onPressed: () {
                  AppBloc.recordBloc.add(SaveRecordFileEvent(record: record));
                },
                icon: Icon(PhosphorIcons.downloadSimple()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
