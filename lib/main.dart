import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/expense.dart';
import 'providers/expense_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/notification_helper.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Notifications
  await NotificationHelper.initialize();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  await Hive.openBox<Expense>('expenses');

  final prefs = await SharedPreferences.getInstance();
  final bool onboardingDone = prefs.getBool(kOnboardingKey) ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (context) => ExpenseProvider()..loadData(),
      child: MyApp(onboardingDone: onboardingDone),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool onboardingDone;

  const MyApp({super.key, required this.onboardingDone});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          title: 'Budget Tracker',
          debugShowCheckedModeBanner: false,
          themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: const Color(0xFFF8F9FA),
            fontFamily:
                'Roboto', // Or standard system font, just setting it explicitly
            appBarTheme: const AppBarTheme(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            ),
            colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: kAccentColor,
            scaffoldBackgroundColor: const Color(0xFF121212),
            cardColor: const Color(0xFF1E1E1E),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF121212),
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            ),
          ),
          home: SplashScreen(onboardingDone: onboardingDone),
        );
      },
    );
  }
}
