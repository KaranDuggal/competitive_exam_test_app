import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/home_controller.dart';
import 'providers/theme_controller.dart';
import 'providers/quiz_provider.dart';
import 'repositories/quiz_repository.dart';
import 'services/local_json_data_source.dart';
import 'services/api_data_source.dart';
import 'theme/app_themes.dart';
import 'utils/app_router.dart';
import 'utils/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final localDataSource = LocalJsonDataSource();
  final apiDataSource = ApiDataSource(baseUrl: AppConfig.baseUrl);
  final quizRepository = QuizRepository(localDataSource: localDataSource, apiDataSource: apiDataSource);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeController(quizRepository)),
        ChangeNotifierProvider(create: (_) => ThemeController(prefs)),
        ChangeNotifierProvider(
          create: (_) => QuizProvider(repository: quizRepository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
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
