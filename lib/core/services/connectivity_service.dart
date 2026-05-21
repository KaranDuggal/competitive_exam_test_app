import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../router/app_router.dart';

class ConnectivityService {

  static StreamSubscription<List<ConnectivityResult>>?
      _subscription;

  static bool _dialogOpen = false;

  static void initialize() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen(
      (List<ConnectivityResult> results) {

        final bool hasConnection =
            results.any(
          (result) =>
              result != ConnectivityResult.none,
        );

        if (!hasConnection) {
          _showNoInternetDialog();
        } else {
          _closeDialog();
        }
      },
    );
  }

  static void dispose() {
    _subscription?.cancel();
  }

  static void _showNoInternetDialog() {

    if (_dialogOpen) {
      return;
    }

    final context =
        AppRouter.navigatorKey.currentState
            ?.overlay
            ?.context;

    if (context == null) {
      return;
    }

    _dialogOpen = true;

    showDialog(
      context: context,

      barrierDismissible: false,

      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'No Internet',
          ),

          content: const Text(
            'Please check your internet connection.',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },

              child: const Text(
                'OK',
              ),
            ),
          ],
        );
      },
    ).then((_) {
      _dialogOpen = false;
    });
  }

  static void _closeDialog() {

    if (!_dialogOpen) {
      return;
    }

    final context =
        AppRouter.navigatorKey.currentState
            ?.overlay
            ?.context;

    if (context == null) {
      return;
    }

    Navigator.of(
      context,
      rootNavigator: true,
    ).pop();

    _dialogOpen = false;
  }
}