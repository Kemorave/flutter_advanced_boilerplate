import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CustomPaginationController<T> {
  CustomPaginationController({
    required Future<List<T>> Function(int page) fetchPage,
  }) : controller = PagingController(
         getNextPageKey: (state) =>
             state.lastPageIsEmpty ? null : state.nextIntPageKey,
         fetchPage: fetchPage,
       );
  final PagingController<int, T> controller;

  /// Dispose the [PagingController]
  void dispose() => controller.dispose();
}

class CustomPagedListView<PageKeyType, ItemType> extends StatelessWidget {
  const CustomPagedListView({
    required this.controller,
    required this.itemBuilder,
    super.key,
    this.firstPageErrorIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.firstPageProgressIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.noItemsFoundIndicatorBuilder,
    this.noMoreItemsIndicatorBuilder,
    this.scrollController,
    this.reverse,
    this.shrinkWrap,
    this.itemExtent,
    this.physics,
    this.padding,
  });

  final PagingController<PageKeyType, ItemType> controller;
  final Widget Function(BuildContext context, ItemType item, int index)
  itemBuilder;
  final Widget Function(BuildContext)? firstPageErrorIndicatorBuilder;
  final Widget Function(BuildContext)? newPageErrorIndicatorBuilder;
  final Widget Function(BuildContext)? firstPageProgressIndicatorBuilder;
  final Widget Function(BuildContext)? newPageProgressIndicatorBuilder;
  final Widget Function(BuildContext)? noItemsFoundIndicatorBuilder;
  final Widget Function(BuildContext)? noMoreItemsIndicatorBuilder;
  final ScrollController? scrollController;
  final bool? reverse;
  final bool? shrinkWrap;
  final double? itemExtent;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;

  
  @override
  Widget build(BuildContext context) {
    return PagingListener(
      controller: controller,
      builder: (context, state, fetchNextPage) {
        return PagedListView<PageKeyType, ItemType>(
          state: state,
          scrollController: scrollController,
          reverse: reverse ?? false,
          shrinkWrap: shrinkWrap ?? false,
          fetchNextPage: fetchNextPage,
          itemExtent: itemExtent,
          padding: padding,
          physics: physics,
          builderDelegate: PagedChildBuilderDelegate<ItemType>(
            itemBuilder: itemBuilder,
            firstPageErrorIndicatorBuilder: firstPageErrorIndicatorBuilder,
            newPageErrorIndicatorBuilder: newPageErrorIndicatorBuilder,
            firstPageProgressIndicatorBuilder:
                firstPageProgressIndicatorBuilder,
            newPageProgressIndicatorBuilder: newPageProgressIndicatorBuilder,
            noItemsFoundIndicatorBuilder: noItemsFoundIndicatorBuilder,
            noMoreItemsIndicatorBuilder: noMoreItemsIndicatorBuilder,
          ),
        );
      },
    );
  }
}
