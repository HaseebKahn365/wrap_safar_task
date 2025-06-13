import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wrap_safar_task/firebase_options.dart';
import 'package:wrap_safar_task/services/rewarded_ad_manager.dart';

import 'core/theme_provider.dart';
import 'presentation/widgets/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Enable Firebase Analytics Debug Mode (for development only)
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

  // Initialize Google Mobile Ads SDK
  MobileAds.instance.initialize();

  rewardedAdManager.loadRewardedAd();

  // Add a dummy document to 123 collection to make sure Firestore is working
  FirebaseFirestore.instance
      .collection('123')
      .add({'test': 'data'})
      .then((_) => log('document created'));

  runApp(
    ChangeNotifierProvider(
      create: (_) => WrapSafarTheme(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WrapSafarTheme>(
      builder: (context, theme, _) {
        return MaterialApp(
          title: 'Wrap Safar',
          debugShowCheckedModeBanner: false,
          theme: theme.themeData,
          home: const HomePage(),
        );
      },
    );
  }
}
