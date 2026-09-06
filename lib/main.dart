import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/services/interstitial_ad_service.dart';
import 'providers/home_provider.dart';
import 'providers/leaderboard_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/auth_provider.dart';
import 'repositories/leaderboard_repository.dart';
import 'repositories/profile_repository.dart';
import 'repositories/quiz_repository.dart';
import 'repositories/auth_repository.dart';
import 'datasources/remote/api_data_source.dart';
import 'core/theme/app_themes.dart';
import 'core/router/app_router.dart';
import 'core/utils/app_config.dart';
import 'core/services/connectivity_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  final prefs = await SharedPreferences.getInstance();
  
  // Step 1: Create temporary API data source (without authProvider yet)
  final tempApiDataSource = ApiDataSource(baseUrl: AppConfig.baseUrl);
  
  // Step 2: Create repositories using temp data source
  final quizRepository = QuizRepository(apiDataSource: tempApiDataSource);
  final authRepository = AuthRepository(apiDataSource: tempApiDataSource);
  final authProvider = AuthProvider(repository: authRepository);
  final leaderboardRepository = LeaderboardRepository(api: tempApiDataSource);
  
  // Step 3: Now create the FINAL API data source WITH authProvider
  final apiDataSource = ApiDataSource(
    baseUrl: AppConfig.baseUrl,
    authProvider: authProvider,  // ← PASS IT HERE
  );

  await authProvider.loadUserSession();
  
  final interstitialAdService = InterstitialAdService();
  interstitialAdService.load();
  ConnectivityService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider(quizRepository)),
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(
          create: (_) => QuizProvider(repository: quizRepository),
        ),
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(
            repository: ProfileRepository(apiDataSource: apiDataSource),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LeaderboardProvider(repository: leaderboardRepository),
        ),
        Provider<InterstitialAdService>(
          create: (_) {
            final service = InterstitialAdService();
            service.load();
            return service;
          },
          dispose: (_, service) => service.dispose(),
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
    return Consumer<ThemeProvider>(
      builder: (context, themeController, child) {
        return MaterialApp.router(
          title: 'KSVH Exam Scholar',
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
