# Pagination Widget

A lightweight Flutter pagination package built without any third-party dependencies.

Features:

✅ Infinite Scroll Pagination  
✅ ListView Pagination  
✅ GridView Pagination  
✅ Loading State  
✅ Error State with Retry  
✅ Empty State  
✅ Pull To Refresh Support  
✅ Generic Type Support  
✅ No External Packages

---

## Installation

Add dependency in your `pubspec.yaml`.

```yaml
dependencies:
  pagination_widget:
    path: ../pagination_widget
```

For published package:

```yaml
dependencies:
  pagination_widget: ^1.0.1
```

---

## Import

```dart
import 'package:pagination_widget/pagination_widget.dart';
```

---

## Create Controller

```dart
late PaginationController<String> controller;

@override
void initState() {
  super.initState();

  controller = PaginationController<String>(
    pageSize: 20,
    fetchPage: fetchUsers,
  );
}
```

---

## API Method

```dart
Future<List<String>> fetchUsers(
  int page,
) async {
  await Future.delayed(
    const Duration(seconds: 2),
  );

  return List.generate(
    20,
    (index) =>
        'User ${(page - 1) * 20 + index}',
  );
}
```

---

# PaginationListView

```dart
PaginationListView<String>(
  controller: controller,
  itemBuilder: (
    context,
    item,
    index,
  ) {
    return ListTile(
      title: Text(item),
    );
  },
)
```

---

# PaginationGridView

```dart
PaginationGridView<String>(
  controller: controller,
  gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
  ),
  itemBuilder: (
    context,
    item,
    index,
  ) {
    return Card(
      child: Center(
        child: Text(item),
      ),
    );
  },
)
```

### Custom Widgets

Both `PaginationListView` and `PaginationGridView` support custom widgets for different states:

```dart
PaginationGridView<String>(
  controller: controller,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
  itemBuilder: (context, item, index) => ListTile(title: Text(item)),
  // Custom loading for initial load
  loadingWidget: MyCustomLoadingWidget(),
  // Custom loading for pagination (bottom of list)
  loadMoreWidget: MyCustomLoadMoreWidget(),
  // Custom error widget with retry callback
  errorWidgetBuilder: (context, error, onRetry) => MyCustomErrorWidget(
    message: error,
    onRetry: onRetry,
  ),
  // Custom empty state
  emptyWidget: MyCustomEmptyWidget(),
)
```

---

# Refresh Data

```dart
await controller.refresh();
```

Example:

```dart
RefreshIndicator(
  onRefresh: () async {
    await controller.refresh();
  },
  child: PaginationListView<String>(
    controller: controller,
    itemBuilder: (
      context,
      item,
      index,
    ) {
      return ListTile(
        title: Text(item),
      );
    },
  ),
)
```

---

# Pagination Status

Available states:

```dart
PaginationStatus.initial
PaginationStatus.loading
PaginationStatus.loaded
PaginationStatus.loadingMore
PaginationStatus.empty
PaginationStatus.error
```

Example:

```dart
final state = controller.state;

if (state.status ==
    PaginationStatus.loading) {
  print('Loading...');
}
```

---

# State Object

```dart
final state = controller.state;
```

Properties:

```dart
state.items
state.status
state.hasMore
state.errorMessage
```

Example:

```dart
print(state.items.length);
print(state.hasMore);
```

---

# Custom Loading Widget

```dart
const PaginationLoadingWidget()
```

---

# Custom Error Widget

```dart
PaginationErrorWidget(
  message: 'Network Error',
  onRetry: () {},
)
```

---

# Example Response Format

Example API response:

```json
{
  "page": 1,
  "totalPages": 10,
  "data": [
    {
      "id": 1,
      "name": "User 1"
    }
  ]
}
```

Example fetch:

```dart
Future<List<User>> fetchUsers(
  int page,
) async {
  final response =
      await api.getUsers(page);

  return response.data;
}
```

---

# License

MIT License

Copyright (c) 2026