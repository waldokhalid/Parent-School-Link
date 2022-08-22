import 'package:flutter/material.dart';

// Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Screen imports
import 'All Screens/Dashboard__screen.dart';
import 'All Screens/announcements_Screen.dart';
import 'All Screens/grades_screen.dart';
import 'All Screens/homeWork_screen.dart';
import 'All Screens/login_screen.dart';
// import 'All Screens/main_screen.dart';
import 'All Screens/reset_password.dart';
import 'All Screens/schoolFeesPayment_screen.dart';
import 'All Screens/start_screen.dart';
import 'All Screens/signup_screen.dart';
import 'services/local_push_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  /// On click listner
}

Future<void> main() async {
  // SystemChrome.setEnabledSystemUIOverlays(
  //   [SystemUiOverlay.bottom],
  // ); // removes the status bar and makes the app fullscreen
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalNotificationService.initialize();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    MyApp(),
  );
}

DatabaseReference userReference =
    FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  static const String idScreen = "MyApp";

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(), // Provide light theme.
      darkTheme: ThemeData.dark(), // Provide dark theme.
      themeMode: ThemeMode.system, // Provide current system theme.
      debugShowCheckedModeBanner: false,
      title: 'School Link Parent',
      // initial route is the page the app will initially open in when initialized
      // initialRoute: StartScreen.idScreen,
      initialRoute: StarterScreen.idScreen,
      // page routes for the page.
      routes: {
        MyApp.idScreen: (context) => MyApp(),
        // MainScreen.idScreen: (context) => MainScreen(),
        // VerifyEmail.idScreen: (context) => VerifyEmail(),
        LoginScreen.idScreen: (context) => LoginScreen(),
        StartScreen.idScreen: (context) => StartScreen(),
        GradesSreen.idScreen: (context) => GradesSreen(),
        SignUpScreen.idScreen: (context) => SignUpScreen(),
        // ProfileScreen.idScreen: (context) => ProfileScreen(),
        StarterScreen.idScreen: (context) => StarterScreen(),
        HomeworkScreen.idScreen: (context) => HomeworkScreen(),
        // AbsenteeScreen.idScreen: (context) => AbsenteeScreen(),
        // FeedbackScreen.idScreen: (context) => FeedbackScreen(),
        // ConfirmPayment.idScreen: (context) => ConfirmPayment(),
        DashboardScreen.idScreen: (context) => DashboardScreen(),
        SchoolFeesScreen.idScreen: (context) => SchoolFeesScreen(),
        AnnouncementScreen.idScreen: (context) => AnnouncementScreen(),
        ResetPasswordScreen.idScreen: (context) => ResetPasswordScreen(),
        // HomeworkGradesScreen.idScreen: (context) => HomeworkGradesScreen(),
      },
    );
  }
}

class StarterScreen extends StatefulWidget {
  const StarterScreen({key}) : super(key: key);
  static const String idScreen = "StarterScreen";

  @override
  State<StarterScreen> createState() => _StarterScreenState();
}

class _StarterScreenState extends State<StarterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return DashboardScreen();
            } else {
              return StartScreen();
            }
          }),
    );
  }
}
