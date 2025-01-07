import 'package:deltanews/data/api/api_service.dart';
import 'package:deltanews/firebase_options.dart';
import 'package:deltanews/providers/category/category_provider.dart';
import 'package:deltanews/providers/connectivity_provider.dart';
import 'package:deltanews/providers/detail_category/detail_category_provider.dart';
import 'package:deltanews/providers/detail_news/detail_news_provider.dart';
import 'package:deltanews/providers/detail_tag/detail_tag_provider.dart';
import 'package:deltanews/providers/home/home_provider.dart';
import 'package:deltanews/providers/main_provider.dart';
import 'package:deltanews/providers/recommendation/recommendation_provider.dart';
import 'package:deltanews/providers/search/search_provider.dart';
import 'package:deltanews/providers/watch/watch_provider.dart';
import 'package:deltanews/screens/auth/bloc/auth_bloc.dart';
import 'package:deltanews/screens/splash_screen.dart';
import 'package:deltanews/utils/colors.dart';
import 'package:deltanews/utils/firebase_notification_service.dart';
import 'package:deltanews/utils/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:deltanews/utils/injector.dart' as di;

import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.setupLocator();
  await dotenv.load(fileName: "lib/.env");
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseNotificationService().initialize();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  final NotificationHelper notificationHelper = NotificationHelper();

  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  notificationHelper.requestIOSPermissions(flutterLocalNotificationsPlugin);

  await initializeDateFormatting('id_ID', null);
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print("FCMToken $fcmToken");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.serviceLocator<AuthBloc>(),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MainProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => ConnectivityProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => HomeProvider(apiService: ApiService()),
          ),
          ChangeNotifierProvider(
            create: (context) => CategoryProvider(apiService: ApiService()),
          ),
          ChangeNotifierProvider(
            create: (context) =>
                RecommendationProvider(apiService: ApiService()),
          ),
          ChangeNotifierProvider(
            create: (context) => SearchProvider(apiService: ApiService()),
          ),
          ChangeNotifierProvider(
            create: (context) =>
                DetailCategoryProvider(apiService: ApiService()),
          ),
          ChangeNotifierProvider(
            create: (context) => DetailTagProvider(apiService: ApiService()),
          ),
          ChangeNotifierProvider(
            create: (context) => DetailNewsProvider(apiService: ApiService()),
          ),
          ChangeNotifierProvider(
            create: (context) => WatchProvider(apiService: ApiService()),
          ),
        ],
        child: MaterialApp(
          title: 'DNEWS',
          theme: Theme.of(context).copyWith(
              textTheme:
                  GoogleFonts.interTextTheme(Theme.of(context).textTheme),
              colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
              scaffoldBackgroundColor: Colors.white),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
