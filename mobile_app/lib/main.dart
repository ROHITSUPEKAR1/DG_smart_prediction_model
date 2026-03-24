import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_app/app.dart';
import 'package:mobile_app/core/cache/cache_manager.dart';
import 'package:mobile_app/services/fcm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize offline caching
  await Hive.initFlutter();
  await CacheManager.init();

  // Real App: await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FCMService.initialize();

  runApp(
    const ProviderScope(
      child: DGSmartApp(),
    ),
  );
}
