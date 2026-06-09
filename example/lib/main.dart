import 'package:flutter/material.dart';
import 'package:pagination_widget/pagination_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pagination Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const PaginationDemoPage(),
    );
  }
}

class PaginationDemoPage extends StatefulWidget {
  const PaginationDemoPage({super.key});

  @override
  State<PaginationDemoPage> createState() => _PaginationDemoPageState();
}

class _PaginationDemoPageState extends State<PaginationDemoPage> {
  late PaginationController<String> controller;

  @override
  void initState() {
    super.initState();
    controller = PaginationController<String>(
      pageSize: 20,
      fetchPage: fetchItems,
    );
  }

  Future<List<String>> fetchItems(int page) async {
    await Future.delayed(const Duration(seconds: 2));

    // Simulate error on page 3
    if (page == 3) {
      throw Exception('Failed to load page $page');
    }

    // Simulate end of data at page 5
    if (page > 5) {
      return [];
    }

    return List.generate(20, (index) => 'Item ${(page - 1) * 20 + index + 1}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagination Custom Widgets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refresh(),
          ),
        ],
      ),
      body: PaginationGridView<String>(
        controller: controller,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2,
        ),
        itemBuilder: (context, item, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: Center(child: Text(item)),
          );
        },
        // Custom Loading Widget
        loadingWidget: const Center(
          child: CircularProgressIndicator(color: Colors.deepPurple),
        ),
        // Custom Load More Widget (at the bottom)
        loadMoreWidget: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: LinearProgressIndicator()),
        ),
        // Custom Error Widget with Retry
        errorWidgetBuilder: (context, error, onRetry) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 8),
                Text('Error: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        },
        // Custom Empty Widget
        emptyWidget: const Center(
          child: Text('No items found.', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
