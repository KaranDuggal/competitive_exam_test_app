import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/home_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/quiz_provider.dart';

import 'repositories/quiz_repository.dart';

import 'datasources/remote/api_data_source.dart';

import 'core/theme/app_themes.dart';
import 'core/router/app_router.dart';
import 'core/utils/app_config.dart';

import 'core/services/connectivity_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final apiDataSource = ApiDataSource(
    baseUrl: AppConfig.baseUrl,
  );

  final quizRepository = QuizRepository(
    apiDataSource: apiDataSource,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeProvider(
            quizRepository,
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => ThemeProvider(
            prefs,
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => QuizProvider(
            repository: quizRepository,
          ),
        ),
      ],

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    ConnectivityService.initialize();
  }

  @override
  void dispose() {
    ConnectivityService.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeController, child) {
        return MaterialApp.router(
          title: 'Exam Jyoti',

          debugShowCheckedModeBanner: false,

          theme: AppThemes.lightTheme,

          darkTheme: AppThemes.darkTheme,

          themeMode: themeController.themeMode,

          routerConfig: AppRouter.router,
        );
      },
    );
  }
}