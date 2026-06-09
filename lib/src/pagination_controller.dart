import 'package:flutter/material.dart';

import 'pagination_state.dart';
import 'pagination_status.dart';

typedef PageFetcher<T> = Future<List<T>> Function(int page);

class PaginationController<T> extends ChangeNotifier {
  PaginationController({required this.fetchPage, this.pageSize = 20});

  final PageFetcher<T> fetchPage;
  final int pageSize;

  PaginationState<T> _state = const PaginationState();

  PaginationState<T> get state => _state;

  int _currentPage = 1;

  Future<void> refresh() async {
    _currentPage = 1;

    _state = const PaginationState(status: PaginationStatus.loading);

    notifyListeners();

    await _loadData(reset: true);
  }

  Future<void> loadMore() async {
    if (!_state.hasMore) return;

    if (_state.status == PaginationStatus.loadingMore) {
      return;
    }

    await _loadData();
  }

  Future<void> _loadData({bool reset = false}) async {
    try {
      _state = _state.copyWith(
        status: reset ? PaginationStatus.loading : PaginationStatus.loadingMore,
      );

      notifyListeners();

      final result = await fetchPage(_currentPage);

      final allItems = reset ? result : [..._state.items, ...result];

      _state = _state.copyWith(
        items: allItems,
        status: allItems.isEmpty
            ? PaginationStatus.empty
            : PaginationStatus.loaded,
        hasMore: result.length >= pageSize,
        errorMessage: null,
      );

      if (result.length >= pageSize) {
        _currentPage++;
      }
    } catch (e) {
      _state = _state.copyWith(
        status: PaginationStatus.error,
        errorMessage: e.toString(),
      );
    }

    notifyListeners();
  }
}
