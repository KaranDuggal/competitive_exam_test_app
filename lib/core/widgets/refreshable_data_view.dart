import 'package:flutter/material.dart';

class RefreshableDataView extends StatelessWidget {
  final bool isLoading;
  final bool isEmpty;
  final String? error;
  final String emptyMessage;
  final Future<void> Function() onRefresh;
  final Widget child;

  const RefreshableDataView({
    super.key,
    required this.isLoading,
    required this.isEmpty,
    this.error,
    required this.emptyMessage,
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null && isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: Stack(
          children: [
            ListView(
              physics: const AlwaysScrollableScrollPhysics(),
            ),
            Center(child: Text('Error: $error')),
          ],
        ),
      );
    }

    if (isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: Stack(
          children: [
            ListView(
              physics: const AlwaysScrollableScrollPhysics(),
            ),
            Center(child: Text(emptyMessage)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: child,
    );
  }
}
