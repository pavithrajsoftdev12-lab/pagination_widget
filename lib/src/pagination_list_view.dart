import 'package:flutter/material.dart';

import 'error_widget.dart';
import 'loading_widget.dart';
import 'pagination_controller.dart';
import 'pagination_status.dart';

class PaginationListView<T> extends StatefulWidget {
  const PaginationListView({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.loadingWidget,
    this.errorWidgetBuilder,
    this.emptyWidget,
    this.loadMoreWidget,
  });

  final PaginationController<T> controller;

  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Widget shown during initial loading.
  final Widget? loadingWidget;

  /// Builder for the error state, providing the error message and a retry callback.
  final Widget Function(
    BuildContext context,
    String error,
    VoidCallback onRetry,
  )?
  errorWidgetBuilder;

  /// Widget shown when there are no items to display.
  final Widget? emptyWidget;

  /// Widget shown at the bottom of the list while loading more items.
  final Widget? loadMoreWidget;

  @override
  State<PaginationListView<T>> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<T> extends State<PaginationListView<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    widget.controller.refresh();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.controller.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (_, _) {
        final state = widget.controller.state;

        if (state.status == PaginationStatus.loading && state.items.isEmpty) {
          return widget.loadingWidget ?? const PaginationLoadingWidget();
        }

        if (state.status == PaginationStatus.error && state.items.isEmpty) {
          return widget.errorWidgetBuilder?.call(
                context,
                state.errorMessage ?? 'Something went wrong',
                widget.controller.refresh,
              ) ??
              PaginationErrorWidget(
                message: state.errorMessage ?? 'Something went wrong',
                onRetry: widget.controller.refresh,
              );
        }

        if (state.status == PaginationStatus.empty) {
          return widget.emptyWidget ??
              const Center(child: Text('No Data Found'));
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: state.items.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < state.items.length) {
              return widget.itemBuilder(context, state.items[index], index);
            }

            return widget.loadMoreWidget ??
                const PaginationLoadingWidget(padding: EdgeInsets.all(8));
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
