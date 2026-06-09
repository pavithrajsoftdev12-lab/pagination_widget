import 'package:flutter/material.dart';

class PaginationLoadingWidget extends StatelessWidget {
  const PaginationLoadingWidget({
    super.key,
    this.padding = const EdgeInsets.all(16),
  });

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
