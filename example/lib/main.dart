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
      debugShowCheckedModeBanner: false,
      home: const UsersPage(),
    );
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late PaginationController<String> controller;

  @override
  void initState() {
    super.initState();

    controller = PaginationController<String>(
      pageSize: 20,
      fetchPage: fetchUsers,
    );
  }

  Future<List<String>> fetchUsers(int page) async {
    await Future.delayed(const Duration(seconds: 1));

    if (page > 5) {
      return [];
    }

    return List.generate(20, (index) => 'User ${(page - 1) * 20 + index + 1}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Pagination Example')),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: PaginationListView<String>(
          controller: controller,
          itemBuilder: (context, item, index) {
            return ListTile(title: Text(item));
          },
        ),
      ),
    );
  }
}
