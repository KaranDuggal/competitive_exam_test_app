import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final bool showThemeButton;

  final bool centerTitle;

  final List<Widget>? actions;

  const AppAppBar({
    super.key,
    required this.title,
    this.showThemeButton = false,
    this.centerTitle = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),

      centerTitle: centerTitle,

      elevation: 0,

      actions: [
        ...?actions,

        if (showThemeButton)
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              final isDark = themeProvider.themeMode == ThemeMode.dark;

              return IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),

                onPressed: () {
                  themeProvider.toggleTheme(!isDark);
                },
              );
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
