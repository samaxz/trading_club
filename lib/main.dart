import 'dart:ui';

import 'package:trading_club/data/helper.dart';
import 'package:trading_club/logic/notifiers/user_info_notifier.dart';
import 'package:trading_club/ui/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  // TODO initialize firebase analytics here in the
  // future

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsP.overrideWithValue(prefs),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool shouldBlur = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    setState(() {
      shouldBlur = state == AppLifecycleState.inactive || state == AppLifecycleState.paused;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return ScreenUtilInit(
      minTextAdapt: true,
      // iphone 12/pro, 13/pro, 14 screen sizes
      designSize: const Size(390, 844),
      builder: (context, child) => MaterialApp(
        title: 'Trading Club',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.dark().copyWith(background: Helper.black),
          useMaterial3: true,
        ),
        home: const SplashScreen(isPocket: false),
        builder: (context, home) => Stack(
          children: [
            home!,
            if (shouldBlur) ...[
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.grey.withOpacity(0.1),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
