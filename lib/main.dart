import 'package:field_flow/auth_gate.dart';
import 'package:field_flow/providers/auth_provider.dart';
import 'package:field_flow/providers/position_provider.dart';
import 'package:field_flow/providers/time_tracker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';

import 'db/firestore_helper.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,  // ✅ Allows any device
  );
  runApp(MultiProvider(
    providers: [
      Provider(create: (context) => FirestoreHelper()),
      Provider(
        create: (context) => AuthProvider(
            firestoreHelper:
                Provider.of<FirestoreHelper>(context, listen: false)),
      ),
      ChangeNotifierProvider(
        create: (context) => TimeTracker(
            firestoreHelper:
                Provider.of<FirestoreHelper>(context, listen: false)),
      ),
      ChangeNotifierProvider(
        create: (context) => PositionProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();
  await service.configure(
      iosConfiguration: IosConfiguration(autoStart: false),
      androidConfiguration: AndroidConfiguration(
          onStart: serviceOnStart,
          isForegroundMode: true,
          autoStart: false,
          autoStartOnBoot: false,
          foregroundServiceTypes: [AndroidForegroundType.location]));
}

Future<void> serviceOnStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
  }

  service.on("startTracking").listen((event) {
    PositionProvider().startTracking(() {
      debugPrint("Background Tracking Running");
    });
  });

  service.on("stopTracking").listen((event) {
    PositionProvider().stopTracking();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FieldFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
