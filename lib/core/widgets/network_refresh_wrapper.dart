import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkRefreshWrapper extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onInternetRestored;

  const NetworkRefreshWrapper({
    super.key,
    required this.child,
    required this.onInternetRestored,
  });

  @override
  State<NetworkRefreshWrapper> createState() =>
      _NetworkRefreshWrapperState();
}

class _NetworkRefreshWrapperState
    extends State<NetworkRefreshWrapper> {

  StreamSubscription<List<ConnectivityResult>>?
      _subscription;

  bool _wasDisconnected = false;

  @override
  void initState() {
    super.initState();

    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((results) async {

      final hasConnection = results.any(
        (result) => result != ConnectivityResult.none,
      );

      if (!hasConnection) {
        _wasDisconnected = true;
      } else {
        if (_wasDisconnected) {
          _wasDisconnected = false;

          await widget.onInternetRestored();
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}