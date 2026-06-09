import 'package:flutter/material.dart';

import 'error_widget.dart';
import 'loading_widget.dart';
import 'pagination_controller.dart';
import 'pagination_status.dart';

class PaginationGridView<T> extends StatefulWidget {
  const PaginationGridView({
    super.key,
    required this.controller,
    required this.gridDelegate,
    required this.itemBuilder,
  });

  final PaginationController<T> controller;

  final SliverGridDelegate gridDelegate;

  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  @override
  State<PaginationGridView<T>> createState() => _PaginationGridViewState<T>();
}

class _PaginationGridViewState<T> extends State<PaginationGridView<T>> {
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
          return const PaginationLoadingWidget();
        }

        if (state.status == PaginationStatus.error && state.items.isEmpty) {
          return PaginationErrorWidget(
            message: state.errorMessage ?? 'Something went wrong',
            onRetry: widget.controller.refresh,
          );
        }

        if (state.status == PaginationStatus.empty) {
          return const Center(child: Text('No Data Found'));
        }

        return GridView.builder(
          controller: _scrollController,
          gridDelegate: widget.gridDelegate,
          itemCount: state.items.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < state.items.length) {
              return widget.itemBuilder(context, state.items[index], index);
            }

            return const PaginationLoadingWidget(padding: EdgeInsets.all(8));
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
