import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reminder/components/loading/loading_screen.dart';
import 'package:reminder/screens/login_screen.dart';
import 'package:reminder/screens/reminder_list.dart';
import 'package:reminder/services/notification_service.dart';
import 'package:reminder/state/auth/providers/is_logged_in_provider.dart';
import 'package:reminder/state/providers/is_loading_provider.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
// ignore: unused_import
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  tz.initializeTimeZones();
  await requestPermissions();
  await NotificationService.initialize();
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

Future<void> requestPermissions() async {
  if (await Permission.notification.request().isGranted) {
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        indicatorColor: Colors.blueGrey,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: Consumer(
        builder: (context, ref, child) {
          ref.listen(isLoadingProvider, (_, isLoading) {
            if (isLoading) {
              LoadingScreen.instance().show(
                context: context,
              );
            } else {
              LoadingScreen.instance().hide();
            }
          });
          final isLoggedIn = ref.watch(isLoggedInProvider);
          if (isLoggedIn) {
            return ReminderList();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
