import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extensions.dart';

class PaginationListView extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final Widget childShimmer;
  final Axis scrollDirection;
  final bool isLoadMore;
  final Function? callBackLoadMore;
  final Function(Function)? callBackRefresh;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final Function(int, int)? onReorder;
  final Widget? extentItem;
  final ScrollController? controller;
  final int? Function(Key)? findChildIndexCallback;
  final bool preventAttachController;
  final int crossAxisCount;
  final bool isDesktopLandscape;
  final bool shrinkWrap;
  final SliverGridDelegate? gridDelegate;

  const PaginationListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.childShimmer,
    this.callBackLoadMore,
    this.callBackRefresh,
    this.padding = EdgeInsets.zero,
    this.scrollDirection = Axis.vertical,
    this.isLoadMore = false,
    this.onReorder,
    this.extentItem,
    this.physics,
    this.controller,
    this.findChildIndexCallback,
    this.preventAttachController = false,
    this.crossAxisCount = 2,
    this.isDesktopLandscape = false,
    this.shrinkWrap = false,
    this.gridDelegate,
  });

  @override
  State<StatefulWidget> createState() => _PaginationListViewState();
}

class _PaginationListViewState extends State<PaginationListView> {
  late ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _scrollController = widget.controller!;
    }
    _scrollController.addListener(
      () {
        if (widget.isLoadMore) return;

        if (_refreshController.isRefresh) return;

        if (_scrollController.position.maxScrollExtent > 0 &&
            _scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 2.sp) {
          widget.callBackLoadMore?.call();
        }
      },
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    if (widget.controller == null) {
      _scrollController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizerUtil.isDesktop
        ? RawScrollbar(
            controller: _scrollController,
            thumbVisibility: false,
            radius: Radius.circular(30.sp),
            thickness: 3.sp,
            child: _buildSmartListView,
          )
        : _buildSmartListView;
  }

  Widget get _buildSmartListView => SmartRefresher(
        physics: widget.physics ?? const BouncingScrollPhysics(),
        controller: _refreshController,
        enablePullDown: widget.callBackRefresh != null,
        header: WaterDropHeader(
          refresh: const CupertinoActivityIndicator(),
          complete: const SizedBox(),
          completeDuration: 100.milliseconds,
        ),
        onRefresh: () async {
          if (widget.callBackRefresh != null) {
            HapticFeedback.lightImpact();
            widget.callBackRefresh?.call(
              () {
                _refreshController.refreshCompleted();
              },
            );
          } else {
            await Future.delayed(500.milliseconds);
            _refreshController.refreshCompleted();
          }
        },
        onLoading: () {},
        child: _buildListView,
      );

  Widget get _buildListView {
    return widget.isDesktopLandscape
        ? GridView.builder(
            padding: widget.padding,
            controller: _scrollController,
            scrollDirection: widget.scrollDirection,
            physics: widget.physics ?? const BouncingScrollPhysics(),
            itemCount: widget.itemCount +
                (widget.isLoadMore ? widget.crossAxisCount : 0),
            gridDelegate: widget.gridDelegate ??
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.crossAxisCount,
                  mainAxisSpacing: 8.sp,
                  crossAxisSpacing: 8.sp,
                  childAspectRatio: 4.5,
                ),
            itemBuilder: (context, index) => widget.isLoadMore &&
                    (index == widget.itemCount || index == widget.itemCount + 1)
                ? widget.childShimmer
                : widget.itemBuilder(context, index),
          )
        : widget.onReorder != null
            ? SingleChildScrollView(
                controller: _scrollController,
                physics: widget.physics ?? const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      proxyDecorator: (child, index, animation) {
                        return AnimatedBuilder(
                          animation: animation,
                          builder: (context, child) {
                            final double animValue =
                                Curves.easeInOut.transform(animation.value);
                            final double scale =
                                lerpDouble(1, 1.02, animValue)!;
                            return Transform.scale(
                              scale: scale,
                              child: child,
                            );
                          },
                          child: child,
                        );
                      },
                      itemBuilder: (context, index) =>
                          widget.isLoadMore && index == widget.itemCount
                              ? widget.childShimmer
                              : widget.itemBuilder(context, index),
                      scrollController: _mScrollController,
                      padding: widget.padding,
                      scrollDirection: widget.scrollDirection,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.itemCount + (widget.isLoadMore ? 1 : 0),
                      onReorder: widget.onReorder!,
                    ),
                    widget.extentItem ?? const SizedBox(),
                  ],
                ),
              )
            : widget.scrollDirection == Axis.horizontal
                ? ListView.builder(
                    shrinkWrap: widget.shrinkWrap,
                    controller: _mScrollController,
                    padding: widget.padding,
                    scrollDirection: widget.scrollDirection,
                    physics: widget.physics ?? const BouncingScrollPhysics(),
                    itemCount: widget.itemCount + (widget.isLoadMore ? 1 : 0),
                    itemBuilder: (context, index) =>
                        widget.isLoadMore && index == widget.itemCount
                            ? widget.childShimmer
                            : widget.itemBuilder(context, index),
                    findChildIndexCallback: widget.findChildIndexCallback,
                  )
                : _sliver;
  }

  Widget get _sliver => CustomScrollView(
        semanticChildCount: widget.itemCount + (widget.isLoadMore ? 1 : 0),
        physics: widget.physics ?? const BouncingScrollPhysics(),
        controller: _mScrollController,
        shrinkWrap: widget.shrinkWrap,
        slivers: [
          SliverPadding(
            padding: widget.padding ?? EdgeInsets.zero,
            sliver: SuperSliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (widget.isLoadMore && index == widget.itemCount) {
                    return widget.childShimmer;
                  } else {
                    return widget.itemBuilder(context, index);
                  }
                },
                findChildIndexCallback: widget.findChildIndexCallback,
                childCount: widget.itemCount + (widget.isLoadMore ? 1 : 0),
              ),
            ),
          ),
        ],
      );

  ScrollController? get _mScrollController =>
      widget.preventAttachController ? null : _scrollController;
}
