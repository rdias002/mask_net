import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'config/app_locater.dart';
import 'firebase_options.dart';

import 'config/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();

  runApp(const MyApp());
}

Future<void> init() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDependencies();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.config(),
      title: 'MaskNet',
    );
  }
}
